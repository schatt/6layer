# Add Notification Service

## Overview

Add a comprehensive Notification Service to the SixLayer Framework that provides platform-appropriate alerts, badge management, notification center integration, and Do Not Disturb support following the same pattern as `InternationalizationService`.

## Motivation

Notification and alert features are essential for user communication but require significant boilerplate code:
- Platform-appropriate alerts (iOS alerts vs macOS notifications)
- Badge management (app icon badge updates)
- Notification center integration
- Do Not Disturb respect
- Sound preferences
- Notification permissions
- Local and remote notifications

However, notifications also require app-specific configuration:
- Notification categories and actions (app-specific)
- Badge update logic (app-specific business rules)
- Alert styles and preferences (app-specific UX)
- Notification scheduling (app-specific timing)

**Solution**: Provide a framework service that handles the boilerplate, while apps provide app-specific logic through configuration and callbacks.

## Architecture Pattern

This follows existing framework patterns:
- **Service pattern**: Similar to `InternationalizationService`, `LocationService`, `OCRService`
- **ObservableObject**: Published properties for UI binding
- **Layer 1 semantic functions**: Similar to `platformPresentLocalizedContent_L1()` functions
- **Configuration-based**: Similar to `InternationalizationHints` pattern
- **Platform-aware**: Automatic platform detection and adaptation

## Proposed API Design

### Error Types

```swift
public enum NotificationServiceError: LocalizedError {
    case permissionDenied
    case permissionNotDetermined
    case notificationNotSupported
    case invalidNotification
    case schedulingFailed
    case badgeUpdateFailed
    case soundNotFound
    case doNotDisturbActive
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permission was denied"
        case .permissionNotDetermined:
            return "Notification permission has not been determined"
        case .notificationNotSupported:
            return "Notifications are not supported on this platform"
        case .invalidNotification:
            return "Invalid notification configuration"
        case .schedulingFailed:
            return "Failed to schedule notification"
        case .badgeUpdateFailed:
            return "Failed to update app badge"
        case .soundNotFound:
            return "Notification sound not found"
        case .doNotDisturbActive:
            return "Do Not Disturb is active"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
```

### Notification Types

```swift
public enum NotificationType {
    case alert
    case banner
    case badge
    case sound
    case all
    
    public var displayName: String {
        switch self {
        case .alert: return "Alert"
        case .banner: return "Banner"
        case .badge: return "Badge"
        case .sound: return "Sound"
        case .all: return "All"
        }
    }
}

public enum NotificationPriority {
    case low
    case normal
    case high
    case critical
}

public enum AlertStyle {
    case alert
    case actionSheet
    case banner
    case notification
}
```

### Notification Status

```swift
public enum NotificationPermissionStatus {
    case notDetermined
    case denied
    case authorized
    case provisional // iOS 12+ for quiet notifications
}

public struct NotificationSettings {
    public let permissionStatus: NotificationPermissionStatus
    public let alertEnabled: Bool
    public let badgeEnabled: Bool
    public let soundEnabled: Bool
    public let doNotDisturbActive: Bool
    public let scheduledDeliveryEnabled: Bool // iOS 15+
    
    public init(
        permissionStatus: NotificationPermissionStatus,
        alertEnabled: Bool = true,
        badgeEnabled: Bool = true,
        soundEnabled: Bool = true,
        doNotDisturbActive: Bool = false,
        scheduledDeliveryEnabled: Bool = false
    ) {
        self.permissionStatus = permissionStatus
        self.alertEnabled = alertEnabled
        self.badgeEnabled = badgeEnabled
        self.soundEnabled = soundEnabled
        self.doNotDisturbActive = doNotDisturbActive
        self.scheduledDeliveryEnabled = scheduledDeliveryEnabled
    }
}
```

### Core Service

