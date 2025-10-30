# Field-Level Display Hints Guide

## Overview

The SixLayer Framework supports field-level display hints that **describe your data**. You create `.hints` files that describe how to present your data models, and 6Layer automatically reads and uses them.

**Key insight**: Hints describe the DATA, so they're stored in `.hints` files that correspond to your data models, not passed in manually.

## How Field Hints Work

### Storage Architecture

Field hints are stored in `.hints` files in a `Hints/` subfolder. The name matches your data model:

```
YourApp/
  Models/
    User.swift                 # Your User data model
    
  Hints/                      # Hints subfolder (created by you)
    User.hints                 # How to present User data
    Product.hints             # How to present Product data
```

### Hints File Format

Create a file named `{YourModelName}.hints` in your project:

**User.hints**:
```json
{
  "username": {
    "expectedLength": 20,
    "displayWidth": "medium",
    "maxLength": 50,
    "minLength": 3,
    "showCharacterCounter": "false"
  },
  "email": {
    "expectedLength": 30,
    "displayWidth": "wide",
    "maxLength": 255
  },
  "bio": {
    "expectedLength": 500,
    "displayWidth": "wide",
    "maxLength": 1000,
    "showCharacterCounter": "true"
  },
  "postalCode": {
    "expectedLength": 10,
    "displayWidth": "narrow",
    "maxLength": 10
  }
}
```

### Using Field Hints

#### 1. Create Your Data Model

```swift
// User.swift
struct User {
    let username: String
    let email: String
    let bio: String?
    let postalCode: String
}
```

#### 2. Create the Hints File in Hints/ Folder

Create a `Hints/` folder in your project and add `User.hints`:

```
YourApp/
  Models/
    User.swift
  Hints/
    User.hints      <- 6Layer reads this automatically
```

**Note**: Add the `Hints/` folder to your Xcode project and include the `.hints` files in your target.

#### 3. Use 6Layer with Model Name

6Layer automatically reads the .hints file:

```swift
struct CreateUserView: View {
    let fields = createUserFields()
    
    var body: some View {
        // Pass modelName to tell 6Layer which .hints file to read
        platformPresentFormData_L1(
            fields: fields,
            hints: EnhancedPresentationHints(
                dataType: .form,
                presentationPreference: .form,
                context: .create
            ),
            modelName: "User"  // 6Layer reads User.hints automatically!
        )
    }
}
```

#### 4. That's It!

6Layer automatically:
- Reads the `User.hints` file
- Applies display widths to each field
- Uses expected lengths for sizing
- Shows character counters when configured

**No manual hint passing needed!** The hints describe your data model.

## Field Hints Properties

### `FieldDisplayHints` Structure

```swift
public struct FieldDisplayHints: Sendable {
    /// Expected maximum length (for display sizing)
    public let expectedLength: Int?
    
    /// Display width: "narrow", "medium", "wide", or numeric value
    public let displayWidth: String?
    
    /// Whether to show a character counter
    public let showCharacterCounter: Bool
    
    /// Maximum allowed length (for validation)
    public let maxLength: Int?
    
    /// Minimum allowed length (for validation)
    public let minLength: Int?
    
    /// Additional metadata
    public let metadata: [String: String]
}
```

## Display Width Guidelines

### Named Widths

- **`narrow`**: ~150 points (e.g., postal code, phone extension)
- **`medium`**: ~200 points (e.g., username, city)
- **`wide`**: ~400 points (e.g., full name, email, address)

### Numeric Widths

You can specify exact widths:

```json
{
  "customField": {
    "displayWidth": "250"
  }
}
```

## Complete Example

### 1. Create Your Data Model

```swift
// User.swift
struct User: Identifiable {
    let id: UUID
    let username: String
    let email: String
    let bio: String?
    let postalCode: String
}
```

### 2. Create the Hints File

