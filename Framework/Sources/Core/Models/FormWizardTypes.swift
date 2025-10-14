import Foundation
import SwiftUI

// MARK: - Form Wizard Core Types

/// Represents a single step in a multi-step form wizard
public struct FormWizardStep: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String?
    public let isRequired: Bool
    public let validationRules: [String: String]?
    public let stepOrder: Int
    
    public init(
        id: String,
        title: String,
        description: String? = nil,
        isRequired: Bool = true,
        validationRules: [String: String]? = nil,
        stepOrder: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isRequired = isRequired
        self.validationRules = validationRules
        self.stepOrder = stepOrder
    }
}

/// Represents the current state of a form wizard
public class FormWizardState: ObservableObject {
    @Published public var currentStepIndex: Int = 0
    @Published public var completedSteps: Set<String> = []
    @Published public var stepData: [String: Any] = [:]
    @Published public var validationErrors: [String: [String]] = [:]
    @Published public var isComplete: Bool = false
    
    public init() {}
    
    /// Move to the next step if validation passes
        func nextStep() -> Bool {
        guard canProceedToNextStep() else { return false }
        
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
            return true
        } else {
            isComplete = true
            return true
        }
    }
    
    /// Move to the previous step
        func previousStep() -> Bool {
        guard currentStepIndex > 0 else { return false }
        currentStepIndex -= 1
        return true
    }
    
    /// Check if we can proceed to the next step
        func canProceedToNextStep() -> Bool {
        guard let currentStep = getCurrentStep() else { return false }
        
        // Check if current step is complete
        if currentStep.isRequired {
            return isStepComplete(currentStep.id)
        }
        return true
    }
    
    /// Check if a specific step is complete
        func isStepComplete(_ stepId: String) -> Bool {
        return completedSteps.contains(stepId)
    }
    
    /// Mark a step as complete
        func markStepComplete(_ stepId: String) {
        completedSteps.insert(stepId)
    }
    
    /// Get the current step
        func getCurrentStep() -> FormWizardStep? {
        guard currentStepIndex < steps.count else { return nil }
        return steps[currentStepIndex]
    }
    
    /// Get all steps (to be set by the wizard)
    public var steps: [FormWizardStep] = []
    
    /// Set the steps for this wizard
        func setSteps(_ newSteps: [FormWizardStep]) {
        steps = newSteps.sorted { $0.stepOrder < $1.stepOrder }
    }
    
    /// Get step data for a specific step
        func getStepData<T>(_ stepId: String, key: String) -> T? {
        let stepKey = "\(stepId).\(key)"
        return stepData[stepKey] as? T
    }
    
    /// Set step data for a specific step
        func setStepData<T>(_ stepId: String, key: String, value: T) {
        let stepKey = "\(stepId).\(key)"
        stepData[stepKey] = value
    }
    
    /// Clear validation errors for a step
        func clearValidationErrors(for stepId: String) {
        validationErrors.removeValue(forKey: stepId)
    }
    
    /// Add validation error for a step
        func addValidationError(_ error: String, for stepId: String) {
        if validationErrors[stepId] == nil {
            validationErrors[stepId] = []
        }
        validationErrors[stepId]?.append(error)
    }
}

/// Protocol for form wizard step content
public protocol FormWizardStepContent: View {}

/// Protocol for form wizard navigation
public protocol FormWizardNavigation: View {}

// MARK: - Form Wizard Builder

/// Builder for creating form wizard configurations
public struct FormWizardBuilder {
    private var steps: [FormWizardStep] = []
    
    public init() {}
    
    /// Add a step to the wizard
    public mutating func addStep(
        id: String,
        title: String,
        description: String? = nil,
        isRequired: Bool = true,
        validationRules: [String: String]? = nil
    ) {
        let step = FormWizardStep(
            id: id,
            title: title,
            description: description,
            isRequired: isRequired,
            validationRules: validationRules,
            stepOrder: steps.count
        )
        steps.append(step)
    }
    
    /// Build the wizard configuration
        func build() -> [FormWizardStep] {
        return steps
    }
}

// MARK: - Form Wizard Progress

/// Represents the progress through a form wizard
public struct FormWizardProgress {
    public let currentStep: Int
    public let totalSteps: Int
    public let completedSteps: Int
    public let progressPercentage: Double
    
    public init(currentStep: Int, totalSteps: Int, completedSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.completedSteps = completedSteps
        self.progressPercentage = totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) : 0.0
    }
    
    /// Check if wizard is complete
    public var isComplete: Bool {
        return completedSteps == totalSteps
    }
    
    /// Check if wizard is on first step
    public var isFirstStep: Bool {
        return currentStep == 0
    }
    
    /// Check if wizard is on last step
    public var isLastStep: Bool {
        return currentStep == totalSteps - 1
    }
}
