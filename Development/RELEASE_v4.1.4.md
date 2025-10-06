# SixLayerFramework v4.1.4 Release Notes

**Release Date:** October 6, 2025  
**Release Type:** Patch Release (Critical Bug Fix)  
**Previous Version:** v4.1.3

## 🐛 Critical Bug Fix

### AccessibilityIdentifierAssignmentModifier Missing globalAutoIDs Check

This release fixes a critical bug where the `AccessibilityIdentifierAssignmentModifier` was not checking the `globalAutoIDs` environment value, causing automatic accessibility identifiers to be completely non-functional even with proper configuration and the global modifier applied.

**Problem:** The logic in `AccessibilityIdentifierAssignmentModifier` was:
```swift
let shouldApplyAutoIDs = !disableAutoIDs && config.enableAutoIDs
```

This was missing the crucial check for `globalAutoIDs`, which meant that even when users applied `.enableGlobalAutomaticAccessibilityIdentifiers()` to their app's root view, the automatic identifiers wouldn't be generated.

**Solution:** Updated the logic to include the `globalAutoIDs` check:
```swift
let shouldApplyAutoIDs = !disableAutoIDs && config.enableAutoIDs && globalAutoIDs
```

## 🔧 Changes Made

- **Fixed AccessibilityIdentifierAssignmentModifier logic** to properly check `globalAutoIDs` environment value
- **Ensured automatic accessibility identifiers work** when global modifier is applied
- **Maintained backward compatibility** with existing configuration patterns

## 🧪 Testing

- **All 1,662 tests pass** with 0 failures
- **Automatic accessibility identifier tests** specifically validated
- **Global modifier functionality** confirmed working

## 📋 User Action Required

**No action required** - this fix is automatic for users who have already applied the global modifier as documented in v4.1.3.

For users who haven't applied the global modifier yet, ensure you have:

1. **Updated to SixLayerFramework v4.1.4**
2. **Applied the global modifier** to your app's root view:
   ```swift
   @main
   struct MyApp: App {
       init() {
           let config = AccessibilityIdentifierConfig.shared
           config.enableAutoIDs = true
           config.namespace = "MyApp"
           config.mode = .automatic
       }
       
       var body: some Scene {
           WindowGroup {
               ContentView()
                   .enableGlobalAutomaticAccessibilityIdentifiers() // ← This is required!
           }
       }
   }
   ```

## 🎯 Impact

This fix resolves the issue where users reported that automatic accessibility identifiers were completely non-functional, showing empty identifiers (`identifier=''`) instead of the expected `namespace.context.role.objectID` pattern.

**Before v4.1.4:** Automatic accessibility identifiers were non-functional even with proper configuration  
**After v4.1.4:** Automatic accessibility identifiers work correctly with the global modifier

## 📚 Documentation

- **Updated documentation** in v4.1.3 remains valid
- **Examples** in `AutomaticAccessibilityIdentifiersExample.swift` show correct usage
- **Framework documentation** in `AutomaticAccessibilityIdentifiers.md` is current

## 🔗 Related Issues

- Fixes the critical bug reported where automatic accessibility identifiers were completely non-functional
- Resolves the issue where users applied the documented approach but still saw empty identifiers
- Ensures the global modifier actually enables automatic identifier generation

---

**Contributor:** Drew Schatt  
**Framework Version:** 4.1.4  
**Test Coverage:** 1,662 tests, 100% pass rate
