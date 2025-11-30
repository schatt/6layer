import Testing
@testable import SixLayerFramework

#if os(macOS)
import AppKit
import SwiftUI

/// macOS integration tests that use a real NSWindow sheet to catch sizing/blank-content issues
/// NOTE: Not marked @MainActor on class to allow parallel execution
struct IntelligentDetailViewSheetIntegrationTests_macOS {

    private struct TestTask: Codable, Identifiable {
        let id: UUID
        let title: String
        let description: String
        let priority: Int
        init(id: UUID = UUID(), title: String, description: String = "Desc", priority: Int = 1) {
            self.id = id
            self.title = title
            self.description = description
            self.priority = priority
        }
    }

    /// Present platformDetailView inside a real AppKit sheet and verify it is not tiny/blank
    @Test @MainActor func testPlatformDetailViewPresentsNonTinyNonBlankSheet() async {
        // Given
        let task = TestTask(title: "Sheet Task", description: "Details", priority: 3)

        // Host window
        let hostWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        hostWindow.isReleasedWhenClosed = false
        hostWindow.contentViewController = NSHostingController(rootView: Text("Host"))

        // Sheet content: IntelligentDetailView with expected minimum frame
        let sheetRoot = IntelligentDetailView.platformDetailView(for: task)
            .frame(minWidth: 400, minHeight: 500)

        let sheetController = NSHostingController(rootView: sheetRoot)
        let sheetWindow = NSWindow(contentViewController: sheetController)
        sheetWindow.isReleasedWhenClosed = false

        // When: Begin sheet and allow layout pass
        hostWindow.beginSheet(sheetWindow, completionHandler: nil)
        // Allow a brief layout pass
        // Reduced from 0.15s to 0.01s for faster test execution
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds

        // Then: Verify the sheet has non-trivial size and visible subviews
        let fittingSize = sheetController.view.fittingSize
        let hasSubviews = !sheetController.view.subviews.isEmpty

        #expect(fittingSize.width >= 300, "Sheet width should be reasonable, got \(fittingSize.width)")
        #expect(fittingSize.height >= 300, "Sheet height should be reasonable, got \(fittingSize.height)")
        #expect(hasSubviews, "Sheet content view should have subviews (not blank)")

        // Cleanup
        hostWindow.endSheet(sheetWindow)
        sheetWindow.close()
        hostWindow.close()
    }
}
#endif


