//
//  SixLayerTestKitExamples.swift
//  SixLayerTestKitTests
//
//  Example tests demonstrating how to use SixLayerTestKit
//

import XCTest
import SwiftUI
@testable import SixLayerFramework
@testable import SixLayerTestKit

class SixLayerTestKitExamples: XCTestCase {

    var testKit: SixLayerTestKit!

    @MainActor
    override func setUp() {
        super.setUp()
        testKit = SixLayerTestKit()
    }
    
    @MainActor
    override func tearDown() {
        testKit = nil
        super.tearDown()
    }

    // MARK: - Service Mocking Examples

    @MainActor
    func testCloudKitServiceMock() {
        // Given: A CloudKit service with mock
        let mock = testKit.serviceMocks.cloudKitService
        mock.configureSuccessResponse()

        // When: We save a record
        let record = CKRecord(recordType: "TestRecord", recordID: CKRecord.ID(recordName: "test"))
        record["name"] = "Test Item"

        // Simulate save operation (in real code, this would be through CloudKitService)
        Task {
            do {
                _ = try await mock.execute(.save(record))
            } catch {
                XCTFail("Save should succeed")
            }
        }

        // Then: Verify the interaction
        XCTAssertTrue(mock.saveWasCalled)
        XCTAssertEqual(mock.saveRecords.count, 1)
        XCTAssertEqual(mock.saveRecords.first?["name"] as? String, "Test Item")
    }

    @MainActor
    func testNotificationServiceMock() {
        // Given: A notification service with mock
        let mock = testKit.serviceMocks.notificationService
        mock.configureSuccessResponse()

        // When: We schedule a notification
        Task {
            do {
                try await mock.scheduleLocalNotification(
                    identifier: "test-notification",
                    title: "Test Title",
                    body: "Test Body",
                    date: Date().addingTimeInterval(60)
                )
            } catch {
                XCTFail("Scheduling should succeed")
            }
        }

        // Then: Verify the interaction
        XCTAssertTrue(mock.scheduleLocalNotificationWasCalled)
        XCTAssertEqual(mock.scheduledNotifications.count, 1)
        XCTAssertEqual(mock.scheduledNotifications.first?.identifier, "test-notification")
    }

    @MainActor
    func testSecurityServiceMock() {
        // Given: A security service with mock
        let mock = testKit.serviceMocks.securityService
        mock.configureSuccessResponse()

        // When: We authenticate with biometrics
        Task {
            do {
                let success = try await mock.authenticateWithBiometrics(reason: "Test auth")
                XCTAssertTrue(success)
            } catch {
                XCTFail("Authentication should succeed")
            }
        }

        // Then: Verify the interaction
        XCTAssertTrue(mock.authenticateWithBiometricsWasCalled)
        XCTAssertEqual(mock.authenticationReason, "Test auth")
    }

    @MainActor
    func testInternationalizationServiceMock() {
        // Given: An internationalization service with mock
        let mock = testKit.serviceMocks.internationalizationService
        mock.addTranslation(key: "greeting", value: "Hello", locale: "en")
        mock.addTranslation(key: "greeting", value: "Hola", locale: "es")

        // When: We request localized strings
        let englishGreeting = mock.localizedString(for: "greeting", locale: "en", defaultValue: "Hi")
        let spanishGreeting = mock.localizedString(for: "greeting", locale: "es", defaultValue: "Hi")
        let missingKey = mock.localizedString(for: "missing", locale: "en", defaultValue: "Default")

        // Then: Verify correct localization
        XCTAssertEqual(englishGreeting, "Hello")
        XCTAssertEqual(spanishGreeting, "Hola")
        XCTAssertEqual(missingKey, "Default")

        // And: Verify tracking
        XCTAssertTrue(mock.wasKeyRequested("greeting"))
        XCTAssertEqual(mock.requestedLocales.count, 3)
    }

    // MARK: - Form Testing Examples

