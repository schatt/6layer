import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Cross-Platform Text Content Types

/// Cross-platform text content type enum that maps to UITextContentType on iOS/Mac Catalyst
/// and provides equivalent functionality on native macOS
public enum SixLayerTextContentType: String, CaseIterable, Hashable {
    // Person Names and Name Parts
    case name = "name"
    case namePrefix = "namePrefix"
    case givenName = "givenName"
    case middleName = "middleName"
    case familyName = "familyName"
    case nameSuffix = "nameSuffix"
    
    // Job/Work Information
    case jobTitle = "jobTitle"
    case organizationName = "organizationName"
    
    // Contact Information
    case emailAddress = "emailAddress"
    case telephoneNumber = "telephoneNumber"
    
    // Credentials/Login Information
    case username = "username"
    case password = "password"
    case newPassword = "newPassword"
    case oneTimeCode = "oneTimeCode"
    
    // Location/Address
    case location = "location"
    case fullStreetAddress = "fullStreetAddress"
    case streetAddressLine1 = "streetAddressLine1"
    case streetAddressLine2 = "streetAddressLine2"
    case addressCity = "addressCity"
    case addressState = "addressState"
    case addressCityAndState = "addressCityAndState"
    case sublocality = "sublocality"
    case countryName = "countryName"
    case postalCode = "postalCode"
    
    // URL and Credit Card Number
    case URL = "URL"
    case creditCardNumber = "creditCardNumber"
    
    #if canImport(UIKit)
    /// Convert to UITextContentType for iOS/Mac Catalyst
    public var uiTextContentType: UITextContentType {
        switch self {
        case .name: return .name
        case .namePrefix: return .namePrefix
        case .givenName: return .givenName
        case .middleName: return .middleName
        case .familyName: return .familyName
        case .nameSuffix: return .nameSuffix
        case .jobTitle: return .jobTitle
        case .organizationName: return .organizationName
        case .emailAddress: return .emailAddress
        case .telephoneNumber: return .telephoneNumber
        case .username: return .username
        case .password: return .password
        case .newPassword: return .newPassword
        case .oneTimeCode: return .oneTimeCode
        case .location: return .location
        case .fullStreetAddress: return .fullStreetAddress
        case .streetAddressLine1: return .streetAddressLine1
        case .streetAddressLine2: return .streetAddressLine2
        case .addressCity: return .addressCity
        case .addressState: return .addressState
        case .addressCityAndState: return .addressCityAndState
        case .sublocality: return .sublocality
        case .countryName: return .countryName
        case .postalCode: return .postalCode
        case .URL: return .URL
        case .creditCardNumber: return .creditCardNumber
        }
    }
    
    /// Create from UITextContentType
    public init(_ uiTextContentType: UITextContentType) {
        switch uiTextContentType {
        case .name: self = .name
        case .namePrefix: self = .namePrefix
        case .givenName: self = .givenName
        case .middleName: self = .middleName
        case .familyName: self = .familyName
        case .nameSuffix: self = .nameSuffix
        case .jobTitle: self = .jobTitle
        case .organizationName: self = .organizationName
        case .emailAddress: self = .emailAddress
        case .telephoneNumber: self = .telephoneNumber
        case .username: self = .username
        case .password: self = .password
        case .newPassword: self = .newPassword
        case .oneTimeCode: self = .oneTimeCode
        case .location: self = .location
        case .fullStreetAddress: self = .fullStreetAddress
        case .streetAddressLine1: self = .streetAddressLine1
        case .streetAddressLine2: self = .streetAddressLine2
        case .addressCity: self = .addressCity
        case .addressState: self = .addressState
        case .addressCityAndState: self = .addressCityAndState
        case .sublocality: self = .sublocality
        case .countryName: self = .countryName
        case .postalCode: self = .postalCode
        case .URL: self = .URL
        case .creditCardNumber: self = .creditCardNumber
        }
    }
    #endif
    
    /// Get string representation for native macOS
    public var stringValue: String {
        return self.rawValue
    }
}

// MARK: - Dynamic Form Field Types

/// Represents a dynamic form field configuration
public struct DynamicFormField: Identifiable, Hashable {
    public let id: String
    public let textContentType: SixLayerTextContentType?  // Cross-platform text content type
    public let contentType: DynamicContentType?      // Our custom enum for UI components
    public let label: String
    public let placeholder: String?
    public let description: String? // Help text for the field
    public let isRequired: Bool
    public let validationRules: [String: String]?
    public let options: [String]? // For select/radio/checkbox fields
    public let defaultValue: String?
    public let metadata: [String: String]?
    
