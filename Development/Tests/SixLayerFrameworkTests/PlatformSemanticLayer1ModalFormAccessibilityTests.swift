import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// BUSINESS PURPOSE: Accessibility tests for PlatformSemanticLayer1.swift modal form functions
/// Ensures modal form presentation functions generate proper accessibility identifiers
/// for automated testing and accessibility tools compliance
final class PlatformSemanticLayer1ModalFormAccessibilityTests: XCTestCase {
    
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    @MainActor
    override func tearDown() async throws {
        try await super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - Test Data Models
    
    struct ModalFormTestData {
        let name: String
        let email: String
    }
    
    // MARK: - Modal Form Presentation Tests
    
    /// BUSINESS PURPOSE: Validates that platformPresentModalForm_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on iOS
    func testPlatformPresentModalFormL1GeneratesAccessibilityIdentifiersOnIOS() async {
        // Given
        let testData = ModalFormTestData(name: "Test Name", email: "test@example.com")
        
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        // Verify test data and hints are properly configured
        XCTAssertEqual(testData.name, "Test Name", "Test data should have correct name")
        XCTAssertEqual(testData.email, "test@example.com", "Test data should have correct email")
        XCTAssertEqual(hints.dataType, .form, "Hints should have correct data type")
        XCTAssertEqual(hints.context, .modal, "Hints should have correct context")
        
        let view = await MainActor.run {
            platformPresentModalForm_L1(
                formType: .form,
                context: .modal
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*modalform", 
                platform: .iOS,
                componentName: "platformPresentModalForm_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentModalForm_L1 should generate accessibility identifiers on iOS")
    }
    
    /// BUSINESS PURPOSE: Validates that platformPresentModalForm_L1 generates proper accessibility identifiers
    /// for automated testing and accessibility tools compliance on macOS
    func testPlatformPresentModalFormL1GeneratesAccessibilityIdentifiersOnMacOS() async {
        // Given
        let testData = ModalFormTestData(name: "Test Name", email: "test@example.com")
        
        let hints = PresentationHints(
            dataType: .form,
            presentationPreference: .automatic,
            complexity: .moderate,
            context: .modal,
            customPreferences: [:]
        )
        
        // Verify test data and hints are properly configured
        XCTAssertEqual(testData.name, "Test Name", "Test data should have correct name")
        XCTAssertEqual(testData.email, "test@example.com", "Test data should have correct email")
        XCTAssertEqual(hints.dataType, .form, "Hints should have correct data type")
        XCTAssertEqual(hints.context, .modal, "Hints should have correct context")
        
        let view = await MainActor.run {
            platformPresentModalForm_L1(
                formType: .form,
                context: .modal
            )
        }
        
        // When & Then
        let hasAccessibilityID = await MainActor.run {
            hasAccessibilityIdentifier(
                view, 
                expectedPattern: "SixLayer.*element.*modalform", 
                platform: .macOS,
                componentName: "platformPresentModalForm_L1"
            )
        }
        
        XCTAssertTrue(hasAccessibilityID, "platformPresentModalForm_L1 should generate accessibility identifiers on macOS")
    }
}
