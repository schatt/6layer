//
//  TaskManagerSampleAppTests.swift
//  TaskManagerSampleApp
//
//  Tests for the TaskManager sample app demonstrating SixLayer Framework usage
//  Following TDD principles - tests written before implementation
//

import XCTest
import CloudKit
@testable import SixLayerFramework
@testable import SixLayerTestKit

/// Test suite for TaskManager sample app
/// Demonstrates testing patterns for SixLayer-based apps
@MainActor
final class TaskManagerSampleAppTests: XCTestCase {
    
    var testKit: SixLayerTestKit!
    
    override func setUp() {
        super.setUp()
        testKit = SixLayerTestKit()
    }
    
    override func tearDown() {
        testKit = nil
        super.tearDown()
    }
    
    // MARK: - Task Model Tests
    
    func testTaskModelCreation() {
        // Given: Task data
        let title = "Test Task"
        let description = "Test Description"
        let dueDate = Date()
        let priority = TaskPriority.high
        
        // When: Creating a task
        let task = Task(
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority
        )
        
        // Then: Task should be created with correct values
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.description, description)
        XCTAssertEqual(task.dueDate, dueDate)
        XCTAssertEqual(task.priority, priority)
        XCTAssertFalse(task.isCompleted)
        XCTAssertNotNil(task.id)
    }
    
    func testTaskCloudKitRecordConversion() {
        // Given: A task
        let task = Task(
            title: "Test Task",
            description: "Test Description",
            dueDate: Date(),
            priority: .medium
        )
        
        // When: Converting to CloudKit record
        let record = task.toCloudKitRecord()
        
        // Then: Record should have correct values
        XCTAssertEqual(record.recordType, "Task")
        XCTAssertEqual(record["title"] as? String, task.title)
        XCTAssertEqual(record["description"] as? String, task.description)
        XCTAssertEqual(record["priority"] as? String, task.priority.rawValue)
        XCTAssertEqual(record["isCompleted"] as? Bool, task.isCompleted)
    }
    
    func testTaskFromCloudKitRecord() {
        // Given: A CloudKit record
        let recordID = CKRecord.ID(recordName: "test-task-id")
        let record = CKRecord(recordType: "Task", recordID: recordID)
        record["title"] = "Test Task"
        record["description"] = "Test Description"
        record["priority"] = "high"
        record["isCompleted"] = false
        
        // When: Creating task from record
        let task = Task(from: record)
        
        // Then: Task should have correct values
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "Test Description")
        XCTAssertEqual(task.priority, .high)
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.cloudKitRecordID, recordID)
    }
    
    // MARK: - TaskManagerViewModel Tests
    
    func testTaskManagerViewModelInitialization() {
        // Given: A view model
        // When: Initializing
        let viewModel = TaskManagerViewModel()
        
        // Then: Should have empty tasks array
        XCTAssertTrue(viewModel.tasks.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testTaskManagerViewModelAddTask() {
        // Given: A view model and a task
        let viewModel = TaskManagerViewModel()
        let task = Task(
            title: "New Task",
            description: "Description",
            dueDate: Date(),
            priority: .low
        )
        
        // When: Adding task
        viewModel.addTask(task)
        
        // Then: Task should be in the array
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "New Task")
    }
    
    func testTaskManagerViewModelDeleteTask() {
        // Given: A view model with tasks
        let viewModel = TaskManagerViewModel()
        let task1 = Task(title: "Task 1", description: nil, dueDate: nil, priority: .medium)
        let task2 = Task(title: "Task 2", description: nil, dueDate: nil, priority: .medium)
        viewModel.addTask(task1)
        viewModel.addTask(task2)
        
        // When: Deleting a task
        viewModel.deleteTask(task1)
        
        // Then: Task should be removed
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Task 2")
    }
    
    func testTaskManagerViewModelToggleTaskCompletion() {
        // Given: A view model with a task
        let viewModel = TaskManagerViewModel()
        let task = Task(title: "Task", description: nil, dueDate: nil, priority: .medium)
        viewModel.addTask(task)
        
        // When: Toggling completion
        viewModel.toggleTaskCompletion(task)
        
        // Then: Task should be completed
        XCTAssertTrue(viewModel.tasks.first?.isCompleted ?? false)
    }
    
    // MARK: - CloudKit Integration Tests
    
    func testTaskManagerCloudKitSync() async throws {
        // Given: Mock CloudKit service configured for success
        let mock = testKit.serviceMocks.cloudKitService
        mock.configureSuccessResponse()
        
        let viewModel = TaskManagerViewModel()
        let cloudKitService = CloudKitService(containerIdentifier: "iCloud.com.example.TaskManager")
        cloudKitService.delegate = viewModel
        
        // When: Syncing tasks
        try await cloudKitService.sync(recordTypes: ["Task"])
        
        // Then: Sync should complete successfully
        XCTAssertEqual(cloudKitService.syncStatus, .complete)
    }
    
    func testTaskManagerCloudKitSave() async throws {
        // Given: Mock CloudKit service and a task
        let mock = testKit.serviceMocks.cloudKitService
        mock.configureSuccessResponse()
        
        let viewModel = TaskManagerViewModel()
        let cloudKitService = CloudKitService(containerIdentifier: "iCloud.com.example.TaskManager")
        cloudKitService.delegate = viewModel
        
        let task = Task(title: "Test Task", description: nil, dueDate: nil, priority: .medium)
        let record = task.toCloudKitRecord()
        
        // When: Saving task
        _ = try await cloudKitService.save(record)
        
        // Then: Save should succeed
        XCTAssertTrue(mock.saveWasCalled)
    }
    
    // MARK: - Notification Service Tests
    
    func testTaskManagerNotificationScheduling() async throws {
        // Given: Mock notification service
        let mock = testKit.serviceMocks.notificationService
        mock.configureSuccessResponse()
        
        let notificationService = NotificationService()
        
        // When: Requesting permission and scheduling notification
        let status = await notificationService.requestPermission()
        XCTAssertEqual(status, .authorized)
        
        let dueDate = Date().addingTimeInterval(3600) // 1 hour from now
        try notificationService.scheduleLocalNotification(
            identifier: "task-reminder-1",
            title: "Task Due",
            body: "Your task is due soon",
            date: dueDate
        )
        
        // Then: Notification should be scheduled
        XCTAssertTrue(mock.scheduleWasCalled)
    }
    
    // MARK: - Security Service Tests
    
    func testTaskManagerBiometricAuthentication() async throws {
        // Given: Mock security service
        let mock = testKit.serviceMocks.securityService
        mock.configureBiometricSuccess()
        
        let securityService = SecurityService()
        
        // When: Authenticating with biometrics
        let success = try await securityService.authenticateWithBiometrics(
            reason: "Authenticate to view tasks"
        )
        
        // Then: Authentication should succeed
        XCTAssertTrue(success)
        XCTAssertTrue(securityService.isAuthenticated)
    }
    
    // MARK: - Localization Tests
    
    func testTaskManagerLocalization() {
        // Given: Internationalization service
        let i18n = InternationalizationService(locale: Locale(identifier: "en"))
        
        // When: Getting localized strings
        let title = i18n.localizedString(for: "task.title")
        let addButton = i18n.localizedString(for: "task.add")
        
        // Then: Strings should be localized (or return key if not found)
        XCTAssertNotNil(title)
        XCTAssertNotNil(addButton)
    }
    
    func testTaskManagerLocalizationMultipleLanguages() {
        // Given: Internationalization services for different languages
        let i18nEn = InternationalizationService(locale: Locale(identifier: "en"))
        let i18nEs = InternationalizationService(locale: Locale(identifier: "es"))
        let i18nFr = InternationalizationService(locale: Locale(identifier: "fr"))
        
        // When: Getting localized strings
        let titleEn = i18nEn.localizedString(for: "task.title")
        let titleEs = i18nEs.localizedString(for: "task.title")
        let titleFr = i18nFr.localizedString(for: "task.title")
        
        // Then: Strings should be available (or return key)
        XCTAssertNotNil(titleEn)
        XCTAssertNotNil(titleEs)
        XCTAssertNotNil(titleFr)
    }
    
    // MARK: - Form Integration Tests
    
    func testTaskManagerFormCreation() {
        // Given: Form helper
        let formHelper = testKit.formHelper
        
        // When: Creating a form for Task
        let formConfig = DynamicFormConfiguration(
            id: "task-form",
            fields: [
                DynamicFormField(
                    id: "title",
                    textContentType: nil,
                    contentType: .text,
                    label: "Title",
                    placeholder: "Enter task title",
                    description: nil,
                    isRequired: true,
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
                )
            ],
            sections: nil,
            submitButtonText: "Save",
            cancelButtonText: "Cancel"
        )
        
        // Then: Form should be created
        XCTAssertEqual(formConfig.id, "task-form")
        XCTAssertEqual(formConfig.fields.count, 1)
    }
}



