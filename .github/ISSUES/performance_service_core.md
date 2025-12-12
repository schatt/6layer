# Performance Service Core: Memory, Cache & Monitoring

**Parent Issue**: #107

## Overview

Add the core Performance Service infrastructure to the SixLayer Framework, providing memory management, cache management, and performance monitoring following the same pattern as `InternationalizationService`.

This is the foundation for all performance optimization features. Subsequent issues will add lazy loading, image optimization, and battery optimization on top of this core.

## Motivation

Performance monitoring and memory/cache management are foundational for all performance optimization features:
- Memory usage monitoring and limits
- Cache management with LRU eviction
- Performance metrics collection (CPU, frame rate, memory)
- Automatic memory cleanup
- Memory pressure handling

**Solution**: Provide a framework service that handles the boilerplate, while apps provide app-specific logic through configuration.

## Architecture Pattern

This follows existing framework patterns:
- **Service pattern**: Similar to `InternationalizationService`, `LocationService`, `OCRService`
- **ObservableObject**: Published properties for UI binding
- **Configuration-based**: Similar to `InternationalizationHints` pattern
- **Platform-aware**: Automatic platform detection and adaptation

## Proposed API Design

### Error Types

```swift
public enum PerformanceServiceError: LocalizedError {
    case memoryLimitExceeded
    case cacheFull
    case optimizationFailed
    case invalidConfiguration
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .memoryLimitExceeded:
            return "Memory limit exceeded"
        case .cacheFull:
            return "Cache is full"
        case .optimizationFailed:
            return "Performance optimization failed"
        case .invalidConfiguration:
            return "Invalid performance configuration"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
```

### Performance Metrics

```swift
public struct PerformanceMetrics {
    public let memoryUsage: Int64 // bytes
    public let memoryLimit: Int64 // bytes
    public let cacheSize: Int64 // bytes
    public let cacheLimit: Int64 // bytes
    public let cpuUsage: Double // percentage
    public let frameRate: Double // fps
    
    public init(
        memoryUsage: Int64,
        memoryLimit: Int64,
        cacheSize: Int64,
        cacheLimit: Int64,
        cpuUsage: Double,
        frameRate: Double
    ) {
        self.memoryUsage = memoryUsage
        self.memoryLimit = memoryLimit
        self.cacheSize = cacheSize
        self.cacheLimit = cacheLimit
        self.cpuUsage = cpuUsage
        self.frameRate = frameRate
    }
    
    public var memoryUsagePercentage: Double {
        guard memoryLimit > 0 else { return 0 }
        return Double(memoryUsage) / Double(memoryLimit) * 100
    }
    
    public var cacheUsagePercentage: Double {
        guard cacheLimit > 0 else { return 0 }
        return Double(cacheSize) / Double(cacheLimit) * 100
    }
}
```

### Optimization Strategy

```swift
public enum OptimizationStrategy {
    case aggressive // Maximum performance, higher resource usage
    case balanced // Balanced performance and resources
    case conservative // Lower resource usage, may impact performance
    case adaptive // Automatically adjust based on conditions
}

public enum OptimizationTarget {
    case memory
    case cpu
    case frameRate
    case all
}
```

### Core Service

