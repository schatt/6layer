# AI Agent Guide for SixLayer Framework v6.4.0

This guide summarizes the version-specific context for v6.4.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.4.0** (see `Package.swift` comment or release tags).
2. **📚 Start with the Sample App**: See `Development/Examples/TaskManagerSampleApp/` for a complete, canonical example of how to structure a real app using SixLayer Framework correctly.
3. Understand that **Design System Bridge** enables mapping external design tokens to SixLayer components.
4. Know that **SixLayerTestKit** provides comprehensive testing utilities for consumers.
5. Know that **CloudKit service** is now available with delegate pattern for CloudKit operations.
6. Know that **Notification service** provides unified notification management across platforms.
7. Know that **Security & Privacy service** handles biometric authentication, encryption, and privacy permissions.
8. Know that **framework localization** is now fully supported with automatic string localization.
9. Know that **cross-platform font extensions** provide unified font API.
10. Know that **additional semantic colors** have been added to ColorName enum.
11. Know that **custom value views** are available for display fields.
12. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.4.0

### Design System Bridge (Issue #118)
- **Design System Bridge**: Framework-level abstraction for mapping external design tokens to SixLayer components
- **DesignSystem Protocol**: Standardized interface for design system implementations
- **DesignTokens Structures**: Structured token types for colors, typography, spacing, and component states
- **Theme Injection**: Environment-based theme injection with automatic component adaptation
- **Built-in Design Systems**: SixLayerDesignSystem (default), HighContrastDesignSystem, and CustomDesignSystem
- **External Token Mapping**: Support for Figma tokens, JSON design systems, and CSS custom properties

### Services Infrastructure (Issues #103, #106, #105) [Inherited from v6.3.0]
- **CloudKit Service**: Framework-level abstraction for CloudKit operations with delegate pattern, offline queue management, and comprehensive error handling
- **Notification Service**: Unified notification management with local and remote notification support, permission handling, and deep linking
- **Security & Privacy Service**: Biometric authentication, secure text entry management, privacy indicators, data encryption, and keychain integration

### Framework Localization (Issues #104, #108, #109, #115) [Inherited from v6.3.0]
- **Framework Localization Support**: Complete localization infrastructure with automatic string localization and key management
- **String Replacement**: Systematic replacement of hardcoded strings with localization keys
- **Localization Testing**: Comprehensive test suite for localization implementation
- **File Completeness**: All localization files contain all required strings

### SixLayerTestKit (Issue #119)
- **SixLayerTestKit**: Comprehensive testing utilities for framework consumers
- **Service Mocks**: Test doubles for CloudKitService, NotificationService, SecurityService, InternationalizationService, and other services
- **Form Testing Helpers**: Utilities for testing DynamicForm and form interactions
- **Navigation Testing Helpers**: Tools for testing navigation flows and Layer 1 functions
- **Layer Flow Driver**: Deterministic testing utilities for Layer 1→6 flows
- **Test Data Generators**: Utilities for generating realistic test data
- **End-to-End Examples**: Complete test examples showing SixLayerTestKit usage

### Platform Extensions (Issues #116, #114, #98) [Inherited from v6.3.0]
- **Cross-Platform Font Extensions**: Unified font API with platform-appropriate font selection
- **Semantic Colors**: Additional semantic color names added to ColorName enum
- **Custom Value Views**: Enhanced display field support with custom value views

## 🧠 Guidance for v6.4.0 Work

### 1. Design System Bridge Usage
- Use `DesignSystem` protocol to map external design tokens to SixLayer components
- Implement `colors(for:)`, `typography(for:)`, `spacing()`, and `componentStates()` methods
- Switch design systems with `VisualDesignSystem.shared.switchDesignSystem(_:)`
- Access design tokens via `@Environment(\.designTokens)` in views
- Use built-in `SixLayerDesignSystem`, `HighContrastDesignSystem`, or create custom implementations
- Map Figma tokens, JSON design systems, or CSS custom properties to SixLayer tokens
- Components automatically adapt to theme changes through environment injection

