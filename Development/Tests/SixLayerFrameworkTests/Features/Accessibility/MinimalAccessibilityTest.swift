import Testing
import SwiftUI
@testable import SixLayerFramework

/// Minimal test to debug accessibility identifier issues
@MainActor
final class MinimalAccessibilityTest {
    
    @Test func testMinimalAccessibilityIdentifier() async {
        // Given: A simple view with automatic accessibility identifiers
        let testView = Text("Hello World")
            .automaticAccessibilityIdentifiers()
        
        // When: We check if it has an accessibility identifier
        let hasID = hasAccessibilityIdentifier(
            testView,
            expectedPattern: "*.main.element.*",
            componentName: "Text"
        )
        
        // Then: It should have an accessibility identifier
        #expect(hasID, "Text view should generate accessibility identifier")
    }
}