```swift
@MainActor
public class PerformanceService: ObservableObject {
    // Published properties for UI binding
    @Published public var metrics: PerformanceMetrics
    @Published public var strategy: OptimizationStrategy = .balanced
    @Published public var isOptimizing: Bool = false
    @Published public var lastError: Error?
    
    // Configuration
    private let memoryLimit: Int64
    private let cacheLimit: Int64
    private let monitoringInterval: TimeInterval
    
    // Cache management
    private var genericCache: [String: CachedItem] = [:]
    
    /// Initialize the performance service
    /// - Parameters:
    ///   - memoryLimit: Maximum memory usage in bytes
    ///   - cacheLimit: Maximum cache size in bytes
    ///   - monitoringInterval: Interval for performance monitoring
    public init(
        memoryLimit: Int64 = 100 * 1024 * 1024, // 100 MB default
        cacheLimit: Int64 = 50 * 1024 * 1024, // 50 MB default
        monitoringInterval: TimeInterval = 1.0
    ) {
        self.memoryLimit = memoryLimit
        self.cacheLimit = cacheLimit
        self.monitoringInterval = monitoringInterval
        
        // Initialize metrics
        self.metrics = PerformanceMetrics(
            memoryUsage: 0,
            memoryLimit: memoryLimit,
            cacheSize: 0,
            cacheLimit: cacheLimit,
            cpuUsage: 0,
            frameRate: 60
        )
        
        // Start monitoring
        startMonitoring()
    }
    
    // MARK: - Memory Management
    
    /// Optimize memory usage
    /// - Parameter target: What to optimize
    public func optimizeMemory(target: OptimizationTarget = .all) async throws {
        isOptimizing = true
        defer { isOptimizing = false }
        
        switch target {
        case .memory, .all:
            try await clearUnusedCache()
            try await reduceMemoryFootprint()
        case .cpu:
            try await optimizeCPUUsage()
        case .frameRate:
            try await optimizeFrameRate()
        }
        
        await updateMetrics()
    }
    
    /// Clear unused cache entries (LRU eviction)
    public func clearUnusedCache() async throws {
        // Remove least recently used cache entries
        let sortedCache = genericCache.sorted { $0.value.lastAccessed < $1.value.lastAccessed }
        var clearedSize: Int64 = 0
        let targetSize = cacheLimit / 2 // Clear down to 50% of limit
        
        for (key, value) in sortedCache {
            if metrics.cacheSize - clearedSize <= targetSize {
                break
            }
            genericCache.removeValue(forKey: key)
            clearedSize += value.size
        }
        
        await updateMetrics()
    }
    
    /// Clear all cache
    public func clearAllCache() async {
        genericCache.removeAll()
        await updateMetrics()
    }
    
    /// Reduce memory footprint
    private func reduceMemoryFootprint() async throws {
        // Force garbage collection, clear temporary data, etc.
        #if os(iOS)
        // Trigger memory warning handling
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        #endif
    }
    
    // MARK: - Cache Management
    
    /// Store item in cache
    /// - Parameters:
    ///   - identifier: Cache identifier
    ///   - data: Data to cache
    public func cacheItem(identifier: String, data: Data) throws {
        let size = Int64(data.count)
        
        // Check if adding would exceed limit
        if metrics.cacheSize + size > cacheLimit {
            // Try to make room
            try await clearUnusedCache()
            
            // Still too big?
            if metrics.cacheSize + size > cacheLimit {
                throw PerformanceServiceError.cacheFull
            }
        }
        
        let item = CachedItem(identifier: identifier, data: data, lastAccessed: Date())
        genericCache[identifier] = item
        await updateMetrics()
    }
    
    /// Retrieve item from cache
    /// - Parameter identifier: Cache identifier
    /// - Returns: Cached data, or nil if not found
    public func retrieveCachedItem(identifier: String) -> Data? {
        guard var item = genericCache[identifier] else { return nil }
        
        // Update last accessed time
        item.lastAccessed = Date()
        genericCache[identifier] = item
        
        return item.data
    }
    
    /// Remove item from cache
    /// - Parameter identifier: Cache identifier
    public func removeCachedItem(identifier: String) {
        genericCache.removeValue(forKey: identifier)
        Task { await updateMetrics() }
    }
    
    // MARK: - Performance Monitoring
    
    /// Start performance monitoring
    private func startMonitoring() {
        Task {
            while true {
                await updateMetrics()
                try? await Task.sleep(nanoseconds: UInt64(monitoringInterval * 1_000_000_000))
            }
        }
    }
    
    /// Update performance metrics
    private func updateMetrics() async {
        let memoryUsage = await getCurrentMemoryUsage()
        let cacheSize = Int64(genericCache.values.reduce(0) { $0 + $1.size })
        let cpuUsage = await getCurrentCPUUsage()
        let frameRate = await getCurrentFrameRate()
        
        metrics = PerformanceMetrics(
            memoryUsage: memoryUsage,
            memoryLimit: memoryLimit,
            cacheSize: cacheSize,
            cacheLimit: cacheLimit,
            cpuUsage: cpuUsage,
            frameRate: frameRate
        )
        
        // Auto-optimize if needed
        if shouldAutoOptimize() {
            try? await optimizeMemory(target: .all)
        }
    }
    
    /// Check if auto-optimization should trigger
    private func shouldAutoOptimize() -> Bool {
        if strategy == .adaptive {
            return metrics.memoryUsagePercentage > 80 ||
                   metrics.cacheUsagePercentage > 80
        }
        return false
    }
    
    // MARK: - Private Helpers
    
    private func getCurrentMemoryUsage() async -> Int64 {
        // Platform-specific memory usage detection
        #if os(iOS)
        return await getIOSMemoryUsage()
        #elseif os(macOS)
        return await getMacOSMemoryUsage()
        #else
        return 0
        #endif
    }
    
    private func getCurrentCPUUsage() async -> Double {
        // Platform-specific CPU usage detection
        return 0.0
    }
    
    private func getCurrentFrameRate() async -> Double {
        // Frame rate monitoring
        return 60.0
    }
    
    private func optimizeCPUUsage() async throws {
        // Reduce CPU-intensive operations
    }
    
    private func optimizeFrameRate() async throws {
        // Optimize rendering for better frame rate
    }
}

// MARK: - Cache Types

private struct CachedItem {
    let identifier: String
    let data: Data
    let size: Int64
    var lastAccessed: Date
    
    init(identifier: String, data: Data, lastAccessed: Date) {
        self.identifier = identifier
        self.data = data
        self.size = Int64(data.count)
        self.lastAccessed = lastAccessed
    }
}
```

