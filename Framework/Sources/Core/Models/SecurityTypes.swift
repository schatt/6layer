//
//  SecurityTypes.swift
//  SixLayerFramework
//
//  Security & Privacy Service Types
//  Defines error types, biometric types, privacy permission types, and related enums
//

import Foundation

// MARK: - Security Service Error Types

/// Errors that can occur in the Security Service
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

// MARK: - Biometric Types

/// Types of biometric authentication available
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

/// Policy for biometric authentication
public enum BiometricPolicy {
    case required
    case optional
    case disabled
}

// MARK: - Privacy Permission Types

/// Types of privacy permissions
public enum PrivacyPermissionType: CaseIterable {
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

/// Status of a privacy permission
public enum PrivacyPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

// MARK: - Keychain Accessibility

/// Keychain accessibility levels
public enum KeychainAccessibility {
    case whenUnlocked
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlock
    case afterFirstUnlockThisDeviceOnly
    case whenPasscodeSetThisDeviceOnly
}

#if os(iOS) || os(macOS)
import Security

extension KeychainAccessibility {
    /// Convert to SecAccessibility value
    internal var secAccessibility: CFString {
        switch self {
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        }
    }
}
#endif
