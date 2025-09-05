import SwiftUI

// MARK: - Layer 3: Photo Strategy Selection

/// Select optimal photo capture strategy based on purpose and context
public func selectPhotoCaptureStrategy_L3(
    purpose: PhotoPurpose,
    context: PhotoContext
) -> PhotoCaptureStrategy {
    let preferences = context.userPreferences
    let capabilities = context.deviceCapabilities
    let _ = context.screenSize
    
    // Check device capabilities
    let hasCamera = capabilities.hasCamera
    let hasPhotoLibrary = capabilities.hasPhotoLibrary
    
    // If device doesn't support both, return what's available
    if !hasCamera && !hasPhotoLibrary {
        return .photoLibrary // Fallback to file selection
    } else if hasCamera && !hasPhotoLibrary {
        return .camera
    } else if !hasCamera && hasPhotoLibrary {
        return .photoLibrary
    }
    
    // Both available - use intelligent selection
    let strategy = determinePhotoCaptureStrategy_L2(purpose: purpose, context: context)
    
    // Override with user preferences if they conflict with optimal strategy
    switch preferences.preferredSource {
    case .camera:
        return hasCamera ? .camera : .photoLibrary
    case .photoLibrary:
        return hasPhotoLibrary ? .photoLibrary : .camera
    case .both:
        return strategy
    }
}

/// Select optimal photo display strategy based on purpose and context
public func selectPhotoDisplayStrategy_L3(
    purpose: PhotoPurpose,
    context: PhotoContext
) -> PhotoDisplayStrategy {
    let availableSpace = context.availableSpace
    let screenSize = context.screenSize
    
    // Calculate space utilization
    let spaceUtilization = (availableSpace.width * availableSpace.height) / (screenSize.width * screenSize.height)
    
    // Determine strategy based on purpose and available space
    switch purpose {
    case .vehiclePhoto:
        // Vehicle photos benefit from aspect fit to show full vehicle
        return spaceUtilization > 0.3 ? .aspectFit : .thumbnail
        
    case .fuelReceipt, .pumpDisplay:
        // Receipts and displays need full size for readability
        return spaceUtilization > 0.2 ? .fullSize : .aspectFit
        
    case .odometer:
        // Odometer photos need to be clear and readable
        return spaceUtilization > 0.15 ? .aspectFit : .thumbnail
        
    case .maintenance, .expense:
        // Maintenance and expense photos are typically reference thumbnails
        return .thumbnail
        
    case .profile:
        // Profile photos are typically rounded
        return .rounded
        
    case .document:
        // Documents need to be readable
        return spaceUtilization > 0.25 ? .aspectFit : .thumbnail
    }
}

// MARK: - Strategy Optimization Helpers

/// Determine if photo editing should be available
public func shouldEnablePhotoEditing(
    for purpose: PhotoPurpose,
    context: PhotoContext
) -> Bool {
    let preferences = context.userPreferences
    let capabilities = context.deviceCapabilities
    
    // Check if editing is supported and allowed
    guard capabilities.supportsEditing && preferences.allowEditing else {
        return false
    }
    
    // Determine based on purpose
    switch purpose {
    case .vehiclePhoto, .profile:
        // These benefit from basic editing (crop, rotate)
        return true
    case .fuelReceipt, .pumpDisplay, .odometer, .document:
        // These should remain unedited for authenticity
        return false
    case .maintenance, .expense:
        // These can benefit from basic editing
        return true
    }
}

/// Determine optimal compression quality for purpose
public func optimalCompressionQuality(
    for purpose: PhotoPurpose,
    context: PhotoContext
) -> Double {
    let preferences = context.userPreferences
    let baseQuality = preferences.compressionQuality
    
    // Adjust quality based on purpose
    switch purpose {
    case .vehiclePhoto, .profile:
        // High quality for visual appeal
        return min(baseQuality + 0.1, 1.0)
        
    case .fuelReceipt, .pumpDisplay, .odometer, .document:
        // High quality for text readability
        return min(baseQuality + 0.15, 1.0)
        
    case .maintenance, .expense:
        // Standard quality for reference photos
        return baseQuality
    }
}

/// Determine if photo should be automatically optimized
public func shouldAutoOptimize(
    for purpose: PhotoPurpose,
    context: PhotoContext
) -> Bool {
    // Auto-optimize based on purpose
    switch purpose {
    case .fuelReceipt, .pumpDisplay, .odometer:
        // Auto-optimize for text recognition
        return true
    case .vehiclePhoto, .profile, .maintenance, .expense, .document:
        // Let user decide for these
        return false
    }
}
