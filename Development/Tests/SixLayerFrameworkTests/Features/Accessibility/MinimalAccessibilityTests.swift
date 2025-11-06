import Testing
import SwiftUI
@testable import SixLayerFramework

/// Minimal test to debug accessibility identifier issues
@MainActor
@Suite("Minimal Accessibility")
open class MinimalAccessibilityTest {
    
    @Test func testMinimalAccessibilityIdentifier() async {
        // Given: Framework component (testing our framework, not SwiftUI Text)
        let testView = platformPresentContent_L1(
            content: "Hello World",
            hints: PresentationHints()
        )
        
        // When: We check if framework component generates accessibility identifier
        let hasID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentContent_L1"
        )
        
        // Then: Framework component should automatically generate accessibility identifier
        #expect(hasID, "Framework component should automatically generate accessibility identifier")
    }
}
