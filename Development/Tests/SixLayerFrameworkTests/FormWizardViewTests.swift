import XCTest
import SwiftUI
@testable import SixLayerFramework
import ViewInspector

/// Tests for FormWizardView.swift
/// 
/// BUSINESS PURPOSE: Ensure FormWizardView generates proper accessibility identifiers
/// TESTING SCOPE: All components in FormWizardView.swift
/// METHODOLOGY: Test each component on both iOS and macOS platforms as required by mandatory testing guidelines
@MainActor
final class FormWizardViewTests: XCTestCase {
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.enableAutoIDs = true
        config.namespace = "SixLayer"
        config.mode = .automatic
        config.enableDebugLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        cleanupTestEnvironment()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    // MARK: - FormWizardView Tests
    
    func testFormWizardViewGeneratesAccessibilityIdentifiersOnIOS() async {
        let step1 = FormWizardStep(id: "step1", title: "Step 1", stepOrder: 0)
        let step2 = FormWizardStep(id: "step2", title: "Step 2", stepOrder: 1)
        
        let view = FormWizardView(steps: [step1, step2]) { step, state in
            Text("Step content for \(step.title)")
        } navigation: { state, onNext, onPrevious, onComplete in
            HStack {
                Button("Previous") { onPrevious() }
                Button("Next") { onNext() }
            }
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .iOS,
            componentName: "FormWizardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "FormWizardView should generate accessibility identifiers on iOS")
    }
    
    func testFormWizardViewGeneratesAccessibilityIdentifiersOnMacOS() async {
        let step1 = FormWizardStep(id: "step1", title: "Step 1", stepOrder: 0)
        let step2 = FormWizardStep(id: "step2", title: "Step 2", stepOrder: 1)
        
        let view = FormWizardView(steps: [step1, step2]) { step, state in
            Text("Step content for \(step.title)")
        } navigation: { state, onNext, onPrevious, onComplete in
            HStack {
                Button("Previous") { onPrevious() }
                Button("Next") { onNext() }
            }
        }
        
        let hasAccessibilityID = hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: .macOS,
            componentName: "FormWizardView"
        )
        
        XCTAssertTrue(hasAccessibilityID, "FormWizardView should generate accessibility identifiers on macOS")
    }
}

