# AI Agent Guide for SixLayer Framework v5.7.1

This guide summarizes the version-specific context for v5.7.1. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v5.7.1** (see `Package.swift` comment or release tags).
2. Understand that **value range validation** is now available for OCR-extracted numeric fields.
3. Know that ranges can be defined in hints files (`expectedRange`) or overridden at runtime (`OCRContext.fieldRanges`).
4. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v5.7.1

### Value Range Validation
- `FieldDisplayHints` now supports `expectedRange: ValueRange?` for hints file validation.
- `OCRContext` accepts `fieldRanges: [String: ValueRange]?` for runtime overrides.
- `OCRService.validateFieldRanges` automatically filters out-of-range values during extraction.

### Priority System
- **Runtime override** (`context.fieldRanges`) takes precedence over hints file ranges.
- If no override exists, hints file `expectedRange` is used.
- If neither exists, no validation is performed (all values accepted).

### Validation Behavior
- Only numeric values are validated (non-numeric values skip range checks).
- Out-of-range values are **removed** (not flagged) to allow calculation groups to fill in correct values.
- Range boundaries are **inclusive** (`min <= value <= max`).

## 🧠 Guidance for v5.7.1 Work

### 1. Range Definition Strategy
- Encourage developers to define realistic ranges in hints files (cover 95% of expected values).
- When ranges depend on dynamic context (vehicle type, user preferences), use runtime overrides.
- Always combine ranges with calculation groups so missing values can be computed.

### 2. Runtime Override Usage
- Use `fieldRanges` when the acceptable range depends on app-level logic (e.g., different ranges for trucks vs motorcycles).
- Keep hints file ranges as sensible defaults, override only when necessary.
- Document why overrides are needed (helps future maintainers understand context).

### 3. Validation Integration
- Range validation happens automatically in `OCRService.processStructuredExtraction`.
- No additional code needed - just define ranges in hints files or pass `fieldRanges` to context.
- Out-of-range values are removed silently (allows calculation groups to fill in correct values).

### 4. Testing Expectations
- Follow TDD: add/adjust tests in `OCRServiceAutomaticHintsTests.swift` before modifying implementation.
- Test boundary conditions: values at min, max, just below min, just above max.
- Test priority system: verify runtime override takes precedence over hints file.
- Test edge cases: non-numeric values, missing ranges, nil overrides.

## ✅ Best Practices

1. **Set realistic ranges**: Use ranges that cover most expected values, not edge cases.
   ```json
   "expectedRange": {"min": 5, "max": 30}  // ✅ Good
   "expectedRange": {"min": 0, "max": 1000}  // ❌ Too broad
   ```

2. **Combine with calculation groups**: If extraction fails due to range validation, let calculations fill in.
   ```json
   {
     "gallons": {
       "expectedRange": {"min": 5, "max": 30},
       "calculationGroups": [{
         "formula": "gallons = total_price / price_per_gallon",
         "dependentFields": ["total_price", "price_per_gallon"]
       }]
     }
   }
   ```

3. **Use runtime overrides sparingly**: Only override when ranges truly depend on dynamic context.
   ```swift
   // ✅ Good - different ranges for different vehicle types
   let ranges = vehicleType == .truck 
       ? ["gallons": ValueRange(min: 20, max: 100)]
       : [:]
   
   // ❌ Avoid - overriding with same values as hints file
   let ranges = ["gallons": ValueRange(min: 5, max: 30)]  // Redundant
   ```

4. **Document range rationale**: Explain why ranges are set to specific values (helps future maintainers).
   ```json
   // Comment in hints file (not JSON, but document in code/docs)
   // Range 5-30 gallons covers most passenger vehicles
   // Trucks use runtime override: 20-100 gallons
   ```

5. **Test boundary conditions**: Verify min, max, and edge cases work correctly.
   ```swift
   #expect(range.contains(5.0) == true)   // At min
   #expect(range.contains(30.0) == true)  // At max
   #expect(range.contains(4.9) == false) // Just below
   #expect(range.contains(30.1) == false) // Just above
   ```

6. **Preserve backward compatibility**: Existing hints files without `expectedRange` continue to work.
   - Never require ranges - they're optional validation hints.
   - If no range is defined, all values are accepted (no breaking changes).

## 🔗 Reference Documentation

- `Framework/Sources/Core/Models/PlatformTypes.swift` – `ValueRange` and `FieldDisplayHints` definitions.
- `Framework/Sources/Core/Models/PlatformOCRTypes.swift` – `OCRContext` with `fieldRanges` property.
- `Framework/Sources/Core/Services/OCRService.swift` – `validateFieldRanges` implementation.
- `Development/Tests/SixLayerFrameworkUnitTests/Features/OCR/OCRServiceAutomaticHintsTests.swift` – Range validation tests.
- `Framework/docs/HintsFileOCRAndCalculationsGuide.md` – Complete value ranges documentation.
- `Development/RELEASE_v5.7.1.md` – Full release notes.

## 🔄 Migration from v5.7.0

### Adding Ranges to Existing Hints Files

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

### Using Runtime Overrides

If your app needs dynamic ranges:

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

## 🚨 Common Pitfalls

1. **Too broad ranges**: Setting `{"min": 0, "max": 1000}` defeats the purpose of validation.
2. **Missing calculation groups**: If extraction fails due to range validation, values are lost unless calculation groups can fill them in.
3. **Redundant overrides**: Overriding with same values as hints file is unnecessary.
4. **Non-numeric validation**: Ranges only validate numeric values - text fields skip validation.
5. **Exclusive boundaries**: Remember boundaries are **inclusive** - `min <= value <= max`.

Follow these guidelines to keep contributions aligned with the v5.7.1 architecture and release objectives.











