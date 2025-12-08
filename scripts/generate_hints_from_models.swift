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
    /// Returns fields and the type name(s) this file defines or extends
    static func parseSwiftFile(at url: URL) -> (fields: [FieldInfo], definedTypes: [String], extendedTypes: [String])? {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        
        // Simple regex-based parsing for struct/class properties
        // This is a basic implementation - could be enhanced with SwiftSyntax for better accuracy
        var fields: [FieldInfo] = []
        var definedTypes: [String] = []
        var extendedTypes: [String] = []
        
        // Pattern to match type definitions: struct/class/enum TypeName
        let typeDefinitionPattern = #"(?:struct|class|enum)\s+(\w+)"#
        let typeDefinitionRegex = try? NSRegularExpression(pattern: typeDefinitionPattern, options: [])
        
        // Pattern to match extension declarations: extension TypeName
        let extensionPattern = #"extension\s+(\w+)"#
        let extensionRegex = try? NSRegularExpression(pattern: extensionPattern, options: [])
        
        // Pattern to match property declarations: let/var name: Type? = defaultValue
        let propertyPattern = #"(?:let|var)\s+(\w+)\s*:\s*([\w\.\[\]?]+)(?:\s*=\s*([^\n]+))?"#
        let regex = try? NSRegularExpression(pattern: propertyPattern, options: [])
        
        let nsContent = content as NSString
        
        // Find type definitions (struct/class/enum)
        let typeMatches = typeDefinitionRegex?.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length)) ?? []
        for match in typeMatches {
            if match.numberOfRanges >= 2 {
                let typeNameRange = match.range(at: 1)
                if typeNameRange.location != NSNotFound {
                    let typeName = nsContent.substring(with: typeNameRange)
                    if !definedTypes.contains(typeName) {
                        definedTypes.append(typeName)
                    }
                }
            }
        }
        
        // Find extension declarations
        let extMatches = extensionRegex?.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length)) ?? []
        for match in extMatches {
            if match.numberOfRanges >= 2 {
                let typeNameRange = match.range(at: 1)
                if typeNameRange.location != NSNotFound {
                    let typeName = nsContent.substring(with: typeNameRange)
                    if !extendedTypes.contains(typeName) {
                        extendedTypes.append(typeName)
                    }
                }
            }
        }
        
        // Find property declarations
        let matches = regex?.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length)) ?? []
        
        for match in matches {
            guard match.numberOfRanges >= 3 else { continue }
            
            let nameRange = match.range(at: 1)
            let typeRange = match.range(at: 2)
            
            guard nameRange.location != NSNotFound,
                  typeRange.location != NSNotFound else { continue }
            
            // Check if this is a computed property (has { after type) vs stored property (has = or nothing)
            let matchEnd = match.range.location + match.range.length
            var isComputed = false
            if matchEnd < nsContent.length {
                // Look ahead to see what comes after the match
                let remainingContent = nsContent.substring(from: matchEnd)
                let trimmed = remainingContent.trimmingCharacters(in: .whitespacesAndNewlines)
                // If it starts with {, it's a computed property
                if trimmed.hasPrefix("{") {
                    isComputed = true
                }
            }
            
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
            
            // Determine if field should be hidden
            // Common patterns: cloudSyncId, syncId, internalId, _id, etc.
            let isHidden = shouldHideField(name: name, type: fieldType)
            
            // Computed properties are not editable
            let isEditable = !isComputed
            
            fields.append(FieldInfo(
                name: name,
                fieldType: fieldType,
                isOptional: isOptional,
                isArray: isArray,
                defaultValue: defaultValue,
                isHidden: isHidden,
                isEditable: isEditable
            ))
        }
        
        return fields.isEmpty && definedTypes.isEmpty && extendedTypes.isEmpty ? nil : (fields, definedTypes, extendedTypes)
    }
    
    /// Parse a Swift source file and extract only field information (backward compatibility)
    static func parseSwiftFileFields(at url: URL) -> [FieldInfo]? {
        guard let result = parseSwiftFile(at: url) else { return nil }
        return result.fields.isEmpty ? nil : result.fields
    }
    
    /// Determine if a field should be hidden based on naming patterns
    private static func shouldHideField(name: String, type: String) -> Bool {
        let lowercased = name.lowercased()
        
        // Common patterns for internal/hidden fields
        let hiddenPatterns = [
            "cloudsyncid", "cloud_sync_id", "cloudSyncId",
            "syncid", "sync_id", "syncId",
            "internalid", "internal_id", "internalId",
            "_id", "_uuid", "_sync",
            "metadata", "internalmetadata",
            "systemid", "system_id", "systemId"
        ]
        
        // Check if field name matches any hidden pattern
        for pattern in hiddenPatterns {
            if lowercased.contains(pattern) {
                return true
            }
        }
        
        // Fields starting with underscore are typically internal
        if name.hasPrefix("_") {
            return true
        }
        
        return false
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
                
                // Determine if field should be hidden
                let isHidden = shouldHideField(name: name, type: fieldType)
                
                // Core Data attributes are always stored (editable)
                fields.append(FieldInfo(
                    name: name,
                    fieldType: fieldType,
                    isOptional: isOptional,
                    isArray: false, // Core Data attributes are not arrays (use relationships)
                    defaultValue: nil,
                    isHidden: isHidden,
                    isEditable: true
                ))
            }
            
            entities.append(EntityInfo(name: entityName, fields: fields))
        }
        
        return entities.isEmpty ? nil : entities
    }
    
    /// Determine if a field should be hidden based on naming patterns
    private static func shouldHideField(name: String, type: String) -> Bool {
        let lowercased = name.lowercased()
        
        // Common patterns for internal/hidden fields
        let hiddenPatterns = [
            "cloudsyncid", "cloud_sync_id", "cloudSyncId",
            "syncid", "sync_id", "syncId",
            "internalid", "internal_id", "internalId",
            "_id", "_uuid", "_sync",
            "metadata", "internalmetadata",
            "systemid", "system_id", "systemId"
        ]
        
        // Check if field name matches any hidden pattern
        for pattern in hiddenPatterns {
            if lowercased.contains(pattern) {
                return true
            }
        }
        
        // Fields starting with underscore are typically internal
        if name.hasPrefix("_") {
            return true
        }
        
        return false
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
    let isHidden: Bool  // Whether field should be hidden from forms
    let isEditable: Bool  // Whether field is editable (false for computed properties)
}

