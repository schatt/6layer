# TaskManager Sample App

**SixLayer Framework v6.6.0**

A complete, opinionated sample application demonstrating how to build a real app using the SixLayer Framework. This app showcases secure, localized, CloudKit-backed task management with notifications, forms, and services used exactly as the framework intends.

## Overview

The TaskManager sample app is a canonical example of SixLayer Framework architecture. It demonstrates:

- ✅ **Layer 1→6 Patterns**: Proper use of semantic intent functions throughout
- ✅ **Service Composition**: CloudKitService, NotificationService, SecurityService integration
- ✅ **Dynamic Forms**: Using DynamicFormView for data entry
- ✅ **CloudKit Sync**: Full CloudKit integration with proper error handling
- ✅ **Notifications**: Task reminders via NotificationService
- ✅ **Security**: Biometric authentication via SecurityService
- ✅ **Localization**: Full i18n support (English, Spanish, French)
- ✅ **Testing**: Comprehensive tests using SixLayerTestKit

## Architecture

### Layer 1 Semantic Intent

All UI uses Layer 1 semantic functions - no bare SwiftUI:

```swift
// ✅ CORRECT: Using Layer 1 functions
platformVStackContainer(alignment: .center, spacing: 16) {
    platformPresentLocalizedString_L1(key: "task.title")
    platformPresentItemCollection_L1(items: tasks, hints: hints)
}

// ❌ WRONG: Bare SwiftUI
VStack {
    Text("Task")
    List(tasks) { task in ... }
}
```

### Service Integration

The app demonstrates proper service composition:

```swift
@MainActor
class TaskManagerViewModel: ObservableObject, CloudKitServiceDelegate {
    private let cloudKitService: CloudKitService
    private let notificationService: NotificationService
    private let securityService: SecurityService
    private let i18nService: InternationalizationService
    
    // Services work together seamlessly
    func syncTasks() async {
        try await cloudKitService.sync(recordTypes: ["Task"])
        // Schedule notifications for due tasks
        for task in tasks where task.dueDate != nil {
            try? await notificationService.scheduleLocalNotification(...)
        }
    }
}
```

### CloudKit Integration

Tasks are synced via CloudKitService with proper delegate pattern:

```swift
extension TaskManagerViewModel: CloudKitServiceDelegate {
    func validateRecord(_ record: CKRecord) throws {
        guard record["title"] as? String != nil else {
            throw CloudKitServiceError.invalidRecord
        }
    }
    
    func handleError(_ error: Error) -> Bool {
        // Custom error handling
        return true
    }
}
```

## Features

### 1. Task Management

- Create, edit, delete tasks
- Mark tasks as complete
- Set priority (low, medium, high)
- Add due dates and descriptions

### 2. CloudKit Sync

- Automatic sync across devices
- Conflict resolution via delegate
- Offline queue support
- Progress tracking

### 3. Notifications

- Task reminders for due dates
- Permission handling
- Do Not Disturb support

### 4. Security

- Biometric authentication
- Secure data storage
- Privacy indicators

### 5. Localization

- English (en)
- Spanish (es)
- French (fr)
- RTL support

## File Structure

```
TaskManagerSampleApp/
├── Task.swift                    # Task model with CloudKit support
├── TaskManagerViewModel.swift    # View model with service composition
├── TaskListView.swift           # Main list view (Layer 1 functions)
├── TaskFormView.swift           # Form view (DynamicFormView)
├── TaskManagerApp.swift        # App entry point
├── TaskManagerSampleAppTests.swift  # Comprehensive tests
└── Resources/
    ├── en.lproj/
    │   └── Localizable.strings
    ├── es.lproj/
    │   └── Localizable.strings
    └── fr.lproj/
        └── Localizable.strings
```

## Usage

### Running the App

1. Ensure you have CloudKit capabilities enabled in your app
2. Configure CloudKit container identifier in `TaskManagerViewModel`
3. Build and run

### Testing

Tests use SixLayerTestKit for service mocking:

```swift
let testKit = SixLayerTestKit()
testKit.serviceMocks.cloudKitService.configureSuccessResponse()

let viewModel = TaskManagerViewModel()
await viewModel.syncTasks()
```

## Key Patterns Demonstrated

### 1. Layer 1 Semantic Functions

All UI uses semantic intent, not implementation:

```swift
// Express WHAT you want, not HOW
platformPresentItemCollection_L1(
    items: tasks,
    hints: ItemCollectionHints(layout: .list),
    customItemView: { task in
        TaskRowView(task: task)
    }
)
```

### 2. Service Composition

Services work together seamlessly:

```swift
// Services are composed, not tightly coupled
let viewModel = TaskManagerViewModel(
    cloudKitService: CloudKitService(...),
    notificationService: NotificationService(...),
    securityService: SecurityService(...),
    i18nService: InternationalizationService(...)
)
```

### 3. Error Handling

Proper error handling via delegates:

```swift
func handleError(_ error: Error) -> Bool {
    if let ckError = error as? CKError {
        switch ckError.code {
        case .networkUnavailable:
            // Handle network error
            return true
        default:
            return false
        }
    }
    return false
}
```

### 4. Localization

Full i18n support with fallback:

```swift
let title = i18nService.localizedString(for: "task.title")
// Checks: App bundle → Framework bundle → Key itself
```

## Testing

The sample app includes comprehensive tests demonstrating:

- ✅ Model creation and CloudKit conversion
- ✅ View model operations (add, delete, update)
- ✅ CloudKit sync and save operations
- ✅ Notification scheduling
- ✅ Biometric authentication
- ✅ Localization across languages
- ✅ Form creation and submission

## Best Practices

This sample app demonstrates:

1. **Always use Layer 1 functions** - Never use bare SwiftUI
2. **Compose services** - Don't create singletons
3. **Handle errors properly** - Use delegate patterns
4. **Test with SixLayerTestKit** - Mock services in tests
5. **Localize everything** - Use InternationalizationService
6. **Follow TDD** - Tests written before implementation

## References

- [SixLayer Framework Documentation](../../../Framework/README.md)
- [AI Agent Guide](../../AI_AGENT.md)
- [CloudKit Service Guide](../../../Framework/docs/CloudKitServiceGuide.md)
- [Notification Service Guide](../../../Framework/docs/NotificationGuide.md)
- [Security Service Guide](../../../Framework/docs/SecurityGuide.md)
- [Internationalization Guide](../../../Framework/docs/InternationalizationGuide.md)

## License

This sample app is part of the SixLayer Framework and follows the same license.