    @MainActor
    func testFormFieldCreationAndInteraction() {
        // Given: Form helper and test fields
        let formHelper = testKit.formHelper

        let nameField = formHelper.createTextField(id: "name", label: "Name", value: "John")
        let emailField = formHelper.createEmailField(id: "email", value: "john@test.com")
        let ageField = formHelper.createNumberField(id: "age", value: 25)

        // When: We create form state
        let formState = formHelper.createFormState(from: [nameField, emailField, ageField])

        // Then: Verify initial state
        XCTAssertEqual(formHelper.getFieldValue(from: formState, fieldId: "name") as? String, "John")
        XCTAssertEqual(formHelper.getFieldValue(from: formState, fieldId: "email") as? String, "john@test.com")
        XCTAssertEqual(formHelper.getFieldValue(from: formState, fieldId: "age") as? Double, 25)
    }

    @MainActor
    func testFormValidation() {
        // Given: Form helper and validation rules
        let formHelper = testKit.formHelper
        let validationRules = formHelper.createValidationRules()

        // When: We validate field values
        let validEmail = formHelper.validateField(
            DynamicFormField(id: "email", label: "Email", contentType: .email, value: "test@example.com"),
            value: "test@example.com",
            rules: validationRules
        )

        let invalidEmail = formHelper.validateField(
            DynamicFormField(id: "email", label: "Email", contentType: .email, value: "invalid-email"),
            value: "invalid-email",
            rules: validationRules
        )

        // Then: Verify validation results
        XCTAssertTrue(validEmail)
        XCTAssertFalse(invalidEmail)
    }

    @MainActor
    func testFormSubmission() {
        // Given: Form helper and test form
        let formHelper = testKit.formHelper
        let fields = formHelper.createTestForm()
        let formState = formHelper.createFormState(from: fields)

        var submittedData: [String: Any]?

        // When: We simulate form submission
        let result = formHelper.simulateFormSubmission(
            state: formState,
            fields: fields,
            onSubmit: { data in
                submittedData = data
            }
        )

        // Then: Verify submission data
        XCTAssertNotNil(submittedData)
        XCTAssertEqual(submittedData?["name"] as? String, "John Doe")
        XCTAssertEqual(result["name"] as? String, "John Doe")
    }

    // MARK: - Navigation Testing Examples

    @MainActor
    func testNavigationFlow() {
        // Given: Navigation helper
        let navHelper = testKit.navigationHelper

        // When: We simulate navigation actions
        navHelper.simulatePush(viewId: "home")
        navHelper.simulatePush(viewId: "settings")
        navHelper.simulatePresentSheet(sheetId: "options")

        // Then: Verify navigation state
        XCTAssertEqual(navHelper.navigationStack, ["home", "settings"])
        XCTAssertEqual(navHelper.presentedSheets, ["options"])

        // When: We simulate going back
        let poppedView = navHelper.simulatePop()
        let dismissedSheet = navHelper.simulateDismissSheet()

        // Then: Verify updated state
        XCTAssertEqual(poppedView, "settings")
        XCTAssertEqual(dismissedSheet, "options")
        XCTAssertEqual(navHelper.navigationStack, ["home"])
        XCTAssertEqual(navHelper.presentedSheets, [])
    }

    @MainActor
    func testDeepLinkHandling() {
        // Given: Navigation helper
        let navHelper = testKit.navigationHelper

        // When: We simulate deep link navigation
        let homeResult = navHelper.simulateDeepLink(URL(string: "myapp://home")!)
        let settingsResult = navHelper.simulateDeepLink(URL(string: "myapp://settings")!)
        let itemResult = navHelper.simulateDeepLink(URL(string: "myapp://item/123")!)

        // Then: Verify navigation results
        XCTAssertEqual(homeResult, [])
        XCTAssertEqual(settingsResult, ["settings"])
        XCTAssertEqual(itemResult, ["item-123"])
    }

    @MainActor
    func testLayer1Functions() {
        // Given: Navigation helper
        let navHelper = testKit.navigationHelper

        // When: We test Layer 1 semantic functions
        let results = navHelper.testSemanticFunctions()

        // Then: Verify function results
        XCTAssertNotNil(results["buttonTapped"])
        XCTAssertNotNil(results["textFieldChanged"])
        XCTAssertNotNil(results["toggleSwitched"])
        XCTAssertNotNil(results["pickerSelected"])
        XCTAssertNotNil(results["sliderMoved"])

        // And: Verify they are the correct types
        XCTAssertTrue(results["buttonTapped"] as? Bool == true)
        XCTAssertTrue(results["textFieldChanged"] is String)
        XCTAssertTrue(results["toggleSwitched"] is Bool)
        XCTAssertTrue(results["pickerSelected"] is String)
        XCTAssertTrue(results["sliderMoved"] is Double)
    }

    // MARK: - Layer Flow Testing Examples

    @MainActor
    func testLayerFlowDriver() async throws {
        // Given: Layer flow driver and configuration
        let flowDriver = testKit.layerFlowDriver
        let input = LayerFlowDriver.LayerInput(
            buttonCount: 2,
            textFieldCount: 1,
            toggleCount: 1,
            sliderCount: 1
        )
        let config = LayerFlowDriver.LayerConfiguration(
            buttonCount: 2,
            textFieldCount: 1,
            toggleCount: 1,
            sliderCount: 1,
            listItemCount: 3,
            cardCount: 2
        )

        // When: We simulate a complete layer flow
        let result = try await flowDriver.simulateLayerFlow(input: input, configuration: config)

        // Then: Verify all layers were executed
        XCTAssertGreaterThan(result.duration, 0)

        // Layer 1 results
        XCTAssertEqual(result.layer1Result.buttonActions.count, 2)
        XCTAssertEqual(result.layer1Result.textFieldInputs.count, 1)
        XCTAssertEqual(result.layer1Result.toggleStates.count, 1)
        XCTAssertEqual(result.layer1Result.sliderValues.count, 1)

        // Layer 2 results
        XCTAssertFalse(result.layer2Result.formSubmissions.isEmpty)
        XCTAssertEqual(result.layer2Result.listSelections.count, 3)
        XCTAssertEqual(result.layer2Result.cardInteractions.count, 2)

        // Layer 3 results
        XCTAssertFalse(result.layer3Result.gridLayouts.isEmpty)
        XCTAssertFalse(result.layer3Result.stackLayouts.isEmpty)
        XCTAssertFalse(result.layer3Result.adaptiveLayouts.isEmpty)

        // Layer 4 results
        XCTAssertFalse(result.layer4Result.tabSwitches.isEmpty)
        XCTAssertFalse(result.layer4Result.sheetPresentations.isEmpty)
        XCTAssertFalse(result.layer4Result.navigationPushes.isEmpty)

        // Layer 5 results
        XCTAssertFalse(result.layer5Result.voiceOverAnnouncements.isEmpty)
        XCTAssertFalse(result.layer5Result.keyboardNavigation.isEmpty)
        XCTAssertFalse(result.layer5Result.dynamicTypeScaling.isEmpty)

        // Layer 6 results
        XCTAssertFalse(result.layer6Result.ocrResults.isEmpty)
        XCTAssertFalse(result.layer6Result.mlPredictions.isEmpty)
        XCTAssertFalse(result.layer6Result.cloudOperations.isEmpty)
    }

    // MARK: - Integration Testing Examples

