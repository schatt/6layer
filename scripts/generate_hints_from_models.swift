#!/usr/bin/env swift

//
//  generate_hints_from_models.swift
//  SixLayer Framework
//
//  Build-time tool to generate/update .hints files from model files
//  Parses Swift source files and Core Data .xcdatamodel files to extract
//  type information and generate fully declarative hints
//

import Foundation

// MARK: - Model Parser

/// Parses Swift source files to extract struct/class property information
struct SwiftModelParser {
    /// Parse a Swift source file and extract field information
    static func parseSwiftFile(at url: URL) -> [FieldInfo]? {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        
        // Simple regex-based parsing for struct/class properties
        // This is a basic implementation - could be enhanced with SwiftSyntax for better accuracy
        var fields: [FieldInfo] = []
        
        // Pattern to match property declarations: let/var name: Type? = defaultValue
        let propertyPattern = #"(?:let|var)\s+(\w+)\s*:\s*([\w\.\[\]?]+)(?:\s*=\s*([^\n]+))?"#
        let regex = try? NSRegularExpression(pattern: propertyPattern, options: [])
        
        let nsContent = content as NSString
        let matches = regex?.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length)) ?? []
        
        for match in matches {
            guard match.numberOfRanges >= 3 else { continue }
            
            let nameRange = match.range(at: 1)
            let typeRange = match.range(at: 2)
            
            guard nameRange.location != NSNotFound,
                  typeRange.location != NSNotFound else { continue }
            
            let name = nsContent.substring(with: nameRange)
            var typeString = nsContent.substring(with: typeRange)
            
            // Determine optionality
            let isOptional = typeString.hasSuffix("?")
            if isOptional {
                typeString = String(typeString.dropLast())
            }
            
            // Determine if array
            let isArray = typeString.hasPrefix("Array<") || typeString.hasPrefix("[")
            
            // Map Swift types to fieldType strings
            let fieldType = mapSwiftTypeToFieldType(typeString)
            
            // Extract default value if present
            var defaultValue: (any Sendable)? = nil
            if match.numberOfRanges >= 4 {
                let defaultValueRange = match.range(at: 3)
                if defaultValueRange.location != NSNotFound {
                    let defaultValueString = nsContent.substring(with: defaultValueRange).trimmingCharacters(in: .whitespaces)
                    defaultValue = parseDefaultValue(from: defaultValueString, type: fieldType)
                }
            }
            
            fields.append(FieldInfo(
                name: name,
                fieldType: fieldType,
                isOptional: isOptional,
                isArray: isArray,
                defaultValue: defaultValue
            ))
        }
        
        return fields.isEmpty ? nil : fields
    }
    
    /// Map Swift type names to fieldType strings
    private static func mapSwiftTypeToFieldType(_ swiftType: String) -> String {
        // Remove generic parameters and array brackets
        let baseType = swiftType
            .replacingOccurrences(of: "Array<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        switch baseType.lowercased() {
        case "string", "string?":
            return "string"
        case "int", "int8", "int16", "int32", "int64", "uint", "uint8", "uint16", "uint32", "uint64":
            return "number"
        case "double", "float", "cgfloat":
            return "number"
        case "bool", "boolean":
            return "boolean"
        case "date":
            return "date"
        case "url":
            return "url"
        case "uuid":
            return "uuid"
        case "data":
            return "document"
        default:
            // Check for image types
            if baseType.contains("Image") || baseType == "UIImage" || baseType == "NSImage" {
                return "image"
            }
            return "custom"
        }
    }
    
    /// Parse default value from string representation
    private static func parseDefaultValue(from string: String, type: String) -> (any Sendable)? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        
        switch type {
        case "string":
            // Remove quotes
            if trimmed.hasPrefix("\"") && trimmed.hasSuffix("\"") {
                return String(trimmed.dropFirst().dropLast())
            }
            return trimmed
        case "number":
            if let intValue = Int(trimmed) {
                return intValue
            } else if let doubleValue = Double(trimmed) {
                return doubleValue
            }
            return nil
        case "boolean":
            if trimmed == "true" {
                return true
            } else if trimmed == "false" {
                return false
            }
            return nil
        default:
            return nil
        }
    }
}

