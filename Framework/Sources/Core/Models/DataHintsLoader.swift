//
//  DataHintsLoader.swift
//  SixLayerFramework
//
//  Loads .hints files that describe how to present data models
//

import Foundation

// MARK: - Data Hints Protocol

/// Protocol for loading hints that describe how to present data models
public protocol DataHintsLoader: Sendable {
    /// Load hints for a data model by its name
    func loadHints(for modelName: String) -> [String: FieldDisplayHints]
}

// MARK: - File-Based Data Hints Loader

/// Loads .hints files from the bundle or filesystem
public class FileBasedDataHintsLoader: DataHintsLoader, @unchecked Sendable {
    private let fileManager: FileManager
    private let bundle: Bundle
    
    public init(fileManager: FileManager = .default, bundle: Bundle = .main) {
        self.fileManager = fileManager
        self.bundle = bundle
    }
    
    /// Load a .hints file for a data model
    /// Example: loadHints(for: "User") looks for "User.hints" file in the Hints/ folder
    public func loadHints(for modelName: String) -> [String: FieldDisplayHints] {
        // Try to load from bundle first (in Hints/ subfolder)
        if let hintsFolder = bundle.url(forResource: "Hints", withExtension: nil) {
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if let data = try? Data(contentsOf: url),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] {
                return parseHints(from: json)
            }
        }
        
        // Also try root level for backward compatibility
        if let url = bundle.url(forResource: modelName, withExtension: "hints"),
           let data = try? Data(contentsOf: url),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] {
            return parseHints(from: json)
        }
        
        // Fall back to documents directory (in Hints/ subfolder)
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let hintsFolder = documentsURL.appendingPathComponent("Hints")
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if fileManager.fileExists(atPath: hintsFolder.path),
               let data = try? Data(contentsOf: url),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] {
                return parseHints(from: json)
            }
        }
        
        return [:]
    }
    
    /// Check if a hints file exists for a model
    public func hasHints(for modelName: String) -> Bool {
        // Check in Hints/ subfolder first
        if let hintsFolder = bundle.url(forResource: "Hints", withExtension: nil) {
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if fileManager.fileExists(atPath: url.path) {
                return true
            }
        }
        
        // Also check root level for backward compatibility
        if let _ = bundle.url(forResource: modelName, withExtension: "hints") {
            return true
        }
        
        // Check documents directory
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let hintsFolder = documentsURL.appendingPathComponent("Hints")
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if fileManager.fileExists(atPath: url.path) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Private Helpers
    
    private func parseHints(from json: [String: [String: String]]) -> [String: FieldDisplayHints] {
        var hints: [String: FieldDisplayHints] = [:]
        
        for (fieldName, properties) in json {
            hints[fieldName] = FieldDisplayHints(
                expectedLength: properties["expectedLength"].flatMap(Int.init),
                displayWidth: properties["displayWidth"],
                showCharacterCounter: properties["showCharacterCounter"] == "true",
                maxLength: properties["maxLength"].flatMap(Int.init),
                minLength: properties["minLength"].flatMap(Int.init),
                metadata: properties
            )
        }
        
        return hints
    }
}

// MARK: - Data Hints Registry

/// Global registry for loading data hints
public actor DataHintsRegistry {
    private var cache: [String: [String: FieldDisplayHints]] = [:]
    private let loader: DataHintsLoader
    
    public init(loader: DataHintsLoader = FileBasedDataHintsLoader()) {
        self.loader = loader
    }
    
    /// Load hints for a data model, checking cache first
    public func loadHints(for modelName: String) -> [String: FieldDisplayHints] {
        // Check cache first
        if let cached = cache[modelName] {
            return cached
        }
        
        // Load from file
        let hints = loader.loadHints(for: modelName)
        
        // Cache for future use
        if !hints.isEmpty {
            cache[modelName] = hints
        }
        
        return hints
    }
    
    /// Check if hints exist for a model
    public func hasHints(for modelName: String) -> Bool {
        if cache[modelName] != nil {
            return true
        }
        
        if let fileLoader = loader as? FileBasedDataHintsLoader {
            return fileLoader.hasHints(for: modelName)
        }
        
        return false
    }
    
    /// Clear cache for a specific model
    public func clearCache(for modelName: String) {
        cache.removeValue(forKey: modelName)
    }
    
    /// Clear all cached hints
    public func clearAllCache() {
        cache.removeAll()
    }
}

// MARK: - Convenience Global Registry

/// Global registry instance for data hints
public let globalDataHintsRegistry = DataHintsRegistry()

// MARK: - Extensions

public extension PresentationHints {
    /// Create hints with field hints loaded from a data model's .hints file
    init(
        dataType: DataTypeHint = .generic,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:],
        modelName: String,
        registry: DataHintsRegistry = globalDataHintsRegistry
    ) async {
        let fieldHints = await registry.loadHints(for: modelName)
        
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
    /// Create enhanced hints with field hints loaded from a data model's .hints file
    init(
        dataType: DataTypeHint,
        presentationPreference: PresentationPreference = .automatic,
        complexity: ContentComplexity = .moderate,
        context: PresentationContext = .dashboard,
        customPreferences: [String: String] = [:],
        extensibleHints: [ExtensibleHint] = [],
        modelName: String,
        registry: DataHintsRegistry = globalDataHintsRegistry
    ) async {
        let fieldHints = await registry.loadHints(for: modelName)
        
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

