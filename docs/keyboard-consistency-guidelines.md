# Keyboard Consistency Guidelines

## Overview

This document provides comprehensive guidelines for maintaining keyboard consistency across the CarManager application. All TextField instances must use appropriate keyboard types and autocapitalization settings to provide the best user experience on both iOS and macOS platforms.

## Core Principles

1. **Always use cross-platform extensions** - Never use platform-specific modifiers directly
2. **Choose appropriate keyboard types** - Match keyboard type to expected input
3. **Apply proper autocapitalization** - Use capitalization that makes sense for the field type
4. **Test on both platforms** - Ensure consistent behavior across iOS and macOS
5. **Follow established patterns** - Use the same keyboard configuration for similar field types

## Available Cross-Platform Extensions

### Keyboard Type Extensions

```swift
// Basic keyboard types
.defaultKeyboard()           // Standard QWERTY keyboard
.numberPadKeyboard()         // Numeric keypad (0-9)
.decimalPadKeyboard()        // Numeric keypad with decimal point
.emailKeyboard()            // Email-optimized keyboard
.phoneKeyboard()            // Phone number keypad
.urlKeyboard()              // URL-optimized keyboard
.asciiCapableKeyboard()     // ASCII characters only
```

### Autocapitalization Extensions

```swift
.allCapsText()              // ALL CHARACTERS CAPITALIZED
.wordsCapsText()            // First Letter Of Each Word Capitalized
// No extension = no autocapitalization
```

## Field Type Categorization and Recommendations

### 1. Vehicle Information Fields

#### Text Fields (Names, Descriptions)
- **Examples:** Make, Model, Color, Name, Title, Description
- **Keyboard Type:** `.defaultKeyboard()`
- **Autocapitalization:** `.wordsCapsText()`
- **Usage:**
```swift
TextField("Make", text: $make)
    .defaultKeyboard()
    .wordsCapsText()
```

#### Identifier Fields
- **Examples:** VIN, License Plate, Policy Number, Transaction ID
- **Keyboard Type:** `.defaultKeyboard()`
- **Autocapitalization:** `.allCapsText()`
- **Usage:**
```swift
TextField("VIN", text: $vin)
    .defaultKeyboard()
    .allCapsText()
```

#### Numeric Fields
- **Examples:** Year, Odometer, Mileage, Warranty Years
- **Keyboard Type:** `.numberPadKeyboard()`
- **Autocapitalization:** None
- **Usage:**
```swift
TextField("Year", text: $year)
    .numberPadKeyboard()
```

#### Decimal Fields
- **Examples:** Fuel Tank Capacity, Purchase Price, Cost, Amount
- **Keyboard Type:** `.decimalPadKeyboard()`
- **Autocapitalization:** None
- **Usage:**
```swift
TextField("Purchase Price", text: $purchasePrice)
    .decimalPadKeyboard()
```

### 2. Contact Information Fields

#### Email Addresses
- **Keyboard Type:** `.emailKeyboard()`
- **Autocapitalization:** None
- **Usage:**
```swift
TextField("Email", text: $email)
    .emailKeyboard()
```

#### Phone Numbers
- **Keyboard Type:** `.phoneKeyboard()`
- **Autocapitalization:** None
- **Usage:**
```swift
TextField("Phone", text: $phone)
    .phoneKeyboard()
```

#### URLs
- **Keyboard Type:** `.urlKeyboard()`
- **Autocapitalization:** None
- **Usage:**
```swift
TextField("Website", text: $website)
    .urlKeyboard()
```

### 3. Notes and Description Fields

#### General Notes
- **Keyboard Type:** `.defaultKeyboard()`
- **Autocapitalization:** `.wordsCapsText()`
- **Usage:**
```swift
TextField("Notes", text: $notes)
    .defaultKeyboard()
    .wordsCapsText()
```

#### Long Descriptions
- **Use:** `TextEditor` instead of `TextField`
- **Autocapitalization:** `.wordsCapsText()`
- **Usage:**
```swift
TextEditor(text: $description)
    .wordsCapsText()
```

## Using FormTextField Component

For consistent form fields, use the `FormTextField` component which automatically applies the correct keyboard configuration:

```swift
FormTextField(
    title: "Make",
    text: $make,
    placeholder: "Enter vehicle make",
    keyboardType: .default,
    autocapitalization: .words
)

FormTextField(
    title: "Year",
    text: $year,
    placeholder: "Enter year",
    keyboardType: .numberPad,
    autocapitalization: .none
)

FormTextField(
    title: "VIN",
    text: $vin,
    placeholder: "Enter VIN",
    keyboardType: .default,
    autocapitalization: .allCharacters
)
```

## Quick Reference Guide

### Field Type → Keyboard Configuration

| Field Type | Keyboard Type | Autocapitalization | Example Fields |
|------------|---------------|-------------------|----------------|
| Names/Titles | `.defaultKeyboard()` | `.wordsCapsText()` | Make, Model, Color, Name |
| Identifiers | `.defaultKeyboard()` | `.allCapsText()` | VIN, License Plate, Policy # |
| Years/Integers | `.numberPadKeyboard()` | None | Year, Warranty Years |
| Prices/Decimals | `.decimalPadKeyboard()` | None | Price, Cost, Amount |
| Email | `.emailKeyboard()` | None | Email Address |
| Phone | `.phoneKeyboard()` | None | Phone Number |
| URL | `.urlKeyboard()` | None | Website URL |
| Notes | `.defaultKeyboard()` | `.wordsCapsText()` | Notes, Description |

