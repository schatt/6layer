//
//  DataValueExtraction.swift
//  SixLayerFramework
//
//  Shared utility for extracting field values from data models
//  Supports both regular Swift types (via Mirror) and CoreData entities (via KVC)
//

import Foundation
#if canImport(CoreData)
import CoreData
#endif

/// Utility for extracting field values from data models
/// Supports both regular Swift types and CoreData entities
public enum DataValueExtraction {
    
    /// Extract a field value from an object using reflection or KVC
    /// - Parameters:
    ///   - object: The object to extract the value from
    ///   - fieldName: The name of the field to extract
    /// - Returns: The field value, or "N/A" if not found or nil
    ///
    /// **CoreData Support**: Automatically uses KVC (`value(forKey:)`) for `NSManagedObject` instances
    /// **Regular Types**: Uses Mirror reflection for regular Swift types
    public static func extractFieldValue(from object: Any, fieldName: String) -> Any {
        #if canImport(CoreData)
        // Check if this is a Core Data managed object
        if let managedObject = object as? NSManagedObject {
            // Use Core Data value extraction via KVC
            if let value = managedObject.value(forKey: fieldName), !(value is NSNull) {
                return value
            }
            return "N/A"
        }
        #endif
        
        // Use Mirror for non-Core Data objects
        let mirror = Mirror(reflecting: object)
        
        for child in mirror.children {
            if child.label == fieldName {
                let value = child.value
                // Return "N/A" for nil values wrapped as Optional.none
                if String(describing: value) == "nil" {
                    return "N/A"
                }
                return value
            }
        }
        
        return "N/A"
    }
}










