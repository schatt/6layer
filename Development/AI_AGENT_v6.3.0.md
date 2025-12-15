# AI Agent Guide for SixLayer Framework v6.3.0

This guide summarizes the version-specific context for v6.3.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.3.0** (see `Package.swift` comment or release tags).
2. Understand that **CloudKit service** is now available with delegate pattern for CloudKit operations.
3. Know that **Notification service** provides unified notification management across platforms.
4. Know that **Security & Privacy service** handles biometric authentication, encryption, and privacy permissions.
5. Know that **framework localization** is now fully supported with automatic string localization.
6. Know that **cross-platform font extensions** provide unified font API.
7. Know that **additional semantic colors** have been added to ColorName enum.
8. Know that **custom value views** are available for display fields.
9. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.3.0

### Services Infrastructure (Issues #103, #106, #105)
- **CloudKit Service**: Framework-level abstraction for CloudKit operations with delegate pattern, offline queue management, and comprehensive error handling
- **Notification Service**: Unified notification management with local and remote notification support, permission handling, and deep linking
- **Security & Privacy Service**: Biometric authentication, secure text entry management, privacy indicators, data encryption, and keychain integration

### Framework Localization (Issues #104, #108, #109, #115)
- **Framework Localization Support**: Complete localization infrastructure with automatic string localization and key management
- **String Replacement**: Systematic replacement of hardcoded strings with localization keys
- **Localization Testing**: Comprehensive test suite for localization implementation
- **File Completeness**: All localization files contain all required strings

### Platform Extensions (Issues #116, #114, #98)
- **Cross-Platform Font Extensions**: Unified font API with platform-appropriate font selection
- **Semantic Colors**: Additional semantic color names added to ColorName enum
- **Custom Value Views**: Enhanced display field support with custom value views

## 🧠 Guidance for v6.3.0 Work

### 1. CloudKit Service Usage
- Implement `CloudKitServiceDelegate` to provide container identifier and configuration
- Use `CloudKitService` for all CloudKit operations (save, fetch, query, delete)
- Service automatically handles offline queue management
- Supports both private and public CloudKit databases
- Custom conflict resolution via delegate methods
- Record validation before saving via delegate methods

### 2. Notification Service Usage
- Use `NotificationService` for all notification operations
- Request permissions with `notificationService.requestPermission()`
- Schedule local notifications with `notificationService.scheduleLocalNotification(...)`
- Handle remote notifications through service callbacks
- Manage badge counts and notification categories
- Deep linking support from notifications

### 3. Security & Privacy Service Usage
- Use `SecurityService` for biometric authentication
- Check `securityService.isBiometricAvailable` before attempting authentication
- Authenticate with `securityService.authenticateWithBiometrics(reason:)`
- Enable secure text entry for password fields with `securityService.enableSecureTextEntry(for:)`
- Track privacy permissions with `securityService.privacyPermissions`
- Encrypt sensitive data with `securityService.encrypt(data:)`

### 4. Framework Localization Usage
- Framework strings are automatically localized
- Use `InternationalizationService.shared.localizedString(key:defaultValue:)` for framework strings
- All hardcoded strings have been replaced with localization keys
- Localization files are validated for completeness
- Missing keys are detected and reported

### 5. Cross-Platform Font Extensions Usage
- Use `.platformFont()` modifier for platform-appropriate font selection
- Font extensions automatically select appropriate fonts for each platform
- Custom font support with system font fallbacks
- Typography utilities for consistent font rendering

### 6. Semantic Colors Usage
- Additional semantic color names available in `ColorName` enum
- Use `Color.named(_:)` with new semantic color names
- Cross-platform color mapping ensures consistent appearance
- System color integration for better platform integration

### 7. Custom Value Views for Display Fields Usage
- Set `field.customValueView` to provide custom rendering for display fields
- Custom views allow flexible display field customization
- Enhanced display field capabilities with custom view support

### 8. Testing Expectations
- Follow TDD: Write tests before implementation
- Test all new services (CloudKit, Notification, Security)
- Test localization implementation and string replacement
- Test cross-platform font extensions
- Test semantic color additions
- Test custom value views in display fields
- Test accessibility compliance for all new features

## ✅ Best Practices

1. **Use CloudKit service for all CloudKit operations**: Eliminates boilerplate
   ```swift
   // ✅ Good - use CloudKit service
   let cloudKitService = CloudKitService(delegate: myDelegate)
   try await cloudKitService.save(record)
   
   // ❌ Avoid - manual CloudKit boilerplate
   // More code, more error-prone
   ```

2. **Use Notification service for notifications**: Unified API
   ```swift
   // ✅ Good - use Notification service
   let notificationService = NotificationService()
   try await notificationService.requestPermission()
   try await notificationService.scheduleLocalNotification(...)
   
   // ❌ Avoid - platform-specific notification code
   // Inconsistent across platforms
   ```

3. **Use Security service for authentication**: Comprehensive security
   ```swift
   // ✅ Good - use Security service
   let securityService = SecurityService()
   if securityService.isBiometricAvailable {
       try await securityService.authenticateWithBiometrics(reason: "...")
   }
   
   // ❌ Avoid - manual security handling
   // More complex, less secure
   ```

4. **Use framework localization**: Automatic string localization
   ```swift
   // ✅ Good - use localization service
   let localized = InternationalizationService.shared.localizedString(
       key: "framework.error.message",
       defaultValue: "An error occurred"
   )
   
   // ❌ Avoid - hardcoded strings
   // Not localizable, not maintainable
   ```

5. **Use platform font extensions**: Consistent typography
   ```swift
   // ✅ Good - platform font extension
   Text("Hello")
       .platformFont()
   
   // ❌ Avoid - platform-specific font code
   // Inconsistent across platforms
   ```