### Common Patterns

#### Vehicle Information
```swift
// Text fields
TextField("Make", text: $make).defaultKeyboard().wordsCapsText()
TextField("Model", text: $model).defaultKeyboard().wordsCapsText()
TextField("Color", text: $color).defaultKeyboard().wordsCapsText()

// Identifiers
TextField("VIN", text: $vin).defaultKeyboard().allCapsText()
TextField("License Plate", text: $licensePlate).defaultKeyboard().allCapsText()

// Numeric fields
TextField("Year", text: $year).numberPadKeyboard()
TextField("Odometer", text: $odometer).decimalPadKeyboard()
```

#### Financial Information
```swift
TextField("Purchase Price", text: $purchasePrice).decimalPadKeyboard()
TextField("Cost", text: $cost).decimalPadKeyboard()
TextField("Amount", text: $amount).decimalPadKeyboard()
```

#### Contact Information
```swift
TextField("Email", text: $email).emailKeyboard()
TextField("Phone", text: $phone).phoneKeyboard()
TextField("Website", text: $website).urlKeyboard()
```

## Best Practices

### 1. Always Use Cross-Platform Extensions

❌ **Don't do this:**
```swift
#if os(iOS)
TextField("Make", text: $make)
    .keyboardType(.default)
    .autocapitalization(.words)
#else
TextField("Make", text: $make)
#endif
```

✅ **Do this:**
```swift
TextField("Make", text: $make)
    .defaultKeyboard()
    .wordsCapsText()
```

### 2. Choose Appropriate Keyboard Types

- **Numbers only:** Use `.numberPadKeyboard()`
- **Numbers with decimals:** Use `.decimalPadKeyboard()`
- **Email addresses:** Use `.emailKeyboard()`
- **Phone numbers:** Use `.phoneKeyboard()`
- **URLs:** Use `.urlKeyboard()`
- **General text:** Use `.defaultKeyboard()`

### 3. Apply Sensible Autocapitalization

- **Names and titles:** Use `.wordsCapsText()`
- **Identifiers and codes:** Use `.allCapsText()`
- **Numbers and emails:** No autocapitalization
- **Notes and descriptions:** Use `.wordsCapsText()`

### 4. Test Your Implementation

- Test on both iOS and macOS
- Verify keyboard appears correctly on iOS
- Ensure no compilation errors on macOS
- Check that autocapitalization works as expected

## Common Mistakes to Avoid

### 1. Platform-Specific Code
```swift
// ❌ Wrong - Platform-specific
#if os(iOS)
    .keyboardType(.numberPad)
#endif

// ✅ Correct - Cross-platform
.numberPadKeyboard()
```

### 2. Inconsistent Field Types
```swift
// ❌ Wrong - Inconsistent keyboard types for similar fields
TextField("Make", text: $make).defaultKeyboard()           // No autocapitalization
TextField("Model", text: $model).numberPadKeyboard()       // Wrong keyboard type

// ✅ Correct - Consistent keyboard types
TextField("Make", text: $make).defaultKeyboard().wordsCapsText()
TextField("Model", text: $model).defaultKeyboard().wordsCapsText()
```

### 3. Missing Autocapitalization
```swift
// ❌ Wrong - Missing autocapitalization for text fields
TextField("Make", text: $make).defaultKeyboard()

// ✅ Correct - Proper autocapitalization
TextField("Make", text: $make).defaultKeyboard().wordsCapsText()
```

## Testing Guidelines

### 1. Unit Testing
- Test that views initialize without errors
- Verify FormTextField components work correctly
- Test cross-platform extension compilation

### 2. UI Testing
- Test keyboard appearance on iOS simulator
- Verify correct keyboard type appears for each field
- Test autocapitalization behavior
- Ensure consistent behavior across different views

### 3. Integration Testing
- Test keyboard consistency across all views
- Verify no compilation errors on macOS
- Test performance impact of keyboard extensions

## Maintenance

### 1. Regular Audits
- Run keyboard consistency audit periodically
- Check for new fields that need keyboard configuration
- Verify existing configurations are still appropriate

### 2. Code Reviews
- Include keyboard configuration in code reviews
- Check that new TextField instances follow guidelines
- Verify cross-platform compatibility

### 3. Documentation Updates
- Update guidelines when new field types are added
- Document any changes to keyboard behavior
- Keep examples current with actual code

## Resources

- **Cross-Platform Extensions:** `Shared/Utils/PlatformExtensions.swift`
- **FormTextField Component:** `Shared/Components/Forms/FormTextField.swift`
- **Keyboard Consistency Tests:** `Tests/Shared/Views/KeyboardConsistencyTests.swift`
- **Audit Report:** `docs/keyboard-consistency-audit.md`

## Support

If you have questions about keyboard consistency or need help implementing the guidelines:

1. Check the audit report for existing patterns
2. Review the test suite for examples
3. Follow the quick reference guide
4. Test your implementation thoroughly
5. Ask for code review to ensure compliance

Remember: **Consistent keyboard behavior improves user experience and reduces input errors. Always prioritize user experience when choosing keyboard configurations.** 