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

/// Generic form field for form handling
public struct GenericFormField: Identifiable {
    public let id = UUID()
    public let label: String
    public let placeholder: String?
    public let value: String
    public let isRequired: Bool
    public let fieldType: FormFieldType
    
    public init(
        label: String,
        placeholder: String? = nil,
        value: String = "",
        isRequired: Bool = false,
        fieldType: FormFieldType = .text
    ) {
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.isRequired = isRequired
        self.fieldType = fieldType
    }
}

// MARK: - Form Field Type

/// Types of form fields
public enum FormFieldType: String, CaseIterable {
    case text = "text"
    case email = "email"
    case password = "password"
    case number = "number"
    case date = "date"
    case select = "select"
    case textarea = "textarea"
    case checkbox = "checkbox"
    case radio = "radio"
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
