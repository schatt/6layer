//
//  CloudKitService+DataSyncHelpers.swift
//  SixLayerFramework
//
//  Shared helpers for Core Data and Swift Data CloudKit sync
//  Extracts common platform-specific workaround logic
//

import Foundation
import CloudKit

@MainActor
extension CloudKitService {
    
    // MARK: - Platform-Specific Sync Helpers
    
    /// Determines if platform-specific sync workarounds should be applied
    /// - Returns: `true` if workarounds are needed (iPad or Mac)
    /// 
    /// **iPad**: Data from other devices may not appear until app restart
    /// **Mac**: May sync on launch but not while active
    internal var needsPlatformSyncWorkaround: Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad
        #elseif os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    /// Creates a standardized error for missing context/container
    /// - Parameter component: The missing component name (e.g., "persistent store coordinator", "model container")
    /// - Returns: A CloudKitServiceError with descriptive message
    internal func createMissingComponentError(_ component: String) -> CloudKitServiceError {
        return CloudKitServiceError.unknown(NSError(
            domain: "CloudKitService",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Context does not have a \(component)"]
        ))
    }
}

#if os(iOS)
import UIKit
#endif
