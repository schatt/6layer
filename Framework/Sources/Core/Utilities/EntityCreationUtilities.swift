//
//  EntityCreationUtilities.swift
//  SixLayerFramework
//
//  Shared utilities for creating Core Data and SwiftData entities
//  Used by both IntelligentFormView and DynamicFormView
//

import Foundation
#if canImport(CoreData)
import CoreData
#endif
#if canImport(SwiftData)
import SwiftData
#endif

/// Shared utilities for entity creation
/// DRY: Centralizes entity creation logic used by both IntelligentFormView and DynamicFormView
@MainActor
public enum EntityCreationUtilities {
    
    // MARK: - Core Data Entity Creation
    
    #if canImport(CoreData)
    /// Create a Core Data entity from a dictionary of values
    /// - Parameters:
    ///   - entityName: Name of the Core Data entity
    ///   - values: Dictionary of field names to values
    ///   - context: Managed object context to insert into
    ///   - fieldHints: Optional hints to filter hidden fields
    /// - Returns: Created NSManagedObject, or nil if creation failed
    public static func createCoreDataEntity(
        entityName: String,
        values: [String: Any],
        context: NSManagedObjectContext,
        fieldHints: [String: FieldDisplayHints]? = nil
    ) -> NSManagedObject? {
        // Create blank entity
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: entityName,
            into: context
        )
        
        // Set values from dictionary
        for (fieldId, value) in values {
            // Check if field should be hidden (skip it)
            if let hints = fieldHints, let hint = hints[fieldId], hint.isHidden {
                continue
            }
            
            // Set value using KVC
            entity.setValue(value, forKey: fieldId)
        }
        
        // Save context
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error saving Core Data entity: \(error.localizedDescription)")
            // Continue - entity is still created, just not saved
        }
        
        return entity
    }
    
    /// Create a blank Core Data entity with defaults from hints
    /// - Parameters:
    ///   - entityName: Name of the Core Data entity
    ///   - context: Managed object context to insert into
    ///   - fields: Array of DataField from analysis
    ///   - fieldHints: Hints containing default values
    /// - Returns: Created NSManagedObject with defaults populated, or nil if creation failed
    public static func createBlankCoreDataEntity(
        entityName: String,
        context: NSManagedObjectContext,
        fields: [DataField],
        fieldHints: [String: FieldDisplayHints]
    ) -> NSManagedObject? {
        // Create blank entity
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: entityName,
            into: context
        )
        
        // Populate with defaults from hints
        for field in fields {
            guard let hint = fieldHints[field.name] else { continue }
            guard !hint.isHidden else { continue }
            
            if let defaultValue = hint.defaultValue {
                // Set default value using KVC
                entity.setValue(defaultValue, forKey: field.name)
            } else if field.isOptional {
                // Optional fields can be nil
                entity.setValue(nil, forKey: field.name)
            } else {
                // Required fields without defaults - use type-based defaults
                let typeDefault = getDefaultValueForType(field.type)
                entity.setValue(typeDefault, forKey: field.name)
            }
        }
        
        return entity
    }
    #endif
    
    // MARK: - SwiftData Entity Creation
    
    #if canImport(SwiftData)
    /// Create a SwiftData entity from a dictionary of values using Codable
    /// - Parameters:
    ///   - entityType: The SwiftData entity type (must conform to Decodable)
    ///   - values: Dictionary of field names to values
    ///   - context: Model context to insert into
    ///   - fieldHints: Optional hints to filter hidden fields
    /// - Returns: Created entity, or nil if creation failed
    @available(macOS 14.0, iOS 17.0, *)
    public static func createSwiftDataEntity(
        entityType: Any.Type,
        values: [String: Any],
        context: ModelContext,
        fieldHints: [String: FieldDisplayHints]? = nil
    ) -> Any? {
        // Check if entityType conforms to Decodable
        guard let decodableType = entityType as? any Decodable.Type else { return nil }
        
        // Filter out hidden fields
        var filteredValues = values
        if let hints = fieldHints {
            filteredValues = values.filter { fieldId, _ in
                guard let hint = hints[fieldId] else { return true }
                return !hint.isHidden
            }
        }
        
        // Encode values to JSON, then decode to entity type
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: filteredValues)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(decodableType, from: jsonData)
            
            // Insert into context
            if let persistentModel = decoded as? any PersistentModel {
                context.insert(persistentModel)
                
                // Save context
                do {
                    if context.hasChanges {
                        try context.save()
                    }
                } catch {
                    print("Error saving SwiftData entity: \(error.localizedDescription)")
                    // Continue - entity is still created, just not saved
                }
            }
            
            return decoded
        } catch {
            print("Error creating SwiftData entity: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Create a blank SwiftData entity with defaults from hints using Codable
    /// - Parameters:
    ///   - entityType: The SwiftData entity type (must conform to Decodable)
    ///   - context: Model context to insert into
    ///   - fields: Array of DataField from analysis
    ///   - fieldHints: Hints containing default values
    /// - Returns: Created entity with defaults populated, or nil if creation failed
    @available(macOS 14.0, iOS 17.0, *)
    public static func createBlankSwiftDataEntity(
        entityType: Any.Type,
        context: ModelContext,
        fields: [DataField],
        fieldHints: [String: FieldDisplayHints]
    ) -> Any? {
        // Check if entityType conforms to Decodable
        guard let decodableType = entityType as? any Decodable.Type else { return nil }
        
        // Build dictionary from hints defaults
        var values: [String: Any] = [:]
        for field in fields {
            guard let hint = fieldHints[field.name] else { continue }
            guard !hint.isHidden else { continue }
            
            if let defaultValue = hint.defaultValue {
                values[field.name] = defaultValue
            } else if field.isOptional {
                // Optional fields can be nil (represented as NSNull in JSON)
                values[field.name] = NSNull()
            } else {
                // Required fields without defaults - use type-based defaults
                values[field.name] = getDefaultValueForType(field.type)
            }
        }
        
        // Encode to JSON, then decode to T using type-erased Decodable
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: values)
            let decoder = JSONDecoder()
            
            // Use type-erased decoding: cast T.self to Decodable.Type, decode, then cast back
            let decoded = try decoder.decode(decodableType, from: jsonData)
            
            // Insert into context
            if let persistentModel = decoded as? any PersistentModel {
                context.insert(persistentModel)
            }
            
            return decoded
        } catch {
            // Codable failed
            print("Error creating SwiftData entity from hints: \(error.localizedDescription)")
            return nil
        }
    }
    #endif
    
    // MARK: - Helper Functions
    
    /// Get default value for a field type
    /// - Parameter fieldType: The field type to get default for
    /// - Returns: Default value for the type
    public static func getDefaultValueForType(_ fieldType: FieldType) -> Any {
        switch fieldType {
        case .string: return ""
        case .number: return 0
        case .boolean: return false
        case .date: return Date()
        case .url: return URL(string: "https://example.com") ?? URL(string: "https://example.com")!
        case .uuid: return UUID()
        case .image, .document: return ""
        case .relationship, .hierarchical, .custom: return ""
        }
    }
}