```swift
@MainActor
public class NotificationService: ObservableObject {
    // Published properties for UI binding
    @Published public var permissionStatus: NotificationPermissionStatus = .notDetermined
    @Published public var settings: NotificationSettings
    @Published public var badgeCount: Int = 0
    @Published public var lastError: Error?
    @Published public var isDoNotDisturbActive: Bool = false
    
    // Configuration
    private let enableBadgeManagement: Bool
    private let respectDoNotDisturb: Bool
    private let defaultSound: String?
    
    /// Initialize the notification service
    /// - Parameters:
    ///   - enableBadgeManagement: Whether to automatically manage badge counts
    ///   - respectDoNotDisturb: Whether to respect Do Not Disturb settings
    ///   - defaultSound: Default notification sound name
    public init(
        enableBadgeManagement: Bool = true,
        respectDoNotDisturb: Bool = true,
        defaultSound: String? = nil
    ) {
        self.enableBadgeManagement = enableBadgeManagement
        self.respectDoNotDisturb = respectDoNotDisturb
        self.defaultSound = defaultSound
        
        // Initialize settings
        self.settings = NotificationSettings(permissionStatus: .notDetermined)
        self.updatePermissionStatus()
        self.updateDoNotDisturbStatus()
    }
    
    // MARK: - Permission Management
    
    /// Request notification permission
    /// - Parameter options: Notification types to request
    /// - Returns: Permission status
    public func requestPermission(options: [NotificationType] = [.alert, .badge, .sound]) async -> NotificationPermissionStatus {
        #if os(iOS)
        return await requestIOSNotificationPermission(options: options)
        #elseif os(macOS)
        return await requestMacOSNotificationPermission(options: options)
        #else
        return .notDetermined
        #endif
    }
    
    /// Check current permission status
    public func checkPermissionStatus() -> NotificationPermissionStatus {
        return permissionStatus
    }
    
    // MARK: - Alerts
    
    /// Show platform-appropriate alert
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - style: Alert style
    ///   - actions: Alert actions
    /// - Returns: Selected action identifier
    public func showAlert(
        title: String,
        message: String? = nil,
        style: AlertStyle = .alert,
        actions: [AlertAction] = []
    ) async -> String? {
        guard !isDoNotDisturbBlocking() else {
            throw NotificationServiceError.doNotDisturbActive
        }
        
        #if os(iOS)
        return await showIOSAlert(title: title, message: message, style: style, actions: actions)
        #elseif os(macOS)
        return await showMacOSAlert(title: title, message: message, style: style, actions: actions)
        #else
        return nil
        #endif
    }
    
    // MARK: - Badge Management
    
    /// Update app badge count
    /// - Parameter count: Badge count (0 to clear)
    public func updateBadge(_ count: Int) throws {
        guard enableBadgeManagement else { return }
        guard count >= 0 else {
            throw NotificationServiceError.badgeUpdateFailed
        }
        
        badgeCount = count
        
        #if os(iOS)
        UIApplication.shared.applicationIconBadgeNumber = count
        #elseif os(macOS)
        // macOS doesn't have badge numbers, but we can track for future use
        #endif
    }
    
    /// Increment badge count
    public func incrementBadge() throws {
        try updateBadge(badgeCount + 1)
    }
    
    /// Decrement badge count
    public func decrementBadge() throws {
        try updateBadge(max(0, badgeCount - 1))
    }
    
    /// Clear badge
    public func clearBadge() throws {
        try updateBadge(0)
    }
    
    // MARK: - Local Notifications
    
    /// Schedule a local notification
    /// - Parameters:
    ///   - identifier: Unique identifier for the notification
    ///   - title: Notification title
    ///   - body: Notification body
    ///   - date: When to deliver the notification
    ///   - sound: Sound name (optional)
    ///   - badge: Badge count (optional)
    public func scheduleLocalNotification(
        identifier: String,
        title: String,
        body: String,
        date: Date,
        sound: String? = nil,
        badge: Int? = nil
    ) throws {
        guard permissionStatus == .authorized || permissionStatus == .provisional else {
            throw NotificationServiceError.permissionDenied
        }
        
        #if os(iOS)
        try scheduleIOSLocalNotification(
            identifier: identifier,
            title: title,
            body: body,
            date: date,
            sound: sound ?? defaultSound,
            badge: badge
        )
        #elseif os(macOS)
        try scheduleMacOSLocalNotification(
            identifier: identifier,
            title: title,
            body: body,
            date: date,
            sound: sound ?? defaultSound
        )
        #endif
    }
    
    /// Cancel a scheduled notification
    /// - Parameter identifier: Notification identifier
    public func cancelNotification(identifier: String) {
        #if os(iOS)
        cancelIOSNotification(identifier: identifier)
        #elseif os(macOS)
        cancelMacOSNotification(identifier: identifier)
        #endif
    }
    
    /// Cancel all scheduled notifications
    public func cancelAllNotifications() {
        #if os(iOS)
        cancelAllIOSNotifications()
        #elseif os(macOS)
        cancelAllMacOSNotifications()
        #endif
    }
    
    // MARK: - Do Not Disturb
    
    /// Check if Do Not Disturb is active
    public func checkDoNotDisturbStatus() -> Bool {
        #if os(iOS)
        return checkIOSDoNotDisturbStatus()
        #elseif os(macOS)
        return checkMacOSDoNotDisturbStatus()
        #else
        return false
        #endif
    }
    
    /// Check if Do Not Disturb would block a notification
    private func isDoNotDisturbBlocking() -> Bool {
        return respectDoNotDisturb && isDoNotDisturbActive
    }
    
    // MARK: - Sound Preferences
    
    /// Check if sound is enabled
    public func isSoundEnabled() -> Bool {
        return settings.soundEnabled && !isDoNotDisturbBlocking()
    }
    
    /// Play notification sound
    /// - Parameter soundName: Sound name (optional, uses default if nil)
    public func playSound(_ soundName: String? = nil) {
        guard isSoundEnabled() else { return }
        // Play sound implementation
    }
    
    // MARK: - Private Helpers
    
    private func updatePermissionStatus() {
        #if os(iOS)
        permissionStatus = checkIOSNotificationPermission()
        #elseif os(macOS)
        permissionStatus = checkMacOSNotificationPermission()
        #else
        permissionStatus = .notDetermined
        #endif
        
        settings = NotificationSettings(
            permissionStatus: permissionStatus,
            alertEnabled: settings.alertEnabled,
            badgeEnabled: settings.badgeEnabled,
            soundEnabled: settings.soundEnabled,
            doNotDisturbActive: isDoNotDisturbActive
        )
    }
    
    private func updateDoNotDisturbStatus() {
        isDoNotDisturbActive = checkDoNotDisturbStatus()
        settings = NotificationSettings(
            permissionStatus: settings.permissionStatus,
            alertEnabled: settings.alertEnabled,
            badgeEnabled: settings.badgeEnabled,
            soundEnabled: settings.soundEnabled,
            doNotDisturbActive: isDoNotDisturbActive
        )
    }
}

// MARK: - Alert Action

public struct AlertAction {
    public let identifier: String
    public let title: String
    public let style: AlertActionStyle
    public let isDestructive: Bool
    
    public init(
        identifier: String,
        title: String,
        style: AlertActionStyle = .default,
        isDestructive: Bool = false
    ) {
        self.identifier = identifier
        self.title = title
        self.style = style
        self.isDestructive = isDestructive
    }
}

public enum AlertActionStyle {
    case `default`
    case cancel
    case destructive
}
```

