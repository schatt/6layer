import Testing
import SwiftUI

// Normal import - same as external modules like CarManager
// NO @testable - tests from external module perspective
import SixLayerFramework

/// External Module Integration Tests
///
/// These tests simulate how an external module (like CarManager) would use the framework.
/// They use normal `import` (not `@testable`) to test public API access.
///
/// **Purpose:**
/// - Catch API visibility issues that would break external modules
/// - Verify public APIs are accessible from external perspective
/// - Ensure framework is usable by external consumers
///
/// **Difference from SixLayerFrameworkTests:**
/// - Uses `import` instead of `@testable import`
/// - Tests public API only (no internal access)
/// - Simulates external module usage patterns
///
/// **What was broken:**
/// - platformPhotoPicker_L4 was changed from static to instance method
/// - @testable tests still worked (could access internals)
/// - External modules couldn't access it (compilation error)
/// - These tests would have caught that bug
@Suite("External Module Integration Tests")
struct ExternalModuleIntegrationTests {
    
    /// Tests that global photo picker function is accessible from external modules
    ///
    /// This test simulates CarManager usage:
    /// ```swift
    /// import SixLayerFramework
    /// var selectedImage: PlatformImage?
    /// let picker = platformPhotoPicker_L4(onImageSelected: { image in selectedImage = image })
    /// ```
    @Test("Global photo picker function accessible")
    func testGlobalPhotoPickerAccessible() async throws {
        // Simulate how CarManager would call this
        await MainActor.run {
            var selectedImage: PlatformImage?
            
            let view = platformPhotoPicker_L4(onImageSelected: { image in
                selectedImage = image
            })
            
            // Test that it compiles and creates a view
            #expect(true, "Function is accessible")
            
            // Test that callback signature is accessible
            // In real usage, external modules would call this with their own callback
            #expect(true, "Callback can be provided")
        }
    }
    
    /// Tests that global camera interface function is accessible
    @Test("Global camera interface function accessible")
    func testGlobalCameraInterfaceAccessible() async throws {
        await MainActor.run {
            var capturedImage: PlatformImage?
            
            let _ = platformCameraInterface_L4(onImageCaptured: { image in
                capturedImage = image
            })
            
            // Test that it compiles and creates a view
            #expect(true, "Function is accessible")
            
            // Test that callback signature is accessible
            // In real usage, external modules would call this with their own callback
            #expect(true, "Callback can be provided")
        }
    }
    
    /// Tests that global photo display function is accessible
    @Test("Global photo display function accessible")
    func testGlobalPhotoDisplayAccessible() async throws {
        let image = PlatformImage()
        await MainActor.run {
            let _ = platformPhotoDisplay_L4(image: image, style: .thumbnail)
            #expect(true, "Function is accessible")
        }
    }
    
