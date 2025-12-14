# Security & Privacy Guide

## Overview

SixLayerFramework provides comprehensive security and privacy features through the `SecurityService`, following the same service pattern as `InternationalizationService`. The service handles biometric authentication, secure text entry, data encryption, keychain integration, and privacy permission management.

## Architecture

The Security Service follows the established framework patterns:
- **Service Pattern**: Similar to `InternationalizationService`, `LocationService`, `OCRService`
- **ObservableObject**: Published properties for SwiftUI binding
- **Layer 1 Functions**: High-level semantic interfaces
- **Configuration-Based**: Uses `SecurityHints` for app-specific configuration
- **Platform-Aware**: Automatic platform detection and adaptation

## Basic Usage

### Creating the Service

```swift
import SixLayerFramework

// Create service with default settings
let security = SecurityService()

// Create service with custom configuration
let security = SecurityService(
    biometricPolicy: .required,
    encryptionKey: "my-app-encryption-key",
    enablePrivacyIndicators: true
)
```

### Biometric Authentication

```swift
// Check if biometrics are available
if security.isBiometricAvailable {
    do {
        let success = try await security.authenticateWithBiometrics(
            reason: "Authenticate to access secure content"
        )
        if success {
            // User authenticated successfully
            print("Authentication successful")
        }
    } catch let error as SecurityServiceError {
        switch error {
        case .biometricNotAvailable:
            print("Biometrics not available")
        case .biometricNotEnrolled:
            print("No biometric data enrolled")
        case .biometricLockout:
            print("Biometric authentication locked out")
        default:
            print("Authentication failed: \(error.localizedDescription)")
        }
    }
}
```

### Data Encryption

```swift
let security = SecurityService()

// Encrypt data
let sensitiveData = "My secret data".data(using: .utf8)!
do {
    let encrypted = try security.encrypt(sensitiveData)
    // Store encrypted data securely
} catch {
    print("Encryption failed: \(error)")
}

// Decrypt data
do {
    let decrypted = try security.decrypt(encrypted)
    let originalString = String(data: decrypted, encoding: .utf8)
} catch {
    print("Decryption failed: \(error)")
}
```

### String Encryption

```swift
let security = SecurityService()

// Encrypt a string (returns base64 encoded)
do {
    let encrypted = try security.encryptString("My secret password")
    // Store encrypted string
} catch {
    print("Encryption failed: \(error)")
}

// Decrypt a string
do {
    let decrypted = try security.decryptString(encrypted)
    print("Decrypted: \(decrypted)")
} catch {
    print("Decryption failed: \(error)")
}
```

### Keychain Integration

```swift
let security = SecurityService()

// Store data in keychain
do {
    let data = "Sensitive data".data(using: .utf8)!
    try security.storeInKeychain(
        data,
        key: "my-app.secret-key",
        accessibility: .whenUnlockedThisDeviceOnly
    )
} catch {
    print("Keychain store failed: \(error)")
}

// Retrieve data from keychain
do {
    if let data = try security.retrieveFromKeychain(key: "my-app.secret-key") {
        let string = String(data: data, encoding: .utf8)
        print("Retrieved: \(string ?? "")")
    }
} catch {
    print("Keychain retrieve failed: \(error)")
}

// Delete data from keychain
do {
    try security.deleteFromKeychain(key: "my-app.secret-key")
} catch {
    print("Keychain delete failed: \(error)")
}
```

### Privacy Permissions

```swift
let security = SecurityService()

// Check privacy permission status
let cameraStatus = security.checkPrivacyPermission(.camera)
switch cameraStatus {
case .authorized:
    print("Camera access authorized")
case .denied:
    print("Camera access denied")
case .notDetermined:
    print("Camera permission not determined")
case .restricted:
    print("Camera access restricted")
}

// Request privacy permission
let status = await security.requestPrivacyPermission(.camera)
if status == .authorized {
    // Permission granted
}

// Show privacy indicator when using camera
security.showPrivacyIndicator(.camera, isActive: true)
// ... use camera ...
security.showPrivacyIndicator(.camera, isActive: false)
```

### Secure Text Entry

```swift
let security = SecurityService()

// Enable secure text entry for a field
security.enableSecureTextEntry(for: "passwordField")

// Disable secure text entry
security.disableSecureTextEntry(for: "passwordField")
```

## SwiftUI Integration

### Using Layer 1 Functions