### Notification Hints

```swift
/// Hints for notification configuration
public struct NotificationHints {
    public let enableBadgeManagement: Bool
    public let respectDoNotDisturb: Bool
    public let defaultSound: String?
    public let alertStyle: AlertStyle
    public let priority: NotificationPriority
    
    public init(
        enableBadgeManagement: Bool = true,
        respectDoNotDisturb: Bool = true,
        defaultSound: String? = nil,
        alertStyle: AlertStyle = .alert,
        priority: NotificationPriority = .normal
    ) {
        self.enableBadgeManagement = enableBadgeManagement
        self.respectDoNotDisturb = respectDoNotDisturb
        self.defaultSound = defaultSound
        self.alertStyle = alertStyle
        self.priority = priority
    }
}
```

## Layer 1 Semantic Functions

Following the pattern of `PlatformInternationalizationL1.swift`:

```swift
/// Present platform-appropriate alert
@MainActor
public func platformPresentAlert_L1(
    title: String,
    message: String? = nil,
    hints: NotificationHints = NotificationHints()
) -> AnyView {
    let notification = NotificationService(
        respectDoNotDisturb: hints.respectDoNotDisturb
    )
    
    // This would typically be used with a button action
    return AnyView(EmptyView()
        .environmentObject(notification)
        .automaticCompliance(named: "platformPresentAlert_L1"))
}

/// Show notification with platform-appropriate style
@MainActor
public func platformShowNotification_L1(
    title: String,
    body: String,
    hints: NotificationHints = NotificationHints()
) async throws {
    let notification = NotificationService(
        respectDoNotDisturb: hints.respectDoNotDisturb,
        defaultSound: hints.defaultSound
    )
    
    try await notification.scheduleLocalNotification(
        identifier: UUID().uuidString,
        title: title,
        body: body,
        date: Date(),
        sound: hints.defaultSound
    )
}

/// Update app badge
@MainActor
public func platformUpdateBadge_L1(
    count: Int,
    hints: NotificationHints = NotificationHints()
) throws {
    let notification = NotificationService(
        enableBadgeManagement: hints.enableBadgeManagement
    )
    try notification.updateBadge(count)
}

/// Request notification permission
@MainActor
public func platformRequestNotificationPermission_L1(
    hints: NotificationHints = NotificationHints()
) async -> NotificationPermissionStatus {
    let notification = NotificationService(
        respectDoNotDisturb: hints.respectDoNotDisturb
    )
    return await notification.requestPermission()
}
```