### Performance Hints

```swift
/// Hints for performance optimization configuration
public struct PerformanceHints {
    public let memoryLimit: Int64
    public let cacheLimit: Int64
    public let strategy: OptimizationStrategy
    public let target: OptimizationTarget
    
    public init(
        memoryLimit: Int64 = 100 * 1024 * 1024,
        cacheLimit: Int64 = 50 * 1024 * 1024,
        strategy: OptimizationStrategy = .balanced,
        target: OptimizationTarget = .all
    ) {
        self.memoryLimit = memoryLimit
        self.cacheLimit = cacheLimit
        self.strategy = strategy
        self.target = target
    }
}
```

## Platform-Specific Considerations

### iOS
- Memory pressure handling via `UIApplication.didReceiveMemoryWarningNotification`
- Process memory usage via `mach_task_basic_info`
- Memory limit detection

### macOS
- System resource management
- Process memory usage via `mach_task_basic_info`
- Multi-display optimization considerations

### visionOS
- Spatial rendering optimization considerations
- Memory constraints for immersive experiences

## Testing

- Framework tests should use mocks for memory/cpu monitoring
- Service should be mockable via protocol
- Platform-specific behavior should be testable
- Performance metrics should be testable
- Cache behavior should be testable (LRU eviction)

## Implementation Checklist

### Phase 1: Core Service Infrastructure
- [ ] Create `PerformanceService` class
- [ ] Define `PerformanceServiceError` enum
- [ ] Define `PerformanceMetrics` struct
- [ ] Define `OptimizationStrategy` enum
- [ ] Define `OptimizationTarget` enum
- [ ] Define `PerformanceHints` struct
- [ ] Implement basic initialization

### Phase 2: Performance Monitoring
- [ ] Implement memory usage monitoring (iOS)
- [ ] Implement memory usage monitoring (macOS)
- [ ] Implement CPU usage monitoring
- [ ] Implement frame rate monitoring
- [ ] Add monitoring interval configuration
- [ ] Add automatic metrics updates

### Phase 3: Cache Management
- [ ] Implement generic cache storage
- [ ] Implement cache retrieval
- [ ] Implement LRU cache eviction
- [ ] Add cache size tracking
- [ ] Add cache limit enforcement
- [ ] Add cache clearing methods

### Phase 4: Memory Management
- [ ] Implement memory optimization
- [ ] Implement cache clearing on memory pressure
- [ ] Add memory pressure handling (iOS)
- [ ] Add automatic cleanup
- [ ] Add memory limit enforcement

### Phase 5: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`PerformanceServiceCoreGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation

## Design Decisions

### Why Service Pattern?
- **Consistency**: Matches `InternationalizationService` pattern
- **ObservableObject**: Enables SwiftUI binding
- **Testability**: Easy to mock for testing
- **Separation of Concerns**: Framework handles boilerplate, app handles configuration

### Why Generic Cache?
- **Foundation**: Provides base for image cache, resource cache, etc.
- **Flexibility**: Can be extended by subsequent issues
- **Reusability**: Single cache implementation for all types

### Why Monitoring First?
- **Foundation**: Metrics needed for all optimization decisions
- **Visibility**: Developers need to see what's happening
- **Adaptive Strategy**: Enables automatic optimization

## Related

- `InternationalizationService.swift` - Reference implementation pattern
- Issue #107 - Parent issue for Performance Service
- Issue #107b - Lazy Loading & Image Optimization (depends on this)
- Issue #107c - Battery Optimization (depends on this)

## Acceptance Criteria

- [ ] `PerformanceService` class exists with core API
- [ ] Memory monitoring works on iOS and macOS
- [ ] CPU usage monitoring is functional
- [ ] Frame rate monitoring is functional
- [ ] Cache management with LRU eviction works correctly
- [ ] Memory optimization works correctly
- [ ] Memory pressure handling works on iOS
- [ ] Performance metrics are accurate
- [ ] Comprehensive tests pass (25+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported
