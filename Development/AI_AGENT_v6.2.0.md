# AI Agent Guide for SixLayer Framework v6.2.0

This guide summarizes the version-specific context for v6.2.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.2.0** (see `Package.swift` comment or release tags).
2. Understand that **form auto-save and draft functionality** is now available for preventing data loss.
3. Know that **field focus management** automatically progresses focus and focuses on errors.
4. Know that **conditional field visibility** allows dynamic showing/hiding based on other field values.
5. Know that **advanced field types** are available: Gauge, MultiDatePicker, LabeledContent, and TextField with axis.
6. Know that **form progress indicators** show completion status for non-wizard forms.
7. Know that **custom field actions** allow per-field actions like scanning and OCR.
8. Know that **field-level help tooltips** provide contextual help for fields.
9. Know that **PlatformCameraPreviewView** provides cross-platform camera preview abstraction.
10. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.2.0

### Form State Management (Issues #80, #81, #77)
- **Form Auto-Save**: Automatic form state saving to prevent data loss with configurable intervals
- **Draft Functionality**: Resume incomplete forms with persistent storage
- **Field Focus Management**: Automatic focus progression and error-focused navigation
- **Conditional Field Visibility**: Dynamic field showing/hiding based on other field values

### Advanced Field Types (Issues #88, #85, #84, #89)
- **Gauge Component**: Visual gauge/level display for iOS 16+/macOS 13+ with circular/linear styles
- **MultiDatePicker**: Multiple date selection support for iOS 16+/macOS 13+
- **LabeledContent**: Read-only/display fields using LabeledContent (iOS 16+/macOS 13+)
- **TextField with Axis**: Multi-line text fields with axis parameter (iOS 16+)

### Form UX Enhancements (Issues #82, #95, #79)
- **Form Progress Indicator**: Visual progress indicator for non-wizard forms
- **Custom Field Actions**: Per-field actions like scanning, OCR, and custom actions
- **Field-Level Help Tooltips**: Info buttons and tooltips for field descriptions

### Platform Extensions (Issue #96)
- **PlatformCameraPreviewView**: Cross-platform camera preview abstraction

### Developer Experience (Issue #97)
- **Debug Warnings**: Warnings when fields exist without hints to improve development workflow

## 🧠 Guidance for v6.2.0 Work

### 1. Form Auto-Save Usage
- Enable auto-save with `formState.enableAutoSave(interval: 5.0)` for automatic saving every 5 seconds
- Use `formState.saveDraft()` to manually save draft state
- Use `formState.loadDraft()` to restore draft state
- Auto-save integrates seamlessly with `DynamicFormView` and `IntelligentFormView`
- Supports entity-based auto-save for Core Data integration

### 2. Field Focus Management Usage
- Focus automatically progresses to next field after input
- Focus management on validation errors helps users fix issues
- Keyboard navigation improvements enhance form usability
- Smart focus behavior based on field type and validation state

### 3. Conditional Field Visibility Usage
- Set `field.visibilityCondition` to control field visibility dynamically
- Expression-based conditional logic supports complex conditions
- Real-time field showing/hiding maintains form state
- Supports conditional chains for dependent fields

### 4. Gauge Component Usage
- Use `.gauge` field type for visual value display
- Configure min/max values via metadata: `"min": "0"`, `"max": "100"`
- Set gauge style: `"gaugeStyle": "circular"` or `"linear"`
- Custom labels via `"gaugeLabel"` metadata
- Fallback to ProgressView for older platforms

### 5. MultiDatePicker Usage
- Use `.multiDate` field type for multiple date selection
- Integrated into `DynamicFormView` field types
- Supports date range selection
- Proper validation and state management

### 6. LabeledContent Usage
- Use `.display` field type for read-only fields
- Automatically uses LabeledContent on iOS 16+/macOS 13+
- Better visual presentation for non-editable fields
- Enhanced accessibility support

### 7. TextField with Axis Usage
- Use TextField with axis parameter for multi-line text
- Vertical text expansion support
- Automatic height adjustment

### 8. Form Progress Indicator Usage
- Visual progress indicator shows completion percentage
- Configurable display styles
- Integration with form validation state

