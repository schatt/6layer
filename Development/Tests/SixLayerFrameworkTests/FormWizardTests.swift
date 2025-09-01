import XCTest
@testable import SixLayerFramework

@MainActor
final class FormWizardTests: XCTestCase {
    
    // MARK: - Form Wizard Step Tests
    
    func testFormWizardStepCreation() {
        let step = FormWizardStep(
            id: "personal",
            title: "Personal Information",
            description: "Basic details about you",
            isRequired: true,
            validationRules: ["minLength": "2"],
            stepOrder: 0
        )
        
        XCTAssertEqual(step.id, "personal")
        XCTAssertEqual(step.title, "Personal Information")
        XCTAssertEqual(step.description, "Basic details about you")
        XCTAssertTrue(step.isRequired)
        XCTAssertEqual(step.validationRules?["minLength"], "2")
        XCTAssertEqual(step.stepOrder, 0)
    }
    
    func testFormWizardStepEquality() {
        let step1 = FormWizardStep(
            id: "step1",
            title: "First Step",
            stepOrder: 0
        )
        
        let step2 = FormWizardStep(
            id: "step1",
            title: "First Step",
            stepOrder: 0
        )
        
        let step3 = FormWizardStep(
            id: "step2",
            title: "Second Step",
            stepOrder: 1
        )
        
        XCTAssertEqual(step1, step2)
        XCTAssertNotEqual(step1, step3)
    }
    
    func testFormWizardStepHashable() {
        let step = FormWizardStep(
            id: "testStep",
            title: "Test Step",
            stepOrder: 0
        )
        
        let stepSet: Set<FormWizardStep> = [step]
        XCTAssertEqual(stepSet.count, 1)
        XCTAssertTrue(stepSet.contains(step))
    }
    
    // MARK: - Form Wizard Builder Tests
    
    func testFormWizardBuilderCreatesSteps() {
        var builder = FormWizardBuilder()
        builder.addStep(id: "step1", title: "First Step")
        builder.addStep(id: "step2", title: "Second Step")
        let steps = builder.build()
        
        XCTAssertEqual(steps.count, 2)
        XCTAssertEqual(steps[0].id, "step1")
        XCTAssertEqual(steps[0].title, "First Step")
        XCTAssertEqual(steps[0].stepOrder, 0)
        XCTAssertEqual(steps[1].id, "step2")
        XCTAssertEqual(steps[1].title, "Second Step")
        XCTAssertEqual(steps[1].stepOrder, 1)
    }
    
    func testFormWizardBuilderWithDescription() {
        var builder = FormWizardBuilder()
        builder.addStep(
            id: "step1",
            title: "First Step",
            description: "Description for first step"
        )
        let steps = builder.build()
        
        XCTAssertEqual(steps.count, 1)
        XCTAssertEqual(steps[0].description, "Description for first step")
    }
    
    func testFormWizardBuilderWithValidation() {
        let validationRules = ["minLength": "3", "maxLength": "50"]
        
        var builder = FormWizardBuilder()
        builder.addStep(
            id: "step1",
            title: "First Step",
            validationRules: validationRules
        )
        let steps = builder.build()
        
        XCTAssertEqual(steps.count, 1)
        XCTAssertEqual(steps[0].validationRules?["minLength"], "3")
        XCTAssertEqual(steps[0].validationRules?["maxLength"], "50")
    }
    
    func testFormWizardBuilderWithRequiredFlag() {
        var builder = FormWizardBuilder()
        builder.addStep(
            id: "step1",
            title: "First Step",
            isRequired: false
        )
        let steps = builder.build()
        
        XCTAssertEqual(steps.count, 1)
        XCTAssertFalse(steps[0].isRequired)
    }
    
    // MARK: - Form Wizard State Tests
    
    func testFormWizardStateInitialization() {
        let state = FormWizardState()
        
        XCTAssertEqual(state.currentStepIndex, 0)
        XCTAssertEqual(state.completedSteps.count, 0)
        XCTAssertEqual(state.stepData.count, 0)
        XCTAssertEqual(state.validationErrors.count, 0)
        XCTAssertFalse(state.isComplete)
    }
    
    func testFormWizardStateStepManagement() {
        let state = FormWizardState()
        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", stepOrder: 0),
            FormWizardStep(id: "step2", title: "Step 2", stepOrder: 1),
            FormWizardStep(id: "step3", title: "Step 3", stepOrder: 2)
        ]
        
        state.setSteps(steps)
        
