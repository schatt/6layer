# SixLayer Framework v6.0.3 Release Documentation

**Release Date**: December 8, 2025  
**Release Type**: Patch (Critical Bug Fix)  
**Previous Release**: v6.0.2  
**Status**: ✅ **COMPLETE**

---

## 🎯 Release Summary

Critical patch release fixing 7 additional instances of infinite recursion crashes in accessibility identifier generation that were missed in v6.0.2.

---

## 🐛 Problem Description

While v6.0.2 fixed the main infinite recursion issue, there were additional places where `@Published` properties from `AccessibilityIdentifierConfig` were accessed directly during SwiftUI view body evaluation:

1. `config.namespace` and `config.globalPrefix` accessed directly in `generateIdentifier` methods
2. `config.enableAutoIDs` accessed directly in debug logging statements  
3. `config.enableDebugLogging` accessed directly instead of using captured values
4. `generateNamedAccessibilityIdentifier` accessing all config properties directly
5. `generateExactNamedAccessibilityIdentifier` accessing `config.enableDebugLogging` directly
6. `AccessibilityIdentifierGenerator.generateID` (public API) accessing all config properties directly

These created the same reactive dependency cycles that caused infinite recursion with thousands of stack frames.

---

## 🔍 Root Cause

Accessing `@Published` properties during `View.body` evaluation causes SwiftUI's AttributeGraph to track them as reactive dependencies. When the view body is re-evaluated, it accesses the properties again, triggering another update cycle, creating an infinite loop.

---

## ✅ Solution

Fixed all 7 instances by capturing `@Published` property values as local variables before any logic that could create reactive dependencies:

1. **Added captures for `namespace` and `globalPrefix`** in all three `generateIdentifier` methods
2. **Added capture for `enableAutoIDs`** for debug logging
3. **Updated all debug logging** to use captured `enableDebugLogging` values
4. **Updated `generateNamedAccessibilityIdentifier`** to accept captured values as parameters
5. **Updated `generateExactNamedAccessibilityIdentifier`** to accept captured `enableDebugLogging`
6. **Fixed `AccessibilityIdentifierGenerator.generateID`** to capture all config properties

---

## 📦 Affected Components

- `Framework/Sources/Extensions/Accessibility/AutomaticAccessibilityIdentifiers.swift`
  - `AutomaticComplianceModifier.EnvironmentAccessor`
  - `AutomaticComplianceModifier.NamedEnvironmentAccessor`
  - `AutomaticComplianceModifier.ForcedEnvironmentAccessor`
  - `NamedModifierEnvironmentAccessor`
  - `ExactNamedModifierEnvironmentAccessor`
- `Framework/Sources/Extensions/Accessibility/AccessibilityIdentifierGenerator.swift`
  - `AccessibilityIdentifierGenerator.generateID`

---

## 🎯 Impact

- **Severity**: Critical - caused app crashes
- **Affected Users**: All users using automatic accessibility identifier generation with non-empty namespace or globalPrefix
- **Platforms**: iOS and macOS
- **Why Tests Didn't Catch**: Tests use ViewInspector which doesn't trigger SwiftUI's AttributeGraph update cycle. The recursion only occurs during actual view rendering in real apps.

---

## 🔧 Technical Details

### Pattern Applied

All fixes follow the same pattern:
1. Capture `@Published` property values as local variables at the start of `View.body`
2. Pass captured values as parameters to helper methods
3. Use captured values instead of accessing `config.` properties directly

### Example Fix

**Before (causes infinite recursion):**
```swift
private func generateIdentifier(...) -> String {
    let namespace = config.namespace.isEmpty ? nil : config.namespace  // ❌ Direct access
    let prefix = config.globalPrefix.isEmpty ? nil : config.globalPrefix  // ❌ Direct access
    // ...
}
```

**After (safe):**
```swift
var body: some View {
    let capturedNamespace = config.namespace  // ✅ Capture first
    let capturedGlobalPrefix = config.globalPrefix  // ✅ Capture first
    // ...
    let identifier = generateIdentifier(
        // ...
        capturedNamespace: capturedNamespace,  // ✅ Pass captured value
        capturedGlobalPrefix: capturedGlobalPrefix  // ✅ Pass captured value
    )
}

private func generateIdentifier(
    // ...
    capturedNamespace: String,  // ✅ Accept as parameter
    capturedGlobalPrefix: String  // ✅ Accept as parameter
) -> String {
    let namespace = capturedNamespace.isEmpty ? nil : capturedNamespace  // ✅ Use captured value
    let prefix = capturedGlobalPrefix.isEmpty ? nil : capturedGlobalPrefix  // ✅ Use captured value
    // ...
}
```

---

## 🔄 Migration

No migration required. This is a bug fix that maintains API compatibility.

---

## ✅ Testing

- All unit tests pass
- Code compiles without errors
- All `@Published` property accesses are now properly captured
- No linter errors

---

## 📚 Related Issues

This fixes the same root cause as v6.0.2 but addresses additional code paths that were missed in the initial fix. The original v6.0.2 fix addressed the main issue but missed these additional instances.

---

## 🚀 Upgrade Instructions

1. Update your `Package.swift`:
   ```swift
   dependencies: [
       .package(url: "https://github.com/schatt/6layer.git", from: "6.0.3")
   ]
   ```

2. Update your imports (no code changes required)

3. Test your app - the crashes should be resolved

---

## 📝 Notes

- This release complements v6.0.2 by fixing all remaining instances of the same issue
- The pattern of capturing `@Published` properties before use is now consistently applied throughout the accessibility identifier generation code
- Future additions should follow this pattern to prevent similar issues
