import Testing
import SwiftUI
@testable import SixLayerFramework

/// Minimal test to debug accessibility identifier issues
/// NOTE: Not marked @MainActor on class to allow parallel execution
@Suite("Minimal Accessibility")
open class MinimalAccessibilityTest {
    
    @Test @MainActor func testMinimalAccessibilityIdentifier() async {
        // Given: Framework component (testing our framework, not SwiftUI Text)
        let testView = platformPresentContent_L1(
            content: "Hello World",
            hints: PresentationHints()
        )
        
        // When: We check if framework component generates accessibility identifier
        #if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
        let hasID = testAccessibilityIdentifiersSinglePlatform(
            testView,
            expectedPattern: "SixLayer.main.ui.*",
            platform: SixLayerPlatform.iOS,
            componentName: "platformPresentContent_L1"
        )
 #expect(hasID, "Framework component should automatically generate accessibility identifier ")
        #else
        // ViewInspector not available on this platform (likely macOS) - this is expected, not a failure
        // The modifier IS present in the code, but ViewInspector can't detect it on macOS
        #endif
    }
}