        XCTAssertEqual(state.steps.count, 3)
        XCTAssertEqual(state.getCurrentStep()?.id, "step1")
        XCTAssertEqual(state.getCurrentStep()?.title, "Step 1")
    }
    
    func testFormWizardStateNavigation() {
        let state = FormWizardState()
        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", stepOrder: 0),
            FormWizardStep(id: "step2", title: "Step 2", stepOrder: 1),
            FormWizardStep(id: "step3", title: "Step 3", stepOrder: 2)
        ]
        
        state.setSteps(steps)
        
        // Initially at first step
        XCTAssertEqual(state.currentStepIndex, 0)
        XCTAssertEqual(state.getCurrentStep()?.id, "step1")
        
        // Mark first step as complete (since it's required by default)
        state.markStepComplete("step1")
        
        // Test next step
        XCTAssertTrue(state.nextStep())
        XCTAssertEqual(state.currentStepIndex, 1)
        XCTAssertEqual(state.getCurrentStep()?.id, "step2")
        
        // Mark second step as complete
        state.markStepComplete("step2")
        
        // Test previous step
        XCTAssertTrue(state.previousStep())
        XCTAssertEqual(state.currentStepIndex, 0)
        XCTAssertEqual(state.getCurrentStep()?.id, "step1")
        
        // Go back to second step
        XCTAssertTrue(state.nextStep())
        XCTAssertEqual(state.currentStepIndex, 1)
        
        // Go to third step
        XCTAssertTrue(state.nextStep())
        XCTAssertEqual(state.currentStepIndex, 2)
        XCTAssertEqual(state.getCurrentStep()?.id, "step3")
        
        // Mark third step as complete
        state.markStepComplete("step3")
        
        // Complete wizard
        XCTAssertTrue(state.nextStep())
        XCTAssertTrue(state.isComplete)
    }
    
    func testFormWizardStateStepCompletion() {
        let state = FormWizardState()
        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", isRequired: true, stepOrder: 0),
            FormWizardStep(id: "step2", title: "Step 2", isRequired: false, stepOrder: 1)
        ]
        
        state.setSteps(steps)
        
        // Initially no steps are complete
        XCTAssertFalse(state.isStepComplete("step1"))
        XCTAssertFalse(state.isStepComplete("step2"))
        
        // Mark step as complete
        state.markStepComplete("step1")
        XCTAssertTrue(state.isStepComplete("step1"))
        XCTAssertFalse(state.isStepComplete("step2"))
    }
    
    func testFormWizardStateValidation() {
        let state = FormWizardState()
        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", isRequired: true, stepOrder: 0)
        ]
        
        state.setSteps(steps)
        
        // Initially can't proceed (required step not complete)
        XCTAssertFalse(state.canProceedToNextStep())
        
        // Mark step as complete
        state.markStepComplete("step1")
        XCTAssertTrue(state.canProceedToNextStep())
    }
    
    func testFormWizardStateDataManagement() {
        let state = FormWizardState()
        
        // Test setting and getting step data
        state.setStepData("step1", key: "name", value: "John")
        state.setStepData("step1", key: "age", value: 25)
        
        XCTAssertEqual(state.getStepData("step1", key: "name") as String?, "John")
        XCTAssertEqual(state.getStepData("step1", key: "age") as Int?, 25)
        XCTAssertNil(state.getStepData("step1", key: "nonexistent") as String?)
    }
    
    func testFormWizardStateValidationErrors() {
        let state = FormWizardState()
        
        // Test validation error management
        state.addValidationError("Name is required", for: "step1")
        state.addValidationError("Name is too short", for: "step1")
        
        // Test error retrieval
        let errors = state.validationErrors["step1"] ?? []
        XCTAssertEqual(errors.count, 2)
        XCTAssertTrue(errors.contains("Name is required"))
        XCTAssertTrue(errors.contains("Name is too short"))
        
        // Test clearing errors
        state.clearValidationErrors(for: "step1")
        XCTAssertEqual(state.validationErrors["step1"]?.count ?? 0, 0)
    }
    
    // MARK: - Form Wizard Progress Tests
    
    func testFormWizardProgressCreation() {
        let progress = FormWizardProgress(
            currentStep: 2,
            totalSteps: 5,
            completedSteps: 3
        )
        
        XCTAssertEqual(progress.currentStep, 2)
        XCTAssertEqual(progress.totalSteps, 5)
        XCTAssertEqual(progress.completedSteps, 3)
        XCTAssertEqual(progress.progressPercentage, 0.6, accuracy: 0.01)
    }
    
    func testFormWizardProgressHelpers() {
        let progress = FormWizardProgress(
            currentStep: 0,
            totalSteps: 3,
            completedSteps: 0
        )
        
        XCTAssertTrue(progress.isFirstStep)
        XCTAssertFalse(progress.isLastStep)
        XCTAssertFalse(progress.isComplete)
        
        let lastStepProgress = FormWizardProgress(
            currentStep: 2,
            totalSteps: 3,
            completedSteps: 3
        )
        
        XCTAssertFalse(lastStepProgress.isFirstStep)
        XCTAssertTrue(lastStepProgress.isLastStep)
        XCTAssertTrue(lastStepProgress.isComplete)
    }
    
    func testFormWizardProgressEdgeCases() {
        // Empty wizard
        let emptyProgress = FormWizardProgress(
            currentStep: 0,
            totalSteps: 0,
            completedSteps: 0
        )
        XCTAssertEqual(emptyProgress.progressPercentage, 0.0)
        
        // Single step
        let singleStepProgress = FormWizardProgress(
            currentStep: 0,
            totalSteps: 1,
            completedSteps: 1
        )
        XCTAssertEqual(singleStepProgress.progressPercentage, 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testFormWizardCompleteWorkflow() {
        var builder = FormWizardBuilder()
        builder.addStep(id: "personal", title: "Personal Info", isRequired: true)
        builder.addStep(id: "contact", title: "Contact Info", isRequired: true)
        builder.addStep(id: "preferences", title: "Preferences", isRequired: false)
        let steps = builder.build()
        
        let state = FormWizardState()
        state.setSteps(steps)
        
        // Navigate through steps
        XCTAssertEqual(state.currentStepIndex, 0)
        XCTAssertEqual(state.getCurrentStep()?.id, "personal")
        
        // Complete first step
        state.markStepComplete("personal")
        XCTAssertTrue(state.canProceedToNextStep())
        
        // Move to next step
        XCTAssertTrue(state.nextStep())
        XCTAssertEqual(state.currentStepIndex, 1)
        XCTAssertEqual(state.getCurrentStep()?.id, "contact")
        
        // Complete second step
        state.markStepComplete("contact")
        XCTAssertTrue(state.canProceedToNextStep())
        
        // Move to final step
        XCTAssertTrue(state.nextStep())
        XCTAssertEqual(state.currentStepIndex, 2)
        XCTAssertEqual(state.getCurrentStep()?.id, "preferences")
        
        // Complete wizard
        XCTAssertTrue(state.nextStep())
        XCTAssertTrue(state.isComplete)
    }
    
    func testFormWizardWithValidationRules() {
        var builder = FormWizardBuilder()
        builder.addStep(
            id: "personal",
            title: "Personal Info",
            isRequired: true,
            validationRules: ["minLength": "2"]
        )
        let steps = builder.build()
        
        let state = FormWizardState()
        state.setSteps(steps)
        
        // Test validation
        XCTAssertFalse(state.canProceedToNextStep())
        
        // Mark step as complete
        state.markStepComplete("personal")
        XCTAssertTrue(state.canProceedToNextStep())
    }
    
    func testFormWizardLargeNumberOfSteps() {
        var builder = FormWizardBuilder()
        
        // Create many steps
        for i in 0..<100 {
            builder.addStep(
                id: "step\(i)",
                title: "Step \(i)"
            )
        }
        
        let steps = builder.build()
        XCTAssertEqual(steps.count, 100)
        
        let state = FormWizardState()
        state.setSteps(steps)
        
        // Test navigation through many steps
        for i in 0..<50 {
            XCTAssertEqual(state.currentStepIndex, i)
            XCTAssertEqual(state.getCurrentStep()?.id, "step\(i)")
            
            // Mark current step as complete before proceeding
            state.markStepComplete("step\(i)")
            
            XCTAssertTrue(state.nextStep())
        }
        
        XCTAssertEqual(state.currentStepIndex, 50)
    }
    
    func testFormWizardStatePersistence() {
        let state = FormWizardState()
        let steps = [
            FormWizardStep(id: "step1", title: "Step 1", stepOrder: 0),
            FormWizardStep(id: "step2", title: "Step 2", stepOrder: 1)
        ]
        
        state.setSteps(steps)
        
        // Set some data and state
        state.setStepData("step1", key: "name", value: "John")
        state.markStepComplete("step1")
        state.addValidationError("Error", for: "step2")
        
        // Verify state is maintained
        XCTAssertEqual(state.getStepData("step1", key: "name") as String?, "John")
        XCTAssertTrue(state.isStepComplete("step1"))
        XCTAssertTrue(state.validationErrors["step2"]?.contains("Error") ?? false)
    }
}
