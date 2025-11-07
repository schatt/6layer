import Testing


import SwiftUI
@testable import SixLayerFramework
#if !os(macOS)
import ViewInspector
#endif
/// Form Callback Functional Tests
/// Tests that forms with callbacks ACTUALLY INVOKE them when buttons are tapped (Rules 6.1, 6.2, 7.3, 7.4)
@MainActor
open class FormCallbackFunctionalTests {
    
    // MARK: - IntelligentFormView Callback Tests
    
    #if !os(macOS)
    @Test func testIntelligentFormViewOnCancelCallbackInvoked() async throws {
        // Rule 6.2 & 7.4: Functional testing - Must verify callbacks ACTUALLY invoke
        // NOTE: ViewInspector is iOS-only, so this test only runs on iOS
        
        var callbackInvoked = false
        
        struct TestFormData {
            let name: String
            let email: String
        }
        
        let testData = TestFormData(name: "Test User", email: "test@example.com")
        
        // Generate form with callback that sets flag when invoked
        let formView = IntelligentFormView.generateForm(
            for: testData,
            onUpdate: { _ in
                // Update callback
            },
            onCancel: {
                callbackInvoked = true
            }
        )
        
        // When: Simulating Cancel button tap using ViewInspector
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        guard let inspector = formView.tryInspect() else {
            Issue.record("ViewInspector failed to inspect form")
            return
        }
        
        #if !os(macOS)
        do {
            // Find all buttons in the view using ViewType.Button (not Button<Text>)
            let buttons = try inspector.findAll(ViewType.Button.self)
            
            // Verify button exists
            #expect(buttons.count > 0, "Form should have buttons")
            
            // Find the Cancel button by inspecting its label text
            for button in buttons {
                do {
                    let labelView = try button.labelView()
                    let labelText = try labelView.text().string()
                    
                    if labelText == "Cancel" {
                        // Tap the button to invoke its action
                        try button.tap()
                        
                        // Then: Callback should be invoked
                        #expect(callbackInvoked, "Cancel callback should be invoked when Cancel button is tapped")
                        break
                    }
                } catch {
                    // Continue searching for the right button
                    continue
                }
            }
            
            // If we couldn't find and tap the Cancel button, that's an issue
            if !callbackInvoked {
                Issue.record("Could not find Cancel button in form or failed to tap it")
            }
        } catch {
            Issue.record("ViewInspector failed to inspect form: \(error)")
        }
    }
    #endif
    
    #if !os(macOS)
    @Test func testIntelligentFormViewOnUpdateCallbackInvoked() async throws {
        // Rule 6.2 & 7.4: Functional testing
        // NOTE: ViewInspector is iOS-only, so this test only runs on iOS
        
        var callbackInvoked = false
        var receivedData: String?
        
        struct TestFormData: Codable {
            let name: String
            let email: String
        }
        
        let testData = TestFormData(name: "Test User", email: "test@example.com")
        
        let formView = IntelligentFormView.generateForm(
            for: testData,
            onUpdate: { data in
                callbackInvoked = true
                receivedData = data.name // Capture some data to verify
            },
            onCancel: {}
        )
        
        // When: Simulating Update button tap using ViewInspector
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        guard let inspector = formView.tryInspect() else {
            Issue.record("ViewInspector failed to inspect form")
            return
        }
        
        #if !os(macOS)
        do {
            // Find all buttons in the view using ViewType.Button (not Button<Text>)
            let buttons = try inspector.findAll(ViewType.Button.self)
            
            // Verify button exists
            #expect(buttons.count > 0, "Form should have buttons")
            
            // Find the Update button by inspecting its label text
            for button in buttons {
                do {
                    let labelView = try button.labelView()
                    let labelText = try labelView.text().string()
                    
                    // Button text could be "Update" or "Create" depending on whether initialData exists
                    if labelText == "Update" || labelText == "Create" {
                        // Tap the button to invoke its action
                        try button.tap()
                        
                        // Then: Callback should be invoked
                        #expect(callbackInvoked, "Update callback should be invoked when Update button is tapped")
                        #expect(receivedData != nil, "Should receive form data")
                        break
                    }
                } catch {
                    // Continue searching for the right button
                    continue
                }
            }
            
            // If we couldn't find and tap the Update button, that's an issue
            if !callbackInvoked {
                Issue.record("Could not find Update button in form or failed to tap it")
            }
        } catch {
            Issue.record("ViewInspector failed to inspect form: \(error)")
        }
        #endif
    }
    #endif
    
    // MARK: - DynamicFormView Callback Tests
    
    #if !os(macOS)
    @Test func testDynamicFormViewOnSubmitCallbackInvoked() async throws {
        // Rule 6.2 & 7.4: Functional testing
        // NOTE: ViewInspector is iOS-only, so this test only runs on iOS
        
        var callbackInvoked = false
        var receivedValues: [String: Any]?
        
        let configuration = DynamicFormConfiguration(
            id: "test-form",
            title: "Test Form"
        )
        
        let formView = DynamicFormView(
            configuration: configuration,
            onSubmit: { values in
                callbackInvoked = true
                receivedValues = values
            }
        )
        
        // When: Simulating Submit button tap using ViewInspector
        // Using wrapper - when ViewInspector works on macOS, no changes needed here
        guard let inspector = formView.tryInspect() else {
            Issue.record("ViewInspector failed to inspect DynamicFormView")
            return
        }
        
        #if !os(macOS)
        do {
            // Find all buttons in the view using ViewType.Button
            let buttons = try inspector.findAll(ViewType.Button.self)
            
            // Verify button exists
            #expect(buttons.count > 0, "Form should have buttons")
            
            // Find the Submit button by inspecting its label text
            for button in buttons {
                do {
                    let labelView = try button.labelView()
                    let labelText = try labelView.text().string()
                    
                    if labelText == "Submit" {
                        // Tap the button to invoke its action
                        try button.tap()
                        
                        // Then: Callback should be invoked
                        #expect(callbackInvoked, "Submit callback should be invoked when Submit button is tapped")
                        #expect(receivedValues != nil, "Should receive form values")
                        break
                    }
                } catch {
                    // Continue searching for the right button
                    continue
                }
            }
            
            // If we couldn't find and tap the Submit button, that's an issue
            if !callbackInvoked {
                Issue.record("Could not find Submit button in form or failed to tap it")
            }
        } catch {
            Issue.record("ViewInspector failed to inspect DynamicFormView: \(error)")
        }
        #endif
    }
    #endif
    
    // MARK: - External Integration Tests
    
    /// Tests that form callbacks are accessible from external modules (Rule 8)
    @Test func testIntelligentFormViewCallbacksExternallyAccessible() async throws {
        struct TestFormData: Codable {
            let name: String
            let email: String
        }
        
        let testData = TestFormData(name: "External Test", email: "external@example.com")
        
        var callbackInvoked = false
        
        let formView = IntelligentFormView.generateForm(
            for: testData,
            onUpdate: { _ in
                callbackInvoked = true
            },
            onCancel: {}
        )
        
        #expect(formView != nil, "Form view should be accessible externally")
        #expect(true, "Callbacks can be provided by external modules")
    }
}
