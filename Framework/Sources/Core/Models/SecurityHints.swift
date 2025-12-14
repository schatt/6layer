//
//  SecurityHints.swift
//  SixLayerFramework
//
//  Hints for security and privacy configuration
//

import Foundation

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
