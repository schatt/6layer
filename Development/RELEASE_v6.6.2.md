# SixLayer Framework v6.6.2 Release Documentation

**Release Date**: December 19, 2025  
**Release Type**: Patch (Swift 6 Compilation Fixes)  
**Previous Release**: v6.6.1  
**Status**: ✅ **COMPLETE**

---

## 🎯 Release Summary

Patch release fixing Swift 6 compilation errors and deprecation warnings. This release addresses main actor isolation issues, updates to iOS 17+ APIs, fixes switch exhaustiveness, and removes unnecessary availability checks.

---

## 🔧 Swift 6 Compilation Fixes

### **Main Actor Isolation Fixes**
- **PlatformHapticFeedbackExtensions**: Added `@MainActor` to `triggerHapticFeedback()` function
- **Task Wrapping**: Wrapped haptic feedback calls in `Task { @MainActor in }` in view modifiers
- **Location**: `Framework/Sources/Components/Input/PlatformHapticFeedbackExtensions.swift`
- **Impact**: Resolves "Call to main actor-isolated" errors in Swift 6 strict concurrency mode

### **iOS 17+ API Updates**
- **onChange Deprecation**: Updated `DynamicFieldComponents` to use new iOS 17+ onChange API
- **Zero-Parameter Closure**: Uses new onChange API with zero-parameter closure when available (iOS 17+)
- **Backward Compatibility**: Falls back to old API for iOS 16
- **Location**: `Framework/Sources/Components/Forms/DynamicFieldComponents.swift`
- **Impact**: Removes deprecation warnings and ensures compatibility with future iOS versions

### **Switch Exhaustiveness Fixes**
- **NotificationService**: Fixed switch to handle iOS 17+ `.ephemeral` authorization status
- **SecurityService**: Fixed switch to handle iOS 17+ `.opticID` biometry type
- **Future-Proof Handling**: Uses string comparison to detect new enum cases when pattern matching isn't possible
- **Location**: `Framework/Sources/Core/Services/NotificationService.swift`, `Framework/Sources/Core/Services/SecurityService.swift`
- **Impact**: Resolves "Switch must be exhaustive" compilation errors

### **Availability Check Cleanup**
- **Removed iOS 10.0 Checks**: Removed unnecessary `@available(iOS 10.0, macOS 10.14, *)` attributes
- **Removed iOS 11.0 Checks**: Removed unnecessary `#available(iOS 11.0, *)` checks
- **Rationale**: Framework targets iOS 17+ and macOS 15+, so these checks were unnecessary
- **Location**: `Framework/Sources/Core/Services/NotificationService.swift`, `Framework/Sources/Core/Services/SecurityService.swift`
- **Impact**: Cleaner code that matches actual deployment targets

### **Deprecated API Updates**
- **Badge Management**: Updated to use `UNUserNotificationCenter.setBadgeCount()` for iOS 17+
- **Removed Deprecated Option**: Removed `.allowAnnouncement` option (deprecated in iOS 15.0+)
- **Focus Status**: Fixed `focusStatus` access (synchronous property, not async/throwing)
- **Location**: `Framework/Sources/Core/Services/NotificationService.swift`
- **Impact**: Removes deprecation warnings and uses modern APIs

### **Function Deprecation Fix**
- **Navigation Title Display Mode**: Replaced deprecated `platformNavigationTitleDisplayMode()` with `platformNavigationTitleDisplayMode_L4()`
- **Location**: `Framework/Sources/Extensions/Accessibility/AppleHIGComplianceModifiers.swift`
- **Impact**: Uses consistent Layer 4 naming convention

---

## 🐛 Issues Resolved

- Fixed "Call to main actor-isolated" errors in haptic feedback extensions
- Fixed "onChange(of:perform:) was deprecated" warning
- Fixed "Switch must be exhaustive" errors in NotificationService and SecurityService
- Fixed "Unknown attribute 'available'" errors (removed invalid @available on switch cases)
- Fixed "applicationIconBadgeNumber was deprecated" warning
- Fixed "allowAnnouncement was deprecated" warning
- Fixed "No calls to throwing functions occur within 'try' expression" warning
- Fixed "platformNavigationTitleDisplayMode is deprecated" warning

---

## 📚 Technical Details

### **Main Actor Isolation**
Swift 6's strict concurrency requires explicit main actor isolation for UI-related APIs. Haptic feedback generators must be accessed on the main actor, so we:
1. Mark the function with `@MainActor`
2. Wrap calls in `Task { @MainActor in }` when called from non-isolated contexts

### **Switch Exhaustiveness**
iOS 17+ introduced new enum cases (`.ephemeral` for UNAuthorizationStatus, `.opticID` for LABiometryType). Since we can't use `@available` on switch cases, we:
1. Use a `default` case
2. Check for new cases using string comparison when available
3. Map appropriately (ephemeral → authorized, opticID → faceID)

### **Availability Cleanup**
Since the framework targets iOS 17+ and macOS 15+, we removed all availability checks for earlier versions, simplifying the code and matching actual deployment targets.

---

## ✅ Testing

- All unit tests pass on both iOS and macOS
- No compilation errors or warnings
- Swift 6 strict concurrency compliance verified

---

## 🔄 Migration Notes

No migration required. This is a patch release that fixes compilation issues without changing any public APIs.

---

## 📦 Files Changed

- `Framework/Sources/Components/Input/PlatformHapticFeedbackExtensions.swift` - Main actor isolation fixes
- `Framework/Sources/Components/Forms/DynamicFieldComponents.swift` - iOS 17+ onChange API
- `Framework/Sources/Core/Services/NotificationService.swift` - Switch exhaustiveness, availability cleanup, deprecated API updates
- `Framework/Sources/Core/Services/SecurityService.swift` - Switch exhaustiveness, availability cleanup
- `Framework/Sources/Extensions/Accessibility/AppleHIGComplianceModifiers.swift` - Deprecated function replacement

---

## 🙏 Acknowledgments

This release addresses Swift 6 compilation errors and ensures the framework compiles cleanly with modern iOS APIs.

