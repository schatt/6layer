//
//  TaskManagerViewModel.swift
//  TaskManagerSampleApp
//
//  View model for TaskManager demonstrating service composition and error handling
//

import Foundation
import CloudKit
import SwiftUI
import SixLayerFramework

/// View model for managing tasks
/// Demonstrates CloudKitService integration, error handling, and service composition
@MainActor
public class TaskManagerViewModel: ObservableObject, CloudKitServiceDelegate {
    
    // MARK: - Published Properties
    
    @Published public var tasks: [Task] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var syncStatus: CloudKitSyncStatus = .idle
    
    // MARK: - Services
    
    public let cloudKitService: CloudKitService
    private let notificationService: NotificationService
    private let securityService: SecurityService
    public let i18nService: InternationalizationService
    
    // MARK: - Initialization
    
    public init(
        cloudKitService: CloudKitService? = nil,
        notificationService: NotificationService? = nil,
        securityService: SecurityService? = nil,
        i18nService: InternationalizationService? = nil
    ) {
        // Initialize services with defaults or provided instances
        self.cloudKitService = cloudKitService ?? CloudKitService(
            containerIdentifier: "iCloud.com.example.TaskManager"
        )
        self.notificationService = notificationService ?? NotificationService()
        self.securityService = securityService ?? SecurityService()
        self.i18nService = i18nService ?? InternationalizationService()
        
        // Set delegate
        self.cloudKitService.delegate = self
    }
    
    // MARK: - Task Management
    
    /// Add a new task
    public func addTask(_ task: Task) {
        tasks.append(task)
        syncStatus = .idle
    }
    
    /// Delete a task
    public func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        syncStatus = .idle
    }
    
    /// Update a task
    public func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
            syncStatus = .idle
        }
    }
    
    /// Toggle task completion status
    public func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = tasks[index]
            updatedTask.isCompleted.toggle()
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
            syncStatus = .idle
        }
    }
    
    // MARK: - CloudKit Integration
    
    /// Sync tasks with CloudKit
    public func syncTasks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await cloudKitService.sync(recordTypes: ["Task"])
            syncStatus = cloudKitService.syncStatus
            
            // Fetch tasks after sync
            await fetchTasks()
        } catch {
            errorMessage = i18nService.localizedString(
                for: "task.sync.error",
                arguments: [error.localizedDescription]
            )
            syncStatus = .error(error)
        }
        
        isLoading = false
    }
    
    /// Fetch tasks from CloudKit
    public func fetchTasks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let query = CKQuery(recordType: "Task", predicate: NSPredicate(value: true))
            let records = try await cloudKitService.query(query)
            
            tasks = records.map { Task(from: $0) }
        } catch {
            errorMessage = i18nService.localizedString(
                for: "task.fetch.error",
                arguments: [error.localizedDescription]
            )
        }
        
        isLoading = false
    }
    
    /// Save task to CloudKit
    public func saveTaskToCloudKit(_ task: Task) async {
        do {
            let record = task.toCloudKitRecord()
            let savedRecord = try await cloudKitService.save(record)
            
            // Update task with CloudKit record ID
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                var updatedTask = tasks[index]
                updatedTask.cloudKitRecordID = savedRecord.recordID
                tasks[index] = updatedTask
            }
        } catch {
            errorMessage = i18nService.localizedString(
                for: "task.save.error",
                arguments: [error.localizedDescription]
            )
        }
    }
    
    // MARK: - Notification Integration
    
    /// Schedule notification for task due date
    public func scheduleTaskNotification(for task: Task) async throws {
        guard let dueDate = task.dueDate else { return }
        
        // Request permission if needed
        let status = await notificationService.requestPermission()
        guard status == .authorized || status == .provisional else {
            throw NotificationServiceError.permissionDenied
        }
        
        // Schedule notification
        let title = i18nService.localizedString(for: "task.notification.title")
        let body = i18nService.localizedString(
            for: "task.notification.body",
            arguments: [task.title]
        )
        
        try notificationService.scheduleLocalNotification(
            identifier: "task-\(task.id.uuidString)",
            title: title,
            body: body,
            date: dueDate
        )
    }
    
    // MARK: - Security Integration
    
    /// Authenticate user before accessing tasks
    public func authenticate() async throws -> Bool {
        guard securityService.isBiometricAvailable else {
            throw SecurityServiceError.biometricNotAvailable
        }
        
        let reason = i18nService.localizedString(for: "task.auth.reason")
        return try await securityService.authenticateWithBiometrics(reason: reason)
    }
    
    // MARK: - CloudKitServiceDelegate
    
    public func validateRecord(_ record: CKRecord) throws {
        // Validate required fields
        guard record["title"] as? String != nil else {
            throw CloudKitServiceError.invalidRecord
        }
    }
    
    public func transformRecord(_ record: CKRecord) -> CKRecord {
        // Add any transformations needed
        return record
    }
    
    public func handleError(_ error: Error) -> Bool {
        // Handle specific errors
        if let ckError = error as? CKError {
            switch ckError.code {
            case .networkUnavailable:
                errorMessage = i18nService.localizedString(for: "task.error.network")
                return true
            case .notAuthenticated:
                errorMessage = i18nService.localizedString(for: "task.error.auth")
                return true
            default:
                return false
            }
        }
        return false
    }
    
    public func syncDidComplete(success: Bool, recordsChanged: Int) {
        syncStatus = success ? .complete : .error(NSError(domain: "TaskManager", code: -1))
    }
}



