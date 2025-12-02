# 🚀 SixLayer Framework v5.7.1 Release Notes

## 🎯 **Value Range Validation for OCR Extraction**

**Release Date**: TBD  
**Status**: ✅ **COMPLETE**  
**Previous Release**: v5.7.0 – Automatic OCR Hints & Structured Extraction Intelligence  
**Next Release**: TBD

---

## 📋 **Release Summary**

SixLayer Framework v5.7.1 adds **value range validation** for OCR-extracted numeric fields. This enables hints files to define acceptable value ranges for fields, and allows apps to override these ranges at runtime based on dynamic context (e.g., different ranges for trucks vs motorcycles).

### **Key Achievements**
- ✅ `FieldDisplayHints` now supports `expectedRange: ValueRange?` for hints file validation
- ✅ `OCRContext` accepts `fieldRanges: [String: ValueRange]?` for runtime overrides
- ✅ `OCRService` validates extracted values against ranges (override > hints file)
- ✅ Out-of-range values are automatically filtered during extraction
- ✅ Tests cover range validation, override precedence, and edge cases

---

## 🆕 **What's New**

### **📊 Value Ranges in Hints Files**

Hints files can now define expected value ranges for numeric fields. This helps validate OCR-extracted values and filter out obviously incorrect readings.

**FuelPurchase.hints**:
```json
{
  "gallons": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["gallons", "gal", "fuel quantity"],
    "expectedRange": {
      "min": 5.0,
      "max": 30.0
    }
  },
  "pricePerGallon": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["price per gallon", "price/gal", "ppg"],
    "expectedRange": {
      "min": 2.0,
      "max": 10.0
    }
  }
}
```

### **🔄 Runtime Range Overrides**

Apps can override hints file ranges at runtime using `OCRContext.fieldRanges`. This is useful when the acceptable range depends on dynamic context (e.g., vehicle type, user preferences, business rules).

```swift
let context = OCRContext(
    textTypes: [.number],
    language: .english,
    extractionMode: .automatic,
    entityName: "FuelPurchase",
    fieldRanges: [
        "gallons": ValueRange(min: 20.0, max: 100.0)  // Override for trucks
    ]
)
```

### **✅ Automatic Validation**

`OCRService.processStructuredExtraction` automatically validates extracted numeric values against ranges:

1. **Priority**: Runtime override (`fieldRanges`) > Hints file (`expectedRange`)
2. **Behavior**: Out-of-range values are removed from `structuredData`
3. **Rationale**: Removed values allow calculation groups to potentially fill in correct values

```swift
let result = try await OCRService().processStructuredExtraction(image, context: context)
// result.structuredData only contains values within expected ranges
```

---

## 💡 **Usage Examples**

### **Basic Hints File Range**

**FuelPurchase.hints**:
```json
{
  "gallons": {
    "expectedRange": {"min": 5, "max": 30},
    "ocrHints": ["gallons", "gal"]
  }
}
```

The framework automatically validates that extracted "gallons" values are between 5 and 30.

### **Runtime Override for Different Contexts**

```swift
// Different ranges for different vehicle types
func createContext(for vehicleType: VehicleType) -> OCRContext {
    let baseRanges: [String: ValueRange]
    
    switch vehicleType {
    case .motorcycle:
        baseRanges = ["gallons": ValueRange(min: 2.0, max: 5.0)]
    case .car:
        baseRanges = ["gallons": ValueRange(min: 10.0, max: 20.0)]
    case .truck:
        baseRanges = ["gallons": ValueRange(min: 20.0, max: 100.0)]
    }
    
    return OCRContext(
        textTypes: [.number],
        language: .english,
        extractionMode: .automatic,
        entityName: "FuelPurchase",
        fieldRanges: baseRanges  // Overrides hints file range
    )
}
```

### **Combined with Calculation Groups**

Value ranges work seamlessly with calculation groups. If an extracted value is out of range and removed, calculation groups can compute the correct value:

```json
{
  "gallons": {
    "expectedRange": {"min": 5, "max": 30},
    "ocrHints": ["gallons", "gal"],
    "calculationGroups": [
      {
        "id": "from_price_total",
        "formula": "gallons = total_price / price_per_gallon",
        "dependentFields": ["total_price", "price_per_gallon"],
        "priority": 1
      }
    ]
  }
}
```

If OCR extracts "gallons: 150" (out of range), it's removed. The calculation group then computes the correct value from `total_price / price_per_gallon`.

---

## 🧪 **Testing & Quality**

- **Targeted Tests**: `OCRServiceAutomaticHintsTests` includes comprehensive range validation tests:
  - `testValueRangeStructure` - Range boundary testing
  - `testFieldDisplayHintsWithExpectedRange` - Hints file range parsing
  - `testOCRContextWithFieldRangesOverride` - Runtime override support
  - `testFieldRangesOverrideTakesPrecedence` - Priority verification
  - `testFieldRangesIsOptional` - Graceful degradation

- **Validation Logic**: `OCRService.validateFieldRanges` implements priority system and numeric parsing
- **Release Gate**: Full test suite passes before release

---

## 📚 **Documentation Updates**

- `Framework/docs/FieldHintsGuide.md` – Added `expectedRange` to `FieldDisplayHints` properties
- `Framework/docs/HintsFileOCRAndCalculationsGuide.md` – Added comprehensive value ranges section
- `Development/AI_AGENT_v5.7.1.md` – New version-specific guidance for AI assistants
- `Development/RELEASE_v5.7.1.md` (this file) – Canonical release notes

---

## 🔧 **Technical Notes**

### **Range Priority System**

1. **Runtime Override** (`context.fieldRanges?[fieldId]`) - Highest priority
2. **Hints File** (`fieldHints[fieldId].expectedRange`) - Fallback
3. **No Range** - No validation (all values accepted)

### **Validation Behavior**

- Only numeric values are validated (non-numeric values skip range checks)
- Out-of-range values are **removed** (not flagged) to allow calculation groups to fill in correct values
- Range boundaries are **inclusive** (`min <= value <= max`)

### **Numeric Parsing**

Values are parsed as `Double`, with comma separators removed:
- `"1,234.56"` → `1234.56`
- `"90.22"` → `90.22`
- `"invalid"` → Skipped (not numeric)

### **Backward Compatibility**

- Existing hints files without `expectedRange` continue to work
- `fieldRanges` is optional in `OCRContext` (nil = use hints file or no validation)
- No breaking changes to existing APIs

---

## 🔄 **Migration Guide**

### **Adding Ranges to Existing Hints Files**

**Before (v5.7.0)**:
```json
{
  "gallons": {
    "ocrHints": ["gallons", "gal"]
  }
}
```

**After (v5.7.1)**:
```json
{
  "gallons": {
    "ocrHints": ["gallons", "gal"],
    "expectedRange": {"min": 5, "max": 30}
  }
}
```

### **Using Runtime Overrides**

If your app needs dynamic ranges based on context:

```swift
// v5.7.0 - No range validation
let context = OCRContext(
    entityName: "FuelPurchase",
    extractionMode: .automatic
)

// v5.7.1 - With runtime override
let context = OCRContext(
    entityName: "FuelPurchase",
    extractionMode: .automatic,
    fieldRanges: ["gallons": ValueRange(min: 20.0, max: 100.0)]
)
```

---

**Summary**: v5.7.1 adds value range validation to OCR structured extraction, enabling hints files to define acceptable ranges and apps to override them at runtime. This improves OCR accuracy by filtering out-of-range values while maintaining full backward compatibility.

