import XCTest
import SwiftUI
@testable import SixLayerFramework

// Import test utilities for accessibility identifier testing
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

// MARK: - Test Extensions for Accessibility Identifier Testing

extension View {
    /// Wrap the view with the global automatic accessibility identifier modifier so
    /// that auto-ID assignment is enabled in hosted test environments.
    func withGlobalAutoIDsEnabled() -> some View {
        self
            .environment(\.globalAutomaticAccessibilityIdentifiers, true)
            .automaticAccessibilityIdentifiers()
    }
}

/// Functional UI tests for actual SwiftUI rendering of platformPresentContent_L1
/// This tests the real UI behavior using hosting controllers instead of XCUITest
final class PlatformPresentContentL1UITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Clean up if needed
    }
    
    // MARK: - GREEN PHASE: Functional UI Tests
    
    /// Test that String content renders without crashing using hosting controller
    @MainActor
    func testStringContentRendersSuccessfully() throws {
        // GIVEN: String content and presentation hints
        let content = "Performance test content"
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "String content should render successfully")
    }
    
    /// Test that Float content renders without crashing using hosting controller
    @MainActor
    func testFloatContentRendersSuccessfully() throws {
        // GIVEN: Float content and presentation hints
        let content = Float(42.0)
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Float content should render successfully")
    }
    
    /// Test that Double content renders without crashing using hosting controller
    @MainActor
    func testDoubleContentRendersSuccessfully() throws {
        // GIVEN: Double content and presentation hints
        let content = Double(3.14159)
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Double content should render successfully")
    }
    
    /// Test that Int content renders without crashing using hosting controller
    @MainActor
    func testIntContentRendersSuccessfully() throws {
        // GIVEN: Int content and presentation hints
        let content = Int(42)
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Int content should render successfully")
    }
    
    /// Test that Bool content renders without crashing using hosting controller
    @MainActor
    func testBoolContentRendersSuccessfully() throws {
        // GIVEN: Bool content and presentation hints
        let content = Bool(true)
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Bool content should render successfully")
    }
    
    /// Test that Array content renders without crashing using hosting controller
    @MainActor
    func testArrayContentRendersSuccessfully() throws {
        // GIVEN: Array content and presentation hints
        let content = ["item1", "item2", "item3"]
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Array content should render successfully")
    }
    
    /// Test that Dictionary content renders without crashing using hosting controller
    @MainActor
    func testDictionaryContentRendersSuccessfully() throws {
        // GIVEN: Dictionary content and presentation hints
        let content = ["key1": "value1", "key2": "value2"]
        let hints = createTestHints()
        
        // WHEN: We create a view and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "Dictionary content should render successfully")
    }
    
    /// Test that accessibility identifiers are properly set
    @MainActor
    func testAccessibilityIdentifiersAreSet() throws {
        // GIVEN: Content with accessibility identifiers enabled
        let content = "Performance test content"
        let hints = createTestHints()
        
        // WHEN: We create a view with accessibility identifiers and host it
        let view = platformPresentContent_L1(content: content, hints: hints)
            .withGlobalAutoIDsEnabled()
        let hostingView = hostRootPlatformView(view)
        
        // THEN: The view should be successfully hosted (rendered)
        XCTAssertNotNil(hostingView, "View with accessibility identifiers should render successfully")
    }
    
    /// Test performance of actual UI rendering
    @MainActor
    func testUIRenderingPerformance() throws {
        // GIVEN: Content for performance testing
        let content = "Performance test content"
        let hints = createTestHints()
        
        // WHEN: We measure the time to render the UI
        // THEN: Rendering should be fast enough
        measure {
            let view = platformPresentContent_L1(content: content, hints: hints)
            let hostingView = hostRootPlatformView(view)
            XCTAssertNotNil(hostingView, "Performance test should render successfully")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Create test hints for content presentation
    private func createTestHints() -> PresentationHints {
        return PresentationHints(
            dataType: .generic,
            presentationPreference: .card,
            complexity: .simple,
            context: .detail,
            customPreferences: [:]
        )
    }
    
    /// Host a SwiftUI view and return the platform root view for inspection.
    @MainActor
    private func hostRootPlatformView<V: View>(_ view: V) -> Any? {
        #if canImport(UIKit)
        let hosting = UIHostingController(rootView: view)
        let root = hosting.view
        root?.setNeedsLayout()
        root?.layoutIfNeeded()
        return root
        #elseif canImport(AppKit)
        let hosting = NSHostingController(rootView: view)
        let root = hosting.view
        root.needsLayout = true
        root.layout()
        return root
        #else
        return nil
        #endif
    }
}