/// Parses Core Data .xcdatamodel XML files
struct CoreDataModelParser {
    /// Parse a Core Data model file and extract entity/attribute information
    static func parseCoreDataModel(at url: URL) -> [EntityInfo]? {
        // .xcdatamodel is a directory containing contents.xml
        let contentsURL = url.appendingPathComponent("contents.xml")
        
        guard FileManager.default.fileExists(atPath: contentsURL.path),
              let xmlData = try? Data(contentsOf: contentsURL),
              let xmlString = String(data: xmlData, encoding: .utf8) else {
            return nil
        }
        
        // Simple XML parsing (could use XMLParser for more robust parsing)
        var entities: [EntityInfo] = []
        
        // Pattern to match entity definitions
        let entityPattern = #"<entity\s+name="([^"]+)"[^>]*>"#
        let entityRegex = try? NSRegularExpression(pattern: entityPattern, options: [])
        
        let nsString = xmlString as NSString
        let entityMatches = entityRegex?.matches(in: xmlString, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        
        for entityMatch in entityMatches {
            guard entityMatch.numberOfRanges >= 2 else { continue }
            let nameRange = entityMatch.range(at: 1)
            guard nameRange.location != NSNotFound else { continue }
            
            let entityName = nsString.substring(with: nameRange)
            
            // Find attributes for this entity
            // Look for the closing </entity> tag
            let entityStart = entityMatch.range.location + entityMatch.range.length
            let entityEndPattern = "</entity>"
            let entityEndRegex = try? NSRegularExpression(pattern: entityEndPattern, options: [])
            let endMatches = entityEndRegex?.matches(in: xmlString, options: [], range: NSRange(location: entityStart, length: nsString.length - entityStart))
            
            let entityEnd = endMatches?.first?.range.location ?? xmlString.count
            let entityContent = nsString.substring(with: NSRange(location: entityStart, length: entityEnd - entityStart))
            
            // Parse attributes
            var fields: [FieldInfo] = []
            let attributePattern = #"<attribute\s+name="([^"]+)"[^>]*attributeType="([^"]+)"[^>]*(?:optional="([^"]+)")?[^>]*/>"#
            let attributeRegex = try? NSRegularExpression(pattern: attributePattern, options: [])
            let attributeMatches = attributeRegex?.matches(in: entityContent, options: [], range: NSRange(location: 0, length: entityContent.count))
            
            for attrMatch in attributeMatches ?? [] {
                guard attrMatch.numberOfRanges >= 3 else { continue }
                
                let nameRange = attrMatch.range(at: 1)
                let typeRange = attrMatch.range(at: 2)
                
                guard nameRange.location != NSNotFound,
                      typeRange.location != NSNotFound else { continue }
                
                let name = (entityContent as NSString).substring(with: nameRange)
                let attributeType = (entityContent as NSString).substring(with: typeRange)
                
                let isOptional = attrMatch.numberOfRanges >= 4 && attrMatch.range(at: 3).location != NSNotFound
                    ? (entityContent as NSString).substring(with: attrMatch.range(at: 3)) == "YES"
                    : false
                
                let fieldType = mapCoreDataAttributeType(attributeType)
                
                fields.append(FieldInfo(
                    name: name,
                    fieldType: fieldType,
                    isOptional: isOptional,
                    isArray: false, // Core Data attributes are not arrays (use relationships)
                    defaultValue: nil
                ))
            }
            
            entities.append(EntityInfo(name: entityName, fields: fields))
        }
        
        return entities.isEmpty ? nil : entities
    }
    
    /// Map Core Data attribute types to fieldType strings
    private static func mapCoreDataAttributeType(_ attributeType: String) -> String {
        switch attributeType {
        case "String":
            return "string"
        case "Integer 16", "Integer 32", "Integer 64", "Decimal", "Double", "Float":
            return "number"
        case "Boolean":
            return "boolean"
        case "Date":
            return "date"
        case "UUID":
            return "uuid"
        case "Binary", "Transformable":
            return "document"
        default:
            return "custom"
        }
    }
}

// MARK: - Data Structures

struct FieldInfo {
    let name: String
    let fieldType: String
    let isOptional: Bool
    let isArray: Bool
    let defaultValue: (any Sendable)?
}

struct EntityInfo {
    let name: String
    let fields: [FieldInfo]
}

// MARK: - Hints Generator

/// Generates .hints JSON files from parsed model information
struct HintsGenerator {
    /// Generate hints file content from field information
    static func generateHintsJSON(fields: [FieldInfo], existingHints: [String: [String: Any]]? = nil) -> [String: Any] {
        var hints: [String: Any] = existingHints ?? [:]
        
        for field in fields {
            var fieldHints: [String: Any] = hints[field.name] as? [String: Any] ?? [:]
            
            // Add type information (only if not already present in existing hints)
            if fieldHints["fieldType"] == nil {
                fieldHints["fieldType"] = field.fieldType
            }
            if fieldHints["isOptional"] == nil {
                fieldHints["isOptional"] = field.isOptional
            }
            if fieldHints["isArray"] == nil {
                fieldHints["isArray"] = field.isArray
            }
            if field.defaultValue != nil && fieldHints["defaultValue"] == nil {
                fieldHints["defaultValue"] = field.defaultValue
            }
            
            hints[field.name] = fieldHints
        }
        
        return hints
    }
    
