//
//  PlatformFileSystemUtilities.swift
//  SixLayerFramework
//
//  Cross-platform file system utility functions
//  Provides platform-agnostic access to common file system directories
//

import Foundation

// MARK: - Cross-Platform File System Utilities

/// Returns the home directory URL for the current user in a cross-platform manner.
///
/// This function abstracts platform-specific home directory access:
/// - **macOS**: Uses `FileManager.default.homeDirectoryForCurrentUser`
/// - **All other platforms (iOS, watchOS, tvOS, visionOS)**: Uses `NSHomeDirectory()` converted to a file URL
///
/// This eliminates the need for conditional compilation in consuming applications:
/// ```swift
/// // Instead of platform-specific code:
/// // #if os(macOS)
/// // let homeDir = FileManager.default.homeDirectoryForCurrentUser
/// // #else
/// // let homeDir = URL(fileURLWithPath: NSHomeDirectory())
/// // #endif
///
/// // Use the cross-platform function:
/// let homeDir = platformHomeDirectory()
/// ```
///
/// - Returns: A `URL` representing the home directory for the current user.
public func platformHomeDirectory() -> URL {
    #if os(macOS)
    return FileManager.default.homeDirectoryForCurrentUser
    #else
    return URL(fileURLWithPath: NSHomeDirectory())
    #endif
}
