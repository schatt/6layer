//
//  NotificationServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of NotificationService for testing
//

import Foundation
import UserNotifications
import SixLayerFramework

/// Mock implementation of NotificationService for testing
public class NotificationServiceMock: NotificationServiceDelegate {

    // MARK: - Configuration

    public enum MockMode {
        case success
        case failure(error: Error)
        case custom(handler: (NotificationOperation) async throws -> Any)
    }

    private var mode: MockMode = .success

    // MARK: - Mock State Tracking

    public private(set) var requestPermissionWasCalled = false
    public private(set) var permissionGranted = true

    public private(set) var scheduleLocalNotificationWasCalled = false
    public private(set) var scheduledNotifications: [LocalNotificationRequest] = []

    public private(set) var cancelNotificationWasCalled = false
    public private(set) var cancelledIdentifiers: [String] = []

    public private(set) var getPendingNotificationsWasCalled = false
    public private(set) var pendingNotifications: [UNNotificationRequest] = []

    public private(set) var getDeliveredNotificationsWasCalled = false
    public private(set) var deliveredNotifications: [UNNotification] = []

    // MARK: - Callbacks

    public var onNotificationReceived: ((Any) -> Void)?

    // MARK: - Configuration Methods

    /// Configure mock to return success for all operations
    public func configureSuccessResponse() {
        mode = .success
    }

    /// Configure mock to return failure for all operations
    public func configureFailureResponse(error: Error = NSError(domain: "NotificationError", code: 1, userInfo: nil)) {
        mode = .failure(error: error)
    }

    /// Configure custom response handler
    public func configureCustomResponse(handler: @escaping (NotificationOperation) async throws -> Any) {
        mode = .custom(handler: handler)
    }

    /// Configure permission response
    public func configurePermissionResponse(granted: Bool) {
        permissionGranted = granted
    }

    /// Reset all tracking state
    public func reset() {
        requestPermissionWasCalled = false
        permissionGranted = true
        scheduleLocalNotificationWasCalled = false
        scheduledNotifications = []
        cancelNotificationWasCalled = false
        cancelledIdentifiers = []
        getPendingNotificationsWasCalled = false
        pendingNotifications = []
        getDeliveredNotificationsWasCalled = false
        deliveredNotifications = []
        mode = .success
    }

    // MARK: - NotificationServiceDelegate Implementation

    public func requestNotificationPermission() async throws -> Bool {
        requestPermissionWasCalled = true

        switch mode {
        case .success:
            return permissionGranted
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.requestPermission)
            guard let granted = result as? Bool else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return granted
        }
    }

    public func scheduleLocalNotification(identifier: String, title: String, body: String, date: Date) async throws {
        scheduleLocalNotificationWasCalled = true

        let request = LocalNotificationRequest(
            identifier: identifier,
            title: title,
            body: body,
            date: date
        )
        scheduledNotifications.append(request)

        switch mode {
        case .success:
            return
        case .failure(let error):
            throw error
        case .custom(let handler):
            _ = try await handler(.scheduleLocal(identifier: identifier, title: title, body: body, date: date))
        }
    }

    public func cancelNotification(identifier: String) async {
        cancelNotificationWasCalled = true
        cancelledIdentifiers.append(identifier)
    }

    public func getPendingNotifications() async -> [UNNotificationRequest] {
        getPendingNotificationsWasCalled = true
        return pendingNotifications
    }

    public func getDeliveredNotifications() async -> [UNNotification] {
        getDeliveredNotificationsWasCalled = true
        return deliveredNotifications
    }

    // MARK: - Mock Notification Simulation

    /// Simulate receiving a notification
    public func simulateNotificationReceived(identifier: String, title: String, body: String) {
        let mockNotification = MockNotification(identifier: identifier, title: title, body: body)
        onNotificationReceived?(mockNotification)
    }

    /// Add mock pending notifications
    public func addMockPendingNotification(identifier: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        pendingNotifications.append(request)
    }

    /// Add mock delivered notifications
    public func addMockDeliveredNotification(identifier: String, title: String, body: String, date: Date) {
        let content = UNNotificationContent()
        content.title = title
        content.body = body

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        let notification = UNNotification(request: request, date: date)
        deliveredNotifications.append(notification)
    }
}

// MARK: - Supporting Types

/// Simplified local notification request for testing
public struct LocalNotificationRequest {
    public let identifier: String
    public let title: String
    public let body: String
    public let date: Date
}

/// Mock notification for testing
public struct MockNotification {
    public let identifier: String
    public let title: String
    public let body: String
}

// MARK: - Notification Operation Types (for testing)

/// Simplified notification operation types for testing
public enum NotificationOperation {
    case requestPermission
    case scheduleLocal(identifier: String, title: String, body: String, date: Date)
    case cancel(identifier: String)
    case getPending
    case getDelivered
}