struct EntityInfo {
    let name: String
    let fields: [FieldInfo]
}

// MARK: - Hints Generator

/// Generates .hints JSON files from parsed model information
struct HintsGenerator {
    /// Generate hints file content from field information
    /// Returns both the hints dictionary and the field order (to preserve custom ordering)
    /// For existing fields, preserves all properties exactly as they are
    /// Only adds type information if missing (for fully declarative hints)
    static func generateHintsJSON(
        fields: [FieldInfo], 
        existingHints: [String: [String: Any]]? = nil
    ) -> (hints: [String: Any], fieldOrder: [String]) {
        var hints: [String: Any] = existingHints ?? [:]
        var fieldOrder: [String] = []
        
        // Preserve order from existing hints first
        if let existing = existingHints {
            fieldOrder = Array(existing.keys) // Preserve existing order
        }
        
        // Process fields from model (in source order)
        // Skip __example field if it exists (it's documentation only)
        for field in fields {
            // Skip __example - it's a documentation field, not a real model field
            if field.name == "__example" {
                continue
            }
            
            let existingFieldHints = hints[field.name] as? [String: Any]
            var fieldHints: [String: Any] = existingFieldHints ?? [:]
            
            // Always include type information (core fields for fully declarative hints)
            // Only override if not already present in existing hints
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
            // Add isHidden (only if not already present, to allow manual override)
            if fieldHints["isHidden"] == nil {
                fieldHints["isHidden"] = field.isHidden
            }
            // Add isEditable (only if not already present, to allow manual override)
            // Computed properties are automatically marked as non-editable
            if fieldHints["isEditable"] == nil {
                fieldHints["isEditable"] = field.isEditable
            }
            
            // For existing fields: don't add any properties that weren't already there
            // This preserves developer's choice to remove properties
            // New fields get minimal type info only - see __example for all options
            
            hints[field.name] = fieldHints
            
            // Add to order if not already present (new fields go at end)
            if !fieldOrder.contains(field.name) {
                fieldOrder.append(field.name)
            }
        }
        
        return (hints, fieldOrder)
    }
    
