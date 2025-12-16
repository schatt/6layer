//
//  TaskFormView.swift
//  TaskManagerSampleApp
//
//  Task form view demonstrating DynamicFormView usage
//

import SwiftUI
import SixLayerFramework

/// Form view for creating/editing tasks
/// Demonstrates DynamicFormView with Layer 1 semantic functions
public struct TaskFormView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    @Environment(\.dismiss) private var dismiss
    
    let task: Task?
    @State private var formState: DynamicFormState
    
    public init(viewModel: TaskManagerViewModel, task: Task?) {
        self.viewModel = viewModel
        self.task = task
        
        // Create form configuration
        let config = TaskFormView.createFormConfiguration()
        _formState = State(initialValue: DynamicFormState(configuration: config))
        
        // Pre-fill form if editing
        if let task = task {
            formState.setValue(task.title, for: "title")
            formState.setValue(task.description ?? "", for: "description")
            formState.setValue(task.dueDate, for: "dueDate")
            formState.setValue(task.priority.rawValue, for: "priority")
        }
    }
    
    public var body: some View {
        platformNavigationContainer_L1(
            title: task == nil
                ? viewModel.i18nService.localizedString(for: "task.add.title")
                : viewModel.i18nService.localizedString(for: "task.edit.title"),
            navigationStyle: .automatic
        ) {
            platformScrollViewContainer {
                // Use DynamicFormView for form presentation
                DynamicFormView(
                    configuration: formState.configuration,
                    state: formState,
                    onSubmit: { values in
                        handleFormSubmit(values: values)
                    },
                    onCancel: {
                        dismiss()
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(viewModel.i18nService.localizedString(for: "cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Form Configuration
    
    private static func createFormConfiguration() -> DynamicFormConfiguration {
        let i18n = InternationalizationService()
        
        return DynamicFormConfiguration(
            id: "task-form",
            fields: [
                DynamicFormField(
                    id: "title",
                    textContentType: nil,
                    contentType: .text,
                    label: i18n.localizedString(for: "task.form.title.label"),
                    placeholder: i18n.localizedString(for: "task.form.title.placeholder"),
                    description: nil,
                    isRequired: true,
                    validationRules: ["minLength": "1"],
                    options: nil,
                    defaultValue: nil,
                    metadata: nil,
                    supportsOCR: false,
                    ocrHint: nil,
                    ocrValidationTypes: nil,
                    ocrFieldIdentifier: nil,
                    ocrValidationRules: nil,
                    ocrHints: nil,
                    supportsBarcodeScanning: false,
                    barcodeHint: nil,
                    supportedBarcodeTypes: nil,
                    barcodeFieldIdentifier: nil,
                    isCalculated: false,
                    calculationFormula: nil,
                    calculationDependencies: nil,
                    calculationGroups: nil
                ),
                DynamicFormField(
                    id: "description",
                    textContentType: nil,
                    contentType: .textarea,
                    label: i18n.localizedString(for: "task.form.description.label"),
                    placeholder: i18n.localizedString(for: "task.form.description.placeholder"),
                    description: nil,
                    isRequired: false,
                    validationRules: nil,
                    options: nil,
                    defaultValue: nil,
                    metadata: nil,
                    supportsOCR: false,
                    ocrHint: nil,
                    ocrValidationTypes: nil,
                    ocrFieldIdentifier: nil,
                    ocrValidationRules: nil,
                    ocrHints: nil,
                    supportsBarcodeScanning: false,
                    barcodeHint: nil,
                    supportedBarcodeTypes: nil,
                    barcodeFieldIdentifier: nil,
                    isCalculated: false,
                    calculationFormula: nil,
                    calculationDependencies: nil,
                    calculationGroups: nil
                ),
                DynamicFormField(
                    id: "dueDate",
                    textContentType: nil,
                    contentType: .date,
                    label: i18n.localizedString(for: "task.form.dueDate.label"),
                    placeholder: nil,
                    description: nil,
                    isRequired: false,
                    validationRules: nil,
                    options: nil,
                    defaultValue: nil,
                    metadata: nil,
                    supportsOCR: false,
                    ocrHint: nil,
                    ocrValidationTypes: nil,
                    ocrFieldIdentifier: nil,
                    ocrValidationRules: nil,
                    ocrHints: nil,
                    supportsBarcodeScanning: false,
                    barcodeHint: nil,
                    supportedBarcodeTypes: nil,
                    barcodeFieldIdentifier: nil,
                    isCalculated: false,
                    calculationFormula: nil,
                    calculationDependencies: nil,
                    calculationGroups: nil
                ),
                DynamicFormField(
                    id: "priority",
                    textContentType: nil,
                    contentType: .select,
                    label: i18n.localizedString(for: "task.form.priority.label"),
                    placeholder: i18n.localizedString(for: "task.form.priority.placeholder"),
                    description: nil,
                    isRequired: false,
                    validationRules: nil,
                    options: TaskPriority.allCases.map { $0.rawValue },
                    defaultValue: TaskPriority.medium.rawValue,
                    metadata: nil,
                    supportsOCR: false,
                    ocrHint: nil,
                    ocrValidationTypes: nil,
                    ocrFieldIdentifier: nil,
                    ocrValidationRules: nil,
                    ocrHints: nil,
                    supportsBarcodeScanning: false,
                    barcodeHint: nil,
                    supportedBarcodeTypes: nil,
                    barcodeFieldIdentifier: nil,
                    isCalculated: false,
                    calculationFormula: nil,
                    calculationDependencies: nil,
                    calculationGroups: nil
                )
            ],
            sections: nil,
            submitButtonText: i18n.localizedString(for: "task.form.submit"),
            cancelButtonText: i18n.localizedString(for: "cancel")
        )
    }
    
    // MARK: - Form Handling
    
    private func handleFormSubmit(values: [String: Any]) {
        let title = values["title"] as? String ?? ""
        let description = values["description"] as? String
        let dueDate = values["dueDate"] as? Date
        let priorityString = values["priority"] as? String ?? TaskPriority.medium.rawValue
        let priority = TaskPriority(rawValue: priorityString) ?? .medium
        
        let newTask = Task(
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority
        )
        
        if let existingTask = task {
            // Update existing task
            var updatedTask = existingTask
            updatedTask.title = newTask.title
            updatedTask.description = newTask.description
            updatedTask.dueDate = newTask.dueDate
            updatedTask.priority = newTask.priority
            updatedTask.updatedAt = Date()
            viewModel.updateTask(updatedTask)
            
            Task {
                await viewModel.saveTaskToCloudKit(updatedTask)
                
                // Schedule notification if due date is set
                if let dueDate = updatedTask.dueDate {
                    try? await viewModel.scheduleTaskNotification(for: updatedTask)
                }
            }
        } else {
            // Add new task
            viewModel.addTask(newTask)
            
            Task {
                await viewModel.saveTaskToCloudKit(newTask)
                
                // Schedule notification if due date is set
                if let dueDate = newTask.dueDate {
                    try? await viewModel.scheduleTaskNotification(for: newTask)
                }
            }
        }
        
        dismiss()
    }
}



