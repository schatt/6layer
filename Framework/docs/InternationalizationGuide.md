# Internationalization Guide

## Overview

SixLayerFramework provides comprehensive internationalization (i18n) support with a flexible bundle fallback system that allows apps to override framework strings while maintaining framework defaults.

## Bundle Fallback System

The framework uses a **three-tier fallback system** for localized strings:

1. **App Bundle** (highest priority) - Allows apps to override framework strings
2. **Framework Bundle** (fallback) - Framework default strings
3. **Key Itself** (final fallback) - Returns the key if not found in either bundle

### How It Works

```
App Request: localizedString(for: "error.title")
    ↓
1. Check App Bundle (Bundle.main)
   ├─ Found? → Return app's translation
   └─ Not Found? ↓
2. Check Framework Bundle
   ├─ Found? → Return framework's translation
   └─ Not Found? ↓
3. Return key itself: "error.title"
```

## Usage

### Basic Usage

```swift
import SixLayerFramework

// Create service (defaults to Bundle.main for app bundle)
let i18n = InternationalizationService()

// Get localized string (checks app bundle, then framework bundle)
let errorMessage = i18n.localizedString(for: "error.title")
// Returns: App's translation → Framework's translation → "error.title"
```

### With String Formatting

```swift
let i18n = InternationalizationService()

// With format arguments
let welcomeMessage = i18n.localizedString(
    for: "welcome.user",
    arguments: ["John"]
)
// If "welcome.user" = "Welcome, %@!" in strings file
// Returns: "Welcome, John!"
```

### Custom App Bundle

```swift
// Use a different bundle for app strings
let customBundle = Bundle(for: MyCustomClass.self)
let i18n = InternationalizationService(appBundle: customBundle)
```

### App-Only Strings

```swift
// Only check app bundle (no framework fallback)
let appString = i18n.appLocalizedString(for: "app.only.key")
```

### Framework-Only Strings

```swift
// Only check framework bundle (no app fallback)
let frameworkString = i18n.frameworkLocalizedString(for: "framework.only.key")
```

## Setting Up Localization Files

### Framework Strings

Framework strings should be placed in the framework bundle:

```
Framework/
└── Resources/
    ├── en.lproj/
    │   └── Localizable.strings
    ├── es.lproj/
    │   └── Localizable.strings
    └── fr.lproj/
        └── Localizable.strings
```

**Framework Localizable.strings:**
```strings
/* Framework default strings */
"error.title" = "Error";
"error.message" = "An error occurred: %@";
"button.save" = "Save";
"button.cancel" = "Cancel";
```

### App Strings

App strings should be placed in the app bundle:

```
YourApp/
└── Resources/
    ├── en.lproj/
    │   └── Localizable.strings
    ├── es.lproj/
    │   └── Localizable.strings
    └── fr.lproj/
        └── Localizable.strings
```

**App Localizable.strings:**
```strings
/* App-specific strings */
"app.title" = "My App";
"app.welcome" = "Welcome to My App!";

/* Override framework strings */
"error.title" = "Oops!";  /* Overrides framework's "Error" */
"button.save" = "Save Changes";  /* Overrides framework's "Save" */
```

## Key Naming Conventions

### Recommended Practices

1. **Framework Keys**: Use a prefix to avoid conflicts
   ```strings
   "SixLayerFramework.error.title" = "Error";
   "SixLayerFramework.button.save" = "Save";
   ```

2. **App Keys**: Use your app's domain prefix
   ```strings
   "MyApp.welcome.title" = "Welcome";
   "MyApp.settings.title" = "Settings";
   ```

3. **Shared Keys**: Use simple names if you want apps to override
   ```strings
   /* Framework */
   "error.title" = "Error";
   
   /* App can override */
   "error.title" = "Oops!";
   ```

## Example: Complete Workflow

### 1. Framework Provides Defaults

**Framework/en.lproj/Localizable.strings:**
```strings
"form.error.required" = "This field is required";
"form.error.invalid" = "Invalid format";
"form.button.submit" = "Submit";
```

### 2. App Overrides Some Strings

**App/en.lproj/Localizable.strings:**
```strings
/* Override framework string */
"form.button.submit" = "Save Form";

/* Add app-specific strings */
"app.name" = "My App";
```

### 3. Usage in Code

```swift
let i18n = InternationalizationService()

// Uses app's override: "Save Form"
let submitText = i18n.localizedString(for: "form.button.submit")

// Uses framework default: "This field is required"
let requiredError = i18n.localizedString(for: "form.error.required")

// Uses app string: "My App"
let appName = i18n.localizedString(for: "app.name")

// Returns key (not found): "unknown.key"
let unknown = i18n.localizedString(for: "unknown.key")
```

## SwiftUI Integration

Use the Layer 1 functions for SwiftUI views:

```swift
import SixLayerFramework

struct MyView: View {
    var body: some View {
        // Automatically uses app bundle → framework bundle fallback
        platformPresentLocalizedString_L1(
            key: "welcome.title",
            arguments: []
        )
    }
}
```

## Advanced: Custom Bundle Detection

The framework automatically detects its bundle using:

1. Swift Package Manager resource bundles
2. Framework bundle (for embedded frameworks)
3. Main bundle (fallback)

You typically don't need to configure this, but the framework handles:
- SPM resource bundles: `SixLayerFramework_SixLayerFramework.bundle`
- Embedded frameworks: The framework's own bundle
- App bundles: `Bundle.main` (default)

## Best Practices

1. **Use Namespaced Keys**: Prefix framework keys to avoid conflicts
2. **Document Overridable Keys**: Document which framework keys apps can override
3. **Provide Complete Translations**: Framework should provide all supported languages
4. **Test Fallback Behavior**: Verify app overrides work correctly
5. **Use Format Arguments**: Use `%@`, `%d`, etc. for dynamic content

## Troubleshooting

### Strings Not Found

If strings aren't being found:

1. **Check Bundle Resources**: Ensure `.strings` files are included in bundle resources
2. **Verify Language Codes**: Use correct language codes (e.g., `en.lproj`, not `en-US.lproj`)
3. **Check File Format**: Ensure `.strings` files are valid property list format
4. **Verify Bundle**: Use `appLocalizedString` or `frameworkLocalizedString` to test specific bundles

### App Override Not Working

If app strings aren't overriding framework strings:

1. **Check Priority**: App bundle is checked first, so app strings should override
2. **Verify Key Match**: Keys must match exactly (case-sensitive)
3. **Check Bundle**: Ensure app bundle is `Bundle.main` or correctly specified
4. **Test Directly**: Use `appLocalizedString` to verify app bundle has the string

## Related Documentation

- [InternationalizationService API Reference](../Sources/Core/Services/InternationalizationService.swift)
- [Layer 1 Internationalization Functions](../Sources/Layers/Layer1-Semantic/PlatformInternationalizationL1.swift)
- [Internationalization Types](../Sources/Core/Models/InternationalizationTypes.swift)
