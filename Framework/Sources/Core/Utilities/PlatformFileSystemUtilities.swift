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

/// Returns the Caches directory URL in a cross-platform manner.
///
/// This function abstracts platform-specific Caches directory access:
/// - **macOS**: Uses `FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)`
/// - **iOS**: Uses `FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)`
/// - **watchOS/tvOS/visionOS**: Uses `FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)`
///
/// While all platforms use the same underlying API, this abstraction provides:
/// - Consistent, testable API across the framework
/// - Future extensibility for platform-specific enhancements
/// - Reduced code verbosity in consuming applications
///
/// This eliminates the need for verbose, repetitive code in consuming applications:
/// ```swift
/// // Instead of:
/// let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
///
/// // Use the cross-platform function:
/// guard let cachesURL = platformCachesDirectory(createIfNeeded: true) else {
///     // Handle error
///     return
/// }
/// ```
///
/// - Parameter createIfNeeded: If `true`, creates the directory if it doesn't exist. Defaults to `false`.
/// - Returns: A `URL` representing the Caches directory, or `nil` if the directory cannot be located or created.
public func platformCachesDirectory(createIfNeeded: Bool = false) -> URL? {
    guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
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

/// Returns the Temporary directory URL in a cross-platform manner.
///
/// This function abstracts platform-specific Temporary directory access:
/// - **All platforms**: Uses `FileManager.default.temporaryDirectory`
///
/// This abstraction provides:
/// - Consistent, testable API across the framework
/// - Future extensibility for platform-specific enhancements
/// - Reduced code verbosity in consuming applications
///
/// This eliminates the need for verbose, repetitive code in consuming applications:
/// ```swift
/// // Instead of:
/// let tempURL = FileManager.default.temporaryDirectory
///
/// // Use the cross-platform function:
/// guard let tempURL = platformTemporaryDirectory(createIfNeeded: true) else {
///     // Handle error
///     return
/// }
/// ```
///
/// - Parameter createIfNeeded: If `true`, creates the directory if it doesn't exist. Defaults to `false`.
/// - Returns: A `URL` representing the Temporary directory, or `nil` if the directory cannot be located or created.
public func platformTemporaryDirectory(createIfNeeded: Bool = false) -> URL? {
    let url = FileManager.default.temporaryDirectory
    
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

/// Returns the Shared Container (App Group) directory URL in a cross-platform manner.
///
/// This function abstracts platform-specific Shared Container directory access:
/// - **iOS/watchOS/tvOS**: Uses `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:)`
/// - **macOS**: Uses `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:)` (when App Groups are configured)
///
/// Shared containers allow apps and their extensions to share data within the same app group.
/// This is commonly used for:
/// - Sharing data between main app and extensions (Today widgets, Share extensions, etc.)
/// - Sharing data between watchOS app and iOS app
/// - Sharing data between multiple apps in the same app group
///
/// This abstraction provides:
/// - Consistent, testable API across the framework
/// - Future extensibility for platform-specific enhancements
/// - Reduced code verbosity in consuming applications
///
/// This eliminates the need for verbose, repetitive code in consuming applications:
/// ```swift
/// // Instead of:
/// let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.example.app")!
///
/// // Use the cross-platform function:
/// guard let containerURL = platformSharedContainerDirectory(containerIdentifier: "group.com.example.app", createIfNeeded: true) else {
///     // Handle error (container may not be configured in entitlements)
///     return
/// }
/// ```
///
/// - Parameters:
///   - containerIdentifier: The app group identifier (e.g., "group.com.example.app")
///   - createIfNeeded: If `true`, creates the directory if it doesn't exist. Defaults to `false`.
/// - Returns: A `URL` representing the Shared Container directory, or `nil` if the container cannot be located or created.
/// - Note: Returns `nil` if the container identifier is not configured in the app's entitlements or if the container cannot be accessed.
public func platformSharedContainerDirectory(containerIdentifier: String, createIfNeeded: Bool = false) -> URL? {
    guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: containerIdentifier) else {
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

// MARK: - Security-Scoped Resource Management

#if os(macOS) || os(iOS)
/// Provides automatic security-scoped resource access with RAII-style lifecycle management.
///
/// This function automatically handles starting and stopping security-scoped resource access,
/// ensuring proper cleanup even if an error is thrown.
///
/// **macOS Use Cases:**
/// - File picker results (`NSOpenPanel`, `fileImporter`)
/// - Drag & drop operations (`NSItemProvider` URLs)
/// - Restored bookmarks from previous sessions
/// - Files accessed via "Open Recent" menu
/// - App Sandbox: Accessing files outside the sandbox
///
/// **iOS Use Cases:**
/// - Document picker results (`UIDocumentPickerViewController`)
/// - Files accessed outside the app's sandbox
/// - Files from file provider extensions
///
/// **Example Usage:**
/// ```swift
/// // From file picker
/// if let url = filePickerURL {
///     platformSecurityScopedAccess(url: url) { accessibleURL in
///         // Use accessibleURL here - access is automatically managed
///         let data = try Data(contentsOf: accessibleURL)
///         // Access automatically stops when block exits
///     }
/// }
///
/// // With error handling
/// do {
///     try platformSecurityScopedAccess(url: url) { accessibleURL in
///         try processFile(at: accessibleURL)
///     }
/// } catch {
///     // Handle error
/// }
/// ```
///
/// - Parameters:
///   - url: The URL that requires security-scoped access
///   - block: A closure that receives the accessible URL. Access is automatically
///            started before the block and stopped after (even if an error is thrown)
/// - Returns: The result of the block
/// - Throws: Any error thrown by the block
/// - Note: On platforms that don't support security-scoped resources, this function simply passes the URL through unchanged
@available(macOS 10.7, iOS 8.0, *)
public func platformSecurityScopedAccess<T>(url: URL, _ block: (URL) throws -> T) rethrows -> T {
    let started = url.startAccessingSecurityScopedResource()
    defer {
        if started {
            url.stopAccessingSecurityScopedResource()
        }
    }
    return try block(url)
}

/// Persists a security-scoped bookmark for later restoration.
///
/// Saves a bookmark for a URL so it can be accessed across app launches without
/// requiring the user to reselect the file. This is essential for sandboxed macOS apps
/// that need persistent access to user-selected directories or files.
///
/// **Storage Location:**
/// Bookmarks are stored in the Application Support directory in a subdirectory
/// specifically for security-scoped bookmarks. This design allows for future enhancement
/// with a dedicated storage manager (e.g., encryption, compression, migration).
///
/// **Example Usage:**
/// ```swift
/// // After user selects a folder
/// if let folderURL = selectedFolderURL {
///     if platformSecurityScopedBookmark(url: folderURL, key: "userDocuments") {
///         print("Bookmark saved successfully")
///     }
/// }
///
/// // Later, restore the bookmark
/// if let restoredURL = platformSecurityScopedRestore(key: "userDocuments") {
///     platformSecurityScopedAccess(url: restoredURL) { accessibleURL in
///         // Use the restored URL
///     }
/// }
/// ```
///
/// - Parameters:
///   - url: The URL to create a bookmark for
///   - key: A unique key to identify this bookmark (used for later restoration)
/// - Returns: `true` if the bookmark was successfully saved, `false` otherwise
/// - Note: Bookmarks are macOS-specific. On iOS and other platforms, this function returns `false`
@available(macOS 10.7, *)
public func platformSecurityScopedBookmark(url: URL, key: String) -> Bool {
    #if os(macOS)
    return _platformSecurityScopedBookmarkSave(url: url, key: key)
    #else
    return false
    #endif
}

/// Restores a previously saved security-scoped bookmark.
///
/// Retrieves a URL from a previously saved bookmark. The returned URL must be used
/// with `platformSecurityScopedAccess()` to actually access the resource.
///
/// **Example Usage:**
/// ```swift
/// // Restore bookmark from previous session
/// if let restoredURL = platformSecurityScopedRestore(key: "userDocuments") {
///     platformSecurityScopedAccess(url: restoredURL) { accessibleURL in
///         // Access the restored resource
///         let files = try FileManager.default.contentsOfDirectory(at: accessibleURL, ...)
///     }
/// } else {
///     // Bookmark not found or invalid - prompt user to reselect
///     showFilePicker()
/// }
/// ```
///
/// - Parameter key: The unique key used when saving the bookmark
/// - Returns: The restored URL, or `nil` if the bookmark doesn't exist or is invalid
/// - Note: Bookmarks are macOS-specific. On iOS and other platforms, this function returns `nil`
@available(macOS 10.7, *)
public func platformSecurityScopedRestore(key: String) -> URL? {
    #if os(macOS)
    return _platformSecurityScopedBookmarkLoad(key: key)
    #else
    return nil
    #endif
}

/// Removes a previously saved security-scoped bookmark.
///
/// Deletes a bookmark from storage. This is useful when the user explicitly removes
/// access or when cleaning up invalid bookmarks.
///
/// - Parameter key: The unique key of the bookmark to remove
/// - Returns: `true` if the bookmark was successfully removed, `false` otherwise
/// - Note: Bookmarks are macOS-specific. On iOS and other platforms, this function returns `false`
@available(macOS 10.7, *)
public func platformSecurityScopedRemoveBookmark(key: String) -> Bool {
    #if os(macOS)
    return _platformSecurityScopedBookmarkRemove(key: key)
    #else
    return false
    #endif
}

/// Checks if a bookmark exists for the given key.
///
/// - Parameter key: The unique key to check
/// - Returns: `true` if a bookmark exists for the key, `false` otherwise
/// - Note: Bookmarks are macOS-specific. On iOS and other platforms, this function returns `false`
@available(macOS 10.7, *)
public func platformSecurityScopedHasBookmark(key: String) -> Bool {
    #if os(macOS)
    return _platformSecurityScopedBookmarkExists(key: key)
    #else
    return false
    #endif
}

// MARK: - Internal Bookmark Storage Helpers

/// Internal helper functions for bookmark storage.
///
/// These functions use Application Support directory directly and are structured
/// to allow future enhancement with a dedicated storage manager (e.g., encryption,
/// compression, migration, etc.) without changing the public API.
///
/// **Future Enhancement Path:**
/// A `SecurityScopedBookmarkManager` class can be added later that wraps these
/// functions, providing additional features like:
/// - Encryption of bookmark data
/// - Compression for large bookmark collections
/// - Migration between storage formats
/// - Bookmark validation and cleanup
/// - Metadata storage (creation date, last access, etc.)
///
/// The public API functions (`platformSecurityScopedBookmark`, etc.) can then
/// delegate to the manager while maintaining backward compatibility.

#if os(macOS)
/// Bookmark storage directory name within Application Support
private let _bookmarkStorageDirectoryName = "SecurityScopedBookmarks"

/// Gets the bookmark storage directory, creating it if needed
/// Note: Bookmarks are macOS-specific only
@available(macOS 10.7, *)
private func _getBookmarkStorageDirectory() -> URL? {
    guard let appSupport = platformApplicationSupportDirectory(createIfNeeded: true) else {
        return nil
    }
    
    let bookmarkDir = appSupport.appendingPathComponent(_bookmarkStorageDirectoryName, isDirectory: true)
    
    // Create directory if it doesn't exist
    if !FileManager.default.fileExists(atPath: bookmarkDir.path) {
        do {
            try FileManager.default.createDirectory(at: bookmarkDir, withIntermediateDirectories: true)
        } catch {
            return nil
        }
    }
    
    return bookmarkDir
}

/// Gets the file URL for a bookmark with the given key
@available(macOS 10.7, *)
private func _bookmarkFileURL(for key: String) -> URL? {
    guard let bookmarkDir = _getBookmarkStorageDirectory() else {
        return nil
    }
    
    // Sanitize key to be filesystem-safe
    let sanitizedKey = key.replacingOccurrences(of: "/", with: "_")
                           .replacingOccurrences(of: "\\", with: "_")
                           .replacingOccurrences(of: "..", with: "_")
    
    return bookmarkDir.appendingPathComponent("\(sanitizedKey).bookmark")
}

/// Saves a bookmark for a URL with the given key
@available(macOS 10.7, *)
private func _platformSecurityScopedBookmarkSave(url: URL, key: String) -> Bool {
    guard let bookmarkFileURL = _bookmarkFileURL(for: key) else {
        return false
    }
    
    do {
        // Create security-scoped bookmark data
        // Note: The bookmark preserves the access level available when created
        let bookmarkData = try url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        
        // Write bookmark data to file
        try bookmarkData.write(to: bookmarkFileURL, options: [.atomic])
        return true
    } catch {
        return false
    }
}

/// Loads a bookmark for the given key and resolves it to a URL
@available(macOS 10.7, *)
private func _platformSecurityScopedBookmarkLoad(key: String) -> URL? {
    guard let bookmarkFileURL = _bookmarkFileURL(for: key),
          FileManager.default.fileExists(atPath: bookmarkFileURL.path) else {
        return nil
    }
    
    do {
        // Read bookmark data from file
        let bookmarkData = try Data(contentsOf: bookmarkFileURL)
        
        // Resolve bookmark to URL with security scope
        var isStale = false
        let url = try URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope, .withoutUI],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        
        // If bookmark is stale, it may still work but should be refreshed
        // For now, we return it anyway - future enhancement could refresh automatically
        if isStale {
            // Optionally refresh the bookmark here in future
        }
        
        return url
    } catch {
        return nil
    }
}

/// Removes a bookmark for the given key
@available(macOS 10.7, *)
private func _platformSecurityScopedBookmarkRemove(key: String) -> Bool {
    guard let bookmarkFileURL = _bookmarkFileURL(for: key) else {
        return false
    }
    
    do {
        try FileManager.default.removeItem(at: bookmarkFileURL)
        return true
    } catch {
        return false
    }
}

/// Checks if a bookmark exists for the given key
@available(macOS 10.7, *)
private func _platformSecurityScopedBookmarkExists(key: String) -> Bool {
    guard let bookmarkFileURL = _bookmarkFileURL(for: key) else {
        return false
    }
    
    return FileManager.default.fileExists(atPath: bookmarkFileURL.path)
}
#endif

#else
// MARK: - Security-Scoped Resource Management (Other Platforms)

/// Provides automatic security-scoped resource access (no-op on platforms that don't support it).
///
/// On platforms that don't support security-scoped resources (watchOS, tvOS, visionOS),
/// this function simply passes the URL through unchanged.
///
/// - Parameters:
///   - url: The URL to access
///   - block: A closure that receives the URL
/// - Returns: The result of the block
/// - Throws: Any error thrown by the block
public func platformSecurityScopedAccess<T>(url: URL, _ block: (URL) throws -> T) rethrows -> T {
    return try block(url)
}

/// Persists a security-scoped bookmark (no-op on platforms that don't support bookmarks).
///
/// Bookmarks are only supported on macOS. On other platforms, this function returns `false`.
///
/// - Parameters:
///   - url: The URL to create a bookmark for
///   - key: A unique key to identify this bookmark
/// - Returns: `false` (bookmarks are macOS-specific)
public func platformSecurityScopedBookmark(url: URL, key: String) -> Bool {
    return false
}

/// Restores a previously saved security-scoped bookmark (no-op on platforms that don't support bookmarks).
///
/// Bookmarks are only supported on macOS. On other platforms, this function returns `nil`.
///
/// - Parameter key: The unique key used when saving the bookmark
/// - Returns: `nil` (bookmarks are macOS-specific)
public func platformSecurityScopedRestore(key: String) -> URL? {
    return nil
}

/// Removes a previously saved security-scoped bookmark (no-op on platforms that don't support bookmarks).
///
/// Bookmarks are only supported on macOS. On other platforms, this function returns `false`.
///
/// - Parameter key: The unique key of the bookmark to remove
/// - Returns: `false` (bookmarks are macOS-specific)
public func platformSecurityScopedRemoveBookmark(key: String) -> Bool {
    return false
}

/// Checks if a bookmark exists for the given key (no-op on platforms that don't support bookmarks).
///
/// Bookmarks are only supported on macOS. On other platforms, this function returns `false`.
///
/// - Parameter key: The unique key to check
/// - Returns: `false` (bookmarks are macOS-specific)
public func platformSecurityScopedHasBookmark(key: String) -> Bool {
    return false
}
#endif

// MARK: - Future Enhancements

/// Potential future enhancements for platform file system utilities:
///
/// **Platform-Specific Features:**
/// - **iCloud Drive Integration**: Support for iCloud-enabled directories on iOS/macOS
///   - Detect if iCloud Drive is available and enabled
///   - Option to use iCloud container directories
///   - Handle iCloud sync status and conflicts
///
/// - **watchOS/tvOS Optimizations**: Platform-specific directory handling
///   - Optimize for limited storage on watchOS
///   - Handle tvOS shared container access
///
/// **Additional Directories:**
/// - ✅ `platformCachesDirectory()` - Cache directory access (IMPLEMENTED)
/// - ✅ `platformTemporaryDirectory()` - Temporary file directory (IMPLEMENTED)
/// - ✅ `platformSharedContainerDirectory()` - App group shared containers (IMPLEMENTED)
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
/// **Security-Scoped Resource Enhancements:**
/// - **Dedicated Storage Manager**: Wrapper around bookmark storage with additional features
///   - Encryption of bookmark data
///   - Compression for large bookmark collections
///   - Migration between storage formats
///   - Bookmark validation and cleanup
///   - Metadata storage (creation date, last access, etc.)
///   - The current implementation uses internal helpers that can be wrapped by a manager
///     class without breaking the public API
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
/// - Security-scoped resource functions use internal helpers that can be wrapped
///   by a dedicated manager class in the future without breaking the public API
