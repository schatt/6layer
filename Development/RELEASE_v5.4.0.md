# Release v5.4.0 - OCR Hints, Calculation Groups, Internationalization, and OCR Overlay Sheets

**Release Date**: November 2025  
**Release Type**: Minor  
**Status**: ✅ **COMPLETE**

## 🎉 Major Features

### OCR Overlay Sheet Modifier (Issue #22)

**NEW**: Convenient view modifier for presenting OCR overlay in a sheet with toolbar and proper configuration!

The `ocrOverlaySheet()` view modifier provides a reusable way to present `OCROverlayView` in a sheet with:
- Cross-platform support (iOS, macOS)
- Built-in toolbar with Done button
- Proper error handling for missing OCR data
- Configurable callbacks for text editing and deletion
- Uses `platformSheet_L4()` internally for consistent sheet presentation

#### Example Usage

```swift
@State private var showOCROverlay = false
@State private var ocrResult: OCRResult?
@State private var ocrImage: PlatformImage?

var body: some View {
    Button("Review OCR Results") {
        showOCROverlay = true
    }
    .ocrOverlaySheet(
        isPresented: $showOCROverlay,
        ocrResult: ocrResult,
        ocrImage: ocrImage,
        onTextEdit: { text, rect in
            // Handle text editing
        },
        onTextDelete: { rect in
            // Handle text deletion
        }
    )
}
```

### OCR Hints and Calculation Groups in Hints Files

**NEW**: You can now define OCR hints and calculation groups directly in your `.hints` files! This extends the hints system to support intelligent OCR form-filling and automatic field calculations, all configured declaratively in JSON.

#### Key Benefits
- **DRY**: Define OCR hints and calculations once in hints files, use everywhere
- **Internationalization**: Language-specific OCR hints with automatic fallback
- **Declarative**: All configuration in JSON, no code changes needed
- **Backward Compatible**: Existing hints files continue to work

### OCR Hints in Hints Files

Add `ocrHints` to any field in your hints file:

```json
{
  "gallons": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["gallons", "gal", "fuel quantity", "liters", "litres"]
  }
}
```

### Calculation Groups in Hints Files

Add `calculationGroups` to fields that can be calculated:

```json
{
  "total": {
    "expectedLength": 10,
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      }
    ]
  }
}
```

### Internationalization Support

**NEW**: Language-specific OCR hints with automatic fallback!

```json
{
  "gallons": {
    "ocrHints": ["gallons", "gal"],  // Default/fallback
    "ocrHints.es": ["galones", "gal"],  // Spanish
    "ocrHints.fr": ["gallons", "litres"]  // French
  }
}
```

Fallback chain: `ocrHints.{language}` → `ocrHints` → `nil`

## 🔧 API Changes

### Extended `FieldDisplayHints`

```swift
public struct FieldDisplayHints: Sendable {
    // ... existing properties ...
    
    /// OCR hints for field identification (NEW)
    public let ocrHints: [String]?
    
    /// Calculation groups for computing field values (NEW)
    public let calculationGroups: [CalculationGroup]?
}
```

### Extended `DataHintsLoader`

```swift
public protocol DataHintsLoader {
    // ... existing methods ...
    
    /// Load complete hints result with locale support for language-specific OCR hints (NEW)
    func loadHintsResult(for modelName: String, locale: Locale) -> DataHintsResult
}
```

### New `DynamicFormField` Method

```swift
extension DynamicFormField {
    /// Apply hints to this field, creating a new field with updated properties (NEW)
    public func applying(hints: FieldDisplayHints) -> DynamicFormField
}
```

### New OCR Overlay Sheet View Modifier

```swift
extension View {
    /// Present OCR overlay in a sheet with toolbar and proper configuration (NEW)
    /// Implements Issue #22: OCR Overlay Sheet Modifier
    func ocrOverlaySheet(
        isPresented: Binding<Bool>,
        ocrResult: OCRResult?,
        ocrImage: PlatformImage?,
        configuration: OCROverlayConfiguration? = nil,
        onTextEdit: ((String, CGRect) -> Void)? = nil,
        onTextDelete: ((CGRect) -> Void)? = nil
    ) -> some View
}
```

### Made `CalculationGroup` Sendable

```swift
public struct CalculationGroup: Sendable {  // Now Sendable
    // ... existing properties ...
}
```

## 📚 Documentation

### New Guides

- **[Hints File OCR and Calculations Guide](Framework/docs/HintsFileOCRAndCalculationsGuide.md)** - Complete guide to OCR hints and calculations in hints files

### Updated Guides

- **[Field Hints Guide](Framework/docs/FieldHintsGuide.md)** - Updated with references to new OCR hints and calculation groups features

## 🐛 Bug Fixes

- **Fixed Runtime Capability Detection Crashes**: Replaced `MainActor.assumeIsolated` with `Thread.isMainThread` checks to prevent crashes during parallel test execution
- **Fixed Platform Matrix Tests**: Added proper capability overrides for macOS tests to ensure correct platform-specific behavior

## 🔄 Migration Guide

### From Code-Based OCR Hints

**Before (v5.2.0)**:
```swift
let field = DynamicFormField(
    id: "gallons",
    contentType: .number,
    label: "Gallons",
    supportsOCR: true,
    ocrHints: ["gallons", "gal", "fuel quantity"]
)
```

**After (v5.4.0)**:
```json
// FuelReceipt.hints
{
  "gallons": {
    "ocrHints": ["gallons", "gal", "fuel quantity"]
  }
}
```

```swift
// Code - hints applied automatically!
let field = DynamicFormField(
    id: "gallons",
    contentType: .number,
    label: "Gallons"
)
// Use modelName to load hints
```

### From Code-Based Calculation Groups

**Before (v5.2.0)**:
```swift
let field = DynamicFormField(
    id: "total",
    contentType: .number,
    label: "Total",
    calculationGroups: [
        CalculationGroup(
            id: "multiply",
            formula: "total = price * quantity",
            dependentFields: ["price", "quantity"],
            priority: 1
        )
    ]
)
```

**After (v5.4.0)**:
```json
// Invoice.hints
{
  "total": {
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      }
    ]
  }
}
```

## ✅ Backward Compatibility

- **100% backward compatible**: Existing hints files continue to work without modification
- Existing code using `DynamicFormField` with OCR hints and calculation groups in code continues to work
- New features are opt-in - add to hints files as needed

## 📖 Examples

See the [Hints File OCR and Calculations Guide](Framework/docs/HintsFileOCRAndCalculationsGuide.md) for complete examples including:
- Basic OCR hints
- Basic calculation groups
- Combined OCR + calculations
- Internationalization examples
- Complete fuel receipt form example
