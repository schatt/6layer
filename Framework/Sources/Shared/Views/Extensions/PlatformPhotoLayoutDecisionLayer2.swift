import SwiftUI

// MARK: - Layer 2: Photo Layout Decision Engine

/// Determine optimal photo layout based on purpose and context
public func determineOptimalPhotoLayout_L2(
    purpose: PhotoPurpose,
    context: PhotoContext
) -> CGSize {
    let availableSpace = context.availableSpace
    let screenSize = context.screenSize
    let _ = context.deviceCapabilities
    
    // Base layout calculations
    let baseWidth = min(availableSpace.width, screenSize.width * 0.8)
    let baseHeight = min(availableSpace.height, screenSize.height * 0.6)
    
    // Adjust based on photo purpose
    switch purpose {
    case .vehiclePhoto:
        // Vehicle photos benefit from wider aspect ratio
        return CGSize(
            width: baseWidth,
            height: baseWidth * 0.6 // 5:3 aspect ratio
        )
        
    case .fuelReceipt, .pumpDisplay:
        // Receipts and displays are typically portrait
        return CGSize(
            width: baseWidth * 0.7,
            height: baseHeight
        )
        
    case .odometer:
        // Odometer photos are typically square or slightly rectangular
        let size = min(baseWidth, baseHeight) * 0.8
        return CGSize(width: size, height: size)
        
    case .maintenance, .expense:
        // Maintenance and expense photos are typically square thumbnails
        let size = min(baseWidth, baseHeight) * 0.6
        return CGSize(width: size, height: size)
        
    case .profile:
        // Profile photos are typically square
        let size = min(baseWidth, baseHeight) * 0.5
        return CGSize(width: size, height: size)
        
    case .document:
        // Documents can vary, but typically portrait
        return CGSize(
            width: baseWidth * 0.6,
            height: baseHeight * 0.8
        )
    }
}

/// Determine photo capture strategy based on purpose and context
public func determinePhotoCaptureStrategy_L2(
    purpose: PhotoPurpose,
    context: PhotoContext
) -> PhotoCaptureStrategy {
    let preferences = context.userPreferences
    let capabilities = context.deviceCapabilities
    
    // Check device capabilities first
    let hasCamera = capabilities.hasCamera
    let hasPhotoLibrary = capabilities.hasPhotoLibrary
    
    // If only one option is available, use it
    if hasCamera && !hasPhotoLibrary {
        return .camera
    } else if !hasCamera && hasPhotoLibrary {
        return .photoLibrary
    } else if !hasCamera && !hasPhotoLibrary {
        // Fallback to photo library (user can select from files)
        return .photoLibrary
    }
    
    // Both options available - use user preferences
    switch preferences.preferredSource {
    case .camera:
        return .camera
    case .photoLibrary:
        return .photoLibrary
    case .both:
        // Determine based on purpose
        switch purpose {
        case .vehiclePhoto, .odometer, .maintenance:
            // These benefit from direct camera capture
            return .camera
        case .fuelReceipt, .pumpDisplay, .expense, .document:
            // These might be better from existing photos
            return .photoLibrary
        case .profile:
            // Profile photos can go either way
            return .both
        }
    }
}

// MARK: - Layout Optimization Helpers

/// Calculate optimal image size for display
public func calculateOptimalImageSize(
    for purpose: PhotoPurpose,
    in availableSpace: CGSize,
    maxResolution: CGSize = CGSize(width: 4096, height: 4096)
) -> CGSize {
    let layout = determineOptimalPhotoLayout_L2(
        purpose: purpose,
        context: PhotoContext(
            screenSize: availableSpace,
            availableSpace: availableSpace,
            userPreferences: PhotoPreferences(),
            deviceCapabilities: PhotoDeviceCapabilities()
        )
    )
    
    // Ensure we don't exceed maximum resolution
    let finalWidth = min(layout.width, maxResolution.width)
    let finalHeight = min(layout.height, maxResolution.height)
    
    return CGSize(width: finalWidth, height: finalHeight)
}

/// Determine if image should be cropped for purpose
public func shouldCropImage(
    for purpose: PhotoPurpose,
    imageSize: CGSize,
    targetSize: CGSize
) -> Bool {
    let aspectRatio = imageSize.width / imageSize.height
    let targetAspectRatio = targetSize.width / targetSize.height
    
    // Allow some tolerance for aspect ratio differences
    let tolerance: CGFloat = 0.1
    
    switch purpose {
    case .vehiclePhoto, .fuelReceipt, .pumpDisplay, .document:
        // These purposes benefit from specific aspect ratios
        return abs(aspectRatio - targetAspectRatio) > tolerance
    case .odometer, .maintenance, .expense, .profile:
        // These are typically square or flexible
        return false
    }
}
