# DataHintsLoader Refactoring Proposal

## Current Design Problems

1. **Dual Cache Complexity**: Actor-isolated cache + static `nonisolated(unsafe)` cache that must stay in sync
2. **Actor Model Mismatch**: Actor isolation adds overhead for cached reads, but synchronous access is needed from SwiftUI init
3. **Swift 5.9 Incompatibility**: `nonisolated(unsafe)` requires Swift 5.10+
4. **Maintenance Burden**: Two caches with complex synchronization logic

## Key Insight

**You're absolutely right!** If the cache is truly read-only after preload, we don't need a lock for reads. However, there's a problem:

**Current code writes to the cache AFTER preload:**
- Line 435-436: Writes without checking `hintsPreloaded` flag
- Line 509: Writes without checking flag  
- Line 520: Writes without checking flag

So we have two options:

### Option A: Fix writes, make reads lock-free
- Use lock only during preload (for writes)
- After preload, ensure NO writes happen (fix the code)
- Use `nonisolated` (not `nonisolated(unsafe)`) for reads - Swift Dictionary reads are safe for immutable dictionaries in practice
- This is the fastest approach

### Option B: Use lock for all access (simpler, slightly slower)
- Lock protects both reads and writes
- Ensures thread-safety even if code has bugs
- Minimal performance impact (lock is fast)

## Proposed Design: Lock-Protected Static Cache

### Core Principle
Since hints are **immutable after loading**, we can use a lock-protected static cache. The lock makes concurrent reads safe, so we don't need `(unsafe)`.

### Architecture Option 1: Lock-Free Reads (Fastest)

**Key**: Use lock only during preload, ensure no writes after preload, then use `nonisolated` (not unsafe) for reads.

```swift
public actor DataHintsRegistry {
    private var cache: [String: [String: FieldDisplayHints]] = [:]
    private var resultCache: [String: DataHintsResult] = [:]
    private let loader: DataHintsLoader
    
    // Lock only for preload writes, then cache is read-only
    nonisolated private static let preloadLock = NSLock()
    nonisolated private static var sharedResultCache: [String: DataHintsResult] = [:]
    nonisolated private static var hintsPreloaded = false
    
    // Synchronous read (NO LOCK NEEDED after preload - cache is read-only!)
    nonisolated public static func getCachedHints(for modelName: String) -> DataHintsResult? {
        // After preload, cache is immutable - safe to read without lock
        // Swift Dictionary reads are safe for immutable dictionaries
        return sharedResultCache[modelName]
    }
    
    // Synchronous check (NO LOCK NEEDED)
    nonisolated public static func hasCachedHints(for modelName: String) -> Bool {
        return sharedResultCache[modelName] != nil
    }
    
    // Preload (lock-protected writes, then cache becomes read-only)
    nonisolated public static func preloadAllHintsSync(modelNames: [String]) {
        preloadLock.lock()
        defer { preloadLock.unlock() }
        
        guard !hintsPreloaded else { return }
        
        let loader = FileBasedDataHintsLoader()
        for modelName in modelNames {
            if sharedResultCache[modelName] == nil, loader.hasHints(for: modelName) {
                let result = loader.loadHintsResult(for: modelName)
                if !result.fieldHints.isEmpty || !result.sections.isEmpty {
                    sharedResultCache[modelName] = result
                }
            }
        }
        
        hintsPreloaded = true
        // Cache is now read-only - no more writes allowed!
    }
    
    // Actor-isolated async load (CRITICAL: Don't write to shared cache after preload!)
    public func loadHintsResult(for modelName: String) -> DataHintsResult {
        // Check actor-local cache first
        if let cached = resultCache[modelName] {
            // Only update shared cache if NOT preloaded (one-time setup)
            if !Self.hintsPreloaded {
                Self.preloadLock.lock()
                if Self.sharedResultCache[modelName] == nil {
                    Self.sharedResultCache[modelName] = cached
                }
                Self.preloadLock.unlock()
            }
            return cached
        }
        
        // Check shared cache (read-only, no lock needed if preloaded)
        if let sharedCached = Self.sharedResultCache[modelName] {
            resultCache[modelName] = sharedCached
            cache[modelName] = sharedCached.fieldHints
            return sharedCached
        }
        
        // Load from file
        let result = loader.loadHintsResult(for: modelName)
        
        if !result.fieldHints.isEmpty || !result.sections.isEmpty {
            resultCache[modelName] = result
            cache[modelName] = result.fieldHints
            
            // Only write to shared cache if NOT preloaded
            if !Self.hintsPreloaded {
                Self.preloadLock.lock()
                Self.sharedResultCache[modelName] = result
                Self.preloadLock.unlock()
            }
        }
        
        return result
    }
    
    // CRITICAL: preloadHints must also respect the preloaded flag
    public func preloadHints(for modelName: String) {
        // If already preloaded, don't write to shared cache
        if Self.hintsPreloaded {
            // Just update actor-local cache
            if resultCache[modelName] == nil {
                if let sharedCached = Self.sharedResultCache[modelName] {
                    resultCache[modelName] = sharedCached
                    cache[modelName] = sharedCached.fieldHints
                } else {
                    let result = loader.loadHintsResult(for: modelName)
                    resultCache[modelName] = result
                    cache[modelName] = result.fieldHints
                }
            }
            return
        }
        
        // Before preload, can write to shared cache (with lock)
        Self.preloadLock.lock()
        if Self.sharedResultCache[modelName] == nil {
            let result = loader.loadHintsResult(for: modelName)
            if !result.fieldHints.isEmpty || !result.sections.isEmpty {
                Self.sharedResultCache[modelName] = result
            }
        }
        Self.preloadLock.unlock()
    }
}
```

