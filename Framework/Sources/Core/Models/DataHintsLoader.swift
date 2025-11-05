//
//  DataHintsLoader.swift
//  SixLayerFramework
//
//  Loads .hints files that describe how to present data models
//

import Foundation

// MARK: - Data Hints Result

/// Complete result from loading a hints file, including both field hints and layout sections
// TODO: Make properly Sendable once DynamicFormField is Sendable
public struct DataHintsResult: @unchecked Sendable {
    /// Field-level display hints keyed by field ID
    public let fieldHints: [String: FieldDisplayHints]
    /// Layout sections parsed from _sections array in hints file
    public let sections: [DynamicFormSection]
    
    public init(fieldHints: [String: FieldDisplayHints] = [:], sections: [DynamicFormSection] = []) {
        self.fieldHints = fieldHints
        self.sections = sections
    }
}

// MARK: - Data Hints Protocol

/// Protocol for loading hints that describe how to present data models
// TODO: Make Sendable once DataHintsResult is Sendable
public protocol DataHintsLoader {
    /// Load hints for a data model by its name (backward compatibility - returns only field hints)
    func loadHints(for modelName: String) -> [String: FieldDisplayHints]
    
    /// Load complete hints result including field hints and sections
    func loadHintsResult(for modelName: String) -> DataHintsResult
}

// MARK: - File-Based Data Hints Loader

/// Loads .hints files from the bundle or filesystem
// TODO: Add @unchecked Sendable once DataHintsResult is Sendable
public class FileBasedDataHintsLoader: DataHintsLoader {
    private let fileManager: FileManager
    private let bundle: Bundle
    
    public init(fileManager: FileManager = .default, bundle: Bundle = .main) {
        self.fileManager = fileManager
        self.bundle = bundle
    }
    
    /// Load a .hints file for a data model (backward compatibility - returns only field hints)
    /// Example: loadHints(for: "User") looks for "User.hints" file in the Hints/ folder
    public func loadHints(for modelName: String) -> [String: FieldDisplayHints] {
        return loadHintsResult(for: modelName).fieldHints
    }
    
    /// Load complete hints result including field hints and sections
    /// Example: loadHintsResult(for: "User") looks for "User.hints" file in the Hints/ folder
    public func loadHintsResult(for modelName: String) -> DataHintsResult {
        // Try to load from bundle first (in Hints/ subfolder)
        if let hintsFolder = bundle.url(forResource: "Hints", withExtension: nil) {
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if let data = try? Data(contentsOf: url),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return parseHintsResult(from: json)
            }
        }
        
        // Also try root level for backward compatibility
        if let url = bundle.url(forResource: modelName, withExtension: "hints"),
           let data = try? Data(contentsOf: url),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return parseHintsResult(from: json)
        }
        
        // Fall back to documents directory (in Hints/ subfolder)
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let hintsFolder = documentsURL.appendingPathComponent("Hints")
            let url = hintsFolder.appendingPathComponent("\(modelName).hints")
            if fileManager.fileExists(atPath: hintsFolder.path),
               let data = try? Data(contentsOf: url),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return parseHintsResult(from: json)
            }
        }
        
        return DataHintsResult()
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
    
    private func parseHintsResult(from json: [String: Any]) -> DataHintsResult {
        var fieldHints: [String: FieldDisplayHints] = [:]
        var sections: [DynamicFormSection] = []
        
        // Parse field hints (all keys except _sections)
        for (key, value) in json {
            if key == "_sections" {
                continue // Handle sections separately
            }
            
            if let properties = value as? [String: String] {
                fieldHints[key] = FieldDisplayHints(
                    expectedLength: properties["expectedLength"].flatMap(Int.init),
                    displayWidth: properties["displayWidth"],
                    showCharacterCounter: properties["showCharacterCounter"] == "true",
                    maxLength: properties["maxLength"].flatMap(Int.init),
                    minLength: properties["minLength"].flatMap(Int.init),
                    metadata: properties
                )
            }
        }
        
        // Parse _sections if present
        if let sectionsArray = json["_sections"] as? [[String: Any]] {
            sections = parseSections(from: sectionsArray)
        }
        
        return DataHintsResult(fieldHints: fieldHints, sections: sections)
    }
    
    private func parseSections(from sectionsArray: [[String: Any]]) -> [DynamicFormSection] {
        var sections: [DynamicFormSection] = []
        
        for sectionDict in sectionsArray {
            // Title is required (for accessibility)
            guard let id = sectionDict["id"] as? String,
                  let title = sectionDict["title"] as? String else {
                print("⚠️ Warning: Skipping section in hints file - missing required 'id' or 'title'")
                continue
            }
            
            let description = sectionDict["description"] as? String
            let fieldIds = sectionDict["fields"] as? [String] ?? []
            let layoutStyleString = sectionDict["layoutStyle"] as? String
            let layoutStyle = layoutStyleString.flatMap { FieldLayout(rawValue: $0) }
            
            // Store field IDs in metadata so we can match them later when creating form
            var metadata: [String: String] = [:]
            if !fieldIds.isEmpty {
                metadata["_fieldIds"] = fieldIds.joined(separator: ",")
            }
            
            // Create section (fields will be populated later when matched with actual form fields)
            let section = DynamicFormSection(
                id: id,
                title: title,
                description: description,
                fields: [], // Fields will be populated when creating form
                metadata: metadata.isEmpty ? nil : metadata,
                layoutStyle: layoutStyle
            )
            
            sections.append(section)
        }
        
        return sections
    }
    
    // Legacy method for backward compatibility
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
    private var resultCache: [String: DataHintsResult] = [:]
    private let loader: DataHintsLoader
    
    public init(loader: DataHintsLoader = FileBasedDataHintsLoader()) {
        self.loader = loader
    }
    
    /// Load hints for a data model, checking cache first (backward compatibility)
    public func loadHints(for modelName: String) -> [String: FieldDisplayHints] {
        return loadHintsResult(for: modelName).fieldHints
    }
    
    /// Load complete hints result including field hints and sections
    public func loadHintsResult(for modelName: String) -> DataHintsResult {
        // Check cache first
        if let cached = resultCache[modelName] {
            return cached
        }
        
        // Load from file
        let result = loader.loadHintsResult(for: modelName)
        
        // Cache for future use
        if !result.fieldHints.isEmpty || !result.sections.isEmpty {
            resultCache[modelName] = result
            // Also update legacy cache for backward compatibility
            cache[modelName] = result.fieldHints
        }
        
        return result
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
        resultCache.removeAll()
    }
}

// MARK: - Section Builder Helper

/// Helper to build DynamicFormSection instances from hints sections, matching fields by ID
/// REFACTOR: Optimized field mapping and cleaner error handling
public enum SectionBuilder {
    /// Build sections from hints, matching field IDs to actual DynamicFormField instances
    /// - Parameters:
    ///   - hintsSections: Sections parsed from hints file (with field IDs in metadata)
    ///   - fields: Actual DynamicFormField instances to match
    /// - Returns: Sections with matched fields, preserving field order from hints
    public static func buildSections(
        from hintsSections: [DynamicFormSection],
        matching fields: [DynamicFormField]
    ) -> [DynamicFormSection] {
        // DRY: Create field map once for O(1) lookups
        let fieldMap = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0) })
        
        var builtSections: [DynamicFormSection] = []
        
        for hintsSection in hintsSections {
            // Extract field IDs from metadata
            guard let fieldIdsString = hintsSection.metadata?["_fieldIds"] else {
                // No fields specified - create empty section
                builtSections.append(hintsSection)
                continue
            }
            
            // Parse and match fields in order specified in hints (DRY)
            let fieldIds = fieldIdsString
                .split(separator: ",")
                .map { String($0).trimmingCharacters(in: .whitespaces) }
            
            let matchedFields = fieldIds.compactMap { fieldMap[$0] }
            let missingFields = fieldIds.filter { fieldMap[$0] == nil }
            
            // Warn about missing fields (graceful degradation)
            if !missingFields.isEmpty {
                print("⚠️ Warning: Section '\(hintsSection.title)' (id: \(hintsSection.id)) references fields that don't exist: \(missingFields.joined(separator: ", ")). These fields will be ignored.")
            }
            
            // Create section with matched fields
            var updatedMetadata = hintsSection.metadata ?? [:]
            updatedMetadata.removeValue(forKey: "_fieldIds") // Remove temporary field IDs storage
            
            let builtSection = DynamicFormSection(
                id: hintsSection.id,
                title: hintsSection.title,
                description: hintsSection.description,
                fields: matchedFields,
                isCollapsible: hintsSection.isCollapsible,
                isCollapsed: hintsSection.isCollapsed,
                metadata: updatedMetadata.isEmpty ? nil : updatedMetadata,
                layoutStyle: hintsSection.layoutStyle
            )
            
            builtSections.append(builtSection)
        }
        
        return builtSections
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

