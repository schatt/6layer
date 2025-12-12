# Performance Service: Lazy Loading & Image Optimization

**Parent Issue**: #107  
**Depends On**: #107a (Performance Service Core)

## Overview

Add lazy loading and image optimization capabilities to the Performance Service, building on the core memory and cache management infrastructure.

This extends the core Performance Service with:
- Lazy resource loading with caching
- Image optimization with automatic caching
- Integration with existing `ImageProcessingPipeline`
- Resource preloading with priority queues

## Motivation

Lazy loading and image optimization are critical for performance:
- Lazy loading reduces initial memory footprint
- Image optimization reduces memory usage and improves load times
- Automatic caching prevents redundant processing
- Resource preloading improves perceived performance

**Solution**: Extend `PerformanceService` with lazy loading and image-specific optimization methods.

## Architecture Pattern

This extends the core `PerformanceService` from issue #107a:
- **Builds on core**: Uses existing cache management
- **Service extension**: Adds methods to existing service
- **Integration**: Works with `ImageProcessingPipeline`

## Proposed API Design

### Extensions to PerformanceService

```swift
extension PerformanceService {
    // MARK: - Lazy Loading
    
    /// Load resource lazily with automatic caching
    /// - Parameters:
    ///   - identifier: Resource identifier
    ///   - loader: Async loader function
    /// - Returns: Loaded resource
    public func loadLazily<T: Codable>(
        identifier: String,
        loader: @escaping () async throws -> T
    ) async throws -> T {
        // Check cache first
        if let cachedData = retrieveCachedItem(identifier: identifier),
           let cached = try? JSONDecoder().decode(T.self, from: cachedData) {
            return cached
        }
        
        // Load and cache
        let value = try await loader()
        if let encoded = try? JSONEncoder().encode(value) {
            try? cacheItem(identifier: identifier, data: encoded)
        }
        
        return value
    }
    
    /// Preload resources in background
    /// - Parameters:
    ///   - identifiers: Resource identifiers to preload
    ///   - loader: Loader function for each identifier
    public func preloadResources<T: Codable>(
        identifiers: [String],
        loader: @escaping (String) async throws -> T
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for identifier in identifiers {
                group.addTask {
                    _ = try? await self.loadLazily(identifier: identifier) {
                        try await loader(identifier)
                    }
                }
            }
        }
    }
    
    // MARK: - Image Optimization
    
    /// Optimize image with automatic caching
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
        let cacheKey = "image-\(image.hashValue)-\(maxSize ?? 0)-\(quality)"
        if let cached = retrieveCachedItem(identifier: cacheKey) {
            return cached
        }
        
        // Optimize image using ImageProcessingPipeline
        let optimized = try await performImageOptimization(
            image: image,
            maxSize: maxSize,
            quality: quality
        )
        
        // Cache result
        try? cacheItem(identifier: cacheKey, data: optimized)
        
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
        // Use ImageProcessingPipeline for resizing
        let processed = try await ImageProcessingPipeline.process(
            image,
            for: .photo,
            with: ProcessingOptions(
                quality: .high,
                targetSize: targetSize,
                maintainAspectRatio: maintainAspectRatio
            )
        )
        return processed.processedImage
    }
    
    /// Get optimized image data for display
    /// - Parameters:
    ///   - image: Image to optimize
    ///   - displaySize: Target display size
    ///   - quality: Compression quality
    /// - Returns: Optimized image data
    public func getOptimizedImageData(
        _ image: PlatformImage,
        displaySize: CGSize,
        quality: Double = 0.8
    ) async throws -> Data {
        // Resize first if needed
        let resized = try await resizeImage(
            image,
            targetSize: displaySize,
            maintainAspectRatio: true
        )
        
        // Then optimize
        return try await optimizeImage(resized, quality: quality)
    }
    
    // MARK: - Private Helpers
    
    private func performImageOptimization(
        image: PlatformImage,
        maxSize: Int64?,
        quality: Double
    ) async throws -> Data {
        // Use ImageProcessingPipeline for optimization
        let processed = try await ImageProcessingPipeline.process(
            image,
            for: .photo,
            with: ProcessingOptions(
                quality: qualityToProcessingQuality(quality),
                enableOptimization: true,
                enableEnhancement: false
            )
        )
        
        // Convert to data
        #if os(iOS)
        return processed.processedImage.pngData() ?? Data()
        #elseif os(macOS)
        let rep = NSBitmapImageRep(cgImage: processed.processedImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        return rep.representation(using: .png, properties: [:]) ?? Data()
        #else
        return Data()
        #endif
    }
    
    private func qualityToProcessingQuality(_ quality: Double) -> ProcessingQuality {
        switch quality {
        case 0.9...1.0:
            return .maximum
        case 0.7..<0.9:
            return .high
        case 0.5..<0.7:
            return .medium
        default:
            return .low
        }
    }
}
```

