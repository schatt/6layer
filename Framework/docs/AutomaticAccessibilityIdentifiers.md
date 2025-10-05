# Automatic Accessibility Identifiers

SixLayer framework automatically generates accessibility identifiers for views, making UI testing easier without requiring manual identifier assignment.

## Overview

The automatic accessibility identifier system provides:

- **Deterministic ID generation** based on object identity and context
- **Global configuration** with namespace and generation mode options
- **Manual override support** - explicit identifiers always take precedence
- **View-level opt-out** for specific views that shouldn't have automatic IDs
- **Collision detection** in DEBUG builds to identify potential conflicts
- **Integration with HIG compliance** - automatic IDs are included in `.appleHIGCompliant()`

## Quick Start

### Enable Automatic Identifiers

```swift
// Enable automatic identifiers globally
AccessibilityIdentifierConfig.shared.enableAutoIDs = true

// Set custom namespace
AccessibilityIdentifierConfig.shared.namespace = "myapp"

// Choose generation mode
AccessibilityIdentifierConfig.shared.mode = .automatic
```

### Use with Layer 1 Functions

```swift
// Layer 1 functions automatically include accessibility identifiers
let view = platformPresentItemCollection_L1(
    items: users,
    hints: PresentationHints(...)
)
// Each user item gets an ID like: "myapp.list.item.user-1"
```

### Manual Override

```swift
// Manual identifiers always override automatic ones
Button("Save") { }
    .platformAccessibilityIdentifier("custom-save-button")
```

### Opt-out for Specific Views

```swift
// Disable automatic identifiers for specific views
Button("Decorative") { }
    .disableAutomaticAccessibilityIdentifiers()
```

## Configuration Options

### Global Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enableAutoIDs` | `Bool` | `true` | Whether to generate automatic identifiers |
| `namespace` | `String` | `"app"` | Global namespace for all generated IDs |
| `mode` | `AccessibilityIdentifierMode` | `.automatic` | ID generation strategy |
| `enableCollisionDetection` | `Bool` | `true` | DEBUG collision detection |

### Generation Modes

#### Automatic Mode (Default)
```
namespace.context.role.objectID
Example: "myapp.list.item.user-1"
```

#### Semantic Mode
```
namespace.role.objectID
Example: "myapp.item.user-1"
```

#### Minimal Mode
```
objectID
Example: "user-1"
```

## ID Generation Rules

### For Identifiable Objects
- Uses `object.id` as the object identifier
- Stable across reordering and data changes
- Example: `User(id: "user-1", ...)` → `"myapp.list.item.user-1"`

### For Non-Identifiable Objects
- Extracts meaningful identifier from content
- Falls back to type name and hash for complex objects
- Example: `"Hello World"` → `"myapp.display.text.hello-world"`

### ID Sanitization
- Spaces → hyphens
- Special characters → hyphens
- Converted to lowercase
- Example: `"User Profile"` → `"user-profile"`

## Integration Points

### Apple HIG Compliance
```swift
// Automatic identifiers are included in HIG compliance
Text("Hello")
    .appleHIGCompliant()
// Gets automatic identifier: "app.ui.element.view"
```

### Layer 1 Functions
All Layer 1 functions automatically include accessibility identifiers:
- `platformPresentItemCollection_L1`
- `platformPresentFormData_L1`
- `platformPresentMediaData_L1`
- And others...

## Best Practices

### When to Use Automatic IDs
- ✅ Repetitive UI elements (lists, forms, cards)
- ✅ Generated content from data models
- ✅ Rapid prototyping and development
- ✅ UI testing scenarios

### When to Use Manual IDs
- ✅ Critical test targets that need specific names
- ✅ Performance-sensitive views (to avoid generation overhead)
- ✅ Views with complex accessibility requirements
- ✅ Public APIs where ID names are part of the contract

### When to Opt Out
- ✅ Purely decorative elements
- ✅ Views that don't need testing
- ✅ Performance-critical rendering paths

## Collision Detection

In DEBUG builds, the system tracks generated IDs to detect potential conflicts:

```swift
let generator = AccessibilityIdentifierGenerator()
let id = generator.generateID(for: user, role: "item", context: "list")
let hasCollision = generator.checkForCollision(id)
```

## Performance Considerations

- **Manual IDs**: Zero overhead - just stores the provided string
- **Automatic IDs**: Small overhead for ID generation and collision tracking
- **Disabled**: Zero overhead - skips all ID generation

## Migration Guide

### From Manual to Automatic
1. Enable automatic IDs globally
2. Remove manual `.platformAccessibilityIdentifier()` calls for repetitive elements
3. Keep manual IDs for critical test targets
4. Test thoroughly to ensure IDs are stable

### From Automatic to Manual
1. Disable automatic IDs globally
2. Add manual `.platformAccessibilityIdentifier()` calls as needed
3. No breaking changes - manual IDs always override automatic ones

## Examples

See `AutomaticAccessibilityIdentifiersExample.swift` for comprehensive examples including:
- Basic automatic identifier usage
- Layer 1 function integration
- Manual override patterns
- Opt-out scenarios
- Global configuration management

## Version History

- **v4.0.0**: Initial implementation with automatic identifiers enabled by default

## Related Documentation

- [Apple HIG Compliance](AppleHIGCompliance.md)
- [Layer 1 Functions](Layer1Functions.md)
- [Platform Accessibility Extensions](PlatformAccessibilityExtensions.md)
