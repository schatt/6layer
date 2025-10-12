import XCTest
import SwiftUI
@testable import SixLayerFramework

final class PhotoSemanticLayerTests: XCTestCase {
    
    // MARK: - Layer 1: Semantic Photo Functions Tests
    
    func testPlatformPhotoCapture_L1() {
        // Given: Photo purpose and context
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        
        // When: Creating semantic photo capture interface
        let captureInterface = platformPhotoCapture_L1(purpose: purpose, context: context) { _ in }
        
        // Then: Capture interface should be created
        XCTAssertNotNil(captureInterface)
    }
    
    func testPlatformPhotoSelection_L1() {
        // Given: Photo purpose and context
        let purpose = PhotoPurpose.fuelReceipt
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: false, hasPhotoLibrary: true)
        )
        
        // When: Creating semantic photo selection interface
        let selectionInterface = platformPhotoSelection_L1(purpose: purpose, context: context) { _ in }
        
        // Then: Selection interface should be created
        XCTAssertNotNil(selectionInterface)
    }
    
    func testPlatformPhotoDisplay_L1() {
        // Given: Photo purpose, context, and image
        let purpose = PhotoPurpose.odometer
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 400, height: 300),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let testImage = createTestPlatformImage()
        
        // When: Creating semantic photo display
        let displayInterface = platformPhotoDisplay_L1(purpose: purpose, context: context, image: testImage)
        
        // Then: Display interface should be created
        XCTAssertNotNil(displayInterface)
    }
    
    // MARK: - Layer 2: Photo Layout Decision Engine Tests
    
    func testDetermineOptimalPhotoLayout_L2() {
        // Given: Photo context and purpose
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let purpose = PhotoPurpose.vehiclePhoto
        
        // When: Determining optimal layout
        let layout = determineOptimalPhotoLayout_L2(purpose: purpose, context: context)
        
        // Then: Layout should be determined
        XCTAssertNotNil(layout)
        XCTAssertTrue(layout.width > 0)
        XCTAssertTrue(layout.height > 0)
    }
    
    func testDeterminePhotoCaptureStrategy_L2() {
        // Given: Photo context and purpose
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let purpose = PhotoPurpose.maintenance
        
        // When: Determining capture strategy
        let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
        
        // Then: Strategy should be determined
        XCTAssertNotNil(strategy)
    }
    
    // MARK: - Layer 3: Photo Strategy Selection Tests
    
    func testSelectPhotoCaptureStrategy_L3() {
        // Given: Photo context and purpose
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .camera),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true)
        )
        let purpose = PhotoPurpose.expense
        
        // When: Selecting capture strategy
        let strategy = selectPhotoCaptureStrategy_L3(purpose: purpose, context: context)
        
        // Then: Strategy should be selected
        XCTAssertNotNil(strategy)
    }
    
    func testSelectPhotoDisplayStrategy_L3() {
        // Given: Photo context and purpose
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 400, height: 300),
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        let purpose = PhotoPurpose.document
        
        // When: Selecting display strategy
        let strategy = selectPhotoDisplayStrategy_L3(purpose: purpose, context: context)
        
        // Then: Strategy should be selected
        XCTAssertNotNil(strategy)
    }
    
    // MARK: - Integration Tests
    
    func testSemanticPhotoWorkflow() {
        // Given: Complete photo workflow context
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize(width: 1024, height: 768),
            availableSpace: CGSize(width: 800, height: 600),
            userPreferences: PhotoPreferences(preferredSource: .both, allowEditing: true),
            deviceCapabilities: PhotoDeviceCapabilities(hasCamera: true, hasPhotoLibrary: true, supportsEditing: true)
        )
        
        // When: Running complete semantic workflow
        let layout = determineOptimalPhotoLayout_L2(purpose: purpose, context: context)
        let captureStrategy = selectPhotoCaptureStrategy_L3(purpose: purpose, context: context)
        let displayStrategy = selectPhotoDisplayStrategy_L3(purpose: purpose, context: context)
        
        // Then: All components should work together
        XCTAssertTrue(layout.width > 0)
        XCTAssertTrue(layout.height > 0)
        XCTAssertNotNil(captureStrategy)
        XCTAssertNotNil(displayStrategy)
    }
    
    // MARK: - Helper Methods
    
    private func createTestPlatformImage() -> PlatformImage {
        // Use existing sample image instead of generating one
        guard let imagePath = Bundle.main.path(forResource: "IMG_3002", ofType: "jpeg"),
              let imageData = NSData(contentsOfFile: imagePath) else {
            // Fallback to a simple colored image if sample image not found
            #if os(iOS)
            let size = CGSize(width: 100, height: 100)
            let renderer = UIGraphicsImageRenderer(size: size)
            let uiImage = renderer.image { context in
                UIColor.red.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
            return PlatformImage(uiImage: uiImage)
            #elseif os(macOS)
            let size = NSSize(width: 100, height: 100)
            let nsImage = NSImage(size: size)
            nsImage.lockFocus()
            NSColor.red.drawSwatch(in: NSRect(origin: .zero, size: size))
            nsImage.unlockFocus()
            return PlatformImage(nsImage: nsImage)
            #else
            return PlatformImage()
            #endif
        }
        
        #if os(iOS)
        return PlatformImage(data: imageData as Data) ?? PlatformImage()
        #elseif os(macOS)
        return PlatformImage(data: imageData as Data) ?? PlatformImage()
        #else
        return PlatformImage()
        #endif
    }
}
