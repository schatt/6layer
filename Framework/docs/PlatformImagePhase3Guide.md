# PlatformImage Phase 3 Guide

## Overview

Phase 3 adds export, processing, and metadata capabilities to `PlatformImage`, making it a complete cross-platform image manipulation solution. This guide covers all Phase 3 features implemented in Issue #33.

## Table of Contents

1. [Export Methods](#export-methods)
2. [Image Processing](#image-processing)
3. [Metadata Extraction](#metadata-extraction)
4. [Complete Examples](#complete-examples)
5. [Best Practices](#best-practices)

---

## Export Methods

Phase 3 adds three export methods to convert `PlatformImage` to various data formats.

### PNG Export

Export images to PNG format with lossless compression:

```swift
let image = PlatformImage.createPlaceholder()
guard let pngData = image.exportPNG() else {
    // Handle export failure
    return
}

// Save to file
try? pngData.write(to: fileURL)

// Use in network request
let request = URLRequest(url: uploadURL)
request.httpBody = pngData
```

### JPEG Export

Export images to JPEG format with configurable quality:

```swift
let image = PlatformImage.createPlaceholder()

// Default quality (0.8)
let jpegData = image.exportJPEG()

// Custom quality (0.0 to 1.0)
let highQualityJPEG = image.exportJPEG(quality: 1.0)  // Maximum quality
let lowQualityJPEG = image.exportJPEG(quality: 0.3)   // Smaller file size
```

**Quality Guidelines:**
- `1.0`: Maximum quality, largest file size (best for photos)
- `0.8`: High quality, balanced (default, good for most uses)
- `0.5`: Medium quality, smaller file size (good for thumbnails)
- `0.3`: Low quality, smallest file size (only for previews)

### Bitmap Export

Export images to platform-specific bitmap format:

```swift
let image = PlatformImage.createPlaceholder()
guard let bitmapData = image.exportBitmap() else {
    return
}

// Platform-specific format:
// - iOS: PNG format
// - macOS: TIFF format
```

---

## Image Processing

Phase 3 adds comprehensive image processing capabilities using Core Image.

### Resize

Resize images to a target size:

```swift
let originalImage = PlatformImage.createPlaceholder()
let targetSize = CGSize(width: 200, height: 200)

// Resize to exact dimensions
let resized = originalImage.resized(to: targetSize)
```

**Note:** Resize maintains aspect ratio by stretching/squashing. For aspect-ratio-preserving resize, use crop or calculate target size manually.

### Crop

Crop images to a specific rectangle:

```swift
let image = PlatformImage.createPlaceholder()
let cropRect = CGRect(x: 10, y: 10, width: 50, height: 50)

// Crop to specified rectangle
let cropped = image.cropped(to: cropRect)

// Invalid rectangles are automatically clamped to image bounds
let invalidRect = CGRect(x: -10, y: -10, width: 200, height: 200)
let safeCropped = image.cropped(to: invalidRect)  // Clamped to valid bounds
```

### Rotate

Rotate images by any angle in degrees:

```swift
let image = PlatformImage.createPlaceholder()

// Rotate 90 degrees clockwise
let rotated90 = image.rotated(by: 90.0)

// Rotate 180 degrees (upside down)
let rotated180 = image.rotated(by: 180.0)

// Rotate 45 degrees
let rotated45 = image.rotated(by: 45.0)

// Negative angles rotate counter-clockwise
let rotatedCCW = image.rotated(by: -90.0)
```

**Note:** Rotation may change image dimensions. A 90° rotation swaps width and height.

### Color Adjustments

Adjust brightness, contrast, and saturation:

```swift
let image = PlatformImage.createPlaceholder()

// Brightness: -1.0 (darkest) to 1.0 (brightest), 0.0 = no change
let brighter = image.adjustedBrightness(by: 0.3)   // 30% brighter
let darker = image.adjustedBrightness(by: -0.2)     // 20% darker

// Contrast: 0.0 to 2.0+, 1.0 = no change
let moreContrast = image.adjustedContrast(by: 1.5)  // 50% more contrast
let lessContrast = image.adjustedContrast(by: 0.7)  // 30% less contrast

// Saturation: 0.0 (grayscale) to 2.0+ (vivid), 1.0 = no change
let moreSaturated = image.adjustedSaturation(by: 1.3)  // 30% more vivid
let desaturated = image.adjustedSaturation(by: 0.5)    // 50% less (near grayscale)
```

### Filters

Apply visual effects filters:

```swift
let image = PlatformImage.createPlaceholder()

// Grayscale filter
let grayscale = image.applyingFilter(.grayscale)

// Blur filter with radius
let blurred = image.applyingFilter(.blur(radius: 5.0))  // 5.0 pixel blur
let heavilyBlurred = image.applyingFilter(.blur(radius: 20.0))

// Sepia tone filter
let sepia = image.applyingFilter(.sepia)
```

**Filter Notes:**
- Blur filter maintains original image size (crops expanded edges)
- All filters preserve image dimensions
- Filters can be chained for combined effects

---

## Metadata Extraction

Extract image properties and metadata:

```swift
let image = PlatformImage.createPlaceholder()
let properties = image.properties

// Basic properties
print("Width: \(properties.width)")
print("Height: \(properties.height)")
print("Size: \(properties.size)")

// Color space information
if let colorSpace = properties.colorSpace {
    print("Color space: \(colorSpace)")
}

// Pixel format information
if let pixelFormat = properties.pixelFormat {
    print("Pixel format: \(pixelFormat)")
    // Example: "32 bits per pixel, 8 bits per component"
}
```

---

## Complete Examples

### Example 1: Image Processing Pipeline

Process an image through multiple operations:

```swift
func processImage(_ image: PlatformImage) -> PlatformImage {
    // 1. Resize to thumbnail
    let thumbnail = image.resized(to: CGSize(width: 200, height: 200))
    
    // 2. Adjust brightness and contrast
    let enhanced = thumbnail
        .adjustedBrightness(by: 0.1)
        .adjustedContrast(by: 1.2)
    
    // 3. Apply sepia filter
    let filtered = enhanced.applyingFilter(.sepia)
    
    return filtered
}
```

### Example 2: Export for Different Use Cases

Export images optimized for different purposes:

```swift
func exportForSharing(_ image: PlatformImage) -> Data? {
    // High quality JPEG for sharing
    return image.exportJPEG(quality: 0.9)
}

func exportForThumbnail(_ image: PlatformImage) -> Data? {
    // Resize first, then export with lower quality
    let thumbnail = image.resized(to: CGSize(width: 150, height: 150))
    return thumbnail.exportJPEG(quality: 0.6)
}

func exportForArchive(_ image: PlatformImage) -> Data? {
    // Lossless PNG for archiving
    return image.exportPNG()
}
```

### Example 3: Image Editor with Undo

Create an image editor with undo capability:

```swift
class ImageEditor {
    private var history: [PlatformImage] = []
    private var currentImage: PlatformImage
    
    init(image: PlatformImage) {
        self.currentImage = image
        self.history.append(image)
    }
    
    func adjustBrightness(by amount: Double) {
        currentImage = currentImage.adjustedBrightness(by: amount)
        history.append(currentImage)
    }
    
    func applyFilter(_ filter: PlatformImage.ImageFilter) {
        currentImage = currentImage.applyingFilter(filter)
        history.append(currentImage)
    }
    
    func rotate(by degrees: Double) {
        currentImage = currentImage.rotated(by: degrees)
        history.append(currentImage)
    }
    
    func undo() -> PlatformImage? {
        guard history.count > 1 else { return nil }
        history.removeLast()
        currentImage = history.last!
        return currentImage
    }
    
    func export() -> Data? {
        return currentImage.exportJPEG(quality: 0.9)
    }
}
```

### Example 4: Image Metadata Analysis

Analyze image properties for optimization:

```swift
func analyzeImage(_ image: PlatformImage) {
    let props = image.properties
    
    print("Image Analysis:")
    print("  Dimensions: \(Int(props.width))x\(Int(props.height))")
    print("  Size: \(props.size)")
    
    if let colorSpace = props.colorSpace {
        print("  Color Space: \(colorSpace)")
    }
    
    if let pixelFormat = props.pixelFormat {
        print("  Pixel Format: \(pixelFormat)")
    }
    
    // Determine optimal export format
    let isLarge = props.width > 2000 || props.height > 2000
    let recommendedFormat = isLarge ? "JPEG (compressed)" : "PNG (lossless)"
    print("  Recommended Format: \(recommendedFormat)")
}
```

### Example 5: Cross-Platform Image Processing

Process images consistently across platforms:

```swift
func prepareImageForUpload(_ image: PlatformImage) -> Data? {
    // These operations work identically on iOS and macOS
    
    // 1. Resize if too large
    let maxDimension: CGFloat = 1920
    let currentSize = image.size
    let needsResize = currentSize.width > maxDimension || currentSize.height > maxDimension
    
    let processed = needsResize 
        ? image.resized(to: CGSize(width: maxDimension, height: maxDimension))
        : image
    
    // 2. Enhance for web display
    let enhanced = processed
        .adjustedBrightness(by: 0.05)
        .adjustedContrast(by: 1.1)
        .adjustedSaturation(by: 1.05)
    
    // 3. Export as JPEG (smaller than PNG)
    return enhanced.exportJPEG(quality: 0.85)
}
```

---

## Best Practices

### 1. Error Handling

Always handle optional return values:

```swift
// ✅ Good: Handle export failures
guard let imageData = image.exportPNG() else {
    print("Failed to export image")
    return
}

// ❌ Bad: Force unwrap
let imageData = image.exportPNG()!  // Can crash
```

### 2. Performance Considerations

- **Resize before processing**: Process smaller images for better performance
- **Reuse CIContext**: The framework handles this internally, but be aware that multiple operations create new contexts
- **Chain operations efficiently**: Each operation creates a new `PlatformImage`, so chain operations when possible

```swift
// ✅ Good: Chain operations
let result = image
    .resized(to: targetSize)
    .adjustedBrightness(by: 0.1)
    .applyingFilter(.sepia)

// ❌ Less efficient: Multiple intermediate variables
let resized = image.resized(to: targetSize)
let brightened = resized.adjustedBrightness(by: 0.1)
let result = brightened.applyingFilter(.sepia)
```

### 3. Quality Settings

Choose appropriate quality based on use case:

```swift
// High quality for photos
let photoData = image.exportJPEG(quality: 0.9)

// Medium quality for thumbnails
let thumbnailData = thumbnail.exportJPEG(quality: 0.7)

// Low quality for previews
let previewData = preview.exportJPEG(quality: 0.5)

// Lossless for archiving
let archiveData = image.exportPNG()
```

### 4. Memory Management

Large images consume significant memory. Process in batches for multiple images:

```swift
func processImages(_ images: [PlatformImage]) {
    for image in images {
        // Process one at a time to manage memory
        let processed = processImage(image)
        // Save or use processed image
    }
}
```

### 5. Cross-Platform Compatibility

All Phase 3 features work identically on iOS and macOS:

```swift
// This code works on both platforms without modification
func processImage(_ image: PlatformImage) -> PlatformImage {
    return image
        .resized(to: CGSize(width: 200, height: 200))
        .adjustedBrightness(by: 0.1)
        .applyingFilter(.sepia)
}
```

---

## API Reference

### Export Methods

- `exportPNG() -> Data?` - Export to PNG format
- `exportJPEG(quality: Double = 0.8) -> Data?` - Export to JPEG format
- `exportJPEG() -> Data?` - Export to JPEG with default quality (0.8)
- `exportBitmap() -> Data?` - Export to platform-specific bitmap format

### Processing Methods

- `resized(to: CGSize) -> PlatformImage` - Resize to target size
- `cropped(to: CGRect) -> PlatformImage` - Crop to rectangle
- `rotated(by: Double) -> PlatformImage` - Rotate by angle in degrees
- `adjustedBrightness(by: Double) -> PlatformImage` - Adjust brightness (-1.0 to 1.0)
- `adjustedContrast(by: Double) -> PlatformImage` - Adjust contrast (0.0 to 2.0+)
- `adjustedSaturation(by: Double) -> PlatformImage` - Adjust saturation (0.0 to 2.0+)
- `applyingFilter(_: ImageFilter) -> PlatformImage` - Apply visual filter

### Filter Types

```swift
enum ImageFilter {
    case grayscale
    case blur(radius: Double)
    case sepia
}
```

### Metadata Properties

```swift
struct ImageProperties {
    let width: CGFloat
    let height: CGFloat
    let size: CGSize
    let colorSpace: String?
    let pixelFormat: String?
}
```

---

## Related Documentation

- [PlatformImage Architecture](../todos.md#platformimage-standardization-plan) - Architecture overview
- [PlatformImage Phase 1 & 2](../todos.md#phase-1-foundation-completed) - Previous phases
- [Issue #33](https://github.com/schatt/6layer/issues/33) - Phase 3 implementation tracking

---

## Implementation Notes

- All methods return non-optional `PlatformImage` (except export methods which return `Data?`)
- Empty images and invalid parameters are handled gracefully (return original image or empty data)
- Core Image is used for color adjustments and filters (requires `canImport(CoreImage)`)
- Cross-platform compatibility is maintained throughout
- Performance optimized with shared helper methods

---

**Last Updated**: December 2025  
**Version**: Phase 3 (Issue #33)  
**Status**: ✅ Complete