**Benefits:**
- ✅ Fastest: No lock overhead for reads after preload
- ✅ Swift 5.9 compatible: Uses `nonisolated` (not `nonisolated(unsafe)`)
- ✅ Safe: Dictionary reads are safe for immutable dictionaries
- ✅ Simple: Lock only during preload phase

**Trade-off:**
- Must ensure no writes after preload (code discipline required)

### Architecture Option 2: Lock All Access (Simpler, Slightly Slower)

If we want to be extra safe and don't mind minimal lock overhead:

```swift
// Synchronous read (with lock - simpler, slightly slower)
nonisolated public static func getCachedHints(for modelName: String) -> DataHintsResult? {
    preloadLock.lock()
    defer { preloadLock.unlock() }
    return sharedResultCache[modelName]
}
```

**Benefits:**
- ✅ Simplest: Lock protects everything
- ✅ Safest: No risk of writes after preload
- ✅ Swift 5.9 compatible

**Trade-off:**
- Slightly slower: Lock overhead for every read (but NSLock is fast)

## Architecture Option 2: Remove Actor Entirely (Simpler)

If we don't need the actor model, we could simplify further:

```swift
public final class DataHintsRegistry {
    private let cacheLock = NSLock()
    private var cache: [String: DataHintsResult] = [:]
    private var isPreloaded = false
    private let loader: DataHintsLoader
    
    // Synchronous read
    public func getCachedHints(for modelName: String) -> DataHintsResult? {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return cache[modelName]
    }
    
    // Async load
    public func loadHintsResult(for modelName: String) async -> DataHintsResult {
        // Fast path: check cache
        if let cached = getCachedHints(for: modelName) {
            return cached
        }
        
        // Load from file
        let result = loader.loadHintsResult(for: modelName)
        
        // Cache it
        cacheLock.lock()
        defer { cacheLock.unlock() }
        if !result.fieldHints.isEmpty || !result.sections.isEmpty {
            cache[modelName] = result
        }
        
        return result
    }
    
    // Synchronous preload
    public static func preloadAllHintsSync(modelNames: [String]) {
        // Use global instance or create new one
        let registry = DataHintsRegistry()
        // ... preload logic
    }
}
```

But this loses the ability to have a global instance easily accessible.

## Recommendation

**Use Option 1 (Lock-Free Reads)** - This is the best approach:
- ✅ Fastest: No lock overhead for reads (the common case)
- ✅ Swift 5.9 compatible: Uses `nonisolated` (not `nonisolated(unsafe)`)
- ✅ Safe: Dictionary reads are safe for immutable dictionaries after preload
- ✅ Simple: Lock only during preload phase
- ✅ Minimal changes: Just fix the write paths to respect `hintsPreloaded` flag

**Key Changes Needed:**
1. Remove `nonisolated(unsafe)` → use `nonisolated` 
2. Fix lines 435-436, 509, 520 to check `hintsPreloaded` before writing
3. Remove lock from read paths (getCachedHints, hasCachedHints)

**Why this works:**
- After `preloadAllHintsSync` completes, `hintsPreloaded = true`
- Dictionary structure doesn't change (no writes)
- Dictionary values are immutable (`DataHintsResult` is a struct with `let` properties)
- Concurrent reads from an immutable dictionary are safe in practice
- Swift compiler allows `nonisolated` (not unsafe) because we're not using unsafe features