## Platform-Specific Considerations

### iOS
- Native alerts and action sheets
- Banner notifications
- Badge numbers on app icon
- Do Not Disturb integration
- Notification Center integration
- Local and remote notifications

### macOS
- Sheet presentations for alerts
- Notification Center integration
- Badge support (limited)
- Do Not Disturb integration
- User notification framework

### visionOS
- Spatial notifications
- Immersive alerts
- Spatial badge indicators

## Testing

- Framework tests should avoid actual notification delivery (use mocks)
- Service should be mockable via protocol
- Platform-specific behavior should be testable
- Permission status should be testable without actual permissions
- Badge updates should be testable

## Implementation Checklist

### Phase 1: Core Service
- [ ] Create `NotificationService` class
- [ ] Define `NotificationServiceError` enum
- [ ] Implement permission status checking
- [ ] Implement permission requesting (iOS)
- [ ] Implement permission requesting (macOS)
- [ ] Define `NotificationHints` struct

### Phase 2: Alerts & Badges
- [ ] Implement platform-appropriate alert presentation
- [ ] Implement badge management (iOS)
- [ ] Implement badge tracking (macOS)
- [ ] Add Do Not Disturb detection
- [ ] Add Do Not Disturb respect logic

### Phase 3: Local Notifications
- [ ] Implement local notification scheduling (iOS)
- [ ] Implement local notification scheduling (macOS)
- [ ] Add notification cancellation
- [ ] Add sound support
- [ ] Add notification categories and actions

### Phase 4: Layer 1 Functions
- [ ] Create `PlatformNotificationL1.swift`
- [ ] Implement `platformPresentAlert_L1()`
- [ ] Implement `platformShowNotification_L1()`
- [ ] Implement `platformUpdateBadge_L1()`
- [ ] Implement `platformRequestNotificationPermission_L1()`
- [ ] Add RTL support for notification UI

### Phase 5: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`NotificationGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation
- [ ] Add integration examples with forms

## Design Decisions

### Why Service Pattern?
- **Consistency**: Matches `InternationalizationService` pattern
- **ObservableObject**: Enables SwiftUI binding
- **Testability**: Easy to mock for testing
- **Separation of Concerns**: Framework handles boilerplate, app handles configuration

### Why Configuration-Based?
- **Flexibility**: Apps can configure notification behavior
- **Privacy**: Apps control when to show notifications
- **Platform Adaptation**: Automatic platform detection

### Why Layer 1 Functions?
- **Semantic Intent**: High-level notification interfaces
- **Framework Focus**: UI abstraction is core to framework
- **Consistency**: Matches existing Layer 1 patterns

## Related

- `InternationalizationService.swift` - Reference implementation pattern
- `LocationService.swift` - Similar service pattern
- `OCRService.swift` - Similar service pattern
- `PlatformInternationalizationL1.swift` - Layer 1 function pattern
- `PlatformMessagingLayer5.swift` - Existing messaging components (to be integrated)

## Acceptance Criteria

- [ ] `NotificationService` class exists with full API
- [ ] Permission requesting works on iOS and macOS
- [ ] Platform-appropriate alerts are shown correctly
- [ ] Badge management works on iOS
- [ ] Local notifications can be scheduled and cancelled
- [ ] Do Not Disturb is respected when enabled
- [ ] Sound preferences are respected
- [ ] Layer 1 semantic functions are implemented
- [ ] Comprehensive tests pass (30+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported


