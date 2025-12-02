# 🚀 SixLayer Framework v5.7.2 Release Notes

## 🎯 **Intelligent Decimal Correction & Field Adjustment Tracking**

**Release Date**: TBD  
**Status**: ✅ **COMPLETE**  
**Previous Release**: v5.7.1 – Value Range Validation for OCR Extraction  
**Next Release**: TBD

---

## 📋 **Release Summary**

SixLayer Framework v5.7.2 adds **intelligent decimal correction** for OCR-extracted values, **field adjustment tracking**, and **enhanced range validation** to help users verify automatically corrected data. The framework now uses expected ranges and calculation groups to infer missing decimal points when Vision framework fails to detect them, treats expected ranges as guidelines (not hard requirements), and provides clear visibility into which fields were adjusted.

### **Key Achievements**
- ✅ Automatic decimal point correction using expected ranges as heuristics
- ✅ Range inference from calculation groups (e.g., if `gallons: 0-32` and `pricePerGallon: 0-10`, infer `totalCost: 0-320`)
- ✅ Field adjustment tracking in `OCRResult.adjustedFields`
- ✅ Expected ranges are now guidelines (not hard requirements) - out-of-range values are kept but flagged
- ✅ Field averages for typical value detection (flag unusual values even within range)
- ✅ Bidirectional pattern matching (handles "Gallons 9.022" and "9.022 Gallons")
- ✅ Vision observation sorting by position (top-to-bottom, left-to-right)
- ✅ Comprehensive test coverage for decimal correction scenarios

---

## 🆕 **What's New**

### **🔧 Intelligent Decimal Correction**

When Vision framework fails to detect decimal points (e.g., extracts "3288" instead of "32.88"), the framework now automatically corrects them using expected ranges and calculation groups.

**How It Works:**

1. **Range-Based Correction**: If an extracted integer value is outside its expected range, the framework tries inserting decimal points at various positions
2. **Calculation Validation**: Corrections are validated by checking if they produce valid calculated values for related fields
3. **Range Inference**: If a field doesn't have an explicit range, it's inferred from calculation groups and related field ranges

**Example:**
```swift
// Vision extracts "3288" for totalCost
// Expected range: 10.0 - 300.0
// Framework tries: "32.88" → ✅ Within range!
// Result: totalCost = "32.88"
```

### **📊 Range Inference from Calculation Groups**

Fields without explicit ranges can now have their ranges inferred from calculation groups and related field ranges.

**Example:**
```json
{
  "gallons": {
    "expectedRange": {"min": 5.0, "max": 30.0},
    "ocrHints": ["gallons", "gal"]
  },
  "pricePerGallon": {
    "expectedRange": {"min": 2.0, "max": 10.0},
    "ocrHints": ["price per gallon", "ppg"]
  },
  "totalCost": {
    "ocrHints": ["total", "amount"],
    "calculationGroups": [
      {
        "id": "fuel_purchase",
        "formula": "totalCost = pricePerGallon * gallons",
        "dependentFields": ["pricePerGallon", "gallons"],
        "priority": 1
      }
    ]
    // No explicit range, but inferred: 2.0*5.0 to 10.0*30.0 = 10.0 - 300.0
  }
}
```

The framework automatically infers that `totalCost` should be in the range 10.0 - 300.0 based on the calculation group and related field ranges.

### **⚠️ Field Adjustment Tracking**

`OCRResult` now includes `adjustedFields` to track which fields were automatically adjusted or calculated, allowing users to verify corrections.

**New Property:**
```swift
public struct OCRResult: Sendable {
    // ... existing properties ...
    
    /// Fields that were adjusted during extraction (e.g., decimal correction, range inference)
    /// Maps field ID to a description of what was adjusted
    public let adjustedFields: [String: String]
}
```

**Usage:**
```swift
let result = try await OCRService().processStructuredExtraction(image, context: context)

// Check if any fields were adjusted
if !result.adjustedFields.isEmpty {
    print("⚠️ Some fields were adjusted:")
    for (fieldId, description) in result.adjustedFields {
        print("  • \(fieldId): \(description)")
    }
}

// Example output:
// ⚠️ Some fields were adjusted:
//   • totalCost: Decimal point corrected: '3288' → '32.88' (inferred from expected range)
//   • pricePerGallon: Calculated from formula: pricePerGallon = totalCost / gallons = 3.64
```

### **🔄 Bidirectional Pattern Matching**

OCR hints patterns now match in both directions, handling cases where Vision reads text in different orders:

- **Before**: Only matched "Gallons 9.022" (hint before number)
- **After**: Also matches "9.022 Gallons" (number before hint)

This improves extraction accuracy when Vision processes text in non-standard reading order.

### **📍 Vision Observation Sorting**

Vision observations are now sorted by position (top-to-bottom, left-to-right) before processing, ensuring proper reading order even when Vision returns observations in arbitrary order.

---

## 💡 **Usage Examples**

### **Basic Decimal Correction**

**FuelPurchase.hints**:
```json
{
  "totalCost": {
    "ocrHints": ["total", "amount", "$"],
    "expectedRange": {"min": 10.0, "max": 300.0}
  }
}
```

If Vision extracts "3288" (outside range), the framework automatically corrects it to "32.88" (within range).

### **Range Inference Example**

**FuelPurchase.hints**:
```json
{
  "gallons": {
    "expectedRange": {"min": 5.0, "max": 30.0},
    "ocrHints": ["gallons", "gal"]
  },
  "pricePerGallon": {
    "expectedRange": {"min": 2.0, "max": 10.0},
    "ocrHints": ["price per gallon"]
  },
  "totalCost": {
    "ocrHints": ["total", "$"],
    "calculationGroups": [
      {
        "id": "fuel_purchase",
        "formula": "totalCost = pricePerGallon * gallons",
        "dependentFields": ["pricePerGallon", "gallons"],
        "priority": 1
      }
    ]
  }
}
```

The framework infers `totalCost` range as 10.0 - 300.0 (from 2.0*5.0 to 10.0*30.0) and uses it for decimal correction.

### **Checking Adjusted Fields**

```swift
let result = try await service.processStructuredExtraction(image, context: context)

// Display warnings for adjusted fields
if !result.adjustedFields.isEmpty {
    for (fieldId, description) in result.adjustedFields {
        // Show warning icon next to field in UI
        showWarning(for: fieldId, message: description)
    }
}

// Access specific adjustment
if let adjustment = result.adjustedFields["totalCost"] {
    print("totalCost was adjusted: \(adjustment)")
    // Output: "totalCost was adjusted: Decimal point corrected: '3288' → '32.88' (inferred from expected range)"
}
```

---

## 🧪 **Testing & Quality**

- **Targeted Tests**: `OCRServiceAutomaticHintsTests` includes comprehensive decimal correction tests:
  - `testIssue30ActualOCRExtractedText` - Real-world OCR image with decimal correction
  - Tests verify decimal correction, range inference, and adjustment tracking

- **Decimal Correction Logic**: `OCRService.correctDecimalPlacement` implements:
  - Range-based decimal insertion
  - Calculation group validation
  - Range inference from formulas

- **Release Gate**: Full test suite passes before release

---

## 📚 **Documentation Updates**

- `Framework/docs/FieldHintsGuide.md` – Updated with decimal correction and range inference examples
- `Framework/docs/HintsFileOCRAndCalculationsGuide.md` – Added section on range inference
- `Development/RELEASE_v5.7.2.md` (this file) – Canonical release notes

---

## 🔧 **Technical Notes**

### **Decimal Correction Algorithm**

1. **Detection**: Identify integer values (no decimal point) that are outside expected range
2. **Correction**: Try inserting decimal point at various positions (right to left, most common: 2 decimal places)
3. **Validation**: 
   - Check if corrected value is within expected range
   - Validate using calculation groups (e.g., if totalCost is corrected, verify pricePerGallon calculation is valid)
4. **Selection**: Choose correction closest to middle of expected range
5. **Tracking**: Record adjustment in `adjustedFields`

### **Range Inference Algorithm**

1. **Collection**: Gather all calculation groups from hints file
2. **Analysis**: For each field without explicit range:
   - Find calculation groups that can calculate it
   - Check if all dependent fields have ranges
   - Calculate inferred range from formula (supports +, -, *, /)
3. **Application**: Use inferred ranges for decimal correction and validation

**Supported Operations:**
- **Multiplication**: `totalCost = pricePerGallon * gallons` → range = (min1*min2 to max1*max2)
- **Addition**: `total = subtotal + tax` → range = (min1+min2 to max1+max2)
- **Subtraction**: `net = gross - tax` → range = (min1-max2 to max1-min2)
- **Division**: `rate = total / quantity` → range = (min1/max2 to max1/min2)

### **Bidirectional Pattern Matching**

Pattern structure: `(?i)((hint1|hint2)\s*[:=]?\s*([\d.,]+)|([\d.,]+)\s+(hint1|hint2))`

- Group 3: Number when hint comes first
- Group 4: Number when number comes first
- Extracts value from appropriate group based on match

### **Vision Observation Sorting**

Observations are sorted by:
1. **Y coordinate** (top to bottom) - Higher Y = higher on screen = comes first
2. **X coordinate** (left to right) - For observations on same row

This ensures proper reading order even when Vision returns observations in arbitrary order.

### **📊 Field Averages for Typical Value Detection**

Apps can now provide typical/average values for fields to identify values that are within expected range but unusual compared to typical usage.

