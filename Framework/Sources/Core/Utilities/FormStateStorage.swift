//
//  FormStateStorage.swift
//  SixLayerFramework
//
//  Form state storage implementations
//  Implements Issue #80: Form auto-save and draft functionality
//

import Foundation

// MARK: - UserDefaults Form State Storage

/// UserDefaults-based implementation of FormStateStorage
/// Suitable for simple form drafts with reasonable size limits
public class UserDefaultsFormStateStorage: FormStateStorage {
    private let userDefaults: UserDefaults
    private let keyPrefix: String
    
    /// Initialize with custom UserDefaults instance and key prefix
    /// - Parameters:
    ///   - userDefaults: UserDefaults instance to use (defaults to .standard)
    ///   - keyPrefix: Prefix for storage keys (defaults to "form_draft_")
    public init(userDefaults: UserDefaults = .standard, keyPrefix: String = "form_draft_") {
        self.userDefaults = userDefaults
        self.keyPrefix = keyPrefix
    }
    
    private func storageKey(for formId: String) -> String {
        return "\(keyPrefix)\(formId)"
    }
    
    public func saveDraft(_ draft: FormDraft) throws {
        let key = storageKey(for: draft.formId)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(draft)
            userDefaults.set(data, forKey: key)
        } catch {
            throw FormStateStorageError.encodingFailed(error)
        }
    }
    
    public func loadDraft(formId: String) -> FormDraft? {
        let key = storageKey(for: formId)
        
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(FormDraft.self, from: data)
        } catch {
            // If decoding fails, clear the corrupted data
            userDefaults.removeObject(forKey: key)
            return nil
        }
    }
    
    public func clearDraft(formId: String) throws {
        let key = storageKey(for: formId)
        userDefaults.removeObject(forKey: key)
    }
    
    public func hasDraft(formId: String) -> Bool {
        let key = storageKey(for: formId)
        return userDefaults.data(forKey: key) != nil
    }
}

// MARK: - Form State Storage Errors

/// Errors that can occur during form state storage operations
public enum FormStateStorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case storageUnavailable
    case quotaExceeded
    
    public var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Failed to encode form draft: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode form draft: \(error.localizedDescription)"
        case .storageUnavailable:
            return "Storage is not available"
        case .quotaExceeded:
            return "Storage quota exceeded"
        }
    }
}
