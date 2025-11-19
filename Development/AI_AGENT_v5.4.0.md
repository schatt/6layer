# AI Agent Guide for SixLayer Framework v5.4.0

This document provides guidance for AI assistants working with the SixLayer Framework v5.4.0. **Always read this version-specific guide first** before attempting to help with this framework.

**Note**: This guide is for AI agents helping developers USE the framework, not for AI agents working ON the framework itself.

## 🎯 Quick Start

1. **Identify the current framework version** from the project's Package.swift or release tags
2. **Read this AI_AGENT_v5.4.0.md file** for version-specific guidance
3. **Follow the guidelines** for architecture, patterns, and best practices

## 🆕 What's New in v5.4.0

### OCR Hints, Calculation Groups, Internationalization, and OCR Overlay Sheets

v5.4.0 is a minor release adding powerful new features to the hints system and OCR functionality:

#### **🎯 OCR Hints in Hints Files**
- **Declarative OCR Configuration**: Define OCR hints directly in `.hints` files for intelligent form-filling
- **Field Identification**: Keyword arrays improve OCR recognition accuracy for field identification
- **DRY Principle**: Define OCR hints once in hints files, use everywhere
- **Backward Compatible**: Existing hints files continue to work without modification

#### **🧮 Calculation Groups in Hints Files**
- **Declarative Calculations**: Define calculation groups directly in `.hints` files
- **Automatic Field Computation**: System calculates missing form values from partial OCR data
- **Priority-Based Conflict Resolution**: Fields can belong to multiple calculation groups with priority-based conflict resolution
- **Mathematical Relationships**: Support for any mathematical relationships (A = B * C, D = E * F, etc.)

#### **🌍 Internationalization Support**
- **Language-Specific OCR Hints**: Support for language-specific OCR hints with automatic fallback
- **Fallback Chain**: `ocrHints.{language}` → `ocrHints` → `nil`
- **Locale-Aware Loading**: `DataHintsLoader` now supports locale parameter for language-specific hints

#### **📄 OCR Overlay Sheet Modifier (Issue #22)**
- **Convenient Sheet Presentation**: New `ocrOverlaySheet()` view modifier for presenting OCR overlay in a sheet
- **Cross-Platform Support**: Works on iOS and macOS with proper sheet presentation
- **Built-in Toolbar**: Includes Done button and proper navigation
- **Error Handling**: Graceful error states when OCR data is missing
- **Configurable Callbacks**: Support for text editing and deletion callbacks

## 🏗️ Framework Architecture Overview

The SixLayer Framework follows a **layered architecture** where each layer builds upon the previous:

1. **Layer 1 (Semantic)**: Express WHAT you want to achieve, not how
2. **Layer 2 (Decision)**: Intelligent layout analysis and decision making
3. **Layer 3 (Strategy)**: Optimal layout strategy selection
4. **Layer 4 (Implementation)**: Platform-agnostic component implementation
5. **Layer 5 (Optimization)**: Platform-specific enhancements and optimizations
6. **Layer 6 (System)**: Direct platform system calls and native implementations

**📚 For complete architecture details, see [6-Layer Architecture Overview](../Framework/docs/README_6LayerArchitecture.md)**

## 🎯 OCR Hints in Hints Files

### Basic Usage

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

The framework will automatically use these hints when processing OCR results to improve field identification accuracy.

### Internationalization

Support for language-specific OCR hints with automatic fallback:

```json
{
  "gallons": {
    "ocrHints": ["gallons", "gal"],  // Default/fallback
    "ocrHints.es": ["galones", "gal"],  // Spanish
    "ocrHints.fr": ["gallons", "litres"]  // French
  }
}
```

The framework will:
1. First try `ocrHints.{languageCode}` (e.g., `ocrHints.es` for Spanish)
2. Fall back to `ocrHints` if language-specific hints aren't found
3. Use `nil` if no hints are available

## 🧮 Calculation Groups in Hints Files

### Basic Usage

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

### Multiple Calculation Groups

Fields can belong to multiple calculation groups with priority-based conflict resolution:

```json
{
  "total": {
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      },
      {
        "id": "add",
        "formula": "total = subtotal + tax",
        "dependentFields": ["subtotal", "tax"],
        "priority": 2
      }
    ]
  }
}
```

When multiple calculations are possible, the framework uses priority to resolve conflicts and marks low-confidence results appropriately.

## 📄 OCR Overlay Sheet Modifier

### Basic Usage

Use the `ocrOverlaySheet()` view modifier to present OCR results in a sheet:

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

### With Configuration

You can also provide custom configuration:

```swift
.ocrOverlaySheet(
    isPresented: $showOCROverlay,
    ocrResult: ocrResult,
    ocrImage: ocrImage,
    configuration: OCROverlayConfiguration(
        // Custom configuration
    ),
    onTextEdit: { text, rect in
        // Handle text editing
    },
    onTextDelete: { rect in
        // Handle text deletion
    }
)
```

## 🔄 Migration from Code-Based Configuration

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

## 📚 Documentation

### New Guides

- **[Hints File OCR and Calculations Guide](../Framework/docs/HintsFileOCRAndCalculationsGuide.md)** - Complete guide to OCR hints and calculations in hints files

### Updated Guides

- **[Field Hints Guide](../Framework/docs/FieldHintsGuide.md)** - Updated with references to new OCR hints and calculation groups features

## 🐛 Bug Fixes in v5.4.0

- **Fixed Runtime Capability Detection Crashes**: Replaced `MainActor.assumeIsolated` with `Thread.isMainThread` checks to prevent crashes during parallel test execution
- **Fixed Platform Matrix Tests**: Added proper capability overrides for macOS tests to ensure correct platform-specific behavior

## 🎯 Key Takeaways for AI Agents

1. **OCR Hints**: Can now be defined in `.hints` files instead of code
2. **Calculation Groups**: Can now be defined in `.hints` files instead of code
3. **Internationalization**: OCR hints support language-specific variants with automatic fallback
4. **OCR Overlay Sheets**: Use `ocrOverlaySheet()` modifier for convenient sheet presentation
5. **Backward Compatible**: All existing code continues to work - new features are opt-in

## 📖 Examples

See the [Hints File OCR and Calculations Guide](../Framework/docs/HintsFileOCRAndCalculationsGuide.md) for complete examples including:
- Basic OCR hints
- Basic calculation groups
- Combined OCR + calculations
- Internationalization examples
- Complete fuel receipt form example

---

*This documentation is specifically designed for AI agents working with SixLayer Framework v5.4.0. For user-facing documentation, see the [Framework Documentation](../Framework/docs/).*