2. SixLayerTestKit Usage
- Import `SixLayerTestKit` in test targets for comprehensive testing utilities
- Use `testKit.serviceMocks` for mocking CloudKit, Notification, Security, and other services
- Use `testKit.formHelper` for creating and testing DynamicForm interactions
- Use `testKit.navigationHelper` for testing navigation flows and Layer 1 functions
- Use `testKit.layerFlowDriver` for deterministic Layer 1→6 flow testing
- Configure mocks before exercising code, verify both results and interactions
- Use `TestDataGenerator` for realistic test data generation

### 2. CloudKit Service Usage
- Implement `CloudKitServiceDelegate` to provide container identifier and configuration
- Use `CloudKitService` for all CloudKit operations (save, fetch, query, delete)
- Service automatically handles offline queue management
- Supports both private and public CloudKit databases
- Custom conflict resolution via delegate methods
- Record validation before saving via delegate methods

### 3. Notification Service Usage
- Use `NotificationService` for all notification operations
- Request permissions with `notificationService.requestPermission()`
- Schedule local notifications with `notificationService.scheduleLocalNotification(...)`
- Handle remote notifications through service callbacks
- Manage badge counts and notification categories
- Deep linking support from notifications

### 4. Security & Privacy Service Usage
- Use `SecurityService` for biometric authentication
- Check `securityService.isBiometricAvailable` before attempting authentication
- Authenticate with `securityService.authenticateWithBiometrics(reason:)`
- Enable secure text entry for password fields with `securityService.enableSecureTextEntry(for:)`
- Track privacy permissions with `securityService.privacyPermissions`
- Encrypt sensitive data with `securityService.encrypt(data:)`

### 5. Framework Localization Usage
- Framework strings are automatically localized
- Use `InternationalizationService.shared.localizedString(key:defaultValue:)` for framework strings
- All hardcoded strings have been replaced with localization keys
- Localization files are validated for completeness
- Missing keys are detected and reported

### 6. Cross-Platform Font Extensions Usage
- Use `.platformFont()` modifier for platform-appropriate font selection
- Font extensions automatically select appropriate fonts for each platform
- Custom font support with system font fallbacks
- Typography utilities for consistent font rendering

### 7. Semantic Colors Usage
- Additional semantic color names available in `ColorName` enum
- Use `Color.named(_:)` with new semantic color names
- Cross-platform color mapping ensures consistent appearance
- System color integration for better platform integration

### 8. Custom Value Views for Display Fields Usage
- Set `field.customValueView` to provide custom rendering for display fields
- Custom views allow flexible display field customization
- Enhanced display field capabilities with custom view support

### 9. Testing Expectations
- Follow TDD: Write tests before implementation
- Test all new services (CloudKit, Notification, Security)
- Test localization implementation and string replacement
- Test cross-platform font extensions
- Test semantic color additions
- Test custom value views in display fields
- Test accessibility compliance for all new features
- Test design system integration and token mapping
- Test theme switching and component adaptation
- Test design token consistency across components
- Test SixLayerTestKit service mocks and form helpers
- Test Layer 1→6 flow determinism with layer flow driver
- Test navigation flows and deep link handling

## ✅ Best Practices

1. **Use Design System Bridge**: Map external design tokens
   ```swift
   // ✅ Good - design system integration
   struct MyDesignSystem: DesignSystem {
       func colors(for theme: Theme) -> DesignTokens.Colors {
           // Map your brand tokens here
           return DesignTokens.Colors(
               primary: Color(hex: "#FF6B35"),
               // ... other mappings
           )
       }
       // ... implement other methods
   }

   VisualDesignSystem.shared.switchDesignSystem(MyDesignSystem())

   // ❌ Avoid - scattered styling
   // Hard to maintain and update
   ```

8. **Use SixLayerTestKit**: Test SixLayer integrations
   ```swift
   // ✅ Good - comprehensive testing with SixLayerTestKit
   import SixLayerTestKit

   class MyAppTests: XCTestCase {
       var testKit: SixLayerTestKit!

       override func setUp() {
           testKit = SixLayerTestKit()
       }

       func testFormSubmission() {
           // Mock services
           testKit.serviceMocks.cloudKitService.configureSuccessResponse()

           // Test form interactions
           let form = testKit.formHelper.createTestForm()
           let state = testKit.formHelper.createFormState(from: form)
           testKit.formHelper.simulateFieldInput(fieldId: "email", value: "test@example.com", in: state)

           // Verify interactions and results
           XCTAssertTrue(testKit.serviceMocks.cloudKitService.saveWasCalled)
       }
   }

   // ❌ Avoid - manual mock creation
   // Time-consuming and error-prone
   ```

3. **Use CloudKit service for all CloudKit operations**: Eliminates boilerplate
   ```swift
   // ✅ Good - use CloudKit service
   let cloudKitService = CloudKitService(delegate: myDelegate)
   try await cloudKitService.save(record)

   // ❌ Avoid - manual CloudKit boilerplate
   // More code, more error-prone
   ```

4. **Use Notification service for notifications**: Unified API
   ```swift
   // ✅ Good - use Notification service
   let notificationService = NotificationService()
   try await notificationService.requestPermission()
   try await notificationService.scheduleLocalNotification(...)

   // ❌ Avoid - platform-specific notification code
   // Inconsistent across platforms
   ```

4. **Use Security service for authentication**: Comprehensive security
   ```swift
   // ✅ Good - use Security service
   let securityService = SecurityService()
   if securityService.isBiometricAvailable {
       try await securityService.authenticateWithBiometrics(reason: "...")
   }

   // ❌ Avoid - manual security handling
   // More complex, less secure
   ```

5. **Use framework localization**: Automatic string localization
   ```swift
   // ✅ Good - use localization service
   let localized = InternationalizationService.shared.localizedString(
       key: "framework.error.message",
       defaultValue: "An error occurred"
   )

   // ❌ Avoid - hardcoded strings
   // Not localizable, not maintainable
   ```

6. **Use platform font extensions**: Consistent typography
   ```swift
   // ✅ Good - platform font extension
   Text("Hello")
       .platformFont()

   // ❌ Avoid - platform-specific font code
   // Inconsistent across platforms
   ```

7. **Use semantic colors**: Better color management
   ```swift
   // ✅ Good - semantic colors
   Color.named(.systemBackground)

   // ❌ Avoid - hardcoded colors
   // Not theme-aware, not maintainable
   ```

## 🔍 Common Patterns

### Design System Bridge
```swift
// 1. Create your design system
struct MyBrandDesignSystem: DesignSystem {
    let name = "My Brand"

    func colors(for theme: Theme) -> DesignTokens.Colors {
        return DesignTokens.Colors(
            primary: Color(hex: "#FF6B35"),    // Your brand primary
            secondary: Color(hex: "#F7931E"),  // Your brand secondary
            background: theme == .dark ? Color.black : Color.white,
            // ... map all your design tokens
        )
    }

    func typography(for theme: Theme) -> DesignTokens.Typography {
        return DesignTokens.Typography(
            largeTitle: Font.custom("YourFont-Bold", size: 34),
            // ... map your typography
        )
    }

    func spacing() -> DesignTokens.Spacing {
        return DesignTokens.Spacing(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48)
    }

    func componentStates() -> DesignTokens.ComponentStates {
        return DesignTokens.ComponentStates(
            cornerRadius: DesignTokens.ComponentCornerRadius(
                sm: 4, md: 8, lg: 12, xl: 16, full: 999
            ),
            // ... other component states
        )
    }
}

// 2. Apply it to your app
@main
struct MyApp: App {
    init() {
        VisualDesignSystem.shared.switchDesignSystem(MyBrandDesignSystem())
    }

    var body: some Scene {
        WindowGroup {
            ThemedFrameworkView {
                ContentView()
            }
        }
    }
}

// 3. Components use design tokens automatically
struct MyView: View {
    @Environment(\.designTokens) private var colors

    var body: some View {
        VStack {
            Text("Hello").foregroundColor(colors.text)
            TextField("Input", text: .constant(""))
                .themedTextField()
        }
        .themedCard()
    }
}
```

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

1. **Design System Bridge**: Framework-level abstraction that maps external design tokens to SixLayer components. Provides single place to manage themes and ensures all components respect the same design system.

2. **Theme injection**: Environment-based theme injection allows runtime theme switching. Components automatically adapt to theme changes without manual updates.

3. **Built-in design systems**: SixLayer provides default design systems (SixLayerDesignSystem, HighContrastDesignSystem) and supports custom implementations for external design tokens.

4. **CloudKit service**: Framework-level abstraction eliminates boilerplate while allowing app-specific configuration through delegate pattern. Automatically handles offline queue management.