### 9. Custom Field Actions Usage
- Set `field.actions` array for per-field actions
- Support for `.scan(type:)`, `.ocr(hint:)`, and `.custom(title:action:)`
- Field action helpers for common patterns
- Flexible action configuration via metadata

### 10. Field-Level Help Tooltips Usage
- Add help content via field metadata
- Info buttons appear automatically
- Platform-appropriate help presentation
- Accessibility support for help content

### 11. PlatformCameraPreviewView Usage
- Use `PlatformCameraPreviewView` for cross-platform camera preview
- Unified API for iOS and macOS
- Proper camera session management
- Integration with photo selection workflows

### 12. Testing Expectations
- Follow TDD: Write tests before implementation
- Test all new form state management features
- Test conditional field visibility with various conditions
- Test all advanced field types (Gauge, MultiDatePicker, etc.)
- Test form progress indicator integration
- Test custom field actions
- Test PlatformCameraPreviewView across platforms
- Test accessibility compliance for all new features

## ✅ Best Practices

1. **Enable auto-save for long forms**: Prevent data loss
   ```swift
   // ✅ Good - auto-save enabled
   formState.enableAutoSave(interval: 5.0)
   
   // ❌ Avoid - manual save only
   // Users may lose data if app crashes
   ```

2. **Use conditional visibility for dependent fields**: Better UX
   ```swift
   // ✅ Good - conditional visibility
   field.visibilityCondition = { formState in
       formState.getValue(for: "showAdvanced") as? Bool == true
   }
   
   // ❌ Avoid - always showing all fields
   // Clutters form with irrelevant fields
   ```

3. **Use Gauge for visual value display**: Better than numbers
   ```swift
   // ✅ Good - Gauge for visual display
   DynamicFormField(
       id: "progress",
       contentType: .gauge,
       metadata: [
           "min": "0",
           "max": "100",
           "gaugeStyle": "circular"
       ]
   )
   
   // ❌ Avoid - plain number display
   Text("75%")
   ```

4. **Use field actions for data capture**: Improve efficiency
   ```swift
   // ✅ Good - field actions
   field.actions = [
       .scan(type: .barcode),
       .ocr(hint: "invoice")
   ]
   
   // ❌ Avoid - manual data entry only
   // Slower and more error-prone
   ```

5. **Use form progress indicator**: Show completion status
   ```swift
   // ✅ Good - progress indicator
   FormProgressIndicator(formState: formState)
   
   // ❌ Avoid - no progress feedback
   // Users don't know how much is left
   ```

6. **Use field-level help**: Provide contextual assistance
   ```swift
   // ✅ Good - field help
   field.helpText = "Enter your full legal name"
   
   // ❌ Avoid - no help available
   // Users may be confused about requirements
   ```

## 🔍 Common Patterns

### Form Auto-Save
```swift
struct MyFormView: View {
    @StateObject private var formState = DynamicFormState()
    
    var body: some View {
        DynamicFormView(
            formState: formState,
            fields: fields
        )
        .onAppear {
            formState.enableAutoSave(interval: 5.0)
        }
    }
}
```

### Conditional Field Visibility
```swift
let advancedField = DynamicFormField(
    id: "advancedOption",
    label: "Advanced Option",
    contentType: .text
)

advancedField.visibilityCondition = { formState in
    formState.getValue(for: "showAdvanced") as? Bool == true
}
```

### Gauge Field
```swift
let gaugeField = DynamicFormField(
    id: "progress",
    label: "Progress",
    contentType: .gauge,
    defaultValue: "75",
    metadata: [
        "min": "0",
        "max": "100",
        "gaugeStyle": "circular",
        "gaugeLabel": "Completion"
    ]
)
```

### Custom Field Actions
```swift
let invoiceField = DynamicFormField(
    id: "invoiceNumber",
    label: "Invoice Number",
    contentType: .text
)

invoiceField.actions = [
    .scan(type: .barcode),
    .ocr(hint: "invoice"),
    .custom(title: "Lookup", action: {
        // Custom lookup action
    })
]
```

### Form Progress Indicator
```swift
VStack {
    FormProgressIndicator(formState: formState)
    
    DynamicFormView(
        formState: formState,
        fields: fields
    )
}
```

### PlatformCameraPreviewView
```swift
PlatformCameraPreviewView { image in
    // Handle captured image
    processImage(image)
}
```

