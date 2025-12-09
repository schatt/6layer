# AI Agent Guide for SixLayer Framework v6.1.0

This guide summarizes the version-specific context for v6.1.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.1.0** (see `Package.swift` comment or release tags).
2. Understand that **form UX enhancements** are now available: collapsible sections, required field indicators, character counters, validation summary, Stepper field type, and Link component for URLs.
3. Know that **batch OCR workflow** is available for filling multiple fields from single scan.
4. Know that **declarative field hints** with Mirror fallback automatically discover properties.
5. Know that **barcode scanning support** and **semantic background colors** are available.
6. Know that **platform extensions** are available for sidebar, containers, lists, and animations.
7. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.1.0

### Form UX Enhancements (Issues #74, #75, #76, #78, #86, #87)
- **Collapsible Sections**: `DynamicFormSectionView` now supports collapsible sections for better organization of long forms
- **Required Field Indicators**: Visual indicators automatically appear in `DynamicFormFieldView` for required fields
- **Character Counters**: Automatic character counters for text fields with `maxLength` validation
- **Validation Summary**: `ValidationSummaryView` shows all form errors at once
- **Stepper Field Type**: Stepper is now a dedicated `DynamicFormField` type for better number input UX
- **Link Component for URLs**: Read-only URL fields automatically use `Link` component instead of `TextField`

### OCR & Data Processing (Issues #83, #90)
- **Batch OCR Workflow**: Process multiple fields from a single OCR scan operation
- **Declarative Field Hints**: Field hints are now fully declarative with Mirror fallback for automatic property discovery

### UI Enhancements (Issues #94, #93)
- **Semantic Background Colors**: Support for SwiftUI semantic background colors via `Color.named()`
- **Barcode Scanning Support**: Barcode scanning for data capture with multiple format support

### Platform Extensions (Issues #64, #65, #66, #67, #69, #70)
- **Platform Sidebar Pull Indicator**: Extension for consistent sidebar interaction patterns
- **Platform Container Extensions**: Extensions for LazyVGrid, Tab, and Scroll containers
- **Platform List Toolbar Extension**: Toolbar extension for List components
- **Platform Animation System Extensions**: Cross-platform animation abstractions (experimental)
- **tvOS Toolbar Placement Research**: Documented tvOS toolbar placement support and best practices
- **String Sanitization Function**: General-purpose string sanitization function for data cleaning

## 🧠 Guidance for v6.1.0 Work

### 1. Form UX Enhancements Usage
- **Collapsible Sections**: Set `isCollapsible: true` in `DynamicFormSectionView` to enable collapsible behavior
- **Required Field Indicators**: Indicators appear automatically for fields with `isRequired: true` - no code changes needed
- **Character Counters**: Counters appear automatically for text fields with `maxLength` validation
- **Validation Summary**: Use `ValidationSummaryView` to show all form errors at once
- **Stepper Fields**: Use `DynamicFormFieldType.stepper` for numeric input fields
- **URL Fields**: Read-only URL fields automatically use `Link` component - no code changes needed

### 2. Batch OCR Workflow Usage
- Use `BatchOCRWorkflow` to process multiple fields from a single scan
- Integrates with existing `OCRService` API
- Maintains backward compatibility with single-field OCR operations
- Comprehensive error handling and validation

### 3. Declarative Field Hints Usage
- Field hints now support automatic property discovery using Swift Mirror reflection
- Reduces boilerplate in hints file definitions
- Maintains backward compatibility with explicit hints
- Mirror fallback automatically discovers properties when hints are not explicitly defined

### 4. Barcode Scanning Usage
- Use `BarcodeScannerService` for barcode scanning
- Supports multiple barcode formats
- Integrates with form field population
- Improves data entry efficiency

### 5. Semantic Background Colors Usage
- Use `Color.named()` for semantic background colors
- Automatically supports light/dark mode
- Follows platform design guidelines
- Uses system semantic colors for better platform integration

### 6. Platform Extensions Usage
- Use platform extensions for consistent cross-platform abstractions
- All extensions follow the 6-layer architecture pattern
- Platform-specific implementations with graceful fallbacks
- Consistent error handling across all extensions

### 7. String Sanitization Usage
- Use `sanitizeString()` for general-purpose string sanitization
- Removes invalid characters and normalizes input
- Supports various sanitization strategies
- Useful for data cleaning and validation