5. **Notification service**: Unified notification management across platforms. Handles permissions, scheduling, and deep linking automatically.

6. **Security & Privacy service**: Comprehensive security features including biometric authentication, encryption, and privacy permission tracking. ObservableObject for SwiftUI integration.

7. **Framework localization**: Complete localization infrastructure with automatic string localization. All hardcoded strings have been replaced with localization keys.

8. **Cross-platform font extensions**: Unified font API ensures consistent typography across platforms with automatic platform-appropriate font selection.

9. **Semantic colors**: Additional semantic color names provide better color management and theme support.

10. **Custom value views**: Enhanced display field support allows flexible customization of display field rendering.

11. **Service patterns**: All new services follow the established framework service patterns (ObservableObject, Layer 1 functions, configuration-based).

12. **Localization completeness**: All localization files are validated for completeness. Missing keys are detected and reported.

13. **Testing**: Comprehensive test suites for all new services and features. All existing tests continue to pass.

## 📚 Related Documentation

- `Framework/docs/DesignSystemIntegrationGuide.md` - Complete design system integration guide
- `Framework/Examples/DesignSystemBridgeExample.swift` - Interactive design system examples
- `Framework/Examples/ExternalDesignTokensExample.swift` - External token mapping examples
- **`Development/Examples/TaskManagerSampleApp/`** - **Canonical sample app** demonstrating complete SixLayer Framework usage:
  - Layer 1→6 patterns with proper semantic intent functions
  - Service composition (CloudKitService, NotificationService, SecurityService)
  - DynamicFormView for data entry
  - CloudKit sync with proper error handling
  - Full localization (English, Spanish, French)
  - Comprehensive tests using SixLayerTestKit
  - **This is the reference implementation for new adopters**
- `Development/RELEASE_v6.3.0.md` - v6.3.0 release notes (inherited features)
- `Framework/docs/CloudKitServiceGuide.md` - CloudKit service guide
- `Framework/docs/NotificationGuide.md` - Notification service guide
- `Framework/docs/SecurityGuide.md` - Security & Privacy service guide
- `Framework/docs/LocalizationGuide.md` - Framework localization guide
- `Framework/Sources/Core/Services/CloudKitService.swift` - CloudKit service implementation
- `Framework/Sources/Core/Services/NotificationService.swift` - Notification service implementation
- `Framework/Sources/Core/Services/SecurityService.swift` - Security service implementation

## 🔗 Related Issues

- [Issue #118](https://github.com/schatt/6layer/issues/118) - Introduce Design System Bridge - ✅ COMPLETED
- [Issue #119](https://github.com/schatt/6layer/issues/119) - Create SixLayerTestKit target - ✅ COMPLETED
- [Issue #116](https://github.com/schatt/6layer/issues/116) - Add Cross-Platform Font Extensions - ✅ COMPLETED (v6.3.0)
- [Issue #115](https://github.com/schatt/6layer/issues/115) - Ensure all localization files contain all strings - ✅ COMPLETED (v6.3.0)
- [Issue #114](https://github.com/schatt/6layer/issues/114) - Add Missing Semantic Colors to ColorName Enum - ✅ COMPLETED (v6.3.0)
- [Issue #109](https://github.com/schatt/6layer/issues/109) - Test and Verify Localization Implementation - ✅ COMPLETED (v6.3.0)
- [Issue #108](https://github.com/schatt/6layer/issues/108) - Replace Hardcoded Strings with Localization Keys - ✅ COMPLETED (v6.3.0)
- [Issue #106](https://github.com/schatt/6layer/issues/106) - Add Notification Service - ✅ COMPLETED (v6.3.0)
- [Issue #105](https://github.com/schatt/6layer/issues/105) - Add Security & Privacy Service - ✅ COMPLETED (v6.3.0)
- [Issue #104](https://github.com/schatt/6layer/issues/104) - Add Framework Localization Support - ✅ COMPLETED (v6.3.0)
- [Issue #103](https://github.com/schatt/6layer/issues/103) - Add CloudKit Service with Delegate Pattern - ✅ COMPLETED (v6.3.0)
- [Issue #98](https://github.com/schatt/6layer/issues/98) - Enhancement: Custom Value Views for Display Fields - ✅ COMPLETED (v6.3.0)

---

**Version**: v6.4.0  
**Last Updated**: December 15, 2025