### Layer 1 Semantic Functions

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
        cacheLimit: hints.cacheLimit
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

/// Lazy load resource with caching
@MainActor
public func platformLoadLazyResource_L1<T: Codable>(
    identifier: String,
    loader: @escaping () async throws -> T,
    hints: PerformanceHints = PerformanceHints()
) async throws -> T {
    let performance = PerformanceService(
        cacheLimit: hints.cacheLimit
    )
    return try await performance.loadLazily(identifier: identifier, loader: loader)
}
```

### LazyView Helper

```swift
/// SwiftUI view that loads content lazily
public struct LazyView<Content: View>: View {
    let identifier: String
    let content: () -> Content
    
    @StateObject private var loader = LazyContentLoader()
    
    public init(identifier: String, @ViewBuilder content: @escaping () -> Content) {
        self.identifier = identifier
        self.content = content
    }
    
    public var body: some View {
        Group {
            if loader.isLoaded {
                content()
            } else {
                ProgressView()
                    .onAppear {
                        loader.load(identifier: identifier)
                    }
            }
        }
    }
}

private class LazyContentLoader: ObservableObject {
    @Published var isLoaded = false
    
    func load(identifier: String) {
        // Load content asynchronously
        Task {
            // Simulate loading
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            await MainActor.run {
                isLoaded = true
            }
        }
    }
}
```

## Platform-Specific Considerations

### iOS
- Image optimization with Metal Performance Shaders (if available)
- Memory-efficient image decoding
- Background image processing

### macOS
- Image optimization with Core Image
- Multi-threaded image processing
- Efficient image format conversion

### visionOS
- Spatial image optimization
- Immersive image loading

## Integration with ImageProcessingPipeline

This issue integrates with the existing `ImageProcessingPipeline`:
- Uses `ImageProcessingPipeline.process()` for image optimization
- Leverages existing enhancement and optimization features
- Adds caching layer on top of processing pipeline
- Maintains compatibility with existing image processing code

## Testing

- Framework tests should use mocks for image processing
- Lazy loading should be testable with mock loaders
- Cache behavior should be verified
- Image optimization results should be testable

## Implementation Checklist

### Phase 1: Lazy Loading
- [ ] Extend `PerformanceService` with `loadLazily()` method
- [ ] Implement resource caching for lazy-loaded items
- [ ] Add `preloadResources()` method
- [ ] Create `LazyView` SwiftUI helper
- [ ] Add priority queue for preloading

### Phase 2: Image Optimization
- [ ] Extend `PerformanceService` with `optimizeImage()` method
- [ ] Integrate with `ImageProcessingPipeline`
- [ ] Implement image caching
- [ ] Add `resizeImage()` method
- [ ] Add `getOptimizedImageData()` method
- [ ] Add platform-specific optimizations (Metal, Core Image)

### Phase 3: Layer 1 Functions
- [ ] Create `PlatformPerformanceL1.swift` (or extend existing)
- [ ] Implement `platformPresentLazyContent_L1()`
- [ ] Implement `platformOptimizeImage_L1()`
- [ ] Implement `platformLoadLazyResource_L1()`
- [ ] Add RTL support for lazy loading UI

### Phase 4: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`PerformanceLazyLoadingGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation
- [ ] Document integration with `ImageProcessingPipeline`

## Design Decisions

### Why Extend Core Service?
- **Reusability**: Uses existing cache management
- **Consistency**: Single service for all performance features
- **Efficiency**: Shared cache for all resource types

### Why Integrate with ImageProcessingPipeline?
- **No Duplication**: Leverages existing image processing
- **Consistency**: Same processing pipeline across framework
- **Extensibility**: Can add caching without changing pipeline

### Why LazyView Helper?
- **SwiftUI Integration**: Easy to use in SwiftUI views
- **Automatic Loading**: Handles loading state automatically
- **Reusability**: Can be used for any lazy-loaded content

## Related

- Issue #107 - Parent issue for Performance Service
- Issue #107a - Performance Service Core (dependency)
- `ImageProcessingPipeline.swift` - Existing image processing
- `InternationalizationService.swift` - Reference implementation pattern

## Acceptance Criteria

- [ ] Lazy loading works with automatic caching
- [ ] Resource preloading works correctly
- [ ] Image optimization works correctly
- [ ] Image caching prevents redundant processing
- [ ] Integration with `ImageProcessingPipeline` works
- [ ] `LazyView` helper works in SwiftUI
- [ ] Layer 1 semantic functions are implemented
- [ ] Comprehensive tests pass (20+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported
