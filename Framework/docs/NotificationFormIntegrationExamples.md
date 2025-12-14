# Notification Service - Form Integration Examples

## Overview

This guide demonstrates how to integrate the Notification Service with forms in the SixLayer Framework, including permission requests, badge updates, and notification scheduling based on form submissions.

## Basic Form Integration

### Requesting Permissions in a Form

```swift
import SwiftUI
import SixLayerFramework

struct NotificationSettingsForm: View {
    @StateObject private var notificationService = NotificationService()
    @State private var showPermissionAlert = false
    
    var body: some View {
        Form {
            Section("Notification Permissions") {
                HStack {
                    Text("Status")
                    Spacer()
                    Text(notificationService.permissionStatus.description)
                        .foregroundColor(.secondary)
                }
                
                Button("Request Permission") {
                    Task {
                        let status = await notificationService.requestPermission()
                        if status == .denied {
                            showPermissionAlert = true
                        }
                    }
                }
            }
            
            Section("Badge Management") {
                Stepper("Badge Count: \(notificationService.badgeCount)") {
                    try? notificationService.incrementBadge()
                } onDecrement: {
                    try? notificationService.decrementBadge()
                }
                
                Button("Clear Badge") {
                    try? notificationService.clearBadge()
                }
            }
        }
        .alert("Permission Denied", isPresented: $showPermissionAlert) {
            Button("OK") { }
        } message: {
            Text("Please enable notifications in Settings.")
        }
    }
}
```

## Form Submission Notifications

### Schedule Notification After Form Submission

```swift
struct TaskForm: View {
    @StateObject private var notificationService = NotificationService()
    @State private var taskTitle = ""
    @State private var dueDate = Date()
    @State private var showSuccess = false
    
    var body: some View {
        Form {
            TextField("Task Title", text: $taskTitle)
            DatePicker("Due Date", selection: $dueDate)
            
            Button("Save Task") {
                saveTask()
            }
        }
        .alert("Task Saved", isPresented: $showSuccess) {
            Button("OK") { }
        }
    }
    
    private func saveTask() {
        // Save task logic here...
        
        // Schedule notification for due date
        Task {
            do {
                try await notificationService.scheduleLocalNotification(
                    identifier: UUID().uuidString,
                    title: "Task Reminder",
                    body: "Don't forget: \(taskTitle)",
                    date: dueDate,
                    sound: "default"
                )
                
                // Update badge
                try notificationService.incrementBadge()
                
                await MainActor.run {
                    showSuccess = true
                }
            } catch {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}
```

## Using Layer 1 Functions in Forms

### Simple Permission Request

```swift
struct SimpleNotificationForm: View {
    @State private var permissionStatus: NotificationPermissionStatus = .notDetermined
    
    var body: some View {
        Form {
            Section {
                Button("Request Notification Permission") {
                    Task {
                        permissionStatus = await platformRequestNotificationPermission_L1()
                    }
                }
                
                Text("Status: \(permissionStatus.description)")
            }
        }
    }
}
```

### Badge Update in Form

```swift
struct BadgeControlForm: View {
    @State private var badgeCount = 0
    
    var body: some View {
        Form {
            Section("Badge Control") {
                Stepper("Count: \(badgeCount)", value: $badgeCount, in: 0...99)
                
                Button("Update Badge") {
                    do {
                        try platformUpdateBadge_L1(count: badgeCount)
                    } catch {
                        print("Failed to update badge: \(error)")
                    }
                }
            }
        }
    }
}
```

## Notification Categories with Form Actions

### Register Categories and Use in Forms

```swift
struct TaskManagementForm: View {
    @StateObject private var notificationService = NotificationService()
    @State private var taskName = ""
    
    var body: some View {
        Form {
            TextField("Task Name", text: $taskName)
            
            Button("Create Task with Reminder") {
                createTaskWithReminder()
            }
        }
        .onAppear {
            setupNotificationCategories()
        }
    }
    
    private func setupNotificationCategories() {
        let completeAction = NotificationAction(
            identifier: "complete",
            title: "Complete",
            options: []
        )
        
        let snoozeAction = NotificationAction(
            identifier: "snooze",
            title: "Snooze",
            options: []
        )
        
        let category = NotificationCategory(
            identifier: "task",
            actions: [completeAction, snoozeAction]
        )
        
        notificationService.registerCategories([category])
    }
    
    private func createTaskWithReminder() {
        Task {
            do {
                try await notificationService.scheduleLocalNotification(
                    identifier: UUID().uuidString,
                    title: "Task Reminder",
                    body: taskName,
                    date: Date().addingTimeInterval(3600),
                    categoryIdentifier: "task"
                )
            } catch {
                print("Failed: \(error)")
            }
        }
    }
}
```

## RTL-Aware Notification Forms

### Form with RTL Support

```swift
struct RTLNotificationForm: View {
    @StateObject private var notificationService = NotificationService()
    @State private var message = ""
    @State private var locale = Locale.current
    
    var body: some View {
        Form {
            TextField("Message", text: $message)
            
            Button("Send Notification") {
                Task {
                    do {
                        try await platformShowNotification_L1(
                            title: "Notification",
                            body: message,
                            locale: locale
                        )
                    } catch {
                        print("Failed: \(error)")
                    }
                }
            }
        }
        .environment(\.locale, locale)
    }
}
```

## Complete Example: Task Management with Notifications

```swift
struct CompleteTaskForm: View {
    @StateObject private var notificationService = NotificationService()
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    @State private var enableReminder = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Title", text: $taskTitle)
                    TextField("Description", text: $taskDescription)
                    DatePicker("Due Date", selection: $dueDate)
                }
                
                Section("Notifications") {
                    Toggle("Enable Reminder", isOn: $enableReminder)
                    
                    if enableReminder {
                        HStack {
                            Text("Permission")
                            Spacer()
                            Text(notificationService.permissionStatus.description)
                                .foregroundColor(.secondary)
                        }
                        
                        if notificationService.permissionStatus != .authorized {
                            Button("Request Permission") {
                                Task {
                                    await notificationService.requestPermission()
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button("Save Task") {
                        saveTask()
                    }
                    .disabled(taskTitle.isEmpty)
                }
            }
            .navigationTitle("New Task")
            .alert("Task Saved", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveTask() {
        // Save task logic...
        
        if enableReminder && notificationService.permissionStatus == .authorized {
            Task {
                do {
                    try await notificationService.scheduleLocalNotification(
                        identifier: UUID().uuidString,
                        title: "Task Reminder: \(taskTitle)",
                        body: taskDescription.isEmpty ? "Don't forget this task!" : taskDescription,
                        date: dueDate,
                        sound: "default"
                    )
                    
                    try notificationService.incrementBadge()
                    
                    await MainActor.run {
                        alertMessage = "Task saved and reminder scheduled!"
                        showAlert = true
                    }
                } catch {
                    await MainActor.run {
                        alertMessage = "Task saved, but reminder failed: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Task saved!"
            showAlert = true
        }
    }
}
```

## Best Practices

1. **Request permissions early** - Ask for notification permissions when the user first interacts with notification features
2. **Handle errors gracefully** - Always wrap notification operations in do-catch blocks
3. **Update badges appropriately** - Increment badges when new items are created, decrement when completed
4. **Use categories for actions** - Register notification categories to enable quick actions
5. **Respect Do Not Disturb** - Check Do Not Disturb status before sending non-critical notifications
6. **Provide RTL support** - Use locale-aware functions for international users

## Related Documentation

- `NotificationGuide.md` - Complete notification service guide
- `PlatformFormsLayer4.swift` - Form components
- `InternationalizationService.swift` - RTL and localization support
