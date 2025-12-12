import Foundation
import SwiftUI

#if canImport(Vision)
import Vision
#endif

// MARK: - Field Action Protocol

/// Protocol for field actions that can be attached to DynamicFormField
/// Actions allow adding custom functionality like barcode scanning, lookup, generate, etc.
/// 
/// BUSINESS PURPOSE: Provides extensible action system for form fields
/// DESIGN: Protocol-based for type safety, async support for long-running operations
@MainActor
public protocol FieldAction: Sendable {
    /// Unique identifier for this action
    var id: String { get }
    
    /// SF Symbol name for the action icon
    var icon: String { get }
    
    /// Display label for the action
    var label: String { get }
    
    /// Accessibility label for VoiceOver
    var accessibilityLabel: String { get }
    
    /// Accessibility hint describing what the action does
    var accessibilityHint: String { get }
    
    /// Perform the action and optionally return a new field value
    /// - Parameters:
    ///   - fieldId: The ID of the field this action is attached to
    ///   - currentValue: The current value of the field (if any)
    ///   - formState: The form state for updating field values
    /// - Returns: Optional new value to set for the field, or nil if no value update needed
    /// - Throws: Error if action fails
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any?
}

// MARK: - Built-in Field Action Types

/// Built-in field action types for common use cases
/// Provides convenient factory methods for creating standard actions
public enum BuiltInFieldAction {
    /// Barcode scanning action
    case barcodeScan(hint: String?, supportedTypes: [BarcodeType]?)
    
    /// OCR scanning action
    case ocrScan(hint: String?, validationTypes: [TextType]?)
    
    /// Lookup action (e.g., address lookup, product lookup)
    case lookup(label: String, perform: @Sendable @MainActor (String, Any?) async throws -> Any?)
    
    /// Generate action (e.g., generate ID, generate password)
    case generate(label: String, perform: @Sendable () async throws -> Any?)
    
    /// Custom action with full control
    /// Note: formState parameter is @MainActor, so this closure must be called from MainActor context
    case custom(
        id: String,
        icon: String,
        label: String,
        accessibilityLabel: String?,
        accessibilityHint: String?,
        perform: @Sendable @MainActor (String, Any?, DynamicFormState) async throws -> Any?
    )
    
    /// Create a FieldAction instance from this built-in type
    @MainActor
    public func toFieldAction() -> any FieldAction {
        switch self {
        case .barcodeScan(let hint, let supportedTypes):
            return BarcodeScanAction(hint: hint, supportedTypes: supportedTypes)
            
        case .ocrScan(let hint, let validationTypes):
            return OCRScanAction(hint: hint, validationTypes: validationTypes)
            
        case .lookup(let label, let perform):
            return LookupAction(label: label, perform: perform)
            
        case .generate(let label, let perform):
            return GenerateAction(label: label, perform: perform)
            
        case .custom(let id, let icon, let label, let accessibilityLabel, let accessibilityHint, let perform):
            return CustomFieldAction(
                id: id,
                icon: icon,
                label: label,
                accessibilityLabel: accessibilityLabel ?? label,
                accessibilityHint: accessibilityHint ?? "Performs custom action",
                perform: perform
            )
        }
    }
}

// MARK: - Built-in Action Implementations

/// Barcode scanning action implementation
@MainActor
private struct BarcodeScanAction: FieldAction {
    let id: String = "barcode-scan"
    let icon: String = "barcode.viewfinder"
    let label: String = "Scan barcode"
    let accessibilityLabel: String
    let accessibilityHint: String
    
    let hint: String?
    let supportedTypes: [BarcodeType]?
    
