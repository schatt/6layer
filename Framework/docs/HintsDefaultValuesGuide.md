# SixLayer Framework - Hints Default Values Guide

## Overview

**NEW in v4.6.0**: The SixLayer Framework's hints system now supports **default values** that can be used when properties are missing, empty, or fail to extract meaningful content. This provides developers with fine-grained control over fallback behavior.

> **Note**: This is a new feature introduced in SixLayer Framework v4.6.0. Previous versions did not support default values in hints.

## Default Value Properties

The following default value properties are available in `PresentationHints.customPreferences`:

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `itemTitleDefault` | String | Default title when title property is missing/empty | `"Untitled Document"` |
| `itemSubtitleDefault` | String | Default subtitle when subtitle property is missing/empty | `"No description available"` |
| `itemIconDefault` | String | Default icon when icon property is missing/empty | `"doc.text"` |
| `itemColorDefault` | String | Default color when color property is missing/empty | `"blue"` |

## Priority System

The framework uses a sophisticated priority system for content extraction:

### 1. **Priority 1: Hint Property Extraction**
```swift
// Try to extract from the specified property
"itemTitleProperty": "title"  // Extract from item.title
```

### 2. **Priority 1.5: Default Values** ⭐ **NEW**
```swift
// Use default when hint property fails or extracts empty string
"itemTitleDefault": "Untitled Document"
```

### 3. **Priority 2: CardDisplayable Protocol**
```swift
// Fall back to CardDisplayable protocol (if no hints provided)
protocol CardDisplayable {
    var cardTitle: String { get }
}
```

### 4. **Priority 3: Reflection Discovery**
```swift
// Use reflection to find meaningful properties (if no hints provided)
// Looks for common property names like "title", "name", "label"
```

### 5. **Priority 4: UI Layer Placeholders**
```swift
// UI layer provides field name placeholders
Text(extractedTitle ?? "Title")  // Shows "Title" in lighter color
```

## Usage Examples

### Basic Default Values

```swift
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "name",
        "itemTitleDefault": "Untitled Document",
        "itemSubtitleProperty": "description", 
        "itemSubtitleDefault": "No description available",
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text",
        "itemColorProperty": "priority",
        "itemColorDefault": "gray"
    ]
)

platformPresentItemCollection_L1(items: documents, hints: hints)
```

### Handling Missing Properties

```swift
// When Core Data entities have nil values
let task = Task(title: nil, description: nil, status: nil)

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",        // Will be nil
        "itemTitleDefault": "Untitled Task",  // Will be used
        "itemSubtitleProperty": "description", // Will be nil  
        "itemSubtitleDefault": "No description" // Will be used
    ]
)

// Result: "Untitled Task" and "No description" will be displayed
```

### Handling Empty Strings

```swift
// When properties exist but are empty strings
let task = Task(title: "", description: "", status: "")

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",        // Will extract ""
        "itemTitleDefault": "Untitled Task",  // Will override empty string
        "itemSubtitleProperty": "description", // Will extract ""
        "itemSubtitleDefault": "No description" // Will override empty string
    ]
)

// Result: "Untitled Task" and "No description" will be displayed
```

### Respecting Intentional Empty Strings

```swift
// When you want to preserve empty strings as valid content
let task = Task(title: "", description: "", status: "")

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title"
        // No default provided - empty string will be preserved
    ]
)

// Result: Empty string will be displayed (UI layer will show placeholder)
```

## Color Default Values

Color defaults support both string names and hex values:

```swift
let hints = PresentationHints(
    customPreferences: [
        "itemColorProperty": "priority",
        "itemColorDefault": "red"        // Named color
        // OR
        "itemColorDefault": "#FF0000"    // Hex color (future support)
    ]
)
```

### Supported Color Names

| Color Name | SwiftUI Color |
|------------|---------------|
| `red` | `.red` |
| `blue` | `.blue` |
| `green` | `.green` |
| `yellow` | `.yellow` |
| `orange` | `.orange` |
| `purple` | `.purple` |
| `pink` | `.pink` |
| `gray` | `.gray` |
| `black` | `.black` |
| `white` | `.white` |
| `cyan` | `.cyan` |
| `mint` | `.mint` |
| `teal` | `.teal` |
| `indigo` | `.indigo` |
| `brown` | `.brown` |

## Icon Default Values

