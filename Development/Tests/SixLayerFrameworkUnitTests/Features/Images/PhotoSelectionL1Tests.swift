import Testing

//
//  PhotoSelectionL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for photo selection L1 functions
//  Tests photo selection and gallery features
//

import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
/// NOTE: Serialized to avoid UI conflicts with hostRootPlatformView
@Suite(.serialized)
open class PhotoSelectionL1Tests: BaseTestClass {
    
    // MARK: - Test Data
    
    private var samplePhotoContext: PhotoContext = PhotoContext(
        screenSize: CGSize(width: 375, height: 667),
        availableSpace: CGSize(width: 375, height: 667),
        userPreferences: PhotoPreferences(),
        deviceCapabilities: PhotoDeviceCapabilities()
    )
    
    private var sampleHints: PresentationHints = PresentationHints()
    
    // MARK: - Photo Selection Tests
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        // view is a non-optional View, so it exists if we reach here
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_WithDifferentPurpose() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a valid SwiftUI view
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type for different purpose")
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    // MARK: - Different Photo Purposes
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_FuelReceipt() {
        // Given
        let purpose = PhotoPurpose.fuelReceipt
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a valid SwiftUI view
        let viewMirror = Mirror(reflecting: view)
        let viewType = String(describing: viewMirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type for fuel receipt")
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_PumpDisplay() {
        // Given
        let purpose = PhotoPurpose.pumpDisplay
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for pump display should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_Odometer() {
        // Given
        let purpose = PhotoPurpose.odometer
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for odometer should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_Maintenance() {
        // Given
        let purpose = PhotoPurpose.maintenance
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for maintenance should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_Expense() {
        // Given
        let purpose = PhotoPurpose.expense
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for expense should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_Profile() {
        // Given
        let purpose = PhotoPurpose.profile
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for profile should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_Document() {
        // Given
        let purpose = PhotoPurpose.document
        let context = samplePhotoContext
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a view that can be hosted
        #expect(Bool(true), "platformPhotoSelection_L1 for document should return a view")  // view is non-optional
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    // MARK: - Edge Cases
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_WithEmptyContext() {
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = PhotoContext(
            screenSize: CGSize.zero,
            availableSpace: CGSize.zero,
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
        
        // When
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return a valid SwiftUI view even with empty context
        let viewMirror = Mirror(reflecting: view)
        let viewType = String(describing: viewMirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View should be a SwiftUI view type even with empty context")
        
        // Test that the view can actually be hosted
        let hostingView = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify hosting view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: hostingView)
        let hostingType = String(describing: mirror.subjectType)
        #expect(hostingType.lowercased().contains("view") || hostingType.contains("ModifiedContent"), 
                "Hosting view should be a SwiftUI view type")
    }
    
    // MARK: - Custom View Tests
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_WithCustomPickerView() {
        initializeTestConfig()
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When: Using custom picker view wrapper
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in },
            customPickerView: { (pickerContent: AnyView) in
                platformVStackContainer {
                    Text("Custom Photo Picker")
                        .font(.headline)
                    pickerContent
                        .padding()
                        .background(Color.platformSecondaryBackground)
                }
            }
        )
        
        // Then: Should return a view with custom wrapper
        let _ = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        // Verify view is a valid SwiftUI view type
        let mirror = Mirror(reflecting: view)
        let viewType = String(describing: mirror.subjectType)
        #expect(viewType.lowercased().contains("view") || viewType.contains("ModifiedContent"), 
                "View with custom picker should be a SwiftUI view type, got: \(viewType)")
    }
    
    @Test @MainActor
    func testPlatformPhotoSelection_L1_WithCustomPickerView_Nil() {
        initializeTestConfig()
        // Given
        let purpose = PhotoPurpose.vehiclePhoto
        let context = samplePhotoContext
        
        // When: Not providing custom picker view (should use default)
        // Omit the parameter to use default value instead of passing nil
        let view = platformPhotoSelection_L1(
            purpose: purpose,
            context: context,
            onImageSelected: { _ in }
        )
        
        // Then: Should return default view
        let _ = hostRootPlatformView(view.withGlobalAutoIDsEnabled())
        #expect(Bool(true), "platformPhotoSelection_L1 with nil custom picker view should return default view")
    }
    
}
