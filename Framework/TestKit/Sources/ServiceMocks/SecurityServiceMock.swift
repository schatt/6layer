//
//  SecurityServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of SecurityService for testing
//

import Foundation
import LocalAuthentication
import SixLayerFramework

/// Mock implementation of SecurityService for testing
/// Note: This is a standalone test utility
public class SecurityServiceMock {

    // MARK: - Configuration

    public enum MockMode {
        case success
        case failure(error: Error)
        case custom(handler: (SecurityOperation) async throws -> Any)
    }

    private var mode: MockMode = .success

    // MARK: - Mock State Tracking

    public private(set) var authenticateWithBiometricsWasCalled = false
    public private(set) var authenticationReason: String?
    public private(set) var authenticationSuccess = true

    public private(set) var isBiometricAvailableValue = true
    public private(set) var biometricTypeValue: LABiometryType = .touchID

    public private(set) var enableSecureTextEntryWasCalled = false
    public private(set) var secureTextEntryFields: [String] = []

    public private(set) var encryptWasCalled = false
    public private(set) var encryptData: Data?
    public private(set) var encryptedResult: Data = Data([1, 2, 3])

    public private(set) var decryptWasCalled = false
    public private(set) var decryptData: Data?
    public private(set) var decryptedResult: Data = Data([4, 5, 6])

    // MARK: - Configuration Methods

    /// Configure mock to return success for all operations
    public func configureSuccessResponse() {
        mode = .success
        authenticationSuccess = true
    }

    /// Configure mock to return failure for all operations
    public func configureFailureResponse(error: Error = NSError(domain: "SecurityError", code: 1, userInfo: nil)) {
        mode = .failure(error: error)
        authenticationSuccess = false
    }

    /// Configure custom response handler
    public func configureCustomResponse(handler: @escaping (SecurityOperation) async throws -> Any) {
        mode = .custom(handler: handler)
    }

    /// Configure biometric availability
    public func configureBiometricAvailability(available: Bool, type: LABiometryType = .touchID) {
        isBiometricAvailableValue = available
        biometricTypeValue = type
    }

    /// Configure authentication result
    public func configureAuthenticationResult(success: Bool) {
        authenticationSuccess = success
    }

    /// Configure encryption/decryption results
    public func configureEncryptionResult(encrypted: Data, decrypted: Data) {
        encryptedResult = encrypted
        decryptedResult = decrypted
    }

    /// Reset all tracking state
    public func reset() {
        authenticateWithBiometricsWasCalled = false
        authenticationReason = nil
        authenticationSuccess = true
        enableSecureTextEntryWasCalled = false
        secureTextEntryFields = []
        encryptWasCalled = false
        encryptData = nil
        decryptWasCalled = false
        decryptData = nil
        mode = .success
    }

    // MARK: - SecurityServiceDelegate Implementation

    public var isBiometricAvailable: Bool {
        return isBiometricAvailableValue
    }

    public var biometricType: LABiometryType {
        return biometricTypeValue
    }

    public func authenticateWithBiometrics(reason: String) async throws -> Bool {
        authenticateWithBiometricsWasCalled = true
        authenticationReason = reason

        switch mode {
        case .success:
            return authenticationSuccess
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.authenticate(reason: reason))
            guard let success = result as? Bool else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return success
        }
    }

    public func enableSecureTextEntry(for fieldIdentifier: String) {
        enableSecureTextEntryWasCalled = true
        secureTextEntryFields.append(fieldIdentifier)
    }

    public func encrypt(data: Data) async throws -> Data {
        encryptWasCalled = true
        encryptData = data

        switch mode {
        case .success:
            return encryptedResult
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.encrypt(data: data))
            guard let encrypted = result as? Data else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return encrypted
        }
    }

    public func decrypt(data: Data) async throws -> Data {
        decryptWasCalled = true
        decryptData = data

        switch mode {
        case .success:
            return decryptedResult
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.decrypt(data: data))
            guard let decrypted = result as? Data else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return decrypted
        }
    }

    // MARK: - Mock Security Simulation

    /// Simulate biometric authentication success
    public func simulateBiometricSuccess() {
        authenticationSuccess = true
    }

    /// Simulate biometric authentication failure
    public func simulateBiometricFailure() {
        authenticationSuccess = false
    }

    /// Get all fields with secure text entry enabled
    public var secureTextEntryEnabledFields: [String] {
        return secureTextEntryFields
    }

    /// Check if secure text entry was enabled for a specific field
    public func isSecureTextEntryEnabled(for fieldIdentifier: String) -> Bool {
        return secureTextEntryFields.contains(fieldIdentifier)
    }
}

// MARK: - Security Operation Types (for testing)

/// Simplified security operation types for testing
public enum SecurityOperation {
    case authenticate(reason: String)
    case encrypt(data: Data)
    case decrypt(data: Data)
    case enableSecureTextEntry(field: String)
}