## ⚠️ Important Notes

1. **Form auto-save**: Automatically saves form state at configurable intervals. Prevents data loss if app crashes or user navigates away.

2. **Draft functionality**: Allows users to resume incomplete forms. Drafts are stored persistently and can be loaded later.

3. **Field focus management**: Automatically progresses focus to next field and focuses on validation errors. Improves form navigation UX.

4. **Conditional field visibility**: Fields can be shown/hidden based on other field values. Maintains form state when fields are hidden.

5. **Gauge component**: Visual gauge display for iOS 16+/macOS 13+. Falls back to ProgressView for older platforms.

6. **MultiDatePicker**: Multiple date selection for iOS 16+/macOS 13+. Integrated into DynamicFormView.

7. **LabeledContent**: Read-only fields use LabeledContent on iOS 16+/macOS 13+ for better visual presentation.

8. **TextField with axis**: Multi-line text fields with vertical expansion. Better for longer content input.

9. **Form progress indicator**: Shows completion percentage for non-wizard forms. Helps users understand progress.

10. **Custom field actions**: Per-field actions like scanning, OCR, and custom actions. Improves data capture efficiency.

11. **Field-level help**: Info buttons and tooltips provide contextual help. Improves user understanding of field requirements.

12. **PlatformCameraPreviewView**: Cross-platform camera preview abstraction. Unified API for iOS and macOS.

13. **Debug warnings**: Warnings when fields exist without hints help identify missing hint definitions during development.

## 📚 Related Documentation

- `Development/RELEASE_v6.2.0.md` - Complete release notes
- `Framework/docs/DynamicFormGuide.md` - DynamicForm documentation
- `Framework/docs/FormAutoSaveGuide.md` - Form auto-save guide
- `Framework/docs/FieldActionsGuide.md` - Field actions guide
- `Framework/Sources/Components/Forms/DynamicFormView.swift` - Form implementation
- `Framework/Sources/Core/Utilities/FormStateStorage.swift` - Form state storage
- `Framework/Sources/Components/Forms/FieldActions.swift` - Field actions implementation

## 🔗 Related Issues

- [Issue #100](https://github.com/schatt/6layer/issues/100) - Add integration tests for form progress indicator - ✅ COMPLETED
- [Issue #99](https://github.com/schatt/6layer/issues/99) - Add UI tests for form progress indicator - ✅ COMPLETED
- [Issue #97](https://github.com/schatt/6layer/issues/97) - Add debug warning when fields exist without hints - ✅ COMPLETED
- [Issue #96](https://github.com/schatt/6layer/issues/96) - Add PlatformCameraPreviewView for cross-platform camera preview abstraction - ✅ COMPLETED
- [Issue #95](https://github.com/schatt/6layer/issues/95) - Feature: Custom Field Actions in DynamicFormView - ✅ COMPLETED
- [Issue #89](https://github.com/schatt/6layer/issues/89) - Add TextField with axis parameter for multi-line text (iOS 16+) - ✅ COMPLETED
- [Issue #88](https://github.com/schatt/6layer/issues/88) - Add Gauge component for visual value display (iOS 16+) - ✅ COMPLETED
- [Issue #85](https://github.com/schatt/6layer/issues/85) - Add MultiDatePicker support for multiple date selection (iOS 16+) - ✅ COMPLETED
- [Issue #84](https://github.com/schatt/6layer/issues/84) - Add LabeledContent support for read-only/display fields (iOS 16+) - ✅ COMPLETED
- [Issue #82](https://github.com/schatt/6layer/issues/82) - Add form progress indicator for non-wizard forms - ✅ COMPLETED
- [Issue #81](https://github.com/schatt/6layer/issues/81) - Implement field focus management (auto-focus next field, focus on errors) - ✅ COMPLETED
- [Issue #80](https://github.com/schatt/6layer/issues/80) - Implement form auto-save and draft functionality - ✅ COMPLETED
- [Issue #79](https://github.com/schatt/6layer/issues/79) - Add field-level help tooltips/info buttons for field descriptions - ✅ COMPLETED
- [Issue #77](https://github.com/schatt/6layer/issues/77) - Implement conditional field visibility based on other field values - ✅ COMPLETED

---

**Version**: v6.2.0  
**Last Updated**: December 10, 2025