**User.hints**:
```json
{
  "username": {
    "expectedLength": 20,
    "displayWidth": "medium",
    "maxLength": 50,
    "minLength": 3
  },
  "email": {
    "displayWidth": "wide"
  },
  "bio": {
    "displayWidth": "wide",
    "showCharacterCounter": "true"
  },
  "postalCode": {
    "displayWidth": "narrow"
  }
}
```

### 3. Create Your View

```swift
struct CreateUserView: View {
    var body: some View {
        platformPresentFormData_L1(
            fields: createUserFields(),
            hints: EnhancedPresentationHints(
                dataType: .form,
                presentationPreference: .form,
                context: .create
            ),
            modelName: "User"  // 6Layer reads User.hints automatically!
        )
    }
}

func createUserFields() -> [DynamicFormField] {
    [
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
        ),
        DynamicFormField(
            id: "postalCode",
            textContentType: .postalCode,
            label: "Postal Code"
        )
    ]
}
```

That's it! 6Layer automatically reads `User.hints` and applies the display properties.

## Integration with DynamicFormField

The framework automatically applies field hints when rendering forms. Simply include hints in your `PresentationHints` and the views will respect the display width and other properties.

## Benefits

1. **Configuration-Driven**: Hints stored in files, separate from code
2. **Type-Safe**: Strongly-typed FieldDisplayHints structure
3. **Cached**: Registry caches hints for performance
4. **File-Based**: Similar to CoreData models, hints are stored in JSON files
5. **Flexible**: Support for both file-based and runtime configuration

## Deterministic Field Ordering (Explicit Order, Groups, Traits)

You can control the display order of fields in IntelligentFormView.

### Quick Start: Runtime Provider

Install a provider once (e.g., at app launch):

```swift
IntelligentFormView.orderRulesProvider = { analysis in
    let names = Set(analysis.fields.map { $0.name })
    let isTask = ["title","status","priority","sizeUnit","estimatedHours","notes"].allSatisfy { names.contains($0) }
    if isTask {
        let base = FieldOrderRules(
            explicitOrder: ["title","status","priority","sizeUnit","estimatedHours","notes"]
        )
        let compact = FieldOrderRules(explicitOrder: ["title","priority","status"])
        return FieldOrderRules(
            explicitOrder: base.explicitOrder,
            perFieldWeights: base.perFieldWeights,
            groups: base.groups,
            traitOverrides: [.compact: compact]
        )
    }
    return nil // fallback to defaults (title/name first)
}
```

Rules are applied trait-aware (phones -> `.compact`, others -> `.regular`). When no provider returns rules, 6Layer defaults to a sensible order that prioritizes common primary fields like `title` or `name` first.

### API Reference

```swift
public struct FieldGroup: Equatable, Sendable {
    public let id: String
    public let title: String?
    public let fields: [String]
}

public enum FieldTrait: Hashable, Sendable { case compact, regular }

public struct FieldOrderRules: Equatable, Sendable {
    public let explicitOrder: [String]?          // Highest precedence
    public let perFieldWeights: [String: Int]    // Higher weight -> earlier
    public let groups: [FieldGroup]              // Declaration order respected
    public let traitOverrides: [FieldTrait: FieldOrderRules]
}
```

Resolver behavior:
- Sort by explicitOrder when provided; unknown keys are ignored.
- Then append remaining fields by weight (desc), then by name for deterministic tie-break.
- Groups render in declaration order; order within each group follows the same rules.
- Trait overrides replace the base rules for that trait.

Validation helper:

```swift
let (sorted, warnings) = IntelligentFormView.inspectEffectiveOrder(analysis: analysis)
// warnings contains any unknown keys detected in explicitOrder/weights/groups
```

### Using Hints

`EnhancedPresentationHints` includes an optional `fieldOrderRules` to carry deterministic ordering through hints if you prefer to keep ordering near your hint definitions:

```swift
let hints = EnhancedPresentationHints(
    dataType: .form,
    fieldOrderRules: FieldOrderRules(
        explicitOrder: ["title","status","priority"]
    )
)
```

If both hints and the runtime provider are present, your app-level provider can decide priority by merging or preferring one.

