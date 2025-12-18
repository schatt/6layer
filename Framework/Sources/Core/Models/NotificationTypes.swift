//
//  NotificationTypes.swift
//  SixLayerFramework
//
//  Type definitions for Notification Service
//  Provides error types, enums, and configuration structs
//

import Foundation

// MARK: - Notification Service Errors

/// Errors that can occur in the notification service
public enum NotificationServiceError: LocalizedError, Equatable {
    case permissionDenied
    case permissionNotDetermined
    case notificationNotSupported
    case invalidNotification
    case schedulingFailed
    case badgeUpdateFailed
    case soundNotFound
    case doNotDisturbActive
    case unknown(Error)
    
    public static func == (lhs: NotificationServiceError, rhs: NotificationServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.permissionDenied, .permissionDenied),
             (.permissionNotDetermined, .permissionNotDetermined),
             (.notificationNotSupported, .notificationNotSupported),
             (.invalidNotification, .invalidNotification),
             (.schedulingFailed, .schedulingFailed),
             (.badgeUpdateFailed, .badgeUpdateFailed),
             (.soundNotFound, .soundNotFound),
             (.doNotDisturbActive, .doNotDisturbActive):
            return true
        case (.unknown(let lhsError), .unknown(let rhsError)):
            // Compare error descriptions since Error doesn't conform to Equatable
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
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

// MARK: - Notification Types

/// Types of notification features that can be requested
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

/// Priority level for notifications
public enum NotificationPriority {
    case low
    case normal
    case high
    case critical
}

/// Style for notification/alert presentation
public enum NotificationPresentationStyle {
    case alert
    case actionSheet
    case banner
    case notification
}

// MARK: - Notification Permission Status

/// Status of notification permissions
public enum NotificationPermissionStatus {
    case notDetermined
    case denied
    case authorized
    case provisional // iOS 12+ for quiet notifications
}

// MARK: - Notification Settings

/// Current notification settings and status
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

// MARK: - Alert Action

/// Action that can be taken in an alert
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

/// Style for alert actions
public enum AlertActionStyle {
    case `default`
    case cancel
    case destructive
}

// MARK: - Notification Category

/// Notification category with actions
public struct NotificationCategory {
    public let identifier: String
    public let actions: [NotificationAction]
    public let intentIdentifiers: [String]
    public let options: NotificationCategoryOptions
    
    public init(
        identifier: String,
        actions: [NotificationAction] = [],
        intentIdentifiers: [String] = [],
        options: NotificationCategoryOptions = []
    ) {
        self.identifier = identifier
        self.actions = actions
        self.intentIdentifiers = intentIdentifiers
        self.options = options
    }
}

/// Notification action for categories
public struct NotificationAction {
    public let identifier: String
    public let title: String
    public let options: NotificationActionOptions
    
    public init(
        identifier: String,
        title: String,
        options: NotificationActionOptions = []
    ) {
        self.identifier = identifier
        self.title = title
        self.options = options
    }
}

/// Options for notification categories
public struct NotificationCategoryOptions: OptionSet, Sendable {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let customDismissAction = NotificationCategoryOptions(rawValue: 1 << 0)
    #if os(iOS)
    public static let allowInCarPlay = NotificationCategoryOptions(rawValue: 1 << 1)
    public static let allowAnnouncement = NotificationCategoryOptions(rawValue: 1 << 2)
    #endif
}

/// Options for notification actions
public struct NotificationActionOptions: OptionSet, Sendable {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let authenticationRequired = NotificationActionOptions(rawValue: 1 << 0)
    public static let destructive = NotificationActionOptions(rawValue: 1 << 1)
    public static let foreground = NotificationActionOptions(rawValue: 1 << 2)
}

// MARK: - Notification Hints

/// Configuration hints for notification behavior
public struct NotificationHints {
    public let enableBadgeManagement: Bool
    public let respectDoNotDisturb: Bool
    public let defaultSound: String?
    public let alertStyle: NotificationPresentationStyle
    public let priority: NotificationPriority
    
    public init(
        enableBadgeManagement: Bool = true,
        respectDoNotDisturb: Bool = true,
        defaultSound: String? = nil,
        alertStyle: NotificationPresentationStyle = .alert,
        priority: NotificationPriority = .normal
    ) {
        self.enableBadgeManagement = enableBadgeManagement
        self.respectDoNotDisturb = respectDoNotDisturb
        self.defaultSound = defaultSound
        self.alertStyle = alertStyle
        self.priority = priority
    }
}






