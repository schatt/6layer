//
//  TaskListView.swift
//  TaskManagerSampleApp
//
//  Main task list view demonstrating Layer 1 semantic functions
//  Uses SixLayer Framework types exclusively - no bare SwiftUI
//

import SwiftUI
import SixLayerFramework

/// Main view displaying list of tasks
/// Demonstrates Layer 1 semantic functions for presenting collections
public struct TaskListView: View {
    @StateObject private var viewModel: TaskManagerViewModel
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    
    public init(viewModel: TaskManagerViewModel = TaskManagerViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        platformNavigationContainer_L1(
            title: viewModel.i18nService.localizedString(for: "task.list.title"),
            navigationStyle: .automatic
        ) {
            platformScrollViewContainer {
                if viewModel.tasks.isEmpty {
                    // Empty state using Layer 1 functions
                    platformVStackContainer(alignment: .center, spacing: 16) {
                        platformPresentLocalizedString_L1(
                            key: "task.empty.title",
                            hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                        )
                        .font(.headline)
                        
                        platformPresentLocalizedString_L1(
                            key: "task.empty.message",
                            hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Button(action: {
                            showingAddTask = true
                        }) {
                            platformPresentLocalizedString_L1(
                                key: "task.add",
                                hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                            )
                        }
                    }
                    .padding()
                } else {
                    // Task list using Layer 1
                    platformPresentItemCollection_L1(
                        items: viewModel.tasks,
                        hints: taskHints,
                        customItemView: { task in
                            TaskRowView(task: task, viewModel: viewModel)
                        }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddTask = true
                    }) {
                        Label(
                            viewModel.i18nService.localizedString(for: "task.add"),
                            systemImage: "plus"
                        )
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        Task {
                            await viewModel.syncTasks()
                        }
                    }) {
                        Label(
                            viewModel.i18nService.localizedString(for: "task.sync"),
                            systemImage: "arrow.clockwise"
                        )
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskFormView(viewModel: viewModel, task: nil)
            }
            .task {
                // Authenticate and load tasks on appear
                do {
                    _ = try await viewModel.authenticate()
                    await viewModel.fetchTasks()
                } catch {
                    // Handle authentication error
                    viewModel.errorMessage = viewModel.i18nService.localizedString(
                        for: "task.auth.error"
                    )
                }
            }
            .alert(
                viewModel.i18nService.localizedString(for: "error.title"),
                isPresented: .constant(viewModel.errorMessage != nil),
                presenting: viewModel.errorMessage
            ) { message in
                Button(viewModel.i18nService.localizedString(for: "error.ok")) {
                    viewModel.errorMessage = nil
                }
            } message: { message in
                Text(message)
            }
        }
    }
    
    // MARK: - Hints Configuration
    
    private var taskHints: ItemCollectionHints {
        var hints = ItemCollectionHints()
        hints.layout = .list
        hints.spacing = 8
        return hints
    }
}

/// Task row view for individual task items
/// Uses Layer 1 functions for all UI components
private struct TaskRowView: View {
    let task: Task
    @ObservedObject var viewModel: TaskManagerViewModel
    
    var body: some View {
        platformHStackContainer(alignment: .center, spacing: 12) {
            // Completion indicator
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
            
            // Task content using Layer 1
            platformVStackContainer(alignment: .leading, spacing: 4) {
                // Title
                platformPresentLocalizedText_L1(
                    text: task.title,
                    hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                )
                .font(.headline)
                .strikethrough(task.isCompleted)
                
                // Description if available
                if let description = task.description, !description.isEmpty {
                    platformPresentLocalizedText_L1(
                        text: description,
                        hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                // Metadata row
                platformHStackContainer(spacing: 8) {
                    // Due date if available
                    if let dueDate = task.dueDate {
                        Label(
                            viewModel.i18nService.formatDate(dueDate, style: .short),
                            systemImage: "calendar"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    // Priority badge
                    platformPresentLocalizedText_L1(
                        text: task.priority.rawValue.capitalized,
                        hints: InternationalizationHints(locale: viewModel.i18nService.locale)
                    )
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor(for: task.priority).opacity(0.2))
                    .foregroundColor(priorityColor(for: task.priority))
                    .cornerRadius(4)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .onTapGesture {
            // Toggle completion on tap
            viewModel.toggleTaskCompletion(task)
            Task {
                await viewModel.saveTaskToCloudKit(task)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.deleteTask(task)
                Task {
                    if let recordID = task.cloudKitRecordID {
                        try? await viewModel.cloudKitService.delete(recordID: recordID)
                    }
                }
            } label: {
                Label(
                    viewModel.i18nService.localizedString(for: "task.delete"),
                    systemImage: "trash"
                )
            }
        }
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        }
    }
}
