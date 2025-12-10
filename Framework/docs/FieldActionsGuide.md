# Field Actions Guide

## Overview

Field Actions allow you to add custom functionality (buttons, icons, etc.) to individual form fields in `DynamicFormView`. This feature addresses Issue #95 and provides a unified, extensible system for field-specific actions like barcode scanning, OCR, lookup, and custom actions.

## Quick Start

### Basic Usage

```swift
import SixLayerFramework

// Create a field with a barcode scanning action
let vinField = DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    fieldAction: BuiltInFieldAction.barcodeScan(
        hint: "Scan VIN",
        supportedTypes: [.code128, .qrCode]
    ).toFieldAction()
)

// Create a field with OCR scanning
let documentField = DynamicFormField(
    id: "document",
    contentType: .text,
    label: "Document Text",
    fieldAction: BuiltInFieldAction.ocrScan(
        hint: "Scan document",
        validationTypes: [.general]
    ).toFieldAction()
)

// Create a field with a lookup action
let addressField = DynamicFormField(
    id: "address",
    contentType: .text,
    label: "Address",
    fieldAction: BuiltInFieldAction.lookup(
        label: "Find Address",
        perform: { fieldId, currentValue in
            // Present address picker
            // Return selected address
            return "123 Main St, City, State 12345"
        }
    ).toFieldAction()
)

// Create a field with a generate action
let idField = DynamicFormField(
    id: "transactionId",
    contentType: .text,
    label: "Transaction ID",
    fieldAction: BuiltInFieldAction.generate(
        label: "Generate ID",
        perform: {
            return UUID().uuidString
        }
    ).toFieldAction()
)
```

## Backward Compatibility

Existing code using `supportsOCR` and `supportsBarcodeScanning` flags continues to work:

```swift
// Old way (still works)
let field = DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    supportsBarcodeScanning: true,
    barcodeHint: "Scan VIN"
)

// New way (preferred)
let field = DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    fieldAction: BuiltInFieldAction.barcodeScan(
        hint: "Scan VIN",
        supportedTypes: [.code128]
    ).toFieldAction()
)
```

The framework automatically converts flags to actions via the `effectiveActions` property, ensuring backward compatibility.

## Built-in Action Types

### Barcode Scanning

```swift
BuiltInFieldAction.barcodeScan(
    hint: String?,
    supportedTypes: [BarcodeType]?
)
```

- **Icon**: `barcode.viewfinder`
- **Label**: "Scan barcode"
- **Use Case**: VIN scanning, product barcode scanning, QR code scanning

### OCR Scanning

```swift
BuiltInFieldAction.ocrScan(
    hint: String?,
    validationTypes: [TextType]?
)
```

- **Icon**: `camera.viewfinder`
- **Label**: "Scan with OCR"
- **Use Case**: Document text extraction, form field population

### Lookup

```swift
BuiltInFieldAction.lookup(
    label: String,
    perform: @Sendable @MainActor (String, Any?) async throws -> Any?
)
```

- **Icon**: `magnifyingglass`
- **Use Case**: Address lookup, product lookup, contact lookup

### Generate

```swift
BuiltInFieldAction.generate(
    label: String,
    perform: @Sendable () async throws -> Any?
)
```

- **Icon**: `sparkles`
- **Use Case**: Generate IDs, passwords, random values

### Custom

```swift
BuiltInFieldAction.custom(
    id: String,
    icon: String,
    label: String,
    accessibilityLabel: String?,
    accessibilityHint: String?,
    perform: @Sendable @MainActor (String, Any?, DynamicFormState) async throws -> Any?
)
```

- **Use Case**: Any custom action with full control

## Custom Actions

### Using View Builder

For complex custom UI, use the `trailingView` property:

```swift
let field = DynamicFormField(
    id: "custom",
    contentType: .text,
    label: "Custom Field",
    trailingView: { field, formState in
        AnyView(
            HStack {
                Button("Action 1") { /* ... */ }
                Button("Action 2") { /* ... */ }
            }
        )
    }
)
```

### Implementing FieldAction Protocol

For reusable actions, implement the `FieldAction` protocol:

```swift
struct MyCustomAction: FieldAction {
    let id: String = "my-custom"
    let icon: String = "star.fill"
    let label: String = "Custom"
    let accessibilityLabel: String = "Custom action"
    let accessibilityHint: String = "Performs custom action"
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        // Perform action
        return "result"
    }
}

let field = DynamicFormField(
    id: "test",
    contentType: .text,
    label: "Test",
    fieldAction: MyCustomAction()
)
```

## Layout and Display

### Single Action

When a field has one action, it renders as a button next to the input field.

### Multiple Actions

