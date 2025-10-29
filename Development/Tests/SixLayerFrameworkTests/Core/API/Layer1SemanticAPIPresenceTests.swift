import Testing

import SwiftUI
@testable import SixLayerFramework

@MainActor
open class Layer1SemanticAPIPresenceTests {
    @Test func testPlatformPresentItemCollectionL1Exists() {
        struct Item: Identifiable { let id = UUID() }
        let items = [Item(), Item()]
        let hints = PresentationHints(dataType: .collection, presentationPreference: .automatic, complexity: .moderate, context: .dashboard)
        let view = platformPresentItemCollection_L1(items: items, hints: hints)
        let _ = view
    }

    @Test func testPlatformPresentContentL1Exists() {
        let hints = PresentationHints(dataType: .generic, presentationPreference: .automatic, complexity: .simple, context: .dashboard)
        let view = platformPresentContent_L1(content: [1,2,3], hints: hints)
        let _ = view
    }

    @Test func testPlatformPresentModalFormL1Exists() {
        let view = platformPresentModalForm_L1(formType: .form, context: .modal)
        let _ = view
    }

    @Test func testPlatformPhotoCaptureSelectionL1Exist() {
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 1024, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .both),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let _ = platformPhotoCapture_L1(purpose: .profile, context: context) { _ in }
        let _ = platformPhotoSelection_L1(purpose: .document, context: context) { _ in }
    }
}