    /// Write hints to a .hints file
    /// Preserves field order from existing hints, then appends new fields
    /// Note: JSONSerialization doesn't guarantee order, so we manually construct JSON
    static func writeHints(_ hints: [String: Any], to url: URL, preserveOrder: [String]? = nil) throws {
        // Build JSON string manually to preserve order
        var jsonLines: [String] = ["{"]
        
        let fieldOrder = preserveOrder ?? Array(hints.keys).sorted()
        var isFirst = true
        
        for fieldName in fieldOrder {
            guard let fieldHints = hints[fieldName] as? [String: Any] else { continue }
            
            if !isFirst {
                jsonLines[jsonLines.count - 1] += ","
            }
            isFirst = false
            
            // Field name
            jsonLines.append("  \"\(fieldName)\": {")
            
            // Field properties (sorted for consistency within each field)
            let sortedKeys = fieldHints.keys.sorted()
            var isFirstProp = true
            for key in sortedKeys {
                guard let value = fieldHints[key] else { continue }
                
                if !isFirstProp {
                    jsonLines[jsonLines.count - 1] += ","
                }
                isFirstProp = false
                
                // Format value based on type
                let valueString: String
                if value is NSNull {
                    valueString = "null"
                } else if let stringValue = value as? String {
                    // Escape quotes in strings
                    let escaped = stringValue.replacingOccurrences(of: "\"", with: "\\\"")
                    valueString = "\"\(escaped)\""
                } else if let boolValue = value as? Bool {
                    valueString = boolValue ? "true" : "false"
                } else if let numberValue = value as? NSNumber {
                    valueString = "\(numberValue)"
                } else if let dictValue = value as? [String: Any] {
                    // Handle dictionaries (like metadata: {})
                    if dictValue.isEmpty {
                        valueString = "{}"
                    } else {
                        // Fallback: use JSONSerialization for non-empty dicts
                        if let jsonData = try? JSONSerialization.data(withJSONObject: dictValue, options: []),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            valueString = jsonString
                        } else {
                            valueString = "{}"
                        }
                    }
                } else {
                    // Fallback: use JSONSerialization for complex types
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        valueString = jsonString
                    } else {
                        valueString = "null"
                    }
                }
                
                jsonLines.append("    \"\(key)\": \(valueString)")
            }
            
            jsonLines.append("  }")
        }
        
        jsonLines.append("}")
        
        // Join with proper spacing
        let jsonString = jsonLines.joined(separator: "\n")
        let data = jsonString.data(using: .utf8)!
        try data.write(to: url)
    }
}

// MARK: - Command Line Argument Parsing

struct Arguments {
    var modelPath: String?
    var modeldPath: String?
    var extensionsDir: [String] = []
    var outputDir: String = "Hints"
    