```swift
import SixLayerFramework
import SwiftUI

struct SecureContentView: View {
    @State private var password = ""
    
    var body: some View {
        VStack {
            // Present secure content with biometric authentication
            platformPresentSecureContent_L1(
                content: Text("Secure Content"),
                hints: SecurityHints(
                    biometricPolicy: .required,
                    enablePrivacyIndicators: true
                )
            )
            
            // Present secure text field
            platformPresentSecureTextField_L1(
                title: "Password",
                text: $password,
                hints: SecurityHints(enableSecureTextEntry: true)
            )
        }
    }
}
```

### Using SecurityService Directly

```swift
import SixLayerFramework
import SwiftUI

struct SecureView: View {
    @StateObject private var security = SecurityService()
    @State private var isAuthenticated = false
    
    var body: some View {
        VStack {
            if security.isBiometricAvailable {
                Button("Authenticate with \(security.biometricType.displayName)") {
                    Task {
                        do {
                            isAuthenticated = try await security.authenticateWithBiometrics(
                                reason: "Access secure content"
                            )
                        } catch {
                            print("Authentication failed: \(error)")
                        }
                    }
                }
            }
            
            if isAuthenticated {
                Text("Secure Content")
            }
        }
        .environmentObject(security)
    }
}
```

## Configuration with SecurityHints

```swift
// Default hints
let defaultHints = SecurityHints()

// Custom hints
let customHints = SecurityHints(
    biometricPolicy: .required,
    requireBiometricForSensitiveActions: true,
    enableSecureTextEntry: true,
    enableEncryption: true,
    enablePrivacyIndicators: true,
    encryptionKey: "my-custom-key"
)
```

## Error Handling

The service provides comprehensive error types:

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
}
```

All errors provide localized descriptions:

```swift
do {
    try await security.authenticateWithBiometrics(reason: "Test")
} catch let error as SecurityServiceError {
    print(error.errorDescription ?? "Unknown error")
}
```

## Platform-Specific Behavior

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
- Basic support (biometrics may not be available)
- Privacy permission checking
- Keychain integration

## Integration with DynamicFormField

The `SecurityService` can be integrated with `DynamicPasswordField` for enhanced security:

```swift
// DynamicPasswordField automatically uses SecureField
// You can enhance it with SecurityService for additional features:

struct SecurePasswordField: View {
    @StateObject private var security = SecurityService()
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    var body: some View {
        DynamicPasswordField(field: field, formState: formState)
            .environmentObject(security)
            .onAppear {
                security.enableSecureTextEntry(for: field.id)
            }
    }
}
```

## Best Practices

1. **Use Keychain for Sensitive Data**: Store encryption keys, tokens, and passwords in the keychain
2. **Request Permissions Appropriately**: Only request privacy permissions when needed
3. **Handle Errors Gracefully**: Always handle `SecurityServiceError` cases appropriately
4. **Use Biometric Policy Wisely**: Use `.required` only when absolutely necessary
5. **Enable Privacy Indicators**: Let users know when privacy-sensitive resources are in use
6. **Encrypt Sensitive Data**: Use encryption for data stored outside the keychain
7. **Test on Real Devices**: Biometric authentication requires real devices or simulators with biometrics configured

## Security Considerations

1. **Encryption Keys**: 
   - Use keychain for key storage when possible
   - Never hardcode encryption keys in source code
   - Use different keys for different data types

2. **Keychain Accessibility**:
   - Use `.whenUnlockedThisDeviceOnly` for maximum security
   - Use `.afterFirstUnlock` only if data is needed before first unlock
   - Consider `.whenPasscodeSetThisDeviceOnly` for sensitive data

3. **Biometric Authentication**:
   - Always provide a fallback authentication method
   - Don't rely solely on biometrics for critical operations
   - Handle lockout scenarios gracefully

4. **Privacy Permissions**:
   - Request permissions only when needed
   - Explain why permissions are needed
   - Handle denied permissions gracefully

## Testing

Comprehensive test coverage is available in `SecurityServiceTests.swift`:

- **Service Initialization**: Tests verify service creation and configuration
- **Biometric Detection**: Tests verify biometric type detection and availability
- **Encryption/Decryption**: Tests verify data and string encryption/decryption
- **Keychain Operations**: Tests verify keychain store/retrieve/delete operations
- **Privacy Permissions**: Tests verify permission checking and requesting
- **Error Handling**: Tests verify all error types provide descriptions

All 30+ tests cover the security service functionality.

## Related Documentation

- [SecurityService API Reference](../Sources/Core/Services/SecurityService.swift)
- [Layer 1 Security Functions](../Sources/Layers/Layer1-Semantic/PlatformSecurityL1.swift)
- [Security Types](../Sources/Core/Models/SecurityTypes.swift)
- [Security Hints](../Sources/Core/Models/SecurityHints.swift)
