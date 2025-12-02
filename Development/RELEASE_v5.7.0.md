# 🚀 SixLayer Framework v5.7.0 Release Notes

## 🎯 **Automatic OCR Hints & Structured Extraction Intelligence**

**Release Date**: December 1, 2025  
**Status**: ✅ **COMPLETE**  
**Previous Release**: v5.6.0 – Enhanced Layer 1 Functions & KeyboardType Extensions  
**Next Release**: TBD

---

## 📋 **Release Summary**

SixLayer Framework v5.7.0 completes Issue #29 by **automating hints file usage for OCR structured extraction**. Projects can now opt into automatic hints loading simply by providing an `entityName` inside `OCRContext`. The framework pulls `{entityName}.hints`, converts `ocrHints` into regex patterns, applies calculation groups after extraction, and leaves developers free to skip hints entirely by keeping `entityName` nil.

### **Key Achievements**
- ✅ `OCRContext` accepts `entityName: String?`, making hints mapping project-defined.
- ✅ `OCRService` automatically loads `.hints` files and converts `ocrHints` to regex patterns.
- ✅ Calculation groups execute after extraction to derive missing financial values.
- ✅ Tests cover entityName opt-in/out flows, hints-to-regex conversion, and calculation group readiness.
- ✅ Platform photo component integration tests stabilized with real image data simulation.

---

## 🆕 **What's New**

### **📄 Configurable OCR Entity Mapping**
- `OCRContext` now owns an optional `entityName`.  
- Projects map their `DocumentType` (or any custom enum) to actual Core Data entities and pass the result to structured extraction.  
- Leaving `entityName` as `nil` gracefully skips hints loading—custom `extractionHints` or built-ins still work.

```swift
let context = OCRContext(
    textTypes: [.price, .number],
    language: .english,
    documentType: .fuelReceipt,
    extractionMode: .automatic,
    entityName: "FuelPurchase"   // loads Hints/FuelPurchase.hints automatically
)
```

### **🤖 Automatic OCR Hints Loading**
- `OCRService.getPatterns` now merges three sources in priority order:
  1. Built-in document patterns
  2. Hints file patterns (when `entityName` is provided)
  3. Custom `extractionHints`
- `loadHintsPatterns` converts `ocrHints` arrays to regex patterns using the format `(?i)(hint1|hint2|...)\\s*[:=]?\\s*([\\d.,]+)`.
- Locale-aware hints loading leverages the existing `FileBasedDataHintsLoader`.

### **🧮 Calculation Group Application**
- After initial extraction, `applyCalculationGroups` walks every hint-defined `CalculationGroup`, sorted by priority.  
- Dependencies are validated and formulas run through `NSExpression` to compute derived values (e.g., total ÷ gallons = price per gallon).  
- Automatically skips calculation groups when `entityName` is nil or dependencies are missing.

### **🧪 Test & Stability Enhancements**
- `OCRServiceAutomaticHintsTests` now cover:
  - Explicit vs. optional `entityName`
  - Custom extraction hints without hints files
  - Regex conversion for `ocrHints`
  - Calculation group prerequisites
- `PlatformPhotoComponentsLayer4IntegrationTests` use `createRealImageData()` so simulated captures/selection always produce non-zero `PlatformImage` sizes, preventing flaky assertions on macOS.

---

## 💡 **Usage Examples**

### **Entity-Driven OCR Extraction**
```swift
let context = OCRContext(
    textTypes: [.price, .quantity],
    language: .english,
    documentType: .fuelReceipt,
    extractionMode: .automatic,
    entityName: "FuelPurchase"    // Optional opt-in
)

let result = try await OCRService().processStructuredExtraction(image, context: context)
print(result.structuredData["pricePerGallon"] ?? "–")
```

### **Opting Out Gracefully**
```swift
let context = OCRContext(
    textTypes: [.price, .number],
    language: .english,
    extractionHints: [
        "total": #"Total:\s*([\d.,]+)"#,
        "gallons": #"Gallons:\s*([\d.,]+)"#
    ],
    documentType: .fuelReceipt,
    extractionMode: .custom
    // entityName left nil → no hints file loading
)
```

---

## 🧪 **Testing & Quality**

- **Targeted Tests**: `swift test --filter OCRServiceAutomaticHintsTests` verifies entityName behavior, hints conversion, and calculation group prerequisites.
- **Integration Stability**: `PlatformPhotoComponentsLayer4IntegrationTests` run with real simulated image data to guarantee valid CGSize assertions across macOS/iOS.
- **Release Gate**: Full release script re-run to confirm test suite success once documentation/state prerequisites are satisfied.

---

## 📚 **Documentation Updates**

- `Development/RELEASES.md` – Added v5.7.0 as current release with detailed summary.
- `README.md`, `Framework/README.md`, `Framework/Examples/README.md` – Updated version references and “What’s New” sections.
- `Development/PROJECT_STATUS.md`, `Development/todo.md` – Current status reflects v5.7.0 milestone.
- `Development/AI_AGENT_v5.7.0.md` – New version-specific guidance for AI assistants.
- `Development/RELEASE_v5.7.0.md` (this file) – Canonical release notes.

---

## 🔧 **Technical Notes**

- `OCRService` combines built-in patterns, hints patterns, and custom hints with predictable precedence.
- `applyCalculationGroups` safely evaluates formulas with dependency checks and uses `NSExpression` for arithmetic.
- Hints loading paths remain unchanged (bundle `Hints/` folder, root level, Documents/Hints).
- Tests document opt-in/opt-out flows rather than forcing hints usage across the codebase.

---

**Summary**: v5.7.0 makes structured OCR extraction dramatically easier—developers simply declare the entity name they care about and the framework does the rest, from loading hints to calculating missing values. All of this remains optional, so existing workflows stay untouched unless teams opt in. Stability fixes ensure photo component integration tests remain reliable for future releases.