    static func parse() -> Arguments? {
        var args = Arguments()
        let arguments = CommandLine.arguments
        var i = 1
        
        while i < arguments.count {
            let arg = arguments[i]
            
            switch arg {
            case "-model":
                guard i + 1 < arguments.count else {
                    print("Error: -model requires a file path")
                    return nil
                }
                args.modelPath = arguments[i + 1]
                i += 2
                
            case "-modeld":
                guard i + 1 < arguments.count else {
                    print("Error: -modeld requires a Core Data model path")
                    return nil
                }
                args.modeldPath = arguments[i + 1]
                i += 2
                
            case "-extensionsdir":
                guard i + 1 < arguments.count else {
                    print("Error: -extensionsdir requires a directory path")
                    return nil
                }
                args.extensionsDir.append(arguments[i + 1])
                i += 2
                
            case "-outputdir":
                guard i + 1 < arguments.count else {
                    print("Error: -outputdir requires a directory path")
                    return nil
                }
                args.outputDir = arguments[i + 1]
                i += 2
                
            case "-h", "-help", "--help":
                printUsage()
                exit(0)
                
            default:
                print("Error: Unknown argument: \(arg)")
                printUsage()
                return nil
            }
        }
        
        return args
    }
    
    static func printUsage() {
        print("Usage: generate_hints_from_models.swift -model <swift_file> | -modeld <xcdatamodel> [options]")
        print("")
        print("Options:")
        print("  -model <path>          Swift .swift file to process")
        print("  -modeld <path>         Core Data .xcdatamodel directory to process")
        print("  -extensionsdir <path>  Directory to search for extension files (can be specified multiple times)")
        print("  -outputdir <path>      Output directory for .hints files (defaults to ./Hints)")
        print("  -h, -help, --help      Show this help message")
        print("")
        print("Examples:")
        print("  # Swift model with extensions in same directory")
        print("  ./scripts/generate_hints_from_models.swift -model Models/User.swift")
        print("")
        print("  # Swift model with extensions in different directory")
        print("  ./scripts/generate_hints_from_models.swift -model Models/User.swift -extensionsdir Extensions/")
        print("")
        print("  # Core Data model with extensions")
        print("  ./scripts/generate_hints_from_models.swift -modeld MyModel.xcdatamodel -extensionsdir Extensions/")
        print("")
        print("  # Custom output directory")
        print("  ./scripts/generate_hints_from_models.swift -model Models/User.swift -outputdir Generated/Hints/")
    }
}

// MARK: - Main