    public init(
        id: String,
        textContentType: SixLayerTextContentType? = nil,
        contentType: DynamicContentType? = nil,
        label: String,
        placeholder: String? = nil,
        description: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        options: [String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.textContentType = textContentType
        self.contentType = contentType
        self.label = label
        self.placeholder = placeholder
        self.description = description
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.options = options
        self.defaultValue = defaultValue
        self.metadata = metadata
    }
    
    /// Convenience initializer for text fields using cross-platform text content type
    public init(
        id: String,
        textContentType: SixLayerTextContentType,
        label: String,
        placeholder: String? = nil,
        description: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.init(
            id: id,
            textContentType: textContentType,
            contentType: nil,
            label: label,
            placeholder: placeholder,
            description: description,
            isRequired: isRequired,
            validationRules: validationRules,
            options: nil,
            defaultValue: defaultValue,
            metadata: metadata
        )
    }
    
    /// Convenience initializer for UI components using our custom DynamicContentType
    public init(
        id: String,
        contentType: DynamicContentType,
        label: String,
        placeholder: String? = nil,
        description: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        options: [String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.init(
            id: id,
            textContentType: nil,
            contentType: contentType,
            label: label,
            placeholder: placeholder,
            description: description,
            isRequired: isRequired,
            validationRules: validationRules,
            options: options,
            defaultValue: defaultValue,
            metadata: metadata
        )
    }
}

/// Custom content types for non-text UI components
public enum DynamicContentType: String, CaseIterable, Hashable {
    case text = "text"               // Basic text input
    case email = "email"             // Email input
    case password = "password"       // Password input
    case phone = "phone"             // Phone number input
    case url = "url"                 // URL input
    case number = "number"           // Number input with validation
    case integer = "integer"         // Integer input
    case date = "date"               // Date picker
    case time = "time"               // Time picker
    case datetime = "datetime"       // Date & time picker
    case select = "select"           // Dropdown picker
    case multiselect = "multiselect" // Multi-select picker
    case radio = "radio"             // Radio buttons
    case checkbox = "checkbox"       // Checkboxes
    case textarea = "textarea"       // Multi-line text
    case richtext = "richtext"       // Rich text editor
    case file = "file"               // File picker
    case image = "image"             // Image picker
    case color = "color"             // Color picker
    case range = "range"             // Slider
    case toggle = "toggle"           // Toggle switch
    case array = "array"             // Array input
    case data = "data"               // Data input
    case autocomplete = "autocomplete" // Autocomplete field
    case `enum` = "enum"             // Enum picker
    case custom = "custom"            // Custom component
    
    /// Check if content type supports options
    public var supportsOptions: Bool {
        switch self {
        case .select, .multiselect, .radio, .checkbox:
            return true
        default:
            return false
        }
    }
    
    /// Check if content type supports multiple values
    public var supportsMultipleValues: Bool {
        switch self {
        case .multiselect, .checkbox:
            return true
        default:
            return false
        }
    }
}

// MARK: - Dynamic Form Section

/// Represents a section in a dynamic form
public struct DynamicFormSection: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String?
    public var fields: [DynamicFormField]
    public let isCollapsible: Bool
    public let isCollapsed: Bool
    public let metadata: [String: String]?
    
    public init(
        id: String,
        title: String,
        description: String? = nil,
        fields: [DynamicFormField] = [],
        isCollapsible: Bool = false,
        isCollapsed: Bool = false,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.fields = fields
        self.isCollapsible = isCollapsible
        self.isCollapsed = isCollapsed
        self.metadata = metadata
    }
}

// MARK: - Dynamic Form Configuration

/// Complete configuration for a dynamic form
public struct DynamicFormConfiguration: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String?
    public let sections: [DynamicFormSection]
    public let submitButtonText: String
    public let cancelButtonText: String?
    public let metadata: [String: String]?
    
    public init(
        id: String,
        title: String,
        description: String? = nil,
        sections: [DynamicFormSection] = [],
        submitButtonText: String = "Submit",
        cancelButtonText: String? = "Cancel",
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.sections = sections
        self.submitButtonText = submitButtonText
        self.cancelButtonText = cancelButtonText
        self.metadata = metadata
    }
    
    /// Get all fields from all sections
    public var allFields: [DynamicFormField] {
        return sections.flatMap { $0.fields }
    }
    
    /// Get field by ID
        func getField(by id: String) -> DynamicFormField? {
        return allFields.first { $0.id == id }
    }
    
    /// Get section by ID
        func getSection(by id: String) -> DynamicFormSection? {
        return sections.first { $0.id == id }
    }
}

// MARK: - Dynamic Form State

/// State management for dynamic forms
public class DynamicFormState: ObservableObject {
    @Published public var fieldValues: [String: Any] = [:]
    @Published public var fieldErrors: [String: [String]] = [:]
    @Published public var sectionStates: [String: Bool] = [:] // collapsed state
    @Published public var isSubmitting: Bool = false
    @Published public var isDirty: Bool = false
    
    private let configuration: DynamicFormConfiguration
    
    public init(configuration: DynamicFormConfiguration) {
        self.configuration = configuration
        setupInitialState()
    }
    
