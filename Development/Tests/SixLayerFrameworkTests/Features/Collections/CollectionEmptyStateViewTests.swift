import Testing
import SwiftUI
@testable import SixLayerFramework

#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
import ViewInspector
#endif
/// Tests for CollectionEmptyStateView component
/// 
/// BUSINESS PURPOSE: Ensure CollectionEmptyStateView generates proper accessibility identifiers
/// TESTING SCOPE: CollectionEmptyStateView component from PlatformSemanticLayer1.swift
/// METHODOLOGY: Uses centralized test functions following DRY principles
@Suite("Collection Empty State View")
@MainActor
open class CollectionEmptyStateViewTests {
    
    // MARK: - CollectionEmptyStateView Tests
    
    @Test(arguments: [SixLayerPlatform.iOS, SixLayerPlatform.macOS])
    func testCollectionEmptyStateViewGeneratesAccessibilityIdentifiers(
        platform: SixLayerPlatform
    ) async {
        await MainActor.run {
            // Setup: Configure test environment with automatic mode (explicit)
            setupTestEnvironment(mode: .automatic)
            
            // Test: Use centralized accessibility testing function
            let testPassed = testAccessibilityIdentifierGeneration(
                createCollectionEmptyStateView(),
                componentName: "CollectionEmptyStateView",
                expectedPattern: "SixLayer.*ui",
                platform: platform
            )
            
            // Assert: Should generate accessibility identifiers in automatic mode
            #expect(testPassed, "CollectionEmptyStateView should generate accessibility identifiers on \(platform.rawValue) in automatic mode")
            
            // Cleanup: Reset test environment
            cleanupTestEnvironment()
        }
    }
    
    @Test
    func testCollectionEmptyStateViewAccessibilityDisabled() async {
        await MainActor.run {
            // Setup: Configure test environment with auto IDs disabled
            setupTestEnvironment(enableAutoIDs: false)
            
            // Test: Use centralized accessibility disabled testing function
            let testPassed = testComponentAccessibilityDisabled(
                componentName: "CollectionEmptyStateView",
                createComponent: createCollectionEmptyStateView
            )
            
            // Assert: Should work correctly when accessibility IDs are disabled
            #expect(testPassed, "CollectionEmptyStateView should work when accessibility IDs are disabled")
            
            // Cleanup: Reset test environment
            cleanupTestEnvironment()
        }
    }
    