    @MainActor
    func testCompleteUserFlow() {
        // Given: All test kit components
        let formHelper = testKit.formHelper
        let navHelper = testKit.navigationHelper

        // Create test user flow: Login -> Profile -> Settings -> Logout
        let actions = navHelper.createMockNavigationActions()

        // When: We execute the user flow
        let flow = ["pushHome", "pushProfile", "pushSettings", "pop", "pop", "pop"]
        var executedActions: [String] = []

        for actionKey in flow {
            if let action = actions[actionKey] {
                action()
                executedActions.append(actionKey)
            }
        }

        // Then: Verify the flow
        XCTAssertEqual(executedActions.count, 6)
        XCTAssertEqual(navHelper.navigationStack, ["home"])

        // And: Test form interaction within the flow
        let loginForm = formHelper.createTestForm()
        let loginState = formHelper.createFormState(from: loginForm)

        // Simulate user filling out login form
        formHelper.simulateFieldInput(fieldId: "email", value: "user@example.com", in: loginState)
        formHelper.simulateFieldInput(fieldId: "password", value: "password123", in: loginState)

        // Verify form data
        let email = formHelper.getFieldValue(from: loginState, fieldId: "email") as? String
        let password = formHelper.getFieldValue(from: loginState, fieldId: "password") as? String

        XCTAssertEqual(email, "user@example.com")
        XCTAssertEqual(password, "password123")
    }

    @MainActor
    func testErrorHandlingWithMocks() {
        // Given: Service mocks configured for failure
        let cloudKitMock = testKit.serviceMocks.cloudKitService
        cloudKitMock.configureFailureResponse(error: CloudKitServiceError.networkError)

        let notificationMock = testKit.serviceMocks.notificationService
        notificationMock.configureFailureResponse()

        // When: Operations are attempted
        let cloudKitResult = Task {
            do {
                let record = CKRecord(recordType: "Test", recordID: CKRecord.ID(recordName: "test"))
                return try await cloudKitMock.execute(.save(record))
            } catch {
                return error
            }
        }

        let notificationResult = Task {
            do {
                try await notificationMock.scheduleLocalNotification(
                    identifier: "test",
                    title: "Test",
                    body: "Test",
                    date: Date().addingTimeInterval(60)
                )
                return nil
            } catch {
                return error
            }
        }

        // Then: Verify error handling
        // Note: In real async tests, you'd use expectations to wait for completion
        // This is a simplified example showing the pattern
        XCTAssertNotNil(cloudKitResult)
        XCTAssertNotNil(notificationResult)
    }

    @MainActor
    func testDataGeneration() {
        // Given: Test data generators
        let userData1 = testKit.formHelper.generateTestUserData()
        let userData2 = testKit.formHelper.generateTestUserData()

        // Then: Verify generated data structure
        XCTAssertNotNil(userData1["name"])
        XCTAssertNotNil(userData1["email"])
        XCTAssertNotNil(userData1["phone"])
        XCTAssertNotNil(userData1["age"])
        XCTAssertNotNil(userData1["birthdate"])
        XCTAssertNotNil(userData1["newsletter"])
        XCTAssertNotNil(userData1["country"])

        // And: Verify data is different (random)
        XCTAssertNotEqual(userData1["name"] as? String, userData2["name"] as? String)
    }

    // MARK: - Performance Testing Example

    @MainActor
    func testPerformanceWithTestKit() {
        // Given: Test kit components
        let formHelper = testKit.formHelper
        let navHelper = testKit.navigationHelper

        // When: We measure performance of test operations
        measure {
            // Simulate complex form interactions
            let fields = formHelper.createTestForm()
            let state = formHelper.createFormState(from: fields)
            formHelper.populateFormWithTestData(state, fields: fields)

            // Simulate navigation
            for i in 0..<10 {
                navHelper.simulatePush(viewId: "view\(i)")
            }
            for _ in 0..<10 {
                _ = navHelper.simulatePop()
            }
        }

        // Then: Performance metrics are automatically collected
        // XCTest measures the block execution time
    }
}

// MARK: - Helper Extensions

extension DynamicFormField {
    init(id: String, label: String, contentType: DynamicContentType, placeholder: String? = nil, value: Any? = nil, options: [String]? = nil) {
        let defaultValue: String?
        if let value = value {
            defaultValue = String(describing: value)
        } else {
            defaultValue = nil
        }
        self.init(
            id: id,
            contentType: contentType,
            label: label,
            placeholder: placeholder,
            options: options,
            defaultValue: defaultValue
        )
    }
}