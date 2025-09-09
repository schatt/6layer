# OCR Overlay Testing Guide

## Problem: SwiftUI StateObject Warnings

When testing SwiftUI views that use `@StateObject`, you may encounter warnings like:

```
Accessing StateObject<OCROverlayState>'s object without being installed on a View. This will create a new instance each time.
```

This happens when you try to access `@StateObject` properties from outside the SwiftUI view context, such as in tests or utility functions.

## Solution: OCROverlayTestableInterface

The `OCROverlayTestableInterface` class provides a way to test OCR overlay functionality without SwiftUI StateObject issues. It wraps the same `OCROverlayState` logic but can be used outside of SwiftUI views.

### Key Differences

| Aspect | OCROverlayView | OCROverlayTestableInterface |
|--------|----------------|----------------------------|
| **Context** | SwiftUI View | Plain Swift class |
| **State Management** | `@StateObject` | Direct instance |
| **Testing** | Requires SwiftUI context | Can be tested directly |
| **Warnings** | May produce StateObject warnings | No warnings |
| **Usage** | UI rendering | Testing and utility functions |

## Usage Examples

### Basic Testing

```swift
func testOCROverlayFunctionality() {
    // Create test data
    let mockResult = OCRResult(
        extractedText: "Hello World\nTest Text",
        boundingBoxes: [
            CGRect(x: 0.1, y: 0.1, width: 0.3, height: 0.1),
            CGRect(x: 0.1, y: 0.3, width: 0.4, height: 0.1)
        ],
        confidence: 0.95,
        textTypes: [.general: "Hello World"],
        processingTime: 0.5,
        language: .english
    )
    
    // Create testable interface
    let interface = OCROverlayTestableInterface(
        result: mockResult,
        onTextEdit: { text, boundingBox in
            // Handle text edit
        },
        onTextDelete: { boundingBox in
            // Handle text delete
        }
    )
    
    // Test functionality
    XCTAssertEqual(interface.textRegions.count, 2)
    XCTAssertFalse(interface.isEditingText)
}
```

### Text Editing Tests

```swift
func testTextEditing() {
    let interface = createTestableInterface()
    let boundingBox = mockResult.boundingBoxes[0]
    
    // Start editing
    interface.startTextEditing(for: boundingBox)
    XCTAssertTrue(interface.isEditingText)
    XCTAssertEqual(interface.editingText, "Hello World")
    
    // Complete editing
    interface.completeTextEditing()
    XCTAssertFalse(interface.isEditingText)
    XCTAssertEqual(textEditCallbacks.count, 1)
}
```

### Text Region Detection Tests

```swift
func testTextRegionDetection() {
    let interface = createTestableInterface()
    
    // Test detection at different points
    let region1 = interface.detectTappedTextRegion(at: CGPoint(x: 0.2, y: 0.15))
    XCTAssertNotNil(region1)
    XCTAssertEqual(region1?.text, "Hello World")
    
    let region2 = interface.detectTappedTextRegion(at: CGPoint(x: 0.3, y: 0.35))
    XCTAssertNotNil(region2)
    XCTAssertEqual(region2?.text, "Test Text")
}
```

### Confidence Color Tests

```swift
func testConfidenceColors() {
    let interface = createTestableInterface()
    let config = OCROverlayConfiguration(
        lowConfidenceThreshold: 0.7,
        highConfidenceThreshold: 0.9
    )
    
    // Test different confidence levels
    XCTAssertEqual(interface.confidenceColor(for: 0.95, configuration: config), .green)
    XCTAssertEqual(interface.confidenceColor(for: 0.8, configuration: config), .orange)
    XCTAssertEqual(interface.confidenceColor(for: 0.5, configuration: config), .red)
}
```

## API Reference

### Initialization

```swift
public init(
    result: OCRResult,
    onTextEdit: @escaping (String, CGRect) -> Void,
    onTextDelete: @escaping (CGRect) -> Void
)
```

