import SwiftUI
import Combine

// MARK: - Layer 5: Performance Optimization
// This layer provides performance optimization features that work across platforms
// Includes lazy loading, memory management, performance profiling, and caching

// MARK: - Performance Metrics

/// Performance metrics for monitoring and optimization
public struct ViewPerformanceMetrics {
    public let renderTime: TimeInterval
    public let memoryUsage: Int64
    public let frameRate: Double
    public let cacheHitRate: Double
    
    public init(
        renderTime: TimeInterval = 0,
        memoryUsage: Int64 = 0,
        frameRate: Double = 0,
        cacheHitRate: Double = 0
    ) {
        self.renderTime = renderTime
        self.memoryUsage = memoryUsage
        self.frameRate = frameRate
        self.cacheHitRate = cacheHitRate
    }
}

// MARK: - Lazy Loading System

/// Lazy loading configuration for views
public struct LazyLoadingConfig {
    public let threshold: Int
    public let batchSize: Int
    public let preloadDistance: Int
    public let enableVirtualization: Bool
    
    public init(
        threshold: Int = 10,
        batchSize: Int = 5,
        preloadDistance: Int = 3,
        enableVirtualization: Bool = true
    ) {
        self.threshold = threshold
        self.batchSize = batchSize
        self.preloadDistance = preloadDistance
        self.enableVirtualization = enableVirtualization
    }
}

/// Lazy loading state management
public class LazyLoadingState: ObservableObject {
    @Published public var loadedItems: [Int] = []
    @Published public var isLoading: Bool = false
    @Published public var hasMoreData: Bool = true
    
    private var totalItems: Int
    private let config: LazyLoadingConfig
    
    public init(totalItems: Int, config: LazyLoadingConfig = LazyLoadingConfig()) {
        self.totalItems = totalItems
        self.config = config
    }
    
    public func loadMoreIfNeeded(currentIndex: Int) {
        guard !isLoading && hasMoreData else { return }
        
        let shouldLoad = currentIndex >= loadedItems.count - config.preloadDistance
        if shouldLoad {
            loadNextBatch()
        }
    }
    
    private func loadNextBatch() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            let startIndex = self.loadedItems.count
            let endIndex = min(startIndex + self.config.batchSize, self.totalItems)
            
            let newItems = Array(startIndex..<endIndex)
            self.loadedItems.append(contentsOf: newItems)
            
            self.hasMoreData = endIndex < self.totalItems
            self.isLoading = false
        }
    }
}

// MARK: - Memory Management

/// Memory management configuration
public struct MemoryConfig {
    public let maxCacheSize: Int
    public let evictionPolicy: EvictionPolicy
    public let enableCompression: Bool
    public let monitorMemoryPressure: Bool
    
    public init(
        maxCacheSize: Int = 100 * 1024 * 1024, // 100MB
        evictionPolicy: EvictionPolicy = .lru,
        enableCompression: Bool = true,
        monitorMemoryPressure: Bool = true
    ) {
        self.maxCacheSize = maxCacheSize
        self.evictionPolicy = evictionPolicy
        self.enableCompression = enableCompression
        self.monitorMemoryPressure = monitorMemoryPressure
    }
}

/// Cache eviction policies
public enum EvictionPolicy: String, CaseIterable {
    case lru = "LRU"           // Least Recently Used
    case lfu = "LFU"           // Least Frequently Used
    case fifo = "FIFO"         // First In, First Out
    case random = "Random"     // Random selection
}

/// Memory manager for optimizing memory usage
public class MemoryManager: ObservableObject {
    @Published public var currentMemoryUsage: Int64 = 0
    @Published public var memoryPressure: MemoryPressure = .normal
    
    private let config: MemoryConfig
    private var cache: [String: Any] = [:]
    private var accessTimes: [String: Date] = [:]
    private var accessCounts: [String: Int] = [:]
    
    public init(config: MemoryConfig = MemoryConfig()) {
        self.config = config
        setupMemoryPressureMonitoring()
    }
    
    public func cache<T>(_ value: T, forKey key: String) {
        let size = MemoryLayout<T>.size
        
        // Check if we need to evict items
        if currentMemoryUsage + Int64(size) > config.maxCacheSize {
            evictItems(neededSpace: Int64(size))
        }
        
        cache[key] = value
        accessTimes[key] = Date()
        accessCounts[key] = 0
        currentMemoryUsage += Int64(size)
    }
    
    public func retrieve<T>(forKey key: String) -> T? {
        guard let value = cache[key] as? T else { return nil }
        
        // Update access tracking
        accessTimes[key] = Date()
        accessCounts[key, default: 0] += 1
        
        return value
    }
    
    private func evictItems(neededSpace: Int64) {
        let keysToEvict = selectKeysForEviction(neededSpace: neededSpace)
        
        for key in keysToEvict {
            if let value = cache[key] {
                let size = MemoryLayout<Any>.size
                cache.removeValue(forKey: key)
                accessTimes.removeValue(forKey: key)
                accessCounts.removeValue(forKey: key)
                currentMemoryUsage -= Int64(size)
            }
        }
    }
    