- **2 actions or fewer** (default `maxVisibleActions = 2`): Actions render as horizontal buttons
- **3+ actions**: Actions render in a menu (ellipsis button)

### Configuration

```swift
let field = DynamicFormField(
    id: "test",
    contentType: .text,
    label: "Test",
    maxVisibleActions: 1,  // Show menu when > 1 action
    useActionMenu: true    // Force menu display
)
```

## Async Actions

Actions support async operations with automatic loading states:

```swift
let action = BuiltInFieldAction.lookup(
    label: "Find",
    perform: { fieldId, currentValue in
        // This can be async
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return try await fetchData()
    }
)
```

The renderer automatically:
- Shows loading indicator during execution
- Disables button while processing
- Handles errors and displays them in form state

## Error Handling

Actions can throw errors, which are automatically handled:

```swift
let action = BuiltInFieldAction.generate(
    label: "Generate",
    perform: {
        if someCondition {
            throw NSError(domain: "Custom", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Generation failed"
            ])
        }
        return UUID().uuidString
    }
)
```

Errors are:
- Added to form state via `formState.addError()`
- Displayed in the field's error area
- Announced to VoiceOver for accessibility

## Accessibility

All actions include full accessibility support:

- **Accessibility Labels**: Descriptive labels for VoiceOver
- **Accessibility Hints**: Explanations of what the action does
- **Keyboard Navigation**: Actions are keyboard accessible
- **Menu Accessibility**: Action menus are fully accessible

## Examples

### VIN Barcode Scanner

```swift
let vinField = DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    placeholder: "Enter or scan VIN",
    fieldAction: BuiltInFieldAction.barcodeScan(
        hint: "Scan VIN barcode",
        supportedTypes: [.code128, .qrCode]
    ).toFieldAction()
)
```

### Address Lookup

```swift
let addressField = DynamicFormField(
    id: "address",
    contentType: .text,
    label: "Address",
    fieldAction: BuiltInFieldAction.lookup(
        label: "Find Address",
        perform: { fieldId, currentValue in
            // Present address picker
            // This is a simplified example
            return await presentAddressPicker()
        }
    ).toFieldAction()
)
```

### Generate Transaction ID

```swift
let transactionIdField = DynamicFormField(
    id: "transactionId",
    contentType: .text,
    label: "Transaction ID",
    fieldAction: BuiltInFieldAction.generate(
        label: "Generate",
        perform: {
            return UUID().uuidString
        }
    ).toFieldAction()
)
```

### Multiple Actions

```swift
// Field with both OCR and barcode scanning
let scanField = DynamicFormField(
    id: "scan",
    contentType: .text,
    label: "Scan Field",
    supportsOCR: true,
    supportsBarcodeScanning: true
    // Both actions will be created automatically
)
```

## Migration Guide

### From Flags to Actions

**Before:**
```swift
DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    supportsBarcodeScanning: true,
    barcodeHint: "Scan VIN"
)
```

**After:**
```swift
DynamicFormField(
    id: "vin",
    contentType: .text,
    label: "VIN",
    fieldAction: BuiltInFieldAction.barcodeScan(
        hint: "Scan VIN",
        supportedTypes: [.code128]
    ).toFieldAction()
)
```

### Benefits of Migration

1. **Type Safety**: Compile-time checking of action properties
2. **Flexibility**: Easy to add custom actions
3. **Consistency**: Unified API for all field actions
4. **Extensibility**: Framework can provide common action types

## Best Practices

1. **Use Built-in Actions**: Prefer `BuiltInFieldAction` types when possible
2. **Provide Hints**: Always provide helpful hints for scanning actions
3. **Handle Errors**: Actions should handle errors gracefully
4. **Accessibility**: Always provide accessibility labels and hints
5. **Async Operations**: Use async/await for long-running operations
6. **Update Form State**: Actions should update field values via `formState.setValue()`

## Architecture

### Components

- **FieldAction Protocol**: Base protocol for all actions
- **BuiltInFieldAction**: Factory enum for common actions
- **FieldActionRenderer**: Renders actions with proper layout
- **DynamicFormField**: Field model with action support

### Flow

1. Field defines actions (via `fieldAction` or flags)
2. `effectiveActions` computed property converts flags to actions
3. `FieldActionRenderer` renders actions based on count
4. User taps action button
5. Action's `perform()` method executes
6. Result updates field value via `formState.setValue()`

## Related Documentation

- [DynamicFormView Guide](./DynamicFormViewGuide.md)
- [Barcode Scanning Guide](./BarcodeScanningGuide.md)
- [OCR Guide](./OCROverlayGuide.md)

## Issue Reference

This feature implements **Issue #95**: Custom Field Actions in DynamicFormView
