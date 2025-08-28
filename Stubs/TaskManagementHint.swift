//
//  TaskManagementHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a starting point for task management hints.
//

import Foundation
import SixLayerFramework

// MARK: - Task Management Hint

/// Custom hint for task management applications
/// Modify this class to match your task management application's requirements
class TaskManagementHint: CustomHint {
    
    // MARK: - Properties
    
    /// Task type for determining optimal layout
    let taskType: TaskType
    
    /// Whether to show priority information
    let showPriority: Bool
    
    /// Whether to show due dates
    let showDueDate: Bool
    
    /// Grouping style for tasks
    let groupingStyle: GroupingStyle
    
    /// Whether to show progress indicators
    let showProgress: Bool
    
    /// Whether to enable drag and drop
    let allowDragAndDrop: Bool
    
    // MARK: - Initialization
    
    init(
        taskType: TaskType,
        showPriority: Bool = true,
        showDueDate: Bool = true,
        groupingStyle: GroupingStyle = .automatic,
        showProgress: Bool = true,
        allowDragAndDrop: Bool = true
    ) {
        self.taskType = taskType
        self.showPriority = showPriority
        self.showDueDate = showDueDate
        self.groupingStyle = groupingStyle
        self.showProgress = showProgress
        self.allowDragAndDrop = allowDragAndDrop
        
        super.init(
            hintType: "taskmanagement.\(taskType.rawValue)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "taskType": taskType.rawValue,
                "showPriority": showPriority,
                "showDueDate": showDueDate,
                "groupingStyle": groupingStyle.rawValue,
                "recommendedLayout": TaskManagementHint.determineOptimalLayout(for: taskType),
                "showProgress": showProgress,
                "allowDragAndDrop": allowDragAndDrop,
                "quickActions": taskType.quickActions,
                "filteringEnabled": true,
                "sortingEnabled": true,
                "searchEnabled": true
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    /// Determine optimal layout based on task type
    private static func determineOptimalLayout(for taskType: TaskType) -> String {
        switch taskType {
        case .simple: return "list"
        case .complex: return "cards"
        case .project: return "kanban"
        case .recurring: return "calendar"
        }
    }
}

// MARK: - Supporting Types

/// Task types for different management scenarios
enum TaskType: String, CaseIterable {
    case simple, complex, project, recurring
    
    var supportsProgress: Bool {
        return self == .complex || self == .project
    }
    
    var quickActions: [String] {
        switch self {
        case .simple: return ["complete", "edit"]
        case .complex: return ["complete", "edit", "delegate"]
        case .project: return ["complete", "edit", "delegate", "archive"]
        case .recurring: return ["complete", "edit", "reschedule"]
        }
    }
}

/// Grouping styles for task organization
enum GroupingStyle: String, CaseIterable {
    case automatic, byPriority, byDueDate, byAssignee, byProject
}

// MARK: - Enhanced Presentation Hints Extension

extension EnhancedPresentationHints {
    
    /// Create hints optimized for task management
    static func forTaskManagement(
        taskType: TaskType,
        showPriority: Bool = true,
        showDueDate: Bool = true,
        groupingStyle: GroupingStyle = .automatic
    ) -> EnhancedPresentationHints {
        let taskHint = TaskManagementHint(
            taskType: taskType,
            showPriority: showPriority,
            showDueDate: showDueDate,
            groupingStyle: groupingStyle
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .automatic, // Let the hint decide
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [taskHint]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your task management app, use it like this:
 
 struct TaskListView: View {
     let tasks: [Task]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forTaskManagement(
             taskType: .complex,
             showPriority: true,
             showDueDate: true,
             groupingStyle: .byPriority
         )
         
         return platformPresentItemCollection_L1(
             items: tasks,
             hints: hints
         )
     }
 }
 
 // For different task types:
 
 struct ProjectView: View {
     let projectTasks: [Task]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forTaskManagement(
             taskType: .project,
             showPriority: true,
             showDueDate: true,
             groupingStyle: .byProject
         )
         
         return platformPresentItemCollection_L1(
             items: projectTasks,
             hints: hints
         )
     }
 }
 
 // Custom task hint for specific use cases:
 
 struct RecurringTaskView: View {
     let recurringTasks: [Task]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .collection,
             presentationPreference: .list,
             complexity: .moderate,
             context: .dashboard,
             extensibleHints: [
                 TaskManagementHint(
                     taskType: .recurring,
                     showPriority: false,
                     showDueDate: true,
                     groupingStyle: .byDueDate,
                     showProgress: false,
                     allowDragAndDrop: false
                 )
             ]
         )
         
         return platformPresentItemCollection_L1(
             items: recurringTasks,
             hints: hints
         )
     }
 }
 
 */
