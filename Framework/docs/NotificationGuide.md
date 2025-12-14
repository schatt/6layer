# Notification Service Guide

## Overview

The Notification Service provides a comprehensive, cross-platform solution for managing notifications, badges, alerts, and notification permissions in the SixLayer Framework. It follows the same pattern as `InternationalizationService` and `LocationService`, providing a unified API that works identically on iOS and macOS.

## Features

- **Cross-platform notification permissions** - Request and check permissions on iOS and macOS
- **Badge management** - Update app badge counts (iOS) and track badges (macOS)
- **Local notification scheduling** - Schedule, cancel, and manage local notifications
- **Do Not Disturb integration** - Respect system Do Not Disturb settings
- **Sound preferences** - Check and manage notification sound settings
- **Layer 1 semantic functions** - High-level notification interfaces

## Basic Usage

### Initialization

```swift
import SixLayerFramework

// Create service with defaults
let notificationService = NotificationService()

// Or with custom configuration
let notificationService = NotificationService(
    enableBadgeManagement: true,
    respectDoNotDisturb: true,
    defaultSound: "default"
)
```

### Requesting Permissions

```swift
// Request notification permissions
let status = await notificationService.requestPermission(
    options: [.alert, .badge, .sound]
)

switch status {
case .authorized:
    print("Notifications authorized")
case .denied:
    print("Notifications denied")
case .notDetermined:
    print("Permission not yet determined")
case .provisional:
    print("Provisional permission granted")
}
```

### Checking Permission Status

```swift
// Check current permission status
let status = notificationService.checkPermissionStatus()

// Or access the published property directly
let currentStatus = notificationService.permissionStatus
```

### Badge Management

```swift
// Update badge count
try notificationService.updateBadge(5)

// Increment badge
try notificationService.incrementBadge()

// Decrement badge
try notificationService.decrementBadge()

// Clear badge
try notificationService.clearBadge()

// Access current badge count
let currentCount = notificationService.badgeCount
```

### Scheduling Local Notifications

```swift
// Schedule a notification for a future date
try notificationService.scheduleLocalNotification(
    identifier: "reminder-1",
    title: "Reminder",
    body: "Don't forget to check your tasks",
    date: Date().addingTimeInterval(3600), // 1 hour from now
    sound: "default",
    badge: 1
)

// Cancel a specific notification
notificationService.cancelNotification(identifier: "reminder-1")

// Cancel all scheduled notifications
notificationService.cancelAllNotifications()
```

### Do Not Disturb

```swift
// Check if Do Not Disturb is active
let isActive = notificationService.checkDoNotDisturbStatus()

// Check if sound is enabled (respects Do Not Disturb)
let soundEnabled = notificationService.isSoundEnabled()
```

## Layer 1 Semantic Functions

The framework provides high-level Layer 1 functions for common notification tasks:

### Request Permission

```swift
let status = await platformRequestNotificationPermission_L1()
```

### Show Notification

```swift
try await platformShowNotification_L1(
    title: "New Message",
    body: "You have a new message",
    hints: NotificationHints(defaultSound: "default")
)
```

### Update Badge

```swift
try platformUpdateBadge_L1(count: 3)
```

### Present Alert

```swift
let alertView = platformPresentAlert_L1(
    title: "Alert",
    message: "This is an alert",
    hints: NotificationHints()
)
```

## Configuration with NotificationHints

Use `NotificationHints` to configure notification behavior:

```swift
let hints = NotificationHints(
    enableBadgeManagement: true,
    respectDoNotDisturb: true,
    defaultSound: "default",
    alertStyle: .alert,
    priority: .normal
)
```

## SwiftUI Integration

The service is an `ObservableObject`, so you can use it with SwiftUI:

```swift
import SwiftUI
import SixLayerFramework

struct NotificationSettingsView: View {
    @StateObject private var notificationService = NotificationService()
    
    var body: some View {
        VStack {
            Text("Permission Status: \(notificationService.permissionStatus.description)")
            Text("Badge Count: \(notificationService.badgeCount)")
            
            Button("Request Permission") {
                Task {
                    await notificationService.requestPermission()
                }
            }
            
            Button("Update Badge") {
                try? notificationService.updateBadge(5)
            }
        }
    }
}
```

## Error Handling

The service throws `NotificationServiceError` for various error conditions:

```swift
do {
    try notificationService.scheduleLocalNotification(
        identifier: "test",
        title: "Test",
        body: "Test body",
        date: Date()
    )
} catch NotificationServiceError.permissionDenied {
    print("Permission denied")
} catch NotificationServiceError.schedulingFailed {
    print("Failed to schedule notification")
} catch {
    print("Unknown error: \(error)")
}
```

## Platform-Specific Behavior

### iOS
- Badge numbers appear on the app icon
- Uses `UNUserNotificationCenter` for all notification operations
- Supports provisional authorization (iOS 12+)

### macOS
- Badge tracking is supported (but not displayed on dock icon)
- Uses `UNUserNotificationCenter` for notification operations (macOS 10.14+)
- Notification Center integration

### Cross-Platform
- Same API works on both platforms
- Automatic platform detection
- Consistent error handling

## Best Practices

1. **Request permissions early** - Request notification permissions when your app launches or when the user first needs notifications
2. **Check permission status** - Always check permission status before scheduling notifications
3. **Handle errors gracefully** - Wrap notification operations in do-catch blocks
4. **Use unique identifiers** - Use unique identifiers for scheduled notifications to avoid conflicts
5. **Respect Do Not Disturb** - Enable Do Not Disturb respect to provide a better user experience

## Integration with Remote Notifications

The service works alongside the Layer 4 remote notification registration:

```swift
// First, request permissions
let status = await notificationService.requestPermission()

if status == .authorized {
    // Then register for remote notifications
    platformRegisterForRemoteNotifications_L4()
}
```

## Related Documentation

- `PlatformNotificationsLayer4.swift` - Remote notification registration
- `InternationalizationService.swift` - Similar service pattern
- `LocationService.swift` - Similar service pattern

## Examples

See the test suite in `NotificationServiceTests.swift` for comprehensive examples of all features.

