# Field Hints System - Complete Guide

## Table of Contents

1. [Overview](#overview)
2. [Key Concepts](#key-concepts)
3. [Getting Started](#getting-started)
4. [Usage Examples](#usage-examples)
5. [Hints File Format](#hints-file-format)
6. [Display Width System](#display-width-system)
7. [Field Hints Properties](#field-hints-properties)
8. [Storage and Organization](#storage-and-organization)
9. [Caching and Performance](#caching-and-performance)
10. [Testing](#testing)
11. [Migration Guide](#migration-guide)
12. [Best Practices](#best-practices)
13. [Troubleshooting](#troubleshooting)

---

## Overview

The Field Hints System in SixLayer Framework v4.8.0 allows you to **declaratively describe** how your data models should be presented. Instead of manually configuring each field in code, you define hints once in `.hints` files and 6Layer automatically applies them everywhere your data is presented.

### Core Principle

> **Hints describe the DATA, not the view.**

This means hints are tied to your data models, not to specific views. Define how `User` data should look once, and it automatically applies to:
- Create user forms
- Edit user forms  
- User detail views
- User list views
- Any other view that presents User data

---

## Key Concepts

### 1. Declarative Configuration

Instead of:
```swift
TextField("Username", text: $username)
    .frame(width: 200)  // Manual configuration
```

You write:
```json
{
  "username": {
    "displayWidth": "medium"
  }
}
```

### 2. DRY (Don't Repeat Yourself)

- Define hints **once** in a `.hints` file
- Use **everywhere** that data model is presented
- **Cached** for performance

### 3. Data-Driven

- Hints describe the data structure
- Not tied to specific views
- Reusable across all presentation contexts

---

## Getting Started

### Step 1: Create Your Data Model

```swift
// Models/User.swift
struct User: Identifiable {
    let id: UUID
    let username: String
    let email: String
    let bio: String?
    let postalCode: String
}
```

### Step 2: Create the Hints File

Create `Hints/User.hints`:

```json
{
  "username": {
    "displayWidth": "medium",
    "expectedLength": 20,
    "maxLength": 50,
    "minLength": 3
  },
  "email": {
    "displayWidth": "wide",
    "maxLength": 255
  },
  "bio": {
    "displayWidth": "wide",
    "showCharacterCounter": true,
    "maxLength": 1000
  },
  "postalCode": {
    "displayWidth": "narrow",
    "maxLength": 10
  }
}
```

### Step 3: Use in Your Views

```swift
let fields = createUserFields()

let view = platformPresentFormData_L1(
    fields: fields,
    hints: EnhancedPresentationHints(
        dataType: .form,
        presentationPreference: .form,
        context: .create
    ),
    modelName: "User"  // 6Layer reads User.hints automatically!
)
```

---

## Usage Examples

### Basic Form with Hints

```swift
struct CreateUserView: View {
    let fields = [
        DynamicFormField(
            id: "username",
            contentType: .text,
            label: "Username",
            isRequired: true
        ),
        DynamicFormField(
            id: "email",
            contentType: .email,
            label: "Email",
            isRequired: true
        ),
        DynamicFormField(
            id: "bio",
            contentType: .textarea,
            label: "Biography"
        )
    ]
    
    var body: some View {
        platformPresentFormData_L1(
            fields: fields,
            hints: EnhancedPresentationHints(
                dataType: .form,
                context: .create
            ),
            modelName: "User"
        )
    }
}
```

### Multiple Models

```swift
// Hints/User.hints
{
  "username": { "displayWidth": "medium" }
}

// Hints/Product.hints
{
  "name": { "displayWidth": "wide" },
  "price": { "displayWidth": "narrow" }
}

// In your views
platformPresentFormData_L1(..., modelName: "User")
platformPresentFormData_L1(..., modelName: "Product")
```

---

## Hints File Format

### Structure

```json
{
  "fieldName": {
    "displayWidth": "medium",
    "expectedLength": 20,
    "maxLength": 50,
    "minLength": 3,
    "showCharacterCounter": "true"
  }
}
```

### Property Types

All properties in hints files are strings:

- Numeric: `"expectedLength": "20"` (parsed as Int)
- Boolean: `"showCharacterCounter": "true"` (parsed as Bool)
- String: `"displayWidth": "medium"` (stored as String)

### Comments

JSON doesn't support comments, but you can document in a separate file:

```json
{
  "_comment": "User.hints - Describes how to present User data",
  "username": {
    "displayWidth": "medium"
  }
}
```

---

## Display Width System

### Named Widths

| Width | Points | Use Cases |
|-------|--------|-----------|
| `narrow` | ~150 | Postal codes, phone extensions, short codes |
| `medium` | ~200 | Usernames, cities, short names |
| `wide` | ~400 | Full names, emails, addresses, descriptions |

### Numeric Widths

Specify exact width in points:

```json
{
  "customField": {
    "displayWidth": "250"
  }
}
```

### When to Use

- **narrow**: Fixed-format fields (zip codes, codes)
- **medium**: Standard input fields
- **wide**: Long text, addresses, descriptions
- **numeric**: Custom width requirements

---

## Field Hints Properties

### FieldDisplayHints Structure

```swift
public struct FieldDisplayHints: Sendable {
    public let expectedLength: Int?
    public let displayWidth: String?
    public let showCharacterCounter: Bool
    public let maxLength: Int?
    public let minLength: Int?
    public let metadata: [String: String]
}
```

### Property Descriptions

#### `expectedLength`
- **Type**: Int
- **Purpose**: Expected maximum length for display sizing
- **Example**: `"expectedLength": "20"`
- **Use**: Helps determine field width

#### `displayWidth`
- **Type**: String
- **Purpose**: Visual width of the field
- **Values**: `"narrow"`, `"medium"`, `"wide"`, or numeric
- **Example**: `"displayWidth": "medium"`

#### `showCharacterCounter`
- **Type**: Bool (stored as `"true"`/`"false"`)
- **Purpose**: Show character count overlay
- **Example**: `"showCharacterCounter": "true"`

#### `maxLength`
- **Type**: Int
- **Purpose**: Maximum allowed length for validation
- **Example**: `"maxLength": "50"`

#### `minLength`
- **Type**: Int
- **Purpose**: Minimum required length for validation
- **Example**: `"minLength": "3"`

#### `metadata`
- **Type**: Dictionary<String, String>
- **Purpose**: Additional custom metadata
- **Example**: Any extra properties

---

## Storage and Organization

### Recommended Structure

```
YourApp/
├── Models/
│   ├── User.swift
│   ├── Product.swift
│   └── Order.swift
├── Hints/
│   ├── User.hints          ← All hints in one folder
│   ├── Product.hints
│   └── Order.hints
└── Views/
    ├── CreateUserView.swift
    └── EditUserView.swift
```

### Naming Convention

- Hints file: `{ModelName}.hints`
- Model name must match exactly
- Case-sensitive

### Where Hints Are Stored

1. **App Bundle** (primary): `Hints/User.hints`
2. **Documents Directory** (runtime): `~/Documents/Hints/User.hints`
3. **Root Level** (backward compat): `User.hints`

6Layer checks in this order and uses the first file found.

---

## Caching and Performance

### How Caching Works

```swift
// First call: loads from file
let hints1 = loadHintsFromFile(for: "User")  

// Second call: returns cached
let hints2 = loadHintsFromFile(for: "User")  

// hints1 === hints2 (same reference)
```

### Performance Characteristics

- **Load Time**: File I/O only on first access
- **Memory**: Cached for lifetime of app
- **Scalability**: Performance doesn't degrade with more hints
- **Thread Safety**: Cached on MainActor

### Cache Management

Cache is managed automatically. To clear (if needed):

```swift
// In a real implementation, would provide API for this
hintsCache.clearCache(for: "User")
```

---

## Testing

### Running Tests

```bash
# All field hints tests
swift test --filter FieldDisplayHintsTests
swift test --filter FieldHintsLoaderTests
swift test --filter FieldHintsDRYTests
swift test --filter FieldHintsIntegrationTests

# All at once
swift test --filter FieldHints
```

### Test Coverage

✅ Basic functionality  
✅ Hints loading from files  
✅ Caching behavior  
✅ Multiple models  
✅ Hints merging  
✅ Integration workflow  

---

## Migration Guide

### Existing Apps (No Changes)

Field hints are **opt-in**. Your existing code continues to work:

```swift
// Still works, no changes needed
platformPresentFormData_L1(
    fields: fields,
    hints: EnhancedPresentationHints(...)
)
```

### Adding Field Hints (New Code)

1. Create `Hints/` folder
2. Add `{ModelName}.hints` files
3. Pass `modelName` parameter

```swift
// Before: no hints
platformPresentFormData_L1(
    fields: fields,
    hints: EnhancedPresentationHints(...)
)

// After: with hints (optional!)
platformPresentFormData_L1(
    fields: fields,
    hints: EnhancedPresentationHints(...),
    modelName: "User"  // ← Add this
)
```

---

## Best Practices

### 1. Name Hints Files Consistently

```
User.swift      → User.hints
Product.swift   → Product.hints
Order.swift     → Order.hints
```

### 2. Organize in Hints/ Folder

```
Keep all hints together:
Hints/
  User.hints
  Product.hints
  Order.hints
```

### 3. Use Meaningful Display Widths

```json
{
  "zipCode": { "displayWidth": "narrow" },      // ✓
  "email": { "displayWidth": "wide" },         // ✓
  "bio": { "displayWidth": "wide" }            // ✓
}
```

### 4. Set Reasonable Limits

```json
{
  "username": {
    "minLength": "3",
    "maxLength": "50"  // Reasonable limits
  }
}
```

### 5. Use Character Counter for Long Text

```json
{
  "description": {
    "displayWidth": "wide",
    "maxLength": "500",
    "showCharacterCounter": "true"  // Helpful for users
  }
}
```

---

## Troubleshooting

### Hints Not Loading

**Problem**: Hints not applied to views

**Solutions**:
1. Check file exists: `Hints/{ModelName}.hints`
2. Verify naming matches exactly (case-sensitive)
3. Ensure file is added to app target in Xcode
4. Check JSON syntax is valid

### Cache Not Updating

**Problem**: Changes to hints file not reflected

**Solution**: This is expected behavior (DRY). To see changes:
- Restart app
- Or implement cache clearing (future enhancement)

### Hint Parsing Errors

**Problem**: Hints file has syntax errors

**Solutions**:
1. Validate JSON syntax
2. Check all strings quoted properly
3. Ensure numeric values as strings: `"20"` not `20`

---

## Additional Resources

- `Framework/docs/FieldHintsGuide.md` - Quick start guide
- `Framework/docs/HintsDRYArchitecture.md` - DRY principles
- `Framework/docs/HintsFolderStructure.md` - File organization
- `Framework/Examples/AutoLoadHintsExample.swift` - Complete example
- `Development/RELEASE_v4.8.0.md` - Release notes

---

## Summary

The Field Hints System makes UI generation more **declarative**, **maintainable**, and **DRY**:

✅ Define hints once in `.hints` files  
✅ Use everywhere automatically  
✅ Organized in `Hints/` folder  
✅ Cached for performance  
✅ Fully backward compatible  
✅ Type-safe and tested  

**Start using hints today!**