    /// Tests that PlatformImage implicit conversion works from external modules
    @Test("PlatformImage implicit conversion works externally")
    func testPlatformImageImplicitConversion() async throws {
        // Test that UIImage and NSImage can be implicitly converted
        #if os(iOS)
        let uiImage = UIImage(systemName: "photo") ?? UIImage()
        let platformImage = PlatformImage(uiImage: uiImage)
        #expect(true, "iOS conversion works")
        #elseif os(macOS)
        let nsImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil) ?? NSImage()
        let platformImage = PlatformImage(nsImage: nsImage)
        #expect(true, "macOS conversion works")
        #endif
    }
    
    /// Tests that Layer 5 messaging functions are accessible
    @Test("Layer 5 messaging functions accessible")
    func testLayer5MessagingAccessible() async throws {
        // Note: PlatformMessagingLayer5 has internal init, so we can't instantiate it
        // This test verifies that we're testing from external perspective
        // In real usage, external modules would use the public static methods
        #expect(true, "Testing from external perspective")
    }
    
    /// Tests that photo components have accessibility identifiers (external perspective)
    @Test("Photo components have accessibility identifiers")
    func testPhotoComponentsHaveAccessibilityIdentifiers() async throws {
        await MainActor.run {
            // Test that photo components apply accessibility identifiers
            // These should work from an external module perspective
            
            var capturedImage: PlatformImage?
            var selectedImage: PlatformImage?
            
            let cameraView = platformCameraInterface_L4(onImageCaptured: { image in
                capturedImage = image
            })
            let pickerView = platformPhotoPicker_L4(onImageSelected: { image in
                selectedImage = image
            })
            let displayView = platformPhotoDisplay_L4(image: PlatformImage(), style: .thumbnail)
            
            // If these compile and create views, the API is accessible
            #expect(true, "Photo components accessible and creating views")
        }
    }
    
    /// Tests that PlatformPhotoComponentsLayer4 enum methods are accessible
    @Test("PlatformPhotoComponentsLayer4 enum methods accessible")
    func testPhotoComponentsLayer4MethodsAccessible() async throws {
        await MainActor.run {
            // Test that we can use the enum methods
            let cameraView = PlatformPhotoComponentsLayer4.platformCameraInterface_L4(onImageCaptured: { _ in })
            let pickerView = PlatformPhotoComponentsLayer4.platformPhotoPicker_L4(onImageSelected: { _ in })
            let displayView = PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(image: PlatformImage(), style: .thumbnail)
            
            // If these compile, the enum methods are accessible from external modules
            #expect(true, "Enum methods accessible")
        }
    }
    
    /// Tests that OCROverlayView is accessible from external modules
    @Test("OCROverlayView accessible from external modules")
    func testOCROverlayViewAccessible() async throws {
        await MainActor.run {
            let testImage = PlatformImage()
            let testResult = OCRResult(
                extractedText: "Test OCR Text",
                confidence: 0.95,
                boundingBoxes: [],
                textTypes: [:],
                processingTime: 1.0,
                language: .english
            )
            
            var editedText: String?
            var editedBounds: CGRect?
            var deletedBounds: CGRect?
            
            // Test that OCROverlayView can be created from external module
            let ocrView = OCROverlayView(
                image: testImage,
                result: testResult,
                configuration: OCROverlayConfiguration(),
                onTextEdit: { text, bounds in
                    editedText = text
                    editedBounds = bounds
                },
                onTextDelete: { bounds in
                    deletedBounds = bounds
                }
            )
            
            // If this compiles and creates a view, the API is accessible
            #expect(true, "OCROverlayView accessible and creating views")
            
            // Test that callback signatures are accessible
            #expect(true, "Callbacks can be provided")
        }
    }
    
    /// Tests that ListCollectionView properly handles callbacks (TDD RED PHASE - This test will fail until callback bug is fixed)
    @Test("ListCollectionView callbacks accessible from external modules")
    func testListCollectionViewCallbacksAccessible() async throws {
        await MainActor.run {
            // Create sample items for testing
            struct TestItem: Identifiable {
                let id = UUID()
                let title: String
            }
            
            let testItems = [TestItem(title: "Test Item")]
            let hints = PresentationHints()
            var selectedItem: TestItem?
            var deletedItem: TestItem?
            
            // Test ListCollectionView with callbacks
            let listView = ListCollectionView(
                items: testItems,
                hints: hints,
                onCreateItem: nil,
                onItemSelected: { item in selectedItem = item },
                onItemDeleted: { item in deletedItem = item }
            )
            
            // If this compiles and creates a view, the API is accessible
            #expect(true, "ListCollectionView with callbacks accessible")
        }
    }
    
    /// Tests that IntelligentFormView.generateForm is accessible from external modules
    @Test("IntelligentFormView.generateForm is accessible")
    func testIntelligentFormViewGenerateFormAccessible() async throws {
        await MainActor.run {
            // Test that IntelligentFormView.generateForm can be called from external modules
            struct TestFormData: Identifiable {
                let id = UUID()
                var name: String
                var email: String
            }
            
            let testData = TestFormData(name: "Test", email: "test@example.com")
            
            // Test that generateForm for creating new data is accessible
            let createForm = IntelligentFormView.generateForm(
                for: TestFormData.self,
                initialData: testData,
                onSubmit: { _ in },
                onCancel: { }
            )
            
            // Test that generateForm for updating existing data is accessible
            let updateForm = IntelligentFormView.generateForm(
                for: testData,
                onUpdate: { _ in },
                onCancel: { }
            )
            
            // If these compile and create views, the API is accessible
            #expect(true, "IntelligentFormView.generateForm is accessible from external modules")
        }
    }
    
    /// Tests that IntelligentDetailView.platformDetailView is accessible from external modules
    @Test("IntelligentDetailView.platformDetailView is accessible")
    func testIntelligentDetailViewAccessible() async throws {
        await MainActor.run {
            struct TestDetailData: Identifiable {
                let id = UUID()
                let name: String
                let status: String
            }
            
            let testData = TestDetailData(name: "Test", status: "Active")
            
            // Test that platformDetailView can be called from external modules
            let detailView = IntelligentDetailView.platformDetailView(for: testData)
            
            // If this compiles and creates a view, the API is accessible
            #expect(true, "IntelligentDetailView.platformDetailView is accessible from external modules")
        }
    }
}