    @Test
    func testCollectionEmptyStateViewAllAccessibilityModes() async {
        await MainActor.run {
            let view = createCollectionEmptyStateView()
            
            // Test automatic mode
            setupTestEnvironment(mode: .automatic)
            let automaticPassed = testComponentAccessibility(
                componentName: "CollectionEmptyStateView-Automatic",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test manual mode
            setupTestEnvironment(mode: .manual)
            let manualPassed = testComponentAccessibilityManual(
                componentName: "CollectionEmptyStateView-Manual",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test semantic mode
            setupTestEnvironment(mode: .semantic)
            let semanticPassed = testComponentAccessibilitySemantic(
                componentName: "CollectionEmptyStateView-Semantic",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Test disabled mode
            setupTestEnvironment(mode: .disabled)
            let disabledPassed = testComponentAccessibilityDisabled(
                componentName: "CollectionEmptyStateView-Disabled",
                createComponent: { view }
            )
            cleanupTestEnvironment()
            
            // Assert: Should work in all accessibility modes
            #expect(automaticPassed, "CollectionEmptyStateView should work in automatic mode")
            #expect(manualPassed, "CollectionEmptyStateView should work in manual mode")
            #expect(semanticPassed, "CollectionEmptyStateView should work in semantic mode")
            #expect(disabledPassed, "CollectionEmptyStateView should work in disabled mode")
        }
    }
    
    // MARK: - Empty State Bug Fix Tests (TDD Red Phase)
    
    /// TDD RED PHASE: Test that custom message from customPreferences is displayed
    /// This test SHOULD FAIL until custom message support is implemented
    @Test
    func testEmptyStateDisplaysCustomMessage() async {
        await MainActor.run {
            setupTestEnvironment()
            
            let customMessage = "No vehicles added yet. Add your first vehicle to start tracking maintenance, expenses, and fuel records."
            let hints = PresentationHints(
                dataType: .collection,
                context: .browse,
                customPreferences: [
                    "customMessage": customMessage
                ]
            )
            
            let view = CollectionEmptyStateView(
                hints: hints,
                onCreateItem: nil,
                customCreateView: nil
            )
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            if let inspected = view.tryInspect() {
                // Find the message text in the VStack
                if let vStack = inspected.sixLayerTryFind(ViewType.VStack.self) {
                    // The message should be in a Text view within the VStack
                    let texts = vStack.sixLayerFindAll(ViewType.Text.self)
                    let messageText = texts?.first { text in
                        let string = try? text.sixLayerString()
                        return string?.contains("vehicles") ?? false || string?.contains("vehicle") ?? false
                    }
                    
                    if let messageText = messageText {
                        let actualMessage = try? messageText.sixLayerString()
                        // TDD RED: Should FAIL - custom message should be displayed
                        #expect(actualMessage?.contains(customMessage) ?? false,
                               "Empty state should display custom message from customPreferences. Expected: '\(customMessage)', Got: '\(actualMessage ?? "nil")'")
                    } else {
                        Issue.record("Could not find message text in empty state view")
                    }
                }
            } else {
                Issue.record("Failed to inspect CollectionEmptyStateView")
            }
            #else
            Issue.record("ViewInspector not available on this platform (likely macOS)")
            #endif
            
            cleanupTestEnvironment()
        }
    }
    
    /// TDD RED PHASE: Test that onCreateItem callback displays a button
    /// This test SHOULD FAIL if button is not displayed when onCreateItem is provided
    @Test
    func testEmptyStateDisplaysCreateButtonWhenOnCreateItemProvided() async {
        await MainActor.run {
            setupTestEnvironment()
            
            var createItemCalled = false
            let onCreateItem: () -> Void = {
                createItemCalled = true
            }
            
            let hints = PresentationHints(
                dataType: .collection,
                context: .browse
            )
            
            let view = CollectionEmptyStateView(
                hints: hints,
                onCreateItem: onCreateItem,
                customCreateView: nil
            )
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            if let inspected = view.tryInspect() {
                // Find the button in the view
                let button = inspected.sixLayerTryFind(ViewType.Button.self)
                
                // TDD RED: Should FAIL - button should exist when onCreateItem is provided
                #expect(button != nil,
                       "Empty state should display create button when onCreateItem is provided")
                
                // Try to tap the button to verify it calls the callback
                if let button = button {
                    try? button.sixLayerTap()
                    #expect(createItemCalled, "Button tap should call onCreateItem callback")
                }
            } else {
                Issue.record("Failed to inspect CollectionEmptyStateView")
            }
            #else
            Issue.record("ViewInspector not available on this platform (likely macOS)")
            #endif
            
            cleanupTestEnvironment()
        }
    }
    
    /// TDD RED PHASE: Test that custom message takes precedence over default context message
    @Test
    func testCustomMessageTakesPrecedenceOverDefaultMessage() async {
        await MainActor.run {
            setupTestEnvironment()
            
            let customMessage = "No vehicles added yet. Add your first vehicle to start tracking maintenance, expenses, and fuel records."
            let hints = PresentationHints(
                dataType: .collection,
                context: .navigation, // This would normally show "No navigation items available."
                customPreferences: [
                    "customMessage": customMessage
                ]
            )
            
            let view = CollectionEmptyStateView(
                hints: hints,
                onCreateItem: nil,
                customCreateView: nil
            )
            
            // Using wrapper - when ViewInspector works on macOS, no changes needed here
            #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
            if let inspected = view.tryInspect() {
                if let vStack = inspected.sixLayerTryFind(ViewType.VStack.self) {
                    let texts = vStack.sixLayerFindAll(ViewType.Text.self)
                    let messageText = texts?.first { text in
                        let string = try? text.sixLayerString()
                        return string?.count ?? 0 > 10 // Find the longer message text
                    }
                    
                    if let messageText = messageText {
                        let actualMessage = try? messageText.sixLayerString()
                        // TDD RED: Should FAIL - custom message should override default
                        #expect(actualMessage?.contains(customMessage) ?? false,
                               "Custom message should override default context message. Expected: '\(customMessage)', Got: '\(actualMessage ?? "nil")'")
                        // Should NOT contain the default navigation message
                        #expect(!(actualMessage?.contains("No navigation items available") ?? false),
                               "Custom message should not show default navigation message")
                    }
                }
            } else {
                Issue.record("Failed to inspect CollectionEmptyStateView")
            }
            #else
            Issue.record("ViewInspector not available on this platform (likely macOS)")
            #endif
            
            cleanupTestEnvironment()
        }
    }
    
    // MARK: - Helper Functions
    
    /// Creates a CollectionEmptyStateView for testing
    public func createCollectionEmptyStateView() -> CollectionEmptyStateView {
        return CollectionEmptyStateView(
            hints: PresentationHints(
                dataType: .collection,
                presentationPreference: .automatic
            ),
            onCreateItem: {},
            customCreateView: nil
        )
    }
}