**Example**:
```swift
let context = OCRContext(
    entityName: "FuelPurchase",
    fieldRanges: ["pricePerGallon": ValueRange(min: 2.0, max: 10.0)],
    fieldAverages: ["pricePerGallon": 4.34]  // Typical gas price user pays
)

// If OCR extracts 9.99 (within range 2.0-10.0 but far from average 4.34)
// Framework flags it as: "Value '9.99' is within expected range but significantly 
// different from typical value (4.34). Deviation: 130.2%. Please verify."
```

**Use Cases**:
- Broad expected ranges (2.0-10.0 covers all possible gas prices)
- Narrow typical values (4.34 is what user typically pays)
- Flag unusual values even when technically within range
- Help users catch legitimate but unexpected values

### **Expected Ranges Are Guidelines (Not Hard Requirements)**

**Important Change from v5.7.1**: Expected ranges are now treated as **guidelines**, not hard requirements.

- **v5.7.1**: Out-of-range values were **removed** from `structuredData`
- **v5.7.2**: Out-of-range values are **kept but flagged** in `OCRResult.adjustedFields`

**Rationale**:
- Real-world scenarios may legitimately fall outside typical ranges (e.g., expensive gas in remote locations)
- If OCR and calculation groups both agree on an out-of-range value, it's likely correct
- Users should verify flagged values, but the framework doesn't reject them automatically
- Expected ranges represent typical values, not absolute limits

**Example**:
```swift
// OCR extracts: pricePerGallon = "15.00" (outside expected range 2.0-10.0)
// Calculation confirms: totalCost / gallons = 15.00 ✅
// Result: Value is kept, flagged as "outside expected range, but confirmed by calculation. Please verify."
```

**Validation Behavior**:
- Out-of-range values are **kept** (not removed)
- Flagged in `OCRResult.adjustedFields` with descriptive message
- If calculation groups confirm the value, message indicates "confirmed by calculation"
- Range boundaries are **inclusive** (`min <= value <= max`)
- Only numeric values are validated (non-numeric values skip range checks)

### **Backward Compatibility**

- `adjustedFields` has default value `[:]` in `OCRResult` initializer
- `fieldAverages` is optional in `OCRContext` (nil = no average-based validation)
- Existing code continues to work without modification
- New properties are opt-in (callers can check them if needed)
- **Behavior change from v5.7.1**: Out-of-range values are now kept (not removed) and flagged in `adjustedFields`

---

## 🔄 **Migration Guide**

### **Using Adjusted Fields in Your App**

**Before (v5.7.1)**:
```swift
let result = try await service.processStructuredExtraction(image, context: context)
// No way to know which fields were adjusted
```

**After (v5.7.2)**:
```swift
let result = try await service.processStructuredExtraction(image, context: context)

// Check for adjusted fields
if !result.adjustedFields.isEmpty {
    // Show warnings to user
    for (fieldId, description) in result.adjustedFields {
        showWarning(for: fieldId, message: description)
    }
}
```

### **Adding Ranges for Better Decimal Correction**

**Before (v5.7.1)**:
```json
{
  "totalCost": {
    "ocrHints": ["total", "$"]
    // No range - decimal correction won't work
  }
}
```

**After (v5.7.2)**:
```json
{
  "totalCost": {
    "ocrHints": ["total", "$"],
    "expectedRange": {"min": 10.0, "max": 300.0}
    // Range enables decimal correction
  }
}
```

### **Leveraging Range Inference**

If you have calculation groups, you can omit explicit ranges and let the framework infer them:

```json
{
  "gallons": {
    "expectedRange": {"min": 5.0, "max": 30.0}
  },
  "pricePerGallon": {
    "expectedRange": {"min": 2.0, "max": 10.0}
  },
  "totalCost": {
    "calculationGroups": [
      {
        "formula": "totalCost = pricePerGallon * gallons",
        "dependentFields": ["pricePerGallon", "gallons"]
      }
    ]
    // No explicit range needed - inferred as 10.0 - 300.0
  }
}
```

---

## 🐛 **Bug Fixes**

### **Issue #30: Generic Fields Instead of Hints-Based Extraction**

- **Fixed**: Hints-based extraction now correctly prioritizes specific field names over generic text types
- **Fixed**: Calculation groups are now applied automatically when extraction mode is `.automatic` or `.hybrid`
- **Fixed**: Generic text types ("price", "number") are no longer added to `structuredData` when hints are used

### **Vision Framework Limitations**

- **Workaround**: Multiple OCR candidates are checked to improve decimal point detection
- **Workaround**: Observations are sorted by position to ensure proper reading order
- **Workaround**: Bidirectional pattern matching handles non-standard text ordering

---

**Summary**: v5.7.2 adds intelligent decimal correction using expected ranges and calculation groups, range inference for fields without explicit ranges, field adjustment tracking, and enhanced range validation (ranges are now guidelines, not hard requirements). This significantly improves OCR accuracy when Vision framework fails to detect decimal points, handles real-world edge cases better, and provides clear visibility into which fields were adjusted or flagged for verification.