### Text Editing Methods

```swift
// Start editing a text region
func startTextEditing(for boundingBox: CGRect)

// Complete editing with current text
func completeTextEditing()

// Complete editing with specific text
func completeTextEditing(with text: String)

// Cancel editing
func cancelTextEditing()
```

### Text Region Methods

```swift
// Detect which text region was tapped
func detectTappedTextRegion(at point: CGPoint) -> OCRTextRegion?

// Delete a text region
func deleteTextRegion(at boundingBox: CGRect)
```

### State Properties

```swift
// Current editing state
var isEditingText: Bool { get }

// Current editing bounding box
var editingBoundingBox: CGRect? { get }

// Current editing text
var editingText: String { get }

// All text regions
var textRegions: [OCRTextRegion] { get }

// Currently selected region
var selectedRegion: OCRTextRegion? { get }
```

### Utility Methods

```swift
// Get confidence color for visual feedback
func confidenceColor(for confidence: Float, configuration: OCROverlayConfiguration) -> Color
```

## Best Practices

### 1. Use for Testing

The `OCROverlayTestableInterface` is specifically designed for testing. Use it when you need to:
- Test OCR overlay logic without SwiftUI context
- Avoid StateObject warnings in tests
- Test edge cases and error conditions
- Perform performance testing

### 2. Use OCROverlayView for UI

The `OCROverlayView` should be used for actual UI rendering. It provides:
- SwiftUI integration
- Automatic state management
- UI updates and animations
- Accessibility support

### 3. Test Both Interfaces

When possible, test both interfaces to ensure consistency:

```swift
func testConsistencyBetweenInterfaces() {
    let mockResult = createMockResult()
    
    // Test testable interface
    let testableInterface = OCROverlayTestableInterface(
        result: mockResult,
        onTextEdit: { _, _ in },
        onTextDelete: { _ in }
    )
    
    // Test SwiftUI view (requires view context)
    let view = OCROverlayView(
        image: PlatformImage(),
        result: mockResult,
        onTextEdit: { _, _ in },
        onTextDelete: { _ in }
    )
    
    // Verify both have same initial state
    XCTAssertEqual(testableInterface.textRegions.count, 3)
    // Note: Can't directly access view.state in tests
}
```

### 4. Mock Callbacks

Use mock callbacks to verify behavior:

```swift
var textEditCallbacks: [(String, CGRect)] = []
var textDeleteCallbacks: [CGRect] = []

let interface = OCROverlayTestableInterface(
    result: mockResult,
    onTextEdit: { text, boundingBox in
        textEditCallbacks.append((text, boundingBox))
    },
    onTextDelete: { boundingBox in
        textDeleteCallbacks.append(boundingBox)
    }
)

// Test operations
interface.startTextEditing(for: boundingBox)
interface.completeTextEditing()

// Verify callbacks
XCTAssertEqual(textEditCallbacks.count, 1)
XCTAssertEqual(textEditCallbacks[0].0, "Hello World")
```

## Migration from Direct View Testing

### Before (Problematic)

```swift
func testOCROverlayView() {
    let view = OCROverlayView(
        image: PlatformImage(),
        result: mockResult,
        onTextEdit: { _, _ in },
        onTextDelete: { _ in }
    )
    
    // This will cause StateObject warnings
    view.startTextEditing(for: boundingBox)
    view.completeTextEditing()
}
```

### After (Recommended)

```swift
func testOCROverlayFunctionality() {
    let interface = OCROverlayTestableInterface(
        result: mockResult,
        onTextEdit: { _, _ in },
        onTextDelete: { _ in }
    )
    
    // No warnings, can be tested directly
    interface.startTextEditing(for: boundingBox)
    interface.completeTextEditing()
}
```

## Conclusion

The `OCROverlayTestableInterface` provides a clean way to test OCR overlay functionality without SwiftUI StateObject warnings. Use it for comprehensive testing while keeping `OCROverlayView` for actual UI rendering.
