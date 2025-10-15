import SwiftUI

/// Main form wizard view that manages multi-step form navigation
public struct FormWizardView: View {
    @StateObject private var wizardState = FormWizardState()
    private let steps: [FormWizardStep]
    private let stepContentBuilder: (FormWizardStep, FormWizardState) -> AnyView
    private let navigationBuilder: (FormWizardState, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> AnyView
    
    public init(
        steps: [FormWizardStep],
        @ViewBuilder stepContent: @escaping (FormWizardStep, FormWizardState) -> some View,
        @ViewBuilder navigation: @escaping (FormWizardState, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> some View
    ) {
        self.steps = steps
        self.stepContentBuilder = { step, state in
            AnyView(stepContent(step, state))
        }
        self.navigationBuilder = { state, onNext, onPrevious, onComplete in
            AnyView(navigation(state, onNext, onPrevious, onComplete))
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            FormWizardProgressView(wizardState: wizardState)
                .padding()
            
            // Current step content
            if let currentStep = wizardState.getCurrentStep() {
                stepContentBuilder(currentStep, wizardState)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                FormWizardErrorView(message: "No steps available")
            }
            
            // Navigation controls
            navigationBuilder(
                wizardState,
                handleNext,
                handlePrevious,
                handleComplete
            )
            .padding()
        }
        .automaticAccessibilityIdentifiers()
        .onAppear {
            wizardState.setSteps(steps)
        }
    }
    
    // MARK: - Navigation Handlers
    
    private func handleNext() {
        if wizardState.nextStep() {
            // Step navigation successful
            if let currentStep = wizardState.getCurrentStep() {
                // Mark current step as complete if it's required
                if currentStep.isRequired {
                    wizardState.markStepComplete(currentStep.id)
                }
            }
        }
    }
    
    private func handlePrevious() {
        _ = wizardState.previousStep()
    }
    
    private func handleComplete() {
        wizardState.isComplete = true
    }
}

// MARK: - Progress View

/// Progress indicator for the form wizard
public struct FormWizardProgressView: View {
    @ObservedObject var wizardState: FormWizardState
    
    public var body: some View {
        VStack(spacing: 12) {
            // Progress bar
            ProgressView(value: progress.progressPercentage)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(y: 2)
            
            // Step indicators
            HStack(spacing: 8) {
                ForEach(Array(wizardState.steps.enumerated()), id: \.element.id) { index, step in
                    FormWizardStepIndicator(
                        step: step,
                        isCurrent: index == wizardState.currentStepIndex,
                        isCompleted: wizardState.isStepComplete(step.id)
                    )
                }
            }
            
            // Progress text
            Text("Step \(wizardState.currentStepIndex + 1) of \(wizardState.steps.count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .automaticAccessibilityIdentifiers()
    }
    
    private var progress: FormWizardProgress {
        FormWizardProgress(
            currentStep: wizardState.currentStepIndex,
            totalSteps: wizardState.steps.count,
            completedSteps: wizardState.completedSteps.count
        )
    }
}

// MARK: - Step Indicator

/// Individual step indicator in the progress view
public struct FormWizardStepIndicator: View {
    let step: FormWizardStep
    let isCurrent: Bool
    let isCompleted: Bool
    
    public var body: some View {
        VStack(spacing: 4) {
            // Step circle
            Circle()
                .fill(stepColor)
                .frame(width: 24, height: 24)
                .overlay(
                    stepIcon
                        .foregroundColor(.white)
                        .font(.caption)
                )
            
            // Step title
            Text(step.title)
                .font(.caption2)
                .foregroundColor(isCurrent ? .primary : .secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: 80)
        .automaticAccessibilityIdentifiers()
    }
    
    private var stepColor: Color {
        if isCompleted {
            return .green
        } else if isCurrent {
            return .blue
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    private var stepIcon: some View {
        if isCompleted {
            AnyView(Image(systemName: "checkmark"))
        } else {
            AnyView(Text("\(step.stepOrder + 1)")
                .fontWeight(.medium))
        }
    }
}

// MARK: - Error View

/// Error view for when wizard encounters issues
public struct FormWizardErrorView: View {
    let message: String
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Wizard Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .automaticAccessibilityIdentifiers()
    }
}

// MARK: - Preview

#Preview {
    let steps = [
        FormWizardStep(
            id: "personal",
            title: "Personal Info",
            description: "Basic information",
            stepOrder: 0
        ),
        FormWizardStep(
            id: "contact",
            title: "Contact Details",
            description: "How to reach you",
            stepOrder: 1
        ),
        FormWizardStep(
            id: "preferences",
            title: "Preferences",
            description: "Your choices",
            stepOrder: 2
        )
    ]
    
    FormWizardView(
        steps: steps,
        stepContent: { step, state in
            VStack {
                Text("Step: \(step.title)")
                Text("Description: \(step.description ?? "No description")")
                Text("Step \(step.stepOrder + 1) of \(steps.count)")
            }
            .padding()
        },
        navigation: { state, onNext, onPrevious, onComplete in
            HStack {
                if state.currentStepIndex > 0 {
                    Button("Previous") { onPrevious() }
                }
                Spacer()
                if state.currentStepIndex < state.steps.count - 1 {
                    Button("Next") { onNext() }
                } else {
                    Button("Complete") { onComplete() }
                }
            }
            .padding()
        }
    )
}
