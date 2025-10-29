//
//  FieldHintsRegistry.swift
//  SixLayerFramework
//
//  Registry for field-level display hints with file-based storage
//

import Foundation

// MARK: - Field Hints Storage Protocol

/// Protocol for storing and loading field hints from external sources
public protocol FieldHintsStore: Sendable {
    /// Load hints for a specific form or entity
    func loadHints(formId: String) -> [String: FieldDisplayHints]
    
    /// Save hints for a specific form or entity
    func saveHints(_ hints: [String: FieldDisplayHints], formId: String) throws
    
    /// Check if hints exist for a form
    func hasHints(for formId: String) -> Bool
}

// MARK: - JSON-Based Field Hints Store

/// JSON file-based implementation of FieldHintsStore
public class JSONFieldHintsStore: FieldHintsStore, @unchecked Sendable {
    private let baseURL: URL?
    private let fileManager: FileManager
    
    public init(baseURL: URL? = nil, fileManager: FileManager = .default) {
        self.baseURL = baseURL
        self.fileManager = fileManager
    }
    
    /// Load hints from a JSON file named "{formId}_hints.json"
    public func loadHints(formId: String) -> [String: FieldDisplayHints] {
        guard let url = getHintsURL(for: formId) else {
            return [:]
        }
        
        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] else {
            return [:]
        }
        
        var hints: [String: FieldDisplayHints] = [:]
        for (fieldId, fieldData) in json {
            hints[fieldId] = parseFieldHints(from: fieldData)
        }
        
        return hints
    }
    
    /// Save hints to a JSON file named "{formId}_hints.json"
    public func saveHints(_ hints: [String: FieldDisplayHints], formId: String) throws {
        guard let url = getHintsURL(for: formId) else {
            throw FieldHintsError.invalidURL
        }
        
        var json: [String: [String: Any]] = [:]
        for (fieldId, hint) in hints {
            json[fieldId] = serializeFieldHints(hint)
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try data.write(to: url)
    }
    
    /// Check if hints exist for a form
    public func hasHints(for formId: String) -> Bool {
        guard let url = getHintsURL(for: formId) else {
            return false
        }
        return fileManager.fileExists(atPath: url.path)
    }
    
    // MARK: - Private Helpers
    
    private func getHintsURL(for formId: String) -> URL? {
        if let baseURL = baseURL {
            return baseURL.appendingPathComponent("\(formId)_hints.json")
        }
        
        // Default to Bundle resources or documents directory
        if let bundleURL = Bundle.main.resourceURL {
            return bundleURL.appendingPathComponent("\(formId)_hints.json")
        }
        
        return nil
    }
    
    private func parseFieldHints(from data: [String: Any]) -> FieldDisplayHints {
        let expectedLength = data["expectedLength"] as? Int
        let displayWidth = data["displayWidth"] as? String
        let showCharacterCounter = data["showCharacterCounter"] as? Bool ?? false
        let maxLength = data["maxLength"] as? Int
        let minLength = data["minLength"] as? Int
        let metadata = data["metadata"] as? [String: String] ?? [:]
        
        return FieldDisplayHints(
            expectedLength: expectedLength,
            displayWidth: displayWidth,
            showCharacterCounter: showCharacterCounter,
            maxLength: maxLength,
            minLength: minLength,
            metadata: metadata
        )
    }
    
    private func serializeFieldHints(_ hint: FieldDisplayHints) -> [String: Any] {
        var result: [String: Any] = [:]
        
        if let expectedLength = hint.expectedLength {
            result["expectedLength"] = expectedLength
        }
        if let displayWidth = hint.displayWidth {
            result["displayWidth"] = displayWidth
        }
        if hint.showCharacterCounter {
            result["showCharacterCounter"] = true
        }
        if let maxLength = hint.maxLength {
            result["maxLength"] = maxLength
        }
        if let minLength = hint.minLength {
            result["minLength"] = minLength
        }
        if !hint.metadata.isEmpty {
            result["metadata"] = hint.metadata
        }
        
        return result
    }
}

// MARK: - Errors

public enum FieldHintsError: Error {
    case invalidURL
    case saveFailed
    case loadFailed
}

// MARK: - Field Hints Registry

/// Registry for managing field hints with support for multiple storage backends
public actor FieldHintsRegistry {
    private var hintsCache: [String: [String: FieldDisplayHints]] = [:]
    private let store: FieldHintsStore
    
    public init(store: FieldHintsStore = JSONFieldHintsStore()) {
        self.store = store
    }
    
    /// Load hints for a form, checking cache first
    public func loadHints(for formId: String) -> [String: FieldDisplayHints] {
        // Check cache first
        if let cached = hintsCache[formId] {
            return cached
        }
        
        // Load from store
        let hints = store.loadHints(formId: formId)
        
        // Cache for future use
        if !hints.isEmpty {
            hintsCache[formId] = hints
        }
        
        return hints
    }
    
    /// Save hints for a form and update cache
    public func saveHints(_ hints: [String: FieldDisplayHints], for formId: String) throws {
        try store.saveHints(hints, formId: formId)
        hintsCache[formId] = hints
    }
    
    /// Check if hints exist for a form
    public func hasHints(for formId: String) -> Bool {
        // Check cache first
        if hintsCache[formId] != nil {
            return true
        }
        
        // Check store
        return store.hasHints(for: formId)
    }
    
    /// Clear the cache for a specific form
    public func clearCache(for formId: String) {
        hintsCache.removeValue(forKey: formId)
    }
    
    /// Clear all cached hints
    public func clearAllCache() {
        hintsCache.removeAll()
    }
    
    /// Register hints directly in the cache (for runtime configuration)
    public func registerHints(_ hints: [String: FieldDisplayHints], for formId: String) {
        hintsCache[formId] = hints
    }
}

// MARK: - Convenience Extensions

public extension PresentationHints {
    /// Create hints with field hints loaded from registry
    init(
        dataType: DataTypeHint = .generic,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:],
        formId: String,
        registry: FieldHintsRegistry
    ) async {
        let fieldHints = await registry.loadHints(for: formId)
        
        self.init(
            dataType: dataType,
            presentationPreference: presentationPreference,
            complexity: complexity,
            context: context,
            customPreferences: customPreferences,
            fieldHints: fieldHints
        )
    }
}

public extension EnhancedPresentationHints {
    /// Create enhanced hints with field hints loaded from registry
    init(
        dataType: DataTypeHint,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:],
        extensibleHints: [ExtensibleHint] = [],
        formId: String,
        registry: FieldHintsRegistry
    ) async {
        let fieldHints = await registry.loadHints(for: formId)
        
        self.init(
            dataType: dataType,
            presentationPreference: presentationPreference,
            complexity: complexity,
            context: context,
            customPreferences: customPreferences,
            extensibleHints: extensibleHints,
            fieldHints: fieldHints
        )
    }
}