### 8. Testing Expectations
- Follow TDD: Write tests before implementation
- Test all new form UX features
- Test batch OCR workflow with multiple fields
- Test declarative field hints with Mirror fallback
- Test platform extensions across all platforms
- Test accessibility compliance for all new features

## ✅ Best Practices

1. **Use collapsible sections for long forms**: Improve navigation and organization
   ```swift
   // ✅ Good - collapsible sections for better UX
   DynamicFormSectionView(
       title: "Personal Information",
       isCollapsible: true,
       fields: personalInfoFields
   )
   
   // ❌ Avoid - always expanded sections in long forms
   DynamicFormSectionView(
       title: "Personal Information",
       fields: personalInfoFields
   )
   ```

2. **Use Stepper for numeric input**: Better UX than text fields
   ```swift
   // ✅ Good - Stepper for numeric input
   DynamicFormFieldView(
       field: DynamicFormField(
           id: "quantity",
           type: .stepper,
           label: "Quantity",
           value: $quantity
       )
   )
   
   // ❌ Avoid - text field for numeric input
   DynamicFormFieldView(
       field: DynamicFormField(
           id: "quantity",
           type: .text,
           label: "Quantity",
           value: $quantity
       )
   )
   ```

3. **Use validation summary for better error visibility**: Show all errors at once
   ```swift
   // ✅ Good - validation summary
   if !formErrors.isEmpty {
       ValidationSummaryView(
           errors: formErrors,
           onErrorTap: { field in
               // Navigate to field
           }
       )
   }
   
   // ❌ Avoid - only inline field errors
   // Users may miss errors in long forms
   ```

4. **Use batch OCR for multi-field data capture**: More efficient than single-field scans
   ```swift
   // ✅ Good - batch OCR workflow
   let workflow = BatchOCRWorkflow(fields: multipleFields)
   let results = try await workflow.processScan(image: scannedImage)
   
   // ❌ Avoid - multiple single-field OCR operations
   for field in fields {
       let result = try await ocrService.processField(image: scannedImage, field: field)
   }
   ```

5. **Use declarative field hints with Mirror fallback**: Reduce boilerplate
   ```swift
   // ✅ Good - declarative hints with Mirror fallback
   let hints = FieldDisplayHints(
       // Only define hints that differ from defaults
       // Mirror automatically discovers other properties
   )
   
   // ❌ Avoid - defining all hints explicitly
   let hints = FieldDisplayHints(
       // Define every single property even if using defaults
   )
   ```

6. **Use semantic background colors**: Better platform integration
   ```swift
   // ✅ Good - semantic background colors
   .background(Color.named("systemBackground"))
   
   // ❌ Avoid - hardcoded colors
   .background(Color.white)
   ```

## 🔍 Common Patterns

### Collapsible Form Sections
```swift
DynamicFormView(
    sections: [
        DynamicFormSectionView(
            title: "Personal Information",
            isCollapsible: true,
            fields: personalInfoFields
        ),
        DynamicFormSectionView(
            title: "Contact Information",
            isCollapsible: true,
            fields: contactInfoFields
        )
    ]
)
```

### Validation Summary
```swift
struct MyFormView: View {
    @State private var formErrors: [FormError] = []
    
    var body: some View {
        VStack {
            if !formErrors.isEmpty {
                ValidationSummaryView(
                    errors: formErrors,
                    onErrorTap: { field in
                        // Scroll to field or navigate
                    }
                )
            }
            
            DynamicFormView(...)
        }
    }
}
```

### Batch OCR Workflow
```swift
let workflow = BatchOCRWorkflow(
    fields: [
        "name",
        "address",
        "phone",
        "email"
    ]
)

let results = try await workflow.processScan(image: scannedImage)

// Results contain extracted values for all fields
for (field, value) in results {
    formData[field] = value
}
```

### Declarative Field Hints
```swift
// Hints file with Mirror fallback
struct ProductHints: FieldDisplayHints {
    // Only define hints that differ from defaults
    var name: FieldDisplayHint {
        FieldDisplayHint(
            label: "Product Name",
            placeholder: "Enter product name",
            isRequired: true
        )
    }
    
    // Other properties automatically discovered via Mirror
    // price, description, category, etc.
}
```

### Barcode Scanning
```swift
let scanner = BarcodeScannerService()

if let barcode = try await scanner.scan(image: scannedImage) {
    // Populate form field with barcode value
    formData["barcode"] = barcode.value
}
```

### Semantic Background Colors
```swift
VStack {
    Text("Content")
}
.background(Color.named("systemBackground"))
// Automatically adapts to light/dark mode
```

## ⚠️ Important Notes

1. **Form UX enhancements**: All enhancements are backward compatible. Existing forms continue to work without changes.

2. **Collapsible sections**: State is maintained when sections are collapsed. Form data is preserved.

3. **Required field indicators**: Appear automatically for fields with `isRequired: true`. No code changes needed.

4. **Character counters**: Appear automatically for text fields with `maxLength` validation. No code changes needed.

5. **Validation summary**: Shows all form errors at once. Helps users identify and fix multiple errors efficiently.

6. **Stepper fields**: Use for numeric input instead of text fields. Provides better UX with increment/decrement controls.

7. **URL fields**: Read-only URL fields automatically use `Link` component. No code changes needed.

8. **Batch OCR workflow**: Processes multiple fields from single scan. More efficient than multiple single-field operations.

9. **Declarative field hints**: Mirror fallback automatically discovers properties. Reduces boilerplate in hints files.

10. **Barcode scanning**: Supports multiple barcode formats. Integrates with form field population.

11. **Semantic background colors**: Automatically support light/dark mode. Use `Color.named()` for system colors.

12. **Platform extensions**: All extensions follow 6-layer architecture. Platform-specific implementations with graceful fallbacks.

## 📚 Related Documentation

- `Development/RELEASE_v6.1.0.md` - Complete release notes
- `Framework/docs/DynamicFormGuide.md` - DynamicForm documentation
- `Framework/Sources/Layers/Layer2/DynamicFormView.swift` - Form implementation
- `Framework/Sources/Services/OCR/OCRService.swift` - OCR service
- `Framework/Sources/Services/Barcode/BarcodeScannerService.swift` - Barcode scanning
- `Framework/Sources/Extensions/Platform/PlatformExtensions.swift` - Platform extensions

## 🔗 Related Issues

- [Issue #64](https://github.com/schatt/6layer/issues/64) - Add Platform Sidebar Pull Indicator - ✅ COMPLETED
- [Issue #65](https://github.com/schatt/6layer/issues/65) - Add Platform Container Extensions - ✅ COMPLETED
- [Issue #66](https://github.com/schatt/6layer/issues/66) - Add Platform List Toolbar Extension - ✅ COMPLETED
- [Issue #67](https://github.com/schatt/6layer/issues/67) - Add Platform Animation System Extensions - ✅ COMPLETED
- [Issue #69](https://github.com/schatt/6layer/issues/69) - Research tvOS Toolbar Placement Support - ✅ COMPLETED
- [Issue #70](https://github.com/schatt/6layer/issues/70) - Add general-purpose string sanitization function - ✅ COMPLETED
- [Issue #74](https://github.com/schatt/6layer/issues/74) - Implement collapsible sections in DynamicFormSectionView - ✅ COMPLETED
- [Issue #75](https://github.com/schatt/6layer/issues/75) - Add required field visual indicators to DynamicFormFieldView - ✅ COMPLETED
- [Issue #76](https://github.com/schatt/6layer/issues/76) - Add character counters for text fields with maxLength validation - ✅ COMPLETED
- [Issue #78](https://github.com/schatt/6layer/issues/78) - Add form validation summary view showing all errors at once - ✅ COMPLETED
- [Issue #83](https://github.com/schatt/6layer/issues/83) - Implement batch OCR workflow for filling multiple fields from single scan - ✅ COMPLETED
- [Issue #86](https://github.com/schatt/6layer/issues/86) - Add Stepper as dedicated DynamicFormField type - ✅ COMPLETED
- [Issue #87](https://github.com/schatt/6layer/issues/87) - Use Link component for read-only URL fields instead of TextField - ✅ COMPLETED
- [Issue #90](https://github.com/schatt/6layer/issues/90) - Make Field Hints Fully Declarative with Mirror Fallback - ✅ COMPLETED
- [Issue #93](https://github.com/schatt/6layer/issues/93) - Add Barcode Scanning Support - ✅ COMPLETED
- [Issue #94](https://github.com/schatt/6layer/issues/94) - Add support for SwiftUI semantic background colors via Color.named() - ✅ COMPLETED

---

**Version**: v6.1.0  
**Last Updated**: December 8, 2025
