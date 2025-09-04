import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Layer 1: Semantic Photo Functions

/// Cross-platform semantic photo capture interface
/// Provides intelligent photo capture based on purpose and context
@ViewBuilder
public func platformPhotoCapture_L1(
    purpose: PhotoPurpose,
    context: PhotoContext,
    onImageCaptured: @escaping (PlatformImage) -> Void
) -> some View {
    // Determine the best capture strategy based on purpose and context
    let strategy = selectPhotoCaptureStrategy_L3(purpose: purpose, context: context)
    
    switch strategy {
    case .camera:
        // Use camera interface for direct capture
        platformCameraInterface_L4(onImageCaptured: onImageCaptured)
    case .photoLibrary:
        // Use photo library picker
        platformPhotoPicker_L4(onImageSelected: onImageCaptured)
    case .both:
        // Provide both options
        VStack {
            platformCameraInterface_L4(onImageCaptured: onImageCaptured)
            platformPhotoPicker_L4(onImageSelected: onImageCaptured)
        }
    }
}

/// Cross-platform semantic photo selection interface
/// Provides intelligent photo selection based on purpose and context
@ViewBuilder
public func platformPhotoSelection_L1(
    purpose: PhotoPurpose,
    context: PhotoContext,
    onImageSelected: @escaping (PlatformImage) -> Void
) -> some View {
    // Determine optimal layout for selection interface
    let layout = determineOptimalPhotoLayout_L2(purpose: purpose, context: context)
    
    // Use photo picker with optimized layout
    platformPhotoPicker_L4(onImageSelected: onImageSelected)
        .frame(width: layout.width, height: layout.height)
}

/// Cross-platform semantic photo display interface
/// Provides intelligent photo display based on purpose and context
@ViewBuilder
public func platformPhotoDisplay_L1(
    purpose: PhotoPurpose,
    context: PhotoContext,
    image: PlatformImage?
) -> some View {
    // Determine optimal display strategy
    let displayStrategy = selectPhotoDisplayStrategy_L3(purpose: purpose, context: context)
    
    // Determine optimal layout
    let layout = determineOptimalPhotoLayout_L2(purpose: purpose, context: context)
    
    // Create display with semantic styling
    platformPhotoDisplay_L4(
        image: image,
        style: displayStyleForPurpose(purpose)
    )
    .frame(width: layout.width, height: layout.height)
}

// MARK: - Helper Functions

/// Determine display style based on photo purpose
private func displayStyleForPurpose(_ purpose: PhotoPurpose) -> PhotoDisplayStyle {
    switch purpose {
    case .vehiclePhoto:
        return .aspectFit
    case .fuelReceipt, .pumpDisplay, .odometer:
        return .fullSize
    case .maintenance, .expense, .document:
        return .thumbnail
    case .profile:
        return .rounded
    }
}

/// Photo capture strategy enum
public enum PhotoCaptureStrategy: String, CaseIterable {
    case camera = "camera"
    case photoLibrary = "photo_library"
    case both = "both"
}

/// Photo display strategy enum
public enum PhotoDisplayStrategy: String, CaseIterable {
    case thumbnail = "thumbnail"
    case fullSize = "full_size"
    case aspectFit = "aspect_fit"
    case aspectFill = "aspect_fill"
    case rounded = "rounded"
}