6. **Use semantic colors**: Better color management
   ```swift
   // ✅ Good - semantic colors
   Color.named(.systemBackground)
   
   // ❌ Avoid - hardcoded colors
   // Not theme-aware, not maintainable
   ```

## 🔍 Common Patterns

### CloudKit Service
```swift
class MyCloudKitDelegate: CloudKitServiceDelegate {
    func containerIdentifier() -> String {
        return "iCloud.com.yourapp.container"
    }
    
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Custom conflict resolution
        return remote // Default: server wins
    }
    
    func validateRecord(_ record: CKRecord) throws {
        // Validate record before saving
        if record["requiredField"] == nil {
            throw CloudKitServiceError.missingRequiredField("requiredField")
        }
    }
}

let cloudKitService = CloudKitService(delegate: MyCloudKitDelegate())
try await cloudKitService.save(record)
```

### Notification Service
```swift
let notificationService = NotificationService()

// Request permission
try await notificationService.requestPermission()

// Schedule local notification
try await notificationService.scheduleLocalNotification(
    identifier: "reminder",
    title: "Reminder",
    body: "Don't forget!",
    date: Date().addingTimeInterval(3600)
)

// Handle notifications
notificationService.onNotificationReceived = { notification in
    // Handle notification
}
```

### Security Service
```swift
let securityService = SecurityService()

// Check biometric availability
if securityService.isBiometricAvailable {
    do {
        let success = try await securityService.authenticateWithBiometrics(
            reason: "Authenticate to access secure content"
        )
        if success {
            // User authenticated
        }
    } catch {
        // Handle error
    }
}

// Enable secure text entry
securityService.enableSecureTextEntry(for: "passwordField")

// Encrypt data
let encrypted = try securityService.encrypt(data: sensitiveData)
```

### Framework Localization
```swift
// Framework strings are automatically localized
let localized = InternationalizationService.shared.localizedString(
    key: "framework.error.message",
    defaultValue: "An error occurred"
)

Text(localized)
```

### Cross-Platform Font Extensions
```swift
Text("Hello")
    .font(.system(size: 16, weight: .medium))
    .platformFont()
```

### Custom Value Views for Display Fields
```swift
let displayField = DynamicFormField(
    id: "customDisplay",
    label: "Custom Display",
    contentType: .display
)

displayField.customValueView = AnyView(
    MyCustomView(data: displayField.value)
)
```

## ⚠️ Important Notes

1. **CloudKit service**: Framework-level abstraction eliminates boilerplate while allowing app-specific configuration through delegate pattern. Automatically handles offline queue management.

2. **Notification service**: Unified notification management across platforms. Handles permissions, scheduling, and deep linking automatically.

3. **Security & Privacy service**: Comprehensive security features including biometric authentication, encryption, and privacy permission tracking. ObservableObject for SwiftUI integration.

4. **Framework localization**: Complete localization infrastructure with automatic string localization. All hardcoded strings have been replaced with localization keys.

5. **Cross-platform font extensions**: Unified font API ensures consistent typography across platforms with automatic platform-appropriate font selection.

6. **Semantic colors**: Additional semantic color names provide better color management and theme support.

7. **Custom value views**: Enhanced display field support allows flexible customization of display field rendering.

8. **Service patterns**: All new services follow the established framework service patterns (ObservableObject, Layer 1 functions, configuration-based).

9. **Localization completeness**: All localization files are validated for completeness. Missing keys are detected and reported.

10. **Testing**: Comprehensive test suites for all new services and features. All existing tests continue to pass.

## 📚 Related Documentation

- `Development/RELEASE_v6.3.0.md` - Complete release notes
- `Framework/docs/CloudKitServiceGuide.md` - CloudKit service guide
- `Framework/docs/NotificationGuide.md` - Notification service guide
- `Framework/docs/SecurityGuide.md` - Security & Privacy service guide
- `Framework/docs/LocalizationGuide.md` - Framework localization guide
- `Framework/Sources/Core/Services/CloudKitService.swift` - CloudKit service implementation
- `Framework/Sources/Core/Services/NotificationService.swift` - Notification service implementation
- `Framework/Sources/Core/Services/SecurityService.swift` - Security service implementation

## 🔗 Related Issues

- [Issue #116](https://github.com/schatt/6layer/issues/116) - Add Cross-Platform Font Extensions - ✅ COMPLETED
- [Issue #115](https://github.com/schatt/6layer/issues/115) - Ensure all localization files contain all strings - ✅ COMPLETED
- [Issue #114](https://github.com/schatt/6layer/issues/114) - Add Missing Semantic Colors to ColorName Enum - ✅ COMPLETED
- [Issue #109](https://github.com/schatt/6layer/issues/109) - Test and Verify Localization Implementation - ✅ COMPLETED
- [Issue #108](https://github.com/schatt/6layer/issues/108) - Replace Hardcoded Strings with Localization Keys - ✅ COMPLETED
- [Issue #106](https://github.com/schatt/6layer/issues/106) - Add Notification Service - ✅ COMPLETED
- [Issue #105](https://github.com/schatt/6layer/issues/105) - Add Security & Privacy Service - ✅ COMPLETED
- [Issue #104](https://github.com/schatt/6layer/issues/104) - Add Framework Localization Support - ✅ COMPLETED
- [Issue #103](https://github.com/schatt/6layer/issues/103) - Add CloudKit Service with Delegate Pattern - ✅ COMPLETED
- [Issue #98](https://github.com/schatt/6layer/issues/98) - Enhancement: Custom Value Views for Display Fields - ✅ COMPLETED

---

**Version**: v6.3.0  
**Last Updated**: December 14, 2025
