import Foundation
import SwiftUI

// MARK: - Dynamic Form Field Types

/// Represents a dynamic form field configuration
public struct DynamicFormField: Identifiable, Hashable {
    public let id: String
    public let type: DynamicFieldType
    public let label: String
    public let placeholder: String?
    public let isRequired: Bool
    public let validationRules: [String: String]?
    public let options: [String]? // For select/radio/checkbox fields
    public let defaultValue: String?
    public let metadata: [String: String]?
    
    public init(
        id: String,
        type: DynamicFieldType,
        label: String,
        placeholder: String? = nil,
        isRequired: Bool = false,
        validationRules: [String: String]? = nil,
        options: [String]? = nil,
        defaultValue: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.type = type
        self.label = label
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.options = options
        self.defaultValue = defaultValue
        self.metadata = metadata
    }
}

/// Types of dynamic form fields
public enum DynamicFieldType: String, CaseIterable, Hashable {
    case text = "text"
    case email = "email"
    case password = "password"
    case number = "number"
    case integer = "integer"  // High Priority: Native Int support
    case phone = "phone"
    case date = "date"
    case time = "time"
    case datetime = "datetime"
    case select = "select"
    case multiselect = "multiselect"
    case radio = "radio"
    case checkbox = "checkbox"
    case textarea = "textarea"
    case file = "file"
    case image = "image"      // High Priority: Native image support
    case url = "url"          // High Priority: Native URL support
    case color = "color"
    case range = "range"
    case toggle = "toggle"
    case richtext = "richtext"
    case autocomplete = "autocomplete"
    case array = "array"      // Medium Priority: Native array support
    case data = "data"        // Medium Priority: Native Data support
    case `enum` = "enum"      // Low Priority: Native enum support
    case custom = "custom"
    
    /// Check if field type supports options
    public var supportsOptions: Bool {
        switch self {
        case .select, .multiselect, .radio, .checkbox:
            return true
        default:
            return false
        }
    }
    
    /// Check if field type supports multiple values
    public var supportsMultipleValues: Bool {
        switch self {
        case .multiselect, .checkbox:
            return true
        default:
            return false
        }
    }
    
    /// Get the appropriate keyboard type for text input
    #if os(iOS)
    public var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .number, .range, .integer:
            return .numberPad
        case .phone:
            return .phonePad
        case .url:
            return .URL
        default:
            return .default
        }
    }
    #else
    public var keyboardType: String {
        switch self {
        case .email:
            return "emailAddress"
        case .number, .range, .integer:
            return "numberPad"
        case .phone:
            return "phonePad"
        case .url:
            return "URL"
        default:
            return "default"
        }
    }
    #endif
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
    
    /// Add a field to the current section
    public mutating func addField(
        id: String,
        type: DynamicFieldType,
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
            type: type,
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
