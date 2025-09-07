# OCR Overlay System Guide

## Overview

The OCR Overlay System provides interactive visual text correction capabilities, allowing users to edit OCR results directly on images through an intuitive tap-to-edit interface. This system follows the six-layer architecture principles and integrates seamlessly with the existing OCR functionality.

## Features

### 🎯 Visual Text Regions
- **Bounding Box Visualization** - Clear visual indicators for detected text regions
- **Confidence Indicators** - Color-coded confidence levels (green/orange/red)
- **Interactive Highlighting** - Visual feedback for selected and editing regions

### ✏️ Text Editing
- **Tap-to-Edit** - Direct text editing by tapping on regions
- **Keyboard Support** - Full keyboard input with focus management
- **Context Menus** - Right-click/long-press for edit/delete options
- **Real-time Updates** - Immediate visual feedback during editing

### ⚙️ Configuration
- **Customizable Behavior** - Enable/disable editing and deletion
- **Visual Customization** - Custom colors and thresholds
- **Accessibility Settings** - VoiceOver and assistive technology support

## Architecture

### Layer 1: Semantic - OCRTextRegion
```swift
public struct OCRTextRegion: Identifiable, Equatable {
    public let id: UUID
    public let text: String
    public let boundingBox: CGRect
    public let confidence: Float
    public let textType: TextType?
}
```

### Layer 2: Decision - OCROverlayState
```swift
@MainActor
public final class OCROverlayState: ObservableObject {
    @Published public var isEditingText = false
    @Published public var editingBoundingBox: CGRect?
    @Published public var editingText = ""
    @Published public var textRegions: [OCRTextRegion] = []
    @Published public var selectedRegion: OCRTextRegion?
}
```

### Layer 3: Strategy - OCROverlayConfiguration
```swift
public struct OCROverlayConfiguration {
    public let allowsEditing: Bool
    public let allowsDeletion: Bool
    public let showConfidenceIndicators: Bool
    public let highlightColor: Color
    public let editingColor: Color
    public let lowConfidenceThreshold: Float
    public let highConfidenceThreshold: Float
}
```

## Usage Examples

### Basic Implementation

```swift
import SixLayerFramework

struct OCRCorrectionView: View {
    let image: PlatformImage
    let ocrResult: OCRResult
    
    var body: some View {
        OCROverlayView(
            image: image,
            result: ocrResult,
            onTextEdit: { newText, boundingBox in
                // Handle text editing
                print("Edited text: \(newText) at \(boundingBox)")
            },
            onTextDelete: { boundingBox in
                // Handle text deletion
                print("Deleted text at \(boundingBox)")
            }
        )
    }
}
```

### Custom Configuration

```swift
let configuration = OCROverlayConfiguration(
    allowsEditing: true,
    allowsDeletion: true,
    showConfidenceIndicators: true,
    highlightColor: .blue,
    editingColor: .green,
    lowConfidenceThreshold: 0.7,
    highConfidenceThreshold: 0.9
)

OCROverlayView(
    image: image,
    result: ocrResult,
    configuration: configuration,
    onTextEdit: handleTextEdit,
    onTextDelete: handleTextDelete
)
```

### Integration with Disambiguation

```swift
let overlayView = OCROverlayView.fromDisambiguationResult(
    image: image,
    result: disambiguationResult,
    onTextEdit: handleTextEdit,
    onTextDelete: handleTextDelete
)
```

## API Reference

### OCROverlayView

#### Initialization
```swift
public init(
    image: PlatformImage,
    result: OCRResult,
    configuration: OCROverlayConfiguration = OCROverlayConfiguration(),
    onTextEdit: @escaping (String, CGRect) -> Void,
    onTextDelete: @escaping (CGRect) -> Void
)
```

#### Public Methods
```swift
// Detect tapped text region
public func detectTappedTextRegion(at point: CGPoint) -> OCRTextRegion?

// Start text editing
public func startTextEditing(for boundingBox: CGRect)

// Complete text editing
public func completeTextEditing()
public func completeTextEditing(with text: String)

// Cancel text editing
public func cancelTextEditing()

// Delete text region
public func deleteTextRegion(at boundingBox: CGRect)

// Get confidence color
public func confidenceColor(for confidence: Float) -> Color
```

#### Static Methods
```swift
// Convert bounding box coordinates
public static func convertBoundingBoxToImageCoordinates(
    boundingBox: CGRect,
    imageSize: CGSize
) -> CGRect

// Create from disambiguation result
public static func fromDisambiguationResult(
    image: PlatformImage,
    result: OCRDisambiguationResult,
    configuration: OCROverlayConfiguration = OCROverlayConfiguration(),
    onTextEdit: @escaping (String, CGRect) -> Void,
    onTextDelete: @escaping (CGRect) -> Void
) -> OCROverlayView
```

## Accessibility

The OCR Overlay System includes comprehensive accessibility support:

- **VoiceOver Integration** - Full VoiceOver support for text regions
- **Accessibility Labels** - Descriptive labels for each text region
- **Accessibility Hints** - Clear instructions for interaction
- **Keyboard Navigation** - Full keyboard support for editing
- **Focus Management** - Proper focus handling during editing

## Performance Considerations

- **Efficient Rendering** - Optimized SwiftUI rendering with minimal redraws
- **Memory Management** - Proper state management with `@StateObject`
- **Platform Optimization** - Platform-specific image rendering optimizations
- **Confidence Calculation** - Efficient confidence color calculation

## Testing

The OCR Overlay System includes comprehensive test coverage:

- **18 test cases** covering all functionality
- **Unit tests** for individual components
- **Integration tests** with disambiguation system
- **Performance tests** for rendering optimization
- **Accessibility tests** for VoiceOver support

## Best Practices

1. **Always provide meaningful callbacks** - Implement `onTextEdit` and `onTextDelete` handlers
2. **Configure appropriately** - Use `OCROverlayConfiguration` to match your app's needs
3. **Handle edge cases** - Consider empty results, overlapping regions, and invalid bounding boxes
4. **Test thoroughly** - Use the provided test suite as a reference
5. **Follow accessibility guidelines** - Ensure your implementation supports all users

## Troubleshooting

### Common Issues

**Text regions not detected:**
- Ensure `OCRResult` has valid `boundingBoxes`
- Check that bounding boxes are in correct coordinate system
- Verify text regions are properly initialized

**Editing not working:**
- Confirm `allowsEditing` is enabled in configuration
- Check that `onTextEdit` callback is properly implemented
- Ensure proper state management

**Accessibility issues:**
- Verify VoiceOver is properly configured
- Check accessibility labels and hints
- Test with assistive technologies

## Future Enhancements

- **Multi-language support** - Enhanced language detection and editing
- **Advanced editing tools** - Font selection, formatting options
- **Batch operations** - Select and edit multiple regions
- **Undo/Redo support** - Edit history management
- **Export functionality** - Save edited results in various formats
