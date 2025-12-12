# Add Performance Service

## Overview

Add a comprehensive Performance Service to the SixLayer Framework that provides lazy loading, memory management, image optimization, and battery optimization following the same pattern as `InternationalizationService`.

## Motivation

Performance optimization features are essential for smooth user experience but require significant boilerplate code:
- Lazy loading of content
- Memory management and cleanup
- Image optimization (resize, compress)
- Battery optimization
- Performance monitoring
- Cache management
- Resource preloading

However, performance optimization also requires app-specific configuration:
- Memory limits (app-specific constraints)
- Cache sizes (app-specific storage)
- Optimization strategies (app-specific priorities)
- Performance thresholds (app-specific targets)

**Solution**: Provide a framework service that handles the boilerplate, while apps provide app-specific logic through configuration and callbacks.

## Architecture Pattern

This follows existing framework patterns:
- **Service pattern**: Similar to `InternationalizationService`, `LocationService`, `OCRService`
- **ObservableObject**: Published properties for UI binding
- **Layer 1 semantic functions**: Similar to `platformPresentLocalizedContent_L1()` functions
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
    case resourceNotFound
    case preloadFailed
    case batteryOptimizationNotAvailable
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
        case .resourceNotFound:
            return "Resource not found"
        case .preloadFailed:
            return "Resource preloading failed"
        case .batteryOptimizationNotAvailable:
            return "Battery optimization is not available"
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
    public let batteryLevel: Double? // percentage (if available)
    public let thermalState: ThermalState
    
    public init(
        memoryUsage: Int64,
        memoryLimit: Int64,
        cacheSize: Int64,
        cacheLimit: Int64,
        cpuUsage: Double,
        frameRate: Double,
        batteryLevel: Double? = nil,
        thermalState: ThermalState = .nominal
    ) {
        self.memoryUsage = memoryUsage
        self.memoryLimit = memoryLimit
        self.cacheSize = cacheSize
        self.cacheLimit = cacheLimit
        self.cpuUsage = cpuUsage
        self.frameRate = frameRate
        self.batteryLevel = batteryLevel
        self.thermalState = thermalState
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

public enum ThermalState {
    case nominal
    case fair
    case serious
    case critical
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
    case battery
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
    private let enableLazyLoading: Bool
    private let enableBatteryOptimization: Bool
    private let monitoringInterval: TimeInterval
    
    // Cache management
    private var imageCache: [String: CachedImage] = [:]
    private var resourceCache: [String: CachedResource] = [:]
    
    /// Initialize the performance service
    /// - Parameters:
    ///   - memoryLimit: Maximum memory usage in bytes
    ///   - cacheLimit: Maximum cache size in bytes
    ///   - enableLazyLoading: Whether to enable lazy loading
    ///   - enableBatteryOptimization: Whether to enable battery optimization
    ///   - monitoringInterval: Interval for performance monitoring
    public init(
        memoryLimit: Int64 = 100 * 1024 * 1024, // 100 MB default
        cacheLimit: Int64 = 50 * 1024 * 1024, // 50 MB default
        enableLazyLoading: Bool = true,
        enableBatteryOptimization: Bool = true,
        monitoringInterval: TimeInterval = 1.0
    ) {
        self.memoryLimit = memoryLimit
        self.cacheLimit = cacheLimit
        self.enableLazyLoading = enableLazyLoading
        self.enableBatteryOptimization = enableBatteryOptimization
        self.monitoringInterval = monitoringInterval
        
        // Initialize metrics
        self.metrics = PerformanceMetrics(
            memoryUsage: 0,
            memoryLimit: memoryLimit,
            cacheSize: 0,
            cacheLimit: cacheLimit,
            cpuUsage: 0,
            frameRate: 60,
            batteryLevel: nil,
            thermalState: .nominal
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
        case .battery:
            try await optimizeBatteryUsage()
        case .frameRate:
            try await optimizeFrameRate()
        }
        
        updateMetrics()
    }
    
    /// Clear unused cache entries
    public func clearUnusedCache() async throws {
        // Remove least recently used cache entries
        let sortedCache = imageCache.sorted { $0.value.lastAccessed < $1.value.lastAccessed }
        var clearedSize: Int64 = 0
        
        for (key, value) in sortedCache {
            if metrics.cacheSize - clearedSize > cacheLimit / 2 {
                break
            }
            imageCache.removeValue(forKey: key)
            clearedSize += Int64(value.data.count)
        }
        
        updateMetrics()
    }
    
    /// Reduce memory footprint
    private func reduceMemoryFootprint() async throws {
        // Force garbage collection, clear temporary data, etc.
        #if os(iOS)
        // Trigger memory warning handling
        #endif
    }
    
    // MARK: - Lazy Loading
    
    /// Load resource lazily
    /// - Parameters:
    ///   - identifier: Resource identifier
    ///   - loader: Async loader function
    /// - Returns: Loaded resource
    public func loadLazily<T>(
        identifier: String,
        loader: @escaping () async throws -> T
    ) async throws -> T {
        guard enableLazyLoading else {
            return try await loader()
        }
        
        // Check cache first
        if let cached = resourceCache[identifier] as? CachedResource<T> {
            return cached.value
        }
        
        // Load and cache
        let value = try await loader()
        let resource = CachedResource(identifier: identifier, value: value)
        resourceCache[identifier] = resource
        
        updateMetrics()
        return value
    }
    
    /// Preload resources
    /// - Parameter identifiers: Resource identifiers to preload
    public func preloadResources(identifiers: [String]) async {
        // Preload in background with priority queue
    }
    
    // MARK: - Image Optimization
    
    /// Optimize image
    /// - Parameters:
    ///   - image: Image to optimize
    ///   - maxSize: Maximum size in bytes
    ///   - quality: Compression quality (0.0 to 1.0)
    /// - Returns: Optimized image data
    public func optimizeImage(
        _ image: PlatformImage,
        maxSize: Int64? = nil,
        quality: Double = 0.8
    ) async throws -> Data {
        // Check cache
        let cacheKey = "\(image.hashValue)-\(maxSize ?? 0)-\(quality)"
        if let cached = imageCache[cacheKey] {
            return cached.data
        }
        
        // Optimize image
        let optimized = try await performImageOptimization(
            image: image,
            maxSize: maxSize,
            quality: quality
        )
        
        // Cache result
        let cached = CachedImage(
            identifier: cacheKey,
            data: optimized,
            lastAccessed: Date()
        )
        imageCache[cacheKey] = cached
        
        updateMetrics()
        return optimized
    }
    
    /// Resize image to target dimensions
    /// - Parameters:
    ///   - image: Image to resize
    ///   - targetSize: Target size
    ///   - maintainAspectRatio: Whether to maintain aspect ratio
    /// - Returns: Resized image
    public func resizeImage(
        _ image: PlatformImage,
        targetSize: CGSize,
        maintainAspectRatio: Bool = true
    ) async throws -> PlatformImage {
        // Implementation
    }
    
    // MARK: - Battery Optimization
    
    /// Optimize for battery life
    public func optimizeForBattery() async throws {
        guard enableBatteryOptimization else { return }
        
        // Reduce CPU usage
        // Reduce network activity
        // Reduce background processing
        // Adjust frame rate
    }
    
    /// Check if battery optimization should be enabled
    public func shouldOptimizeForBattery() -> Bool {
        guard let batteryLevel = metrics.batteryLevel else { return false }
        return batteryLevel < 20.0 || metrics.thermalState == .serious || metrics.thermalState == .critical
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
        let cacheSize = Int64(imageCache.values.reduce(0) { $0 + $1.data.count })
        let cpuUsage = await getCurrentCPUUsage()
        let frameRate = await getCurrentFrameRate()
        let batteryLevel = await getBatteryLevel()
        let thermalState = await getThermalState()
        
        metrics = PerformanceMetrics(
            memoryUsage: memoryUsage,
            memoryLimit: memoryLimit,
            cacheSize: cacheSize,
            cacheLimit: cacheLimit,
            cpuUsage: cpuUsage,
            frameRate: frameRate,
            batteryLevel: batteryLevel,
            thermalState: thermalState
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
                   metrics.cacheUsagePercentage > 80 ||
                   shouldOptimizeForBattery()
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
    
    private func getBatteryLevel() async -> Double? {
        #if os(iOS)
        return await getIOSBatteryLevel()
        #else
        return nil
        #endif
    }
    
    private func getThermalState() async -> ThermalState {
        #if os(iOS)
        return await getIOSThermalState()
        #else
        return .nominal
        #endif
    }
    
    private func performImageOptimization(
        image: PlatformImage,
        maxSize: Int64?,
        quality: Double
    ) async throws -> Data {
        // Image compression and optimization
    }
    
    private func optimizeCPUUsage() async throws {
        // Reduce CPU-intensive operations
    }
    
    private func optimizeBatteryUsage() async throws {
        // Reduce battery-draining operations
    }
    
    private func optimizeFrameRate() async throws {
        // Optimize rendering for better frame rate
    }
}

// MARK: - Cache Types

private struct CachedImage {
    let identifier: String
    let data: Data
    var lastAccessed: Date
}

private class CachedResource<T> {
    let identifier: String
    let value: T
    var lastAccessed: Date
    
    init(identifier: String, value: T) {
        self.identifier = identifier
        self.value = value
        self.lastAccessed = Date()
    }
}
```

### Performance Hints

```swift
/// Hints for performance optimization configuration
public struct PerformanceHints {
    public let memoryLimit: Int64
    public let cacheLimit: Int64
    public let enableLazyLoading: Bool
    public let enableBatteryOptimization: Bool
    public let strategy: OptimizationStrategy
    public let target: OptimizationTarget
    
    public init(
        memoryLimit: Int64 = 100 * 1024 * 1024,
        cacheLimit: Int64 = 50 * 1024 * 1024,
        enableLazyLoading: Bool = true,
        enableBatteryOptimization: Bool = true,
        strategy: OptimizationStrategy = .balanced,
        target: OptimizationTarget = .all
    ) {
        self.memoryLimit = memoryLimit
        self.cacheLimit = cacheLimit
        self.enableLazyLoading = enableLazyLoading
        self.enableBatteryOptimization = enableBatteryOptimization
        self.strategy = strategy
        self.target = target
    }
}
```

## Layer 1 Semantic Functions

Following the pattern of `PlatformInternationalizationL1.swift`:

```swift
/// Present content with lazy loading
@MainActor
public func platformPresentLazyContent_L1<Content: View>(
    identifier: String,
    @ViewBuilder content: @escaping () -> Content,
    hints: PerformanceHints = PerformanceHints()
) -> AnyView {
    let performance = PerformanceService(
        memoryLimit: hints.memoryLimit,
        cacheLimit: hints.cacheLimit,
        enableLazyLoading: hints.enableLazyLoading
    )
    
    return AnyView(
        LazyView(identifier: identifier, content: content)
            .environmentObject(performance)
            .automaticCompliance(named: "platformPresentLazyContent_L1")
    )
}

/// Optimize image with automatic caching
@MainActor
public func platformOptimizeImage_L1(
    image: PlatformImage,
    maxSize: Int64? = nil,
    hints: PerformanceHints = PerformanceHints()
) async throws -> Data {
    let performance = PerformanceService(
        cacheLimit: hints.cacheLimit
    )
    return try await performance.optimizeImage(image, maxSize: maxSize)
}

/// Optimize performance for current conditions
@MainActor
public func platformOptimizePerformance_L1(
    target: OptimizationTarget = .all,
    hints: PerformanceHints = PerformanceHints()
) async throws {
    let performance = PerformanceService(
        memoryLimit: hints.memoryLimit,
        cacheLimit: hints.cacheLimit,
        enableBatteryOptimization: hints.enableBatteryOptimization
    )
    performance.strategy = hints.strategy
    try await performance.optimizeMemory(target: target)
}
```

## Platform-Specific Considerations

### iOS
- Memory pressure handling
- Battery level monitoring
- Thermal state monitoring
- Background app refresh optimization
- Image optimization with Metal Performance Shaders

### macOS
- Multi-display optimization
- Window management optimization
- System resource management
- Background processing optimization
- Image optimization with Core Image

### visionOS
- Spatial rendering optimization
- Immersive performance optimization
- Hand tracking performance

## Testing

- Framework tests should avoid actual resource loading (use mocks)
- Service should be mockable via protocol
- Platform-specific behavior should be testable
- Performance metrics should be testable
- Cache behavior should be testable

## Implementation Checklist

### Phase 1: Core Service
- [ ] Create `PerformanceService` class
- [ ] Define `PerformanceServiceError` enum
- [ ] Implement performance metrics collection
- [ ] Implement memory monitoring
- [ ] Implement cache management
- [ ] Define `PerformanceHints` struct

### Phase 2: Memory & Cache Management
- [ ] Implement memory optimization
- [ ] Implement cache clearing
- [ ] Add LRU cache eviction
- [ ] Add memory pressure handling
- [ ] Implement automatic cleanup

### Phase 3: Lazy Loading
- [ ] Implement lazy resource loading
- [ ] Add resource preloading
- [ ] Add priority queue for preloading
- [ ] Integrate with SwiftUI views

### Phase 4: Image Optimization
- [ ] Implement image compression
- [ ] Implement image resizing
- [ ] Add image caching
- [ ] Integrate with `ImageProcessingPipeline`
- [ ] Add platform-specific optimizations (Metal, Core Image)

### Phase 5: Battery Optimization
- [ ] Implement battery level monitoring
- [ ] Implement thermal state monitoring
- [ ] Add battery optimization strategies
- [ ] Add adaptive frame rate adjustment

### Phase 6: Layer 1 Functions
- [ ] Create `PlatformPerformanceL1.swift`
- [ ] Implement `platformPresentLazyContent_L1()`
- [ ] Implement `platformOptimizeImage_L1()`
- [ ] Implement `platformOptimizePerformance_L1()`
- [ ] Add performance monitoring views

### Phase 7: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`PerformanceGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation
- [ ] Add performance profiling tools

## Design Decisions

### Why Service Pattern?
- **Consistency**: Matches `InternationalizationService` pattern
- **ObservableObject**: Enables SwiftUI binding
- **Testability**: Easy to mock for testing
- **Separation of Concerns**: Framework handles boilerplate, app handles configuration

### Why Configuration-Based?
- **Flexibility**: Apps can configure performance limits
- **Adaptability**: Apps can adjust based on device capabilities
- **Platform Adaptation**: Automatic platform detection

### Why Layer 1 Functions?
- **Semantic Intent**: High-level performance interfaces
- **Framework Focus**: UI abstraction is core to framework
- **Consistency**: Matches existing Layer 1 patterns

## Related

- `InternationalizationService.swift` - Reference implementation pattern
- `ImageProcessingPipeline.swift` - Existing image processing (to be integrated)
- `PlatformInternationalizationL1.swift` - Layer 1 function pattern
- `PlatformPerformanceExtensionsLayer5.swift` - Existing performance extensions (to be integrated)

## Acceptance Criteria

- [ ] `PerformanceService` class exists with full API
- [ ] Memory management works correctly
- [ ] Cache management is functional
- [ ] Lazy loading works for resources
- [ ] Image optimization works correctly
- [ ] Battery optimization is functional
- [ ] Performance monitoring provides accurate metrics
- [ ] Layer 1 semantic functions are implemented
- [ ] Comprehensive tests pass (40+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported
