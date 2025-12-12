# Add Security & Privacy Service

## Overview

Add a comprehensive Security & Privacy Service to the SixLayer Framework that provides biometric authentication, secure text entry management, privacy indicators, and data encryption following the same pattern as `InternationalizationService`.

## Motivation

Security and privacy features are essential for modern apps but require significant boilerplate code:
- Biometric authentication (Face ID, Touch ID, Touch Bar)
- Secure text entry management for password fields
- Privacy indicators (camera/microphone usage)
- Data encryption for sensitive form data
- Keychain integration
- Secure storage management

However, security also requires app-specific configuration:
- Biometric authentication policies (when to require, fallback options)
- Encryption keys and algorithms (app-specific)
- Privacy permission handling (app-specific use cases)
- Secure storage locations (app-specific)

**Solution**: Provide a framework service that handles the boilerplate, while apps provide app-specific logic through configuration and callbacks.

## Architecture Pattern

This follows existing framework patterns:
- **Service pattern**: Similar to `InternationalizationService`, `LocationService`, `OCRService`
- **ObservableObject**: Published properties for UI binding
- **Layer 1 semantic functions**: Similar to `platformPresentLocalizedContent_L1()` functions
- **Configuration-based**: Similar to `InternationalizationHints` pattern
- **Platform-aware**: Automatic platform detection and adaptation

## Proposed API Design

### Error Types

```swift
public enum SecurityServiceError: LocalizedError {
    case biometricNotAvailable
    case biometricNotEnrolled
    case biometricLockout
    case biometricNotSupported
    case authenticationFailed
    case encryptionFailed
    case decryptionFailed
    case keychainError(Error)
    case privacyPermissionDenied
    case privacyPermissionNotDetermined
    case invalidConfiguration
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .biometricNotAvailable:
            return "Biometric authentication is not available"
        case .biometricNotEnrolled:
            return "No biometric data is enrolled"
        case .biometricLockout:
            return "Biometric authentication is locked out"
        case .biometricNotSupported:
            return "Biometric authentication is not supported on this device"
        case .authenticationFailed:
            return "Authentication failed"
        case .encryptionFailed:
            return "Data encryption failed"
        case .decryptionFailed:
            return "Data decryption failed"
        case .keychainError(let error):
            return "Keychain error: \(error.localizedDescription)"
        case .privacyPermissionDenied:
            return "Privacy permission was denied"
        case .privacyPermissionNotDetermined:
            return "Privacy permission has not been determined"
        case .invalidConfiguration:
            return "Invalid security configuration"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
```

### Biometric Types

```swift
public enum BiometricType {
    case faceID
    case touchID
    case touchBar
    case none
    
    public var displayName: String {
        switch self {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .touchBar: return "Touch Bar"
        case .none: return "None"
        }
    }
}

public enum BiometricPolicy {
    case required
    case optional
    case disabled
}
```

### Privacy Permission Types

```swift
public enum PrivacyPermissionType {
    case camera
    case microphone
    case location
    case contacts
    case photos
    case calendar
    case reminders
    case motion
    case health
    case bluetooth
    case speechRecognition
    
    public var displayName: String {
        switch self {
        case .camera: return "Camera"
        case .microphone: return "Microphone"
        case .location: return "Location"
        case .contacts: return "Contacts"
        case .photos: return "Photos"
        case .calendar: return "Calendar"
        case .reminders: return "Reminders"
        case .motion: return "Motion"
        case .health: return "Health"
        case .bluetooth: return "Bluetooth"
        case .speechRecognition: return "Speech Recognition"
        }
    }
}

public enum PrivacyPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}
```

### Core Service

```swift
@MainActor
public class SecurityService: ObservableObject {
    // Published properties for UI binding
    @Published public var biometricType: BiometricType = .none
    @Published public var isBiometricAvailable: Bool = false
    @Published public var isAuthenticated: Bool = false
    @Published public var lastError: Error?
    @Published public var privacyPermissions: [PrivacyPermissionType: PrivacyPermissionStatus] = [:]
    
    // Configuration
    private let biometricPolicy: BiometricPolicy
    private let encryptionKey: String?
    private let enablePrivacyIndicators: Bool
    
    /// Initialize the security service
    /// - Parameters:
    ///   - biometricPolicy: Policy for biometric authentication
    ///   - encryptionKey: Optional encryption key (if nil, uses keychain)
    ///   - enablePrivacyIndicators: Whether to show privacy indicators
    public init(
        biometricPolicy: BiometricPolicy = .optional,
        encryptionKey: String? = nil,
        enablePrivacyIndicators: Bool = true
    ) {
        self.biometricPolicy = biometricPolicy
        self.encryptionKey = encryptionKey
        self.enablePrivacyIndicators = enablePrivacyIndicators
        
        // Initialize biometric detection
        self.biometricType = Self.detectBiometricType()
        self.isBiometricAvailable = Self.checkBiometricAvailability()
        
        // Initialize privacy permissions
        self.updatePrivacyPermissions()
    }
    
    // MARK: - Biometric Authentication
    
    /// Authenticate using biometrics
    /// - Parameter reason: Reason for authentication (shown to user)
    /// - Returns: True if authentication succeeded
    public func authenticateWithBiometrics(reason: String) async throws -> Bool {
        guard isBiometricAvailable else {
            throw SecurityServiceError.biometricNotAvailable
        }
        
        // Platform-specific implementation
        #if os(iOS)
        return try await authenticateWithFaceIDOrTouchID(reason: reason)
        #elseif os(macOS)
        return try await authenticateWithTouchIDOrTouchBar(reason: reason)
        #else
        throw SecurityServiceError.biometricNotSupported
        #endif
    }
    
    /// Check if biometric authentication is available
    public func checkBiometricAvailability() -> Bool {
        return isBiometricAvailable
    }
    
    // MARK: - Secure Text Entry
    
    /// Enable secure text entry for a field
    /// - Parameter fieldID: Identifier for the field
    public func enableSecureTextEntry(for fieldID: String) {
        // Store secure field configuration
        // Integrate with DynamicFormField
    }
    
    /// Disable secure text entry for a field
    /// - Parameter fieldID: Identifier for the field
    public func disableSecureTextEntry(for fieldID: String) {
        // Remove secure field configuration
    }
    
    // MARK: - Data Encryption
    
    /// Encrypt sensitive data
    /// - Parameter data: Data to encrypt
    /// - Returns: Encrypted data
    public func encrypt(_ data: Data) throws -> Data {
        // Implementation using keychain or provided key
    }
    
    /// Decrypt sensitive data
    /// - Parameter encryptedData: Encrypted data
    /// - Returns: Decrypted data
    public func decrypt(_ encryptedData: Data) throws -> Data {
        // Implementation using keychain or provided key
    }
    
    /// Encrypt a string
    /// - Parameter string: String to encrypt
    /// - Returns: Encrypted string (base64 encoded)
    public func encryptString(_ string: String) throws -> String {
        guard let data = string.data(using: .utf8) else {
            throw SecurityServiceError.encryptionFailed
        }
        let encrypted = try encrypt(data)
        return encrypted.base64EncodedString()
    }
    
    /// Decrypt a string
    /// - Parameter encryptedString: Encrypted string (base64 encoded)
    /// - Returns: Decrypted string
    public func decryptString(_ encryptedString: String) throws -> String {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw SecurityServiceError.decryptionFailed
        }
        let decrypted = try decrypt(data)
        guard let string = String(data: decrypted, encoding: .utf8) else {
            throw SecurityServiceError.decryptionFailed
        }
        return string
    }
    
    // MARK: - Privacy Permissions
    
    /// Request privacy permission
    /// - Parameter type: Type of permission to request
    /// - Returns: Permission status
    public func requestPrivacyPermission(_ type: PrivacyPermissionType) async -> PrivacyPermissionStatus {
        // Platform-specific implementation
        #if os(iOS)
        return await requestIOSPrivacyPermission(type)
        #elseif os(macOS)
        return await requestMacOSPrivacyPermission(type)
        #else
        return .notDetermined
        #endif
    }
    
    /// Check privacy permission status
    /// - Parameter type: Type of permission to check
    /// - Returns: Current permission status
    public func checkPrivacyPermission(_ type: PrivacyPermissionType) -> PrivacyPermissionStatus {
        return privacyPermissions[type] ?? .notDetermined
    }
    
    /// Show privacy indicator for active usage
    /// - Parameters:
    ///   - type: Type of privacy resource in use
    ///   - isActive: Whether the resource is currently active
    public func showPrivacyIndicator(_ type: PrivacyPermissionType, isActive: Bool) {
        guard enablePrivacyIndicators else { return }
        // Show platform-appropriate indicator
    }
    
    // MARK: - Keychain Integration
    
    /// Store data in keychain
    /// - Parameters:
    ///   - data: Data to store
    ///   - key: Key identifier
    ///   - accessibility: Keychain accessibility level
    public func storeInKeychain(_ data: Data, key: String, accessibility: KeychainAccessibility = .whenUnlocked) throws {
        // Keychain implementation
    }
    
    /// Retrieve data from keychain
    /// - Parameter key: Key identifier
    /// - Returns: Stored data, or nil if not found
    public func retrieveFromKeychain(key: String) throws -> Data? {
        // Keychain implementation
    }
    
    /// Delete data from keychain
    /// - Parameter key: Key identifier
    public func deleteFromKeychain(key: String) throws {
        // Keychain implementation
    }
    
    // MARK: - Private Helpers
    
    private static func detectBiometricType() -> BiometricType {
        #if os(iOS)
        if #available(iOS 11.0, *) {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    return .faceID
                case .touchID:
                    return .touchID
                case .none:
                    return .none
                @unknown default:
                    return .none
                }
            }
        }
        #elseif os(macOS)
        // Check for Touch ID or Touch Bar
        #endif
        return .none
    }
    
    private static func checkBiometricAvailability() -> Bool {
        let type = detectBiometricType()
        return type != .none
    }
    
    private func updatePrivacyPermissions() {
        // Check all privacy permission statuses
        for permissionType in PrivacyPermissionType.allCases {
            privacyPermissions[permissionType] = checkPrivacyPermission(permissionType)
        }
    }
}
```