    /// Write hints to a .hints file
    static func writeHints(_ hints: [String: Any], to url: URL) throws {
        let data = try JSONSerialization.data(withJSONObject: hints, options: [.prettyPrinted, .sortedKeys])
        try data.write(to: url)
    }
}

// MARK: - Main

func main() {
    let arguments = CommandLine.arguments
    guard arguments.count >= 2 else {
        print("Usage: generate_hints_from_models.swift <model_file> [output_hints_file]")
        print("  model_file: Swift .swift file or Core Data .xcdatamodel directory")
        print("  output_hints_file: Optional path to output .hints file (defaults to Hints/<model_name>.hints)")
        exit(1)
    }
    
    let modelPath = arguments[1]
    let modelURL = URL(fileURLWithPath: modelPath)
    
    guard FileManager.default.fileExists(atPath: modelURL.path) else {
        print("Error: Model file not found: \(modelPath)")
        exit(1)
    }
    
    // Determine output path
    let outputPath: String
    if arguments.count >= 3 {
        outputPath = arguments[2]
    } else {
        let modelName = modelURL.deletingPathExtension().lastPathComponent
        outputPath = "Hints/\(modelName).hints"
    }
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Ensure output directory exists
    let outputDir = outputURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    
    // Load existing hints if they exist
    var existingHints: [String: [String: Any]]? = nil
    if FileManager.default.fileExists(atPath: outputURL.path),
       let data = try? Data(contentsOf: outputURL),
       let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] {
        existingHints = json
    }
    
    // Parse model file
    var fields: [FieldInfo]? = nil
    
    if modelURL.pathExtension == "swift" {
        fields = SwiftModelParser.parseSwiftFile(at: modelURL)
    } else if modelURL.pathExtension == "xcdatamodel" || modelURL.lastPathComponent.hasSuffix(".xcdatamodel") {
        if let entities = CoreDataModelParser.parseCoreDataModel(at: modelURL) {
            // For now, use first entity (could be enhanced to handle multiple entities)
            if let firstEntity = entities.first {
                fields = firstEntity.fields
            }
        }
    } else {
        print("Error: Unsupported model file type. Supported: .swift, .xcdatamodel")
        exit(1)
    }
    
    guard let fields = fields, !fields.isEmpty else {
        print("Error: Could not parse model file or no fields found")
        exit(1)
    }
    
    // Generate hints
    let hints = HintsGenerator.generateHintsJSON(fields: fields, existingHints: existingHints)
    
    // Write hints file
    do {
        try HintsGenerator.writeHints(hints, to: outputURL)
        print("✅ Generated hints file: \(outputPath)")
        print("   Found \(fields.count) fields")
    } catch {
        print("Error: Failed to write hints file: \(error)")
        exit(1)
    }
}

main()