Icon defaults support SF Symbols:

```swift
let hints = PresentationHints(
    customPreferences: [
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text"           // SF Symbol
        // OR
        "itemIconDefault": "checkmark.circle"    // SF Symbol
    ]
)
```

## Best Practices

### 1. **Provide Meaningful Defaults**
```swift
// ✅ Good - Descriptive defaults
"itemTitleDefault": "Untitled Document"
"itemSubtitleDefault": "No description available"

// ❌ Avoid - Generic defaults
"itemTitleDefault": "Item"
"itemSubtitleDefault": "N/A"
```

### 2. **Use Context-Appropriate Defaults**
```swift
// For tasks
"itemTitleDefault": "Untitled Task"
"itemIconDefault": "doc.text"

// For projects  
"itemTitleDefault": "Untitled Project"
"itemIconDefault": "folder"

// For users
"itemTitleDefault": "Unknown User"
"itemIconDefault": "person.circle"
```

### 3. **Consider User Experience**
```swift
// ✅ Good - User-friendly defaults
"itemTitleDefault": "Untitled Document"
"itemSubtitleDefault": "Tap to add description"

// ❌ Avoid - Technical defaults
"itemTitleDefault": "nil"
"itemSubtitleDefault": "undefined"
```

### 4. **Handle Different Data States**
```swift
let hints = PresentationHints(
    customPreferences: [
        // Handle missing properties
        "itemTitleProperty": "title",
        "itemTitleDefault": "Untitled Task",
        
        // Handle empty properties  
        "itemSubtitleProperty": "description",
        "itemSubtitleDefault": "No description",
        
        // Handle invalid properties
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text"
    ]
)
```

## Migration from Previous Versions

### Before (v4.5.0 and earlier)
```swift
// Old behavior - always got hardcoded fallbacks
let title = CardDisplayHelper.extractTitle(from: item) // Always returned a string
// No way to customize fallback behavior
```

### After (v4.6.0+) - **NEW FEATURES**
```swift
// New behavior - can return nil, defaults can override
let title = CardDisplayHelper.extractTitle(from: item) // Can return nil

// NEW: Use defaults to control fallback behavior
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "name",
        "itemTitleDefault": "Untitled Document"  // NEW: Custom default
    ]
)
```

### What's New in v4.6.0
- ✅ **Default values** in hints (`itemTitleDefault`, `itemSubtitleDefault`, etc.)
- ✅ **Smart empty string handling** (respects empty strings unless default provided)
- ✅ **UI layer placeholders** (shows field names when no content found)
- ✅ **Better separation** between data layer and UI layer responsibilities

## Troubleshooting

### Default Values Not Working

1. **Check property names**: Ensure `itemTitleProperty` matches actual property names
2. **Verify defaults**: Ensure default values are non-empty strings
3. **Check priority**: Defaults only work when hint properties fail

### Empty Strings Not Respected

1. **Remove defaults**: Don't provide defaults if you want to preserve empty strings
2. **Use UI placeholders**: Let the UI layer handle empty string display

### CardDisplayable Not Used

1. **Check hints**: CardDisplayable is only used when no hints are provided
2. **Use defaults**: Provide defaults in hints to control fallback behavior

## Examples in Context

### Core Data Integration

```swift
// Core Data entities with optional properties
extension Task: CardDisplayable {
    public var cardTitle: String {
        return title ?? "Untitled Task"
    }
}

// Use hints with defaults for better control
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",
        "itemTitleDefault": "New Task",  // Override CardDisplayable fallback
        "itemSubtitleProperty": "taskDescription",
        "itemSubtitleDefault": "Tap to add description"
    ]
)
```

### Dynamic Content

```swift
// Different defaults based on context
func createHints(for context: DocumentContext) -> PresentationHints {
    let titleDefault = context == .draft ? "Draft Document" : "Untitled Document"
    
    return PresentationHints(
        customPreferences: [
            "itemTitleProperty": "name",
            "itemTitleDefault": titleDefault,
            "itemIconProperty": "type",
            "itemIconDefault": context == .draft ? "doc.text" : "folder"
        ]
    )
}
```

---

**Version**: SixLayer Framework v4.6.0+  
**Last Updated**: October 24, 2025  
**Related**: [CardDisplayable Protocol Guide](./CardDisplayableGuide.md)
