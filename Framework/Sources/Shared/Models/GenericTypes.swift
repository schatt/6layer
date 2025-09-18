//
//  GenericTypes.swift
//  SixLayerFramework
//
//  Generic types to replace CarManager-specific business logic
//

import Foundation
import SwiftUI

// MARK: - Generic Vehicle Type

/// Generic vehicle type for demonstration and testing purposes
/// This replaces the CarManager-specific Vehicle type
public struct GenericVehicle: Identifiable, Hashable {
    public let id = UUID()
    public let name: String
    public let description: String
    public let type: VehicleType
    
    public init(name: String, description: String, type: VehicleType = .generic) {
        self.name = name
        self.description = description
        self.type = type
    }
    
        public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: GenericVehicle, rhs: GenericVehicle) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Vehicle Type Enumeration

/// Generic vehicle types for categorization
public enum VehicleType: String, CaseIterable {
    case generic = "Generic"
    case car = "Car"
    case truck = "Truck"
    case motorcycle = "Motorcycle"
    case boat = "Boat"
    case aircraft = "Aircraft"
    case other = "Other"
}

// MARK: - Generic Data Types

/// Generic data item for collections
public struct GenericDataItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let data: [String: Any]
    
    public init(title: String, subtitle: String? = nil, data: [String: Any] = [:]) {
        self.title = title
        self.subtitle = subtitle
        self.data = data
    }
    
        public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: GenericDataItem, rhs: GenericDataItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Generic Form Field

/// Generic form field for form handling with binding support
public struct GenericFormField: Identifiable {
    public let id = UUID()
    public let label: String
    public let placeholder: String?
    public let isRequired: Bool
    public let fieldType: DynamicFieldType
    public let validationRules: [ValidationRule]
    public let options: [String] // For select, radio, multiselect fields
    public let maxLength: Int?
    public let minLength: Int?
    
    // Binding for two-way data binding
    @Binding public var value: String
    
    public init(
        label: String,
        placeholder: String? = nil,
        value: Binding<String>,
        isRequired: Bool = false,
        fieldType: DynamicFieldType = .text,
        validationRules: [ValidationRule] = [],
        options: [String] = [],
        maxLength: Int? = nil,
        minLength: Int? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._value = value
        self.isRequired = isRequired
        self.fieldType = fieldType
        self.validationRules = validationRules
        self.options = options
        self.maxLength = maxLength
        self.minLength = minLength
    }
}

// MARK: - Validation Rule

/// Form field validation rule
public struct ValidationRule {
    public let rule: ValidationRuleType
    public let message: String
    public let customValidator: ((String) -> Bool)?
    
    public init(
        rule: ValidationRuleType,
        message: String,
        customValidator: ((String) -> Bool)? = nil
    ) {
        self.rule = rule
        self.message = message
        self.customValidator = customValidator
    }
}

// MARK: - Validation Rule Types

public enum ValidationRuleType {
    case required
    case email
    case phone
    case url
    case minLength(Int)
    case maxLength(Int)
    case pattern(String) // Regex pattern
    case custom((String) -> Bool)
}

// MARK: - Form Validation Result

public struct FormValidationResult {
    public let isValid: Bool
    public let errors: [String: String] // fieldId: errorMessage
    
    public init(isValid: Bool, errors: [String: String] = [:]) {
        self.isValid = isValid
        self.errors = errors
    }
}


// MARK: - Generic Media Item

/// Generic media item for media collections
public struct GenericMediaItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String?
    public let mediaType: MediaType
    public let url: URL?
    
    public init(
        title: String,
        description: String? = nil,
        mediaType: MediaType = .image,
        url: URL? = nil
    ) {
        self.title = title
        self.description = description
        self.mediaType = mediaType
        self.url = url
    }
}

// MARK: - Media Type

/// Types of media
public enum MediaType: String, CaseIterable {
    case image = "image"
    case video = "video"
    case audio = "audio"
    case document = "document"
    case other = "other"
}

// MARK: - Generic Temporal Data

/// Generic temporal data for date-based collections
public struct GenericTemporalData: Identifiable {
    public let id = UUID()
    public let title: String
    public let date: Date
    public let description: String?
    public let data: [String: Any]
    
    public init(
        title: String,
        date: Date,
        description: String? = nil,
        data: [String: Any] = [:]
    ) {
        self.title = title
        self.date = date
        self.description = description
        self.data = data
    }
}

// MARK: - Generic Hierarchical Data

/// Generic hierarchical data for tree-like structures
public struct GenericHierarchicalData: Identifiable {
    public let id = UUID()
    public let title: String
    public let children: [GenericHierarchicalData]
    public let data: [String: Any]
    
    public init(
        title: String,
        children: [GenericHierarchicalData] = [],
        data: [String: Any] = [:]
    ) {
        self.title = title
        self.children = children
        self.data = data
    }
}

// MARK: - Generic Numeric Data

/// Generic numeric data for charts and analytics
public struct GenericNumericData: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: Double
    public let unit: String?
    public let metadata: [String: Any]
    
    public init(
        label: String,
        value: Double,
        unit: String? = nil,
        metadata: [String: Any] = [:]
    ) {
        self.label = label
        self.value = value
        self.unit = unit
        self.metadata = metadata
    }
}

// MARK: - Generic Hierarchical Item

/// Generic hierarchical item for tree-like structures
public struct GenericHierarchicalItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let children: [GenericHierarchicalItem]
    public let data: [String: Any]
    
    public init(
        title: String,
        children: [GenericHierarchicalItem] = [],
        data: [String: Any] = [:]
    ) {
        self.title = title
        self.children = children
        self.data = data
    }
}

// MARK: - Generic Temporal Item

/// Generic temporal item for date-based collections
public struct GenericTemporalItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let date: Date
    public let description: String?
    public let data: [String: Any]
    
    public init(
        title: String,
        date: Date,
        description: String? = nil,
        data: [String: Any] = [:]
    ) {
        self.title = title
        self.date = date
        self.description = description
        self.data = data
    }
}