    /// Get value for a specific field
    public func getValue<T>(for fieldId: String) -> T? {
        return fieldValues[fieldId] as? T
    }
    
    /// Set value for a specific field
    public func setValue<T>(_ value: T, for fieldId: String) {
        fieldValues[fieldId] = value
        isDirty = true
        clearErrors(for: fieldId)
    }
    
    /// Check if field has errors
    public func hasErrors(for fieldId: String) -> Bool {
        return !(fieldErrors[fieldId]?.isEmpty ?? true)
    }
    
    /// Get errors for a specific field
    public func getErrors(for fieldId: String) -> [String] {
        return fieldErrors[fieldId] ?? []
    }
    
    /// Add error for a specific field
    public func addError(_ error: String, for fieldId: String) {
        if fieldErrors[fieldId] == nil {
            fieldErrors[fieldId] = []
        }
        fieldErrors[fieldId]?.append(error)
    }
    
    /// Clear errors for a specific field
    public func clearErrors(for fieldId: String) {
        fieldErrors.removeValue(forKey: fieldId)
    }
    
    /// Clear all errors
    public func clearAllErrors() {
        fieldErrors.removeAll()
    }
    
    /// Check if section is collapsed
    public func isSectionCollapsed(_ sectionId: String) -> Bool {
        return sectionStates[sectionId] ?? false
    }
    
    /// Toggle section collapsed state
    public func toggleSection(_ sectionId: String) {
        sectionStates[sectionId] = !isSectionCollapsed(sectionId)
    }
    
    /// Check if form is valid
    public var isValid: Bool {
        return fieldErrors.values.allSatisfy { $0.isEmpty }
    }
    
    /// Reset form to initial state
    public func reset() {
        fieldValues.removeAll()
        fieldErrors.removeAll()
        sectionStates.removeAll()
        isDirty = false
        setupInitialState()
    }
    
    /// Get form data as dictionary
    public var formData: [String: Any] {
        return fieldValues
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        // Set default values
        for field in configuration.allFields {
            if let defaultValue = field.defaultValue {
                fieldValues[field.id] = defaultValue
            }
        }
        
        // Set initial section states
        for section in configuration.sections {
            sectionStates[section.id] = section.isCollapsed
        }
    }
}

// MARK: - Dynamic Form Builder

/// Builder for creating dynamic form configurations
public struct DynamicFormBuilder {
    private var sections: [DynamicFormSection] = []
    private var currentSection: DynamicFormSection?
    
    public init() {}
    
    /// Start a new section
    public mutating func startSection(
        id: String,
        title: String,
        description: String? = nil,
        isCollapsible: Bool = false,
        isCollapsed: Bool = false
    ) {
        // Complete previous section if exists
        if let section = currentSection {
            sections.append(section)
        }
        
        currentSection = DynamicFormSection(
            id: id,
            title: title,
            description: description,
            isCollapsible: isCollapsible,
            isCollapsed: isCollapsed
        )
    }
    
    /// Add a text field using cross-platform text content type
    public mutating func addTextField(
        id: String,
        textContentType: SixLayerTextContentType,
        label: String,
        placeholder: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        if currentSection == nil {
            // Create default section if none exists
            currentSection = DynamicFormSection(
                id: "default",
                title: "Form Fields",
                fields: []
            )
        }
        
        let field = DynamicFormField(
            id: id,
            textContentType: textContentType,
            label: label,
            placeholder: placeholder,
            isRequired: isRequired,
            validationRules: validationRules,
            defaultValue: defaultValue,
            metadata: metadata
        )
        
        currentSection?.fields.append(field)
    }
    
    /// Add a UI component using our custom DynamicContentType
    public mutating func addContentField(
        id: String,
        contentType: DynamicContentType,
        label: String,
        placeholder: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        options: [String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        if currentSection == nil {
            // Create default section if none exists
            currentSection = DynamicFormSection(
                id: "default",
                title: "Form Fields",
                fields: []
            )
        }
        
        let field = DynamicFormField(
            id: id,
            contentType: contentType,
            label: label,
            placeholder: placeholder,
            isRequired: isRequired,
            validationRules: validationRules,
            options: options,
            defaultValue: defaultValue,
            metadata: metadata
        )
        
        currentSection?.fields.append(field)
    }
    
    /// Complete the current section
    public mutating func endSection() {
        if let section = currentSection {
            sections.append(section)
            currentSection = nil
        }
    }
    
    /// Build the form configuration
    public mutating func build(
        id: String,
        title: String,
        description: String? = nil,
        submitButtonText: String = "Submit",
        cancelButtonText: String? = "Cancel"
    ) -> DynamicFormConfiguration {
        // Complete any remaining section
        if let section = currentSection {
            sections.append(section)
        }
        
        return DynamicFormConfiguration(
            id: id,
            title: title,
            description: description,
            sections: sections,
            submitButtonText: submitButtonText,
            cancelButtonText: cancelButtonText
        )
    }
}