func main() {
    guard let args = Arguments.parse() else {
        exit(1)
    }
    
    // Validate that exactly one of -model or -modeld is provided
    guard (args.modelPath != nil) != (args.modeldPath != nil) else {
        print("Error: Must specify exactly one of -model or -modeld")
        Arguments.printUsage()
        exit(1)
    }
    
    let modelURL: URL
    if let modelPath = args.modelPath {
        modelURL = URL(fileURLWithPath: modelPath)
    } else {
        modelURL = URL(fileURLWithPath: args.modeldPath!)
    }
    
    guard FileManager.default.fileExists(atPath: modelURL.path) else {
        print("Error: Model file not found: \(modelURL.path)")
        exit(1)
    }
    
    // Determine output directory (defaults to ./Hints in current directory)
    // If relative path, make it relative to current working directory
    let outputDir: URL
    if args.outputDir.hasPrefix("/") {
        outputDir = URL(fileURLWithPath: args.outputDir)
    } else {
        let currentDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        outputDir = currentDir.appendingPathComponent(args.outputDir)
    }
    let extensionSearchPaths = args.extensionsDir.map { URL(fileURLWithPath: $0) }
    
    // Ensure output directory exists
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    
    // Parse model file and generate hints
    if modelURL.pathExtension == "swift" {
        // Swift file: may have extensions in separate files
        // Find all related files (main file + extension files like ModelName+*.swift)
        let modelName = modelURL.deletingPathExtension().lastPathComponent
        let modelDir = modelURL.deletingLastPathComponent()
        
        // Find all Swift files that might contain this model or its extensions
        var swiftFiles: [URL] = [modelURL] // Start with the main file
        
        // Search directories for extension files
        var searchDirs = [modelDir] // Start with same directory as main file
        searchDirs.append(contentsOf: extensionSearchPaths) // Add any provided search paths
        
        for searchDir in searchDirs {
            guard FileManager.default.fileExists(atPath: searchDir.path) else { continue }
            
            // Look for extension files matching ModelName+*.swift
            if let dirContents = try? FileManager.default.contentsOfDirectory(at: searchDir, includingPropertiesForKeys: nil) {
                for file in dirContents {
                    let fileName = file.deletingPathExtension().lastPathComponent
                    // Check if it's an extension file for this model
                    // Matches: ModelName+Something.swift or ModelName+Something+More.swift
                    if file.pathExtension == "swift" && fileName.hasPrefix("\(modelName)+") {
                        // Avoid duplicates
                        if !swiftFiles.contains(where: { $0.path == file.path }) {
                            swiftFiles.append(file)
                        }
                    }
                }
            }
        }
        
        // Parse all related files and combine fields
        var allFields: [FieldInfo] = []
        for file in swiftFiles {
            if let result = SwiftModelParser.parseSwiftFile(at: file) {
                allFields.append(contentsOf: result.fields)
            }
        }
        
        guard !allFields.isEmpty else {
            print("Error: Could not parse Swift file(s) or no fields found")
            if swiftFiles.count > 1 {
                print("   Searched files: \(swiftFiles.map { $0.lastPathComponent }.joined(separator: ", "))")
            }
            exit(1)
        }
        
        let outputURL = outputDir.appendingPathComponent("\(modelName).hints")
        
        generateHintsFile(for: allFields, outputURL: outputURL)
        print("✅ Generated hints file: \(outputURL.path)")
        print("   Found \(allFields.count) fields")
        if swiftFiles.count > 1 {
            print("   Processed \(swiftFiles.count) file(s): \(swiftFiles.map { $0.lastPathComponent }.joined(separator: ", "))")
        }
        
    } else if modelURL.pathExtension == "xcdatamodel" || modelURL.lastPathComponent.hasSuffix(".xcdatamodel") {
        // Core Data model: multiple entities, generate/update one hints file per entity
        guard let entities = CoreDataModelParser.parseCoreDataModel(at: modelURL) else {
            print("Error: Could not parse Core Data model or no entities found")
            exit(1)
        }
        
        if entities.isEmpty {
            print("Error: No entities found in Core Data model")
            exit(1)
        }
        
        print("Found \(entities.count) entity/entities in Core Data model:")
        for entity in entities {
            // For each entity, look for extension files in search paths
            var entityFields = entity.fields
            
            // Search for extension files for this entity
            var searchDirs = extensionSearchPaths
            if searchDirs.isEmpty {
                // If no search paths provided, try the model directory and common locations
                searchDirs = [
                    modelURL.deletingLastPathComponent(), // Same directory as .xcdatamodel
                    modelURL.deletingLastPathComponent().deletingLastPathComponent() // Parent directory
                ]
            }
            
            var extensionFiles: [URL] = []
            for searchDir in searchDirs {
                guard FileManager.default.fileExists(atPath: searchDir.path) else { continue }
                
                // Look for extension files matching EntityName+*.swift
                if let dirContents = try? FileManager.default.contentsOfDirectory(at: searchDir, includingPropertiesForKeys: nil) {
                    for file in dirContents {
                        let fileName = file.deletingPathExtension().lastPathComponent
                        // Check if it's an extension file for this entity
                        if file.pathExtension == "swift" && fileName.hasPrefix("\(entity.name)+") {
                            if !extensionFiles.contains(where: { $0.path == file.path }) {
                                extensionFiles.append(file)
                            }
                        }
                    }
                }
            }
            
            // Parse extension files and add their fields
            for extFile in extensionFiles {
                if let result = SwiftModelParser.parseSwiftFile(at: extFile) {
                    entityFields.append(contentsOf: result.fields)
                }
            }
            
            let outputURL = outputDir.appendingPathComponent("\(entity.name).hints")
            generateHintsFile(for: entityFields, outputURL: outputURL)
            print("✅ Generated/updated hints file: \(outputURL.path)")
            print("   Entity: \(entity.name), Found \(entityFields.count) fields")
            if !extensionFiles.isEmpty {
                print("   Extension files: \(extensionFiles.map { $0.lastPathComponent }.joined(separator: ", "))")
            }
        }
        
    } else {
        print("Error: Unsupported model file type. Supported: .swift, .xcdatamodel")
        exit(1)
    }
}

/// Generate or update a hints file for a set of fields
/// Preserves existing hints properties and field order
func generateHintsFile(for fields: [FieldInfo], outputURL: URL) {
    // Ensure output directory exists
    let outputDir = outputURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    // Load existing hints if they exist, preserving field order
    var existingHints: [String: [String: Any]]? = nil
    var existingFieldOrder: [String] = []
    
    if FileManager.default.fileExists(atPath: outputURL.path),
       let data = try? Data(contentsOf: outputURL),
       let jsonString = String(data: data, encoding: .utf8),
       let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] {
        existingHints = json
        
        // Extract field order from JSON string (fields appear in order in JSON)
        // Simple regex to find field names in order: "fieldName": {
        let fieldPattern = #""([^"]+)":\s*\{"#
        let regex = try? NSRegularExpression(pattern: fieldPattern, options: [])
        let nsString = jsonString as NSString
        let matches = regex?.matches(in: jsonString, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        for match in matches {
            if match.numberOfRanges >= 2 {
                let fieldNameRange = match.range(at: 1)
                if fieldNameRange.location != NSNotFound {
                    let fieldName = nsString.substring(with: fieldNameRange)
                    // Skip __example when tracking order (it's added at end)
                    if fieldName != "__example" && !existingFieldOrder.contains(fieldName) {
                        existingFieldOrder.append(fieldName)
                    }
                }
            }
        }
    }
    
    // Generate hints (returns both hints and field order)
    let (hints, newFieldOrder) = HintsGenerator.generateHintsJSON(
        fields: fields, 
        existingHints: existingHints
    )
    
    // Add/update __example field with all possible properties and defaults
    // This serves as documentation showing all available options
    // Always ensure it has all properties, even if it existed before
    var finalHints = hints
    finalHints["__example"] = [
        "fieldType": "string",  // string, number, boolean, date, url, uuid, document, image, custom
        "isOptional": false,
        "isArray": false,
        "defaultValue": NSNull(),  // Can be String, Int, Bool, Double, etc.
        "isHidden": false,
        "isEditable": true,  // false for computed/read-only fields
        "expectedLength": NSNull(),  // Int or null
        "displayWidth": NSNull(),  // "narrow", "medium", "wide", or numeric value
        "showCharacterCounter": false,
        "maxLength": NSNull(),  // Int or null
        "minLength": NSNull(),  // Int or null
        "expectedRange": NSNull(),  // {"min": 0.0, "max": 100.0} or null
        "metadata": [:],  // Dictionary of string key-value pairs
        "ocrHints": NSNull(),  // ["keyword1", "keyword2"] or null
        "calculationGroups": NSNull(),  // [{"id": "...", "formula": "...", ...}] or null
        "inputType": NSNull(),  // "picker", "text", etc. or null
        "pickerOptions": NSNull()  // [{"value": "...", "label": "..."}] or null
    ] as [String: Any]
    
    // Use existing field order if available, otherwise use new order
    // Always ensure __example is at the end
    let finalFieldOrder: [String] = {
        var merged: [String]
        if existingFieldOrder.isEmpty {
            // New file: use new order
            merged = newFieldOrder
        } else {
            // Existing file: merge existing order with new fields
            merged = existingFieldOrder
            for fieldName in newFieldOrder {
                if !merged.contains(fieldName) {
                    merged.append(fieldName)
                }
            }
        }
        // Always move __example to the end (remove if present, then append)
        merged.removeAll { $0 == "__example" }
        merged.append("__example")
        return merged
    }()
    
    // Write hints file (preserving field order)
    do {
        try HintsGenerator.writeHints(finalHints, to: outputURL, preserveOrder: finalFieldOrder)
    } catch {
        print("Error: Failed to write hints file \(outputURL.path): \(error)")
        exit(1)
    }
}

main()