### Security Hints

```swift
/// Hints for security and privacy configuration
public struct SecurityHints {
    public let biometricPolicy: BiometricPolicy
    public let requireBiometricForSensitiveActions: Bool
    public let enableSecureTextEntry: Bool
    public let enableEncryption: Bool
    public let enablePrivacyIndicators: Bool
    public let encryptionKey: String?
    
    public init(
        biometricPolicy: BiometricPolicy = .optional,
        requireBiometricForSensitiveActions: Bool = false,
        enableSecureTextEntry: Bool = true,
        enableEncryption: Bool = true,
        enablePrivacyIndicators: Bool = true,
        encryptionKey: String? = nil
    ) {
        self.biometricPolicy = biometricPolicy
        self.requireBiometricForSensitiveActions = requireBiometricForSensitiveActions
        self.enableSecureTextEntry = enableSecureTextEntry
        self.enableEncryption = enableEncryption
        self.enablePrivacyIndicators = enablePrivacyIndicators
        self.encryptionKey = encryptionKey
    }
}
```

## Layer 1 Semantic Functions

Following the pattern of `PlatformInternationalizationL1.swift`:

```swift
/// Present secure content with biometric authentication
@MainActor
public func platformPresentSecureContent_L1<Content: View>(
    content: Content,
    hints: SecurityHints = SecurityHints()
) -> AnyView {
    let security = SecurityService(
        biometricPolicy: hints.biometricPolicy,
        encryptionKey: hints.encryptionKey,
        enablePrivacyIndicators: hints.enablePrivacyIndicators
    )
    
    return AnyView(content
        .environmentObject(security)
        .automaticCompliance(named: "platformPresentSecureContent_L1"))
}

/// Present secure text field with automatic secure entry
@MainActor
public func platformPresentSecureTextField_L1(
    title: String,
    text: Binding<String>,
    hints: SecurityHints = SecurityHints()
) -> AnyView {
    let security = SecurityService(enableSecureTextEntry: hints.enableSecureTextEntry)
    security.enableSecureTextEntry(for: title)
    
    return AnyView(SecureField(title, text: text)
        .environmentObject(security)
        .automaticCompliance(named: "platformPresentSecureTextField_L1"))
}

/// Request biometric authentication
@MainActor
public func platformRequestBiometricAuth_L1(
    reason: String,
    hints: SecurityHints = SecurityHints()
) async throws -> Bool {
    let security = SecurityService(biometricPolicy: hints.biometricPolicy)
    return try await security.authenticateWithBiometrics(reason: reason)
}

/// Show privacy indicator
@MainActor
public func platformShowPrivacyIndicator_L1(
    type: PrivacyPermissionType,
    isActive: Bool,
    hints: SecurityHints = SecurityHints()
) -> some View {
    let security = SecurityService(enablePrivacyIndicators: hints.enablePrivacyIndicators)
    security.showPrivacyIndicator(type, isActive: isActive)
    
    return EmptyView() // Indicator is shown via system APIs
}
```

## Platform-Specific Considerations

### iOS
- Face ID / Touch ID authentication
- Privacy indicators in status bar
- Secure enclave integration
- App sandboxing support

### macOS
- Touch ID (on supported Macs)
- Touch Bar authentication
- Keychain Services integration
- File system encryption

### visionOS
- Spatial privacy zones
- Hand tracking privacy
- Immersive data protection

## Testing

- Framework tests should avoid actual biometric authentication (use mocks)
- Service should be mockable via protocol
- Platform-specific behavior should be testable
- Privacy permission status should be testable without actual permissions

## Implementation Checklist

### Phase 1: Core Service
- [ ] Create `SecurityService` class
- [ ] Define `SecurityServiceError` enum
- [ ] Implement biometric type detection
- [ ] Implement biometric availability checking
- [ ] Add basic biometric authentication (iOS)
- [ ] Add basic biometric authentication (macOS)
- [ ] Define `SecurityHints` struct

### Phase 2: Secure Text Entry & Encryption
- [ ] Implement secure text entry management
- [ ] Integrate with `DynamicFormField` for password fields
- [ ] Implement data encryption/decryption
- [ ] Implement string encryption/decryption
- [ ] Add keychain integration
- [ ] Add keychain storage/retrieval/deletion

### Phase 3: Privacy Permissions
- [ ] Implement privacy permission checking
- [ ] Implement privacy permission requesting (iOS)
- [ ] Implement privacy permission requesting (macOS)
- [ ] Add privacy indicator support
- [ ] Add privacy permission status monitoring

### Phase 4: Layer 1 Functions
- [ ] Create `PlatformSecurityL1.swift`
- [ ] Implement `platformPresentSecureContent_L1()`
- [ ] Implement `platformPresentSecureTextField_L1()`
- [ ] Implement `platformRequestBiometricAuth_L1()`
- [ ] Implement `platformShowPrivacyIndicator_L1()`
- [ ] Add RTL support for security UI

### Phase 5: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`SecurityGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation
- [ ] Add integration with `DynamicFormView` for secure fields

## Design Decisions

### Why Service Pattern?
- **Consistency**: Matches `InternationalizationService` pattern
- **ObservableObject**: Enables SwiftUI binding
- **Testability**: Easy to mock for testing
- **Separation of Concerns**: Framework handles boilerplate, app handles configuration

### Why Configuration-Based?
- **Flexibility**: Apps can configure security policies
- **Privacy**: Apps control when to use encryption
- **Platform Adaptation**: Automatic platform detection

### Why Layer 1 Functions?
- **Semantic Intent**: High-level security interfaces
- **Framework Focus**: UI abstraction is core to framework
- **Consistency**: Matches existing Layer 1 patterns

## Related

- `InternationalizationService.swift` - Reference implementation pattern
- `LocationService.swift` - Similar service pattern
- `OCRService.swift` - Similar service pattern
- `PlatformInternationalizationL1.swift` - Layer 1 function pattern
- `DynamicFormField` - Integration point for secure text entry

## Acceptance Criteria

- [ ] `SecurityService` class exists with full API
- [ ] Biometric authentication works on iOS and macOS
- [ ] Secure text entry integrates with `DynamicFormField`
- [ ] Data encryption/decryption works correctly
- [ ] Keychain integration is functional
- [ ] Privacy permissions can be checked and requested
- [ ] Privacy indicators are shown when appropriate
- [ ] Layer 1 semantic functions are implemented
- [ ] Comprehensive tests pass (30+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported
