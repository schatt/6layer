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

/// Returns the Application Support directory URL in a cross-platform manner.
///
/// This function abstracts platform-specific Application Support directory access:
/// - **macOS**: Uses `FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)`
/// - **iOS**: Uses `FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)`
///
/// While both platforms use the same underlying API, this abstraction provides:
/// - Consistent, testable API across the framework
/// - Future extensibility for platform-specific enhancements (e.g., iCloud Drive integration, sandbox handling)
/// - Reduced code verbosity in consuming applications
///
/// This eliminates the need for verbose, repetitive code in consuming applications:
/// ```swift
/// // Instead of:
/// let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
///
/// // Use the cross-platform function:
/// guard let appSupport = platformApplicationSupportDirectory(createIfNeeded: true) else {
///     // Handle error
///     return
/// }
/// ```
///
/// - Parameter createIfNeeded: If `true`, creates the directory if it doesn't exist. Defaults to `false`.
/// - Returns: A `URL` representing the Application Support directory, or `nil` if the directory cannot be located or created.
public func platformApplicationSupportDirectory(createIfNeeded: Bool = false) -> URL? {
    guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    // Check if directory exists
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
    
    if exists && isDirectory.boolValue {
        // Directory exists, return it
        return url
    }
    
    // Directory doesn't exist
    if createIfNeeded {
        // Try to create the directory
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            // Verify it was created successfully
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                return url
            }
        } catch {
            // Creation failed, return nil
            return nil
        }
    }
    
    // Directory doesn't exist and createIfNeeded is false, or creation failed
    return nil
}

/// Returns the Documents directory URL in a cross-platform manner.
///
/// This function abstracts platform-specific Documents directory access:
/// - **macOS**: Uses `FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`
/// - **iOS**: Uses `FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`
///
/// While both platforms use the same underlying API, this abstraction provides:
/// - Consistent, testable API across the framework
/// - Future extensibility for platform-specific enhancements (e.g., iCloud Drive integration, sandbox handling)
/// - Reduced code verbosity in consuming applications
///
/// This eliminates the need for verbose, repetitive code in consuming applications:
/// ```swift
/// // Instead of:
/// let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
///
/// // Use the cross-platform function:
/// guard let documentsURL = platformDocumentsDirectory(createIfNeeded: true) else {
///     // Handle error
///     return
/// }
/// ```
///
/// - Parameter createIfNeeded: If `true`, creates the directory if it doesn't exist. Defaults to `false`.
/// - Returns: A `URL` representing the Documents directory, or `nil` if the directory cannot be located or created.
public func platformDocumentsDirectory(createIfNeeded: Bool = false) -> URL? {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    // Check if directory exists
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
    
    if exists && isDirectory.boolValue {
        // Directory exists, return it
        return url
    }
    
    // Directory doesn't exist
    if createIfNeeded {
        // Try to create the directory
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            // Verify it was created successfully
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                return url
            }
        } catch {
            // Creation failed, return nil
            return nil
        }
    }
    
    // Directory doesn't exist and createIfNeeded is false, or creation failed
    return nil
}

// MARK: - Future Enhancements

/// Potential future enhancements for platform file system utilities:
///
/// **Platform-Specific Features:**
/// - **iCloud Drive Integration**: Support for iCloud-enabled directories on iOS/macOS
///   - Detect if iCloud Drive is available and enabled
///   - Option to use iCloud container directories
///   - Handle iCloud sync status and conflicts
///
/// - **Sandbox Handling**: Enhanced App Sandbox support on macOS
///   - Automatic security-scoped resource access
///   - Bookmark data persistence for sandboxed apps
///   - Handle sandbox permission requests
///
/// - **watchOS/tvOS Optimizations**: Platform-specific directory handling
///   - Optimize for limited storage on watchOS
///   - Handle tvOS shared container access
///
/// **Additional Directories:**
/// - `platformCachesDirectory()` - Cache directory access
/// - `platformTemporaryDirectory()` - Temporary file directory
/// - `platformSharedContainerDirectory()` - App group shared containers
///
/// **Enhanced Features:**
/// - **Error Details**: Return detailed error information instead of just `nil`
///   - Custom error type with specific failure reasons
///   - Better debugging and error reporting
///
/// - **Directory Validation**: Verify directory permissions and accessibility
///   - Check read/write permissions
///   - Validate directory is actually accessible
///
/// - **Path Utilities**: Additional helper functions
///   - Safe path component appending
///   - Path existence checking
///   - Directory size calculation
///
/// **Considerations:**
/// - Maintain backward compatibility with existing API
/// - Keep optional return types for safe error handling
/// - Consider adding throwing variants for detailed error information
/// - Evaluate performance impact of additional features
///
/// **Implementation Notes:**
/// - Current implementation uses same API on both platforms, but abstraction
///   enables future platform-specific behavior without breaking changes
/// - Optional return type pattern allows graceful degradation
/// - `createIfNeeded` parameter provides flexibility for different use cases