    private func selectKeysForEviction(neededSpace: Int64) -> [String] {
        switch config.evictionPolicy {
        case .lru:
            return Array(accessTimes.keys.sorted { accessTimes[$0]! < accessTimes[$1]! })
        case .lfu:
            return Array(accessCounts.keys.sorted { accessCounts[$0, default: 0] < accessCounts[$1, default: 0] })
        case .fifo:
            return Array(cache.keys)
        case .random:
            return Array(cache.keys.shuffled())
        }
    }
    
    private func setupMemoryPressureMonitoring() {
        #if os(iOS)
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleMemoryPressure()
        }
        #endif
    }
    
    private func handleMemoryPressure() {
        memoryPressure = .critical
        // Clear cache aggressively
        cache.removeAll()
        accessTimes.removeAll()
        accessCounts.removeAll()
        currentMemoryUsage = 0
    }
}

/// Memory pressure levels
public enum MemoryPressure: String, CaseIterable {
    case normal = "Normal"
    case warning = "Warning"
    case critical = "Critical"
}

// MARK: - Performance Profiling

/// Performance profiler for measuring view performance
public class PerformanceProfiler: ObservableObject {
    @Published public var metrics: ViewPerformanceMetrics = ViewPerformanceMetrics()
    
    private var renderStartTime: Date?
    private var frameCount: Int = 0
    private var lastFrameTime: Date = Date()
    
    public func startRender() {
        renderStartTime = Date()
    }
    
    public func endRender() {
        guard let startTime = renderStartTime else { return }
        
        let renderTime = Date().timeIntervalSince(startTime)
        metrics = ViewPerformanceMetrics(
            renderTime: renderTime,
            memoryUsage: metrics.memoryUsage,
            frameRate: metrics.frameRate,
            cacheHitRate: metrics.cacheHitRate
        )
        
        renderStartTime = nil
    }
    
    public func recordFrame() {
        frameCount += 1
        let now = Date()
        let timeSinceLastFrame = now.timeIntervalSince(lastFrameTime)
        
        if timeSinceLastFrame > 0 {
            let frameRate = 1.0 / timeSinceLastFrame
            metrics = ViewPerformanceMetrics(
                renderTime: metrics.renderTime,
                memoryUsage: metrics.memoryUsage,
                frameRate: frameRate,
                cacheHitRate: metrics.cacheHitRate
            )
        }
        
        lastFrameTime = now
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply lazy loading to a list of items
    func lazyLoading<T: Identifiable>(
        items: [T],
        config: LazyLoadingConfig = LazyLoadingConfig(),
        @ViewBuilder content: @escaping (T) -> some View
    ) -> some View {
        LazyLoadingView(
            items: items,
            config: config,
            content: content
        )
    }
    
    /// Apply memory optimization
    func memoryOptimized(config: MemoryConfig = MemoryConfig()) -> some View {
        MemoryOptimizedView(config: config) {
            self
        }
    }
    
    /// Apply performance profiling
    func performanceProfiled() -> some View {
        PerformanceProfiledView {
            self
        }
    }
}

// MARK: - Lazy Loading View

public struct LazyLoadingView<T: Identifiable, Content: View>: View {
    let items: [T]
    let config: LazyLoadingConfig
    let content: (T) -> Content
    
    @StateObject private var lazyState: LazyLoadingState
    
    public init(
        items: [T],
        config: LazyLoadingConfig,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.items = items
        self.config = config
        self.content = content
        self._lazyState = StateObject(wrappedValue: LazyLoadingState(totalItems: items.count, config: config))
    }
    
    public var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                content(item)
                    .onAppear {
                        lazyState.loadMoreIfNeeded(currentIndex: index)
                    }
            }
            
            if lazyState.isLoading {
                ProgressView("Loading...")
                    .padding()
            }
        }
    }
}

// MARK: - Memory Optimized View

public struct MemoryOptimizedView<Content: View>: View {
    let config: MemoryConfig
    let content: () -> Content
    
    @StateObject private var memoryManager = MemoryManager()
    
    public init(config: MemoryConfig, @ViewBuilder content: @escaping () -> Content) {
        self.config = config
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(memoryManager)
            .onReceive(memoryManager.$memoryPressure) { pressure in
                if pressure == .critical {
                    // Apply aggressive memory optimization
                    print("Memory pressure critical - applying optimizations")
                }
            }
    }
}

// MARK: - Performance Profiled View

public struct PerformanceProfiledView<Content: View>: View {
    let content: () -> Content
    
    @StateObject private var profiler = PerformanceProfiler()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(profiler)
            .onAppear {
                profiler.startRender()
            }
            .onDisappear {
                profiler.endRender()
            }
            .onReceive(profiler.$metrics) { metrics in
                // Log performance metrics
                if metrics.renderTime > 0.1 {
                    print("Performance warning: Render time \(metrics.renderTime)s")
                }
            }
    }
}