    init(hint: String?, supportedTypes: [BarcodeType]?) {
        self.hint = hint
        self.supportedTypes = supportedTypes
        self.accessibilityLabel = hint ?? "Scan barcode"
        self.accessibilityHint = hint ?? "Scan barcode to fill this field"
    }
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        // Barcode scanning requires UI interaction (image picker)
        // This will be handled by FieldActionRenderer presenting the scanning view
        // For now, throw a special error that the renderer can catch and handle
        throw FieldActionError.scanningRequiresUI(
            type: .barcode,
            hint: hint,
            supportedTypes: supportedTypes
        )
    }
}

/// OCR scanning action implementation
@MainActor
private struct OCRScanAction: FieldAction {
    let id: String = "ocr-scan"
    let icon: String = "camera.viewfinder"
    let label: String = "Scan with OCR"
    let accessibilityLabel: String
    let accessibilityHint: String
    
    let hint: String?
    let validationTypes: [TextType]?
    
    init(hint: String?, validationTypes: [TextType]?) {
        self.hint = hint
        self.validationTypes = validationTypes
        self.accessibilityLabel = hint ?? "Scan with OCR"
        self.accessibilityHint = hint ?? "Scan document to fill this field"
    }
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        // OCR scanning requires UI interaction (image picker + overlay)
        // This will be handled by FieldActionRenderer presenting the scanning view
        // For now, throw a special error that the renderer can catch and handle
        throw FieldActionError.scanningRequiresUI(
            type: .ocr,
            hint: hint,
            validationTypes: validationTypes
        )
    }
}

/// Lookup action implementation
@MainActor
private struct LookupAction: FieldAction {
    let id: String = "lookup"
    let icon: String = "magnifyingglass"
    let label: String
    let accessibilityLabel: String
    let accessibilityHint: String = "Look up a value for this field"
    
    let perform: @Sendable @MainActor (String, Any?) async throws -> Any?
    
    init(label: String, perform: @Sendable @MainActor @escaping (String, Any?) async throws -> Any?) {
        self.label = label
        self.accessibilityLabel = label
        self.perform = perform
    }
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        return try await perform(fieldId, currentValue)
    }
}

/// Generate action implementation
@MainActor
private struct GenerateAction: FieldAction {
    let id: String = "generate"
    let icon: String = "sparkles"
    let label: String
    let accessibilityLabel: String
    let accessibilityHint: String = "Generate a value for this field"
    
    let perform: @Sendable () async throws -> Any?
    
    init(label: String, perform: @Sendable @escaping () async throws -> Any?) {
        self.label = label
        self.accessibilityLabel = label
        self.perform = perform
    }
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        return try await perform()
    }
}

/// Custom field action implementation
@MainActor
private struct CustomFieldAction: FieldAction {
    let id: String
    let icon: String
    let label: String
    let accessibilityLabel: String
    let accessibilityHint: String
    
    let perform: @Sendable @MainActor (String, Any?, DynamicFormState) async throws -> Any?
    
    init(
        id: String,
        icon: String,
        label: String,
        accessibilityLabel: String,
        accessibilityHint: String,
        perform: @Sendable @MainActor @escaping (String, Any?, DynamicFormState) async throws -> Any?
    ) {
        self.id = id
        self.icon = icon
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.perform = perform
    }
    
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any? {
        return try await perform(fieldId, currentValue, formState)
    }
}

// MARK: - Field Action Errors

/// Errors specific to field actions
public enum FieldActionError: Error, LocalizedError {
    case scanningRequiresUI(
        type: ScanningType,
        hint: String?,
        supportedTypes: [BarcodeType]? = nil,
        validationTypes: [TextType]? = nil
    )
    
    public enum ScanningType {
        case barcode
        case ocr
    }
    
    public var errorDescription: String? {
        let i18n = InternationalizationService()
        switch self {
        case .scanningRequiresUI(let type, let hint, _, _):
            if let hint = hint {
                return hint
            }
            let key = type == .barcode ? "SixLayerFramework.fieldAction.barcodeScanningRequiresUI" : "SixLayerFramework.fieldAction.ocrScanningRequiresUI"
            return i18n.localizedString(for: key)
        }
    }
}
