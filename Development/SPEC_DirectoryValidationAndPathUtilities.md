# Directory Validation and Path Utilities - Complete Specification

**Issue**: #56  
**Status**: Specification (Pre-Implementation)  
**Target**: v6.0.0

## Overview

This specification defines directory validation and path utility functions for the SixLayer Framework. These utilities provide safe, cross-platform file system operations with proper error handling and security considerations.

## Design Principles

1. **Consistency**: Match existing `PlatformFileSystemUtilities.swift` patterns
2. **Safety**: Prefer safe operations over convenience
3. **Cross-Platform**: Work correctly on macOS, iOS, watchOS, tvOS, and visionOS
4. **Sandbox-Aware**: Properly handle sandboxed app environments
5. **Error Handling**: Provide both simple (optional) and detailed (throwing) variants
6. **Performance**: Document performance characteristics and provide async variants where needed

---

## Type Definitions

### DirectoryPermissions

```swift
/// Directory permissions for the current process (effective UID)
///
/// This structure represents what the current process can do with a directory.
/// Permissions are checked using the process's effective user ID (EUID).
///
/// In sandboxed apps, these permissions reflect:
/// - The app's sandbox boundaries
/// - User-granted access via TCC (Transparency, Consent, and Control)
/// - Security-scoped resource access (if applicable)
///
/// **Platform Notes:**
/// - **macOS**: Checks traditional Unix permissions + sandbox restrictions
/// - **iOS/watchOS/tvOS/visionOS**: Primarily reflects sandbox permissions
///
/// **Example Usage:**
/// ```swift
/// let permissions = checkDirectoryPermissions(at: someURL)
/// if permissions.readable && permissions.writable {
///     // Safe to read and write
/// }
/// ```
public struct DirectoryPermissions: Sendable {
    /// Whether the current process can read this directory
    public let readable: Bool
    
    /// Whether the current process can write to this directory
    public let writable: Bool
    
    /// Whether the current process can execute/search this directory
    /// (required to list contents or traverse into subdirectories)
    public let executable: Bool
    
    /// Whether the directory exists and is a directory (not a file)
    public let exists: Bool
    
    /// Whether the path exists but is not a directory (e.g., it's a file)
    public let isFile: Bool
    
    /// Whether the directory is accessible (exists and is a directory)
    public var accessible: Bool {
        return exists && !isFile
    }
    
    /// Whether the directory is usable for read operations
    public var canRead: Bool {
        return accessible && readable
    }
    
    /// Whether the directory is usable for write operations
    public var canWrite: Bool {
        return accessible && writable
    }
    
    /// Whether the directory is usable for full operations (read, write, list)
    public var fullyAccessible: Bool {
        return accessible && readable && writable && executable
    }
    
    public init(
        readable: Bool,
        writable: Bool,
        executable: Bool,
        exists: Bool,
        isFile: Bool
    ) {
        self.readable = readable
        self.writable = writable
        self.executable = executable
        self.exists = exists
        self.isFile = isFile
    }
}
```

### DirectoryValidationError

```swift
/// Errors that can occur during directory validation
public enum DirectoryValidationError: Error, LocalizedError, Sendable {
    /// The path does not exist
    case doesNotExist
    
    /// The path exists but is not a directory (e.g., it's a file)
    case notADirectory
    
    /// The directory exists but the current process cannot read it
    case notReadable
    
    /// The directory exists but the current process cannot write to it
    case notWritable
    
    /// The directory exists but the current process cannot execute/search it
    case notExecutable
    
    /// The directory is on a network volume that is unavailable
    case networkVolumeUnavailable
    
    /// The directory is on a network volume that is slow/unresponsive
    case networkVolumeSlow
    
    /// An underlying file system error occurred
    case fileSystemError(Error)
    
    /// The path contains invalid characters or is malformed
    case invalidPath
    
    /// Security-scoped resource access is required but not available
    case securityScopedAccessRequired
    
    public var errorDescription: String? {
        switch self {
        case .doesNotExist:
            return "The directory does not exist"
        case .notADirectory:
            return "The path exists but is not a directory"
        case .notReadable:
            return "The directory is not readable by the current process"
        case .notWritable:
            return "The directory is not writable by the current process"
        case .notExecutable:
            return "The directory is not executable/searchable by the current process"
        case .networkVolumeUnavailable:
            return "The directory is on a network volume that is unavailable"
        case .networkVolumeSlow:
            return "The directory is on a network volume that is slow or unresponsive"
        case .fileSystemError(let error):
            return "File system error: \(error.localizedDescription)"
        case .invalidPath:
            return "The path contains invalid characters or is malformed"
        case .securityScopedAccessRequired:
            return "Security-scoped resource access is required but not available"
        }
    }
}
```

---

## Function Specifications

### 1. validateDirectoryAccess

**Purpose**: Simple boolean check for directory accessibility and basic permissions.

**Signature**:
```swift
/// Validates that a directory exists, is accessible, and has required permissions.
///
/// This is a convenience function that performs basic validation checks.
/// For detailed error information, use `validateDirectoryAccessThrowing()`.
///
/// **What it checks:**
/// - Directory exists
/// - Path is actually a directory (not a file)
/// - Current process can read the directory
///
/// **What it does NOT check:**
/// - Write permissions (use `checkDirectoryPermissions()` for that)
/// - Execute permissions
/// - Network volume availability
///
/// **Platform Behavior:**
/// - **macOS**: Checks Unix permissions + sandbox restrictions
/// - **iOS/watchOS/tvOS/visionOS**: Checks sandbox permissions
///
/// **Security-Scoped Resources:**
/// - Does NOT automatically start security-scoped access
/// - If the URL requires security-scoped access, wrap the call in
///   `platformSecurityScopedAccess()` first
///
/// **Example Usage:**
/// ```swift
/// // Simple check
/// if validateDirectoryAccess(at: someURL) {
///     // Directory is accessible and readable
/// }
///
/// // With security-scoped resources
/// platformSecurityScopedAccess(url: userSelectedURL) { accessibleURL in
///     if validateDirectoryAccess(at: accessibleURL) {
///         // Safe to use
///     }
/// }
/// ```
///
/// - Parameter url: The directory URL to validate
/// - Returns: `true` if the directory exists, is a directory, and is readable by the current process
public func validateDirectoryAccess(at url: URL) -> Bool
```

**Behavior**:
- Returns `true` if: directory exists, is a directory (not file), and is readable
- Returns `false` for: non-existent paths, files (not directories), or unreadable directories
- Does NOT check write or execute permissions
- Does NOT handle security-scoped resources automatically
- Thread-safe (uses FileManager which is thread-safe)

**Edge Cases**:
- Symlinks: Follows to the target (standard FileManager behavior)
- Network volumes: May return `false` if volume is unavailable (no timeout)
- Special directories: Works with system directories if permissions allow
- Relative paths: Resolved relative to current working directory

---

### 2. validateDirectoryAccessThrowing

**Purpose**: Detailed validation with error information.

**Signature**:
```swift
/// Validates directory access and returns detailed error information on failure.
///
/// This is the throwing variant that provides specific error information.
/// For simple boolean checks, use `validateDirectoryAccess()`.
///
/// **What it checks:**
/// - Directory exists
/// - Path is actually a directory (not a file)
/// - Current process can read the directory
///
/// **Error Details:**
/// - Returns specific `DirectoryValidationError` cases
/// - Wraps underlying file system errors
///
/// **Example Usage:**
/// ```swift
/// do {
///     try validateDirectoryAccessThrowing(at: someURL)
///     // Directory is accessible and readable
/// } catch DirectoryValidationError.doesNotExist {
///     // Handle missing directory
/// } catch DirectoryValidationError.notReadable {
///     // Handle permission issue
/// } catch {
///     // Handle other errors
/// }
/// ```
///
/// - Parameter url: The directory URL to validate
/// - Throws: `DirectoryValidationError` if validation fails
/// - Returns: `true` if validation succeeds (always returns true, throws on failure)
@discardableResult
public func validateDirectoryAccessThrowing(at url: URL) throws -> Bool
```

**Behavior**:
- Same checks as `validateDirectoryAccess()` but throws detailed errors
- Throws `DirectoryValidationError` with specific cases
- Always returns `true` if no error (discardable result)

---

### 3. checkDirectoryPermissions

**Purpose**: Comprehensive permission checking for the current process.

**Signature**:
```swift
/// Checks directory permissions for the current process (effective UID).
///
/// Returns detailed permission information including read, write, and execute
/// permissions. Permissions are checked using the process's effective user ID.
///
/// **What it checks:**
/// - Directory existence
/// - Whether path is a directory (not a file)
/// - Read permission (can list contents)
/// - Write permission (can create/modify files)
/// - Execute permission (can traverse/search)
///
/// **Platform Behavior:**
/// - **macOS**: Checks Unix permissions (owner/group/other) based on effective UID
/// - **iOS/watchOS/tvOS/visionOS**: Primarily reflects sandbox permissions
///
/// **Security-Scoped Resources:**
/// - Does NOT automatically start security-scoped access
/// - If the URL requires security-scoped access, wrap the call in
///   `platformSecurityScopedAccess()` first
///
/// **Example Usage:**
/// ```swift
/// let permissions = checkDirectoryPermissions(at: someURL)
///
/// if permissions.canRead {
///     // Safe to read/list contents
/// }
///
/// if permissions.canWrite {
///     // Safe to create/modify files
/// }
///
/// if permissions.fullyAccessible {
///     // Safe for all operations
/// }
/// ```
///
/// - Parameter url: The directory URL to check
/// - Returns: `DirectoryPermissions` structure with detailed permission information
public func checkDirectoryPermissions(at url: URL) -> DirectoryPermissions
```

**Behavior**:
- Uses `FileManager.isReadableFile(atPath:)`, `isWritableFile(atPath:)`, `isExecutableFile(atPath:)`
- These methods check permissions for the current process's effective UID
- Returns `DirectoryPermissions` with all permission flags
- Handles non-existent paths (returns `exists: false`)
- Handles files vs directories (returns `isFile: true` if it's a file)

**Edge Cases**:
- Non-existent paths: Returns `DirectoryPermissions(exists: false, ...)`
- Files (not directories): Returns `DirectoryPermissions(isFile: true, ...)`
- Symlinks: Follows to target (standard FileManager behavior)
- Network volumes: May be slow, but no timeout (returns permissions if available)

---

### 4. getAvailableDiskSpace

**Purpose**: Get available disk space for a directory's volume.

**Signature**:
```swift
/// Gets the available disk space for the volume containing the specified directory.
///
/// **Platform Behavior:**
/// - **macOS**: Generally reliable, returns bytes available
/// - **iOS/watchOS/tvOS/visionOS**: May be unreliable or return `nil` in some cases
///   - iCloud Drive volumes may report incorrect values
///   - Some system volumes may not report space
///   - Sandbox restrictions may limit accuracy
///
/// **Performance:**
/// - Generally fast (< 10ms)
/// - May be slower on network volumes
///
/// **Example Usage:**
/// ```swift
/// if let availableSpace = getAvailableDiskSpace(at: someURL) {
///     let availableGB = Double(availableSpace) / 1_000_000_000.0
///     if availableGB < 1.0 {
///         // Warn user about low disk space
///     }
/// }
/// ```
///
/// - Parameter url: A URL on the volume to check (can be any path on the volume)
/// - Returns: Available disk space in bytes, or `nil` if unavailable or cannot be determined
public func getAvailableDiskSpace(at url: URL) -> Int64?
```

**Behavior**:
- Uses `FileManager.attributesOfFileSystem(forPath:)` with `.systemFreeSize` key
- Returns `nil` if: volume unavailable, API unavailable, or error occurs
- Returns bytes as `Int64`
- Works with any path on the volume (doesn't need to be the root)

**Edge Cases**:
- Network volumes: May return `nil` if unavailable
- iCloud volumes: May return inaccurate values on iOS
- System volumes: May return `nil` on some platforms
- Non-existent paths: Uses the volume of the path's parent directory

**Implementation Notes**:
```swift
// Uses FileManager.attributesOfFileSystem(forPath:)
// Key: .systemFreeSize
// Returns Int64? (nil on error or unavailable)
```

---

### 4a. hasEnoughDiskSpace

**Purpose**: Check if enough disk space exists for a specific operation.

**Signature**:
```swift
/// Checks if there is enough available disk space for a specified operation.
///
/// This is a convenience function that wraps `getAvailableDiskSpace()` to provide
/// a simple boolean check for whether a specific amount of space is available.
///
/// **Platform Behavior:**
/// - Same platform limitations as `getAvailableDiskSpace()`
/// - Returns `false` if space cannot be determined (conservative approach)
///
/// **Performance:**
/// - Same as `getAvailableDiskSpace()` (< 10ms typically)
///
/// **Example Usage:**
/// ```swift
/// // Check if we can create a 2GB file
/// if hasEnoughDiskSpace(at: someURL, requiredBytes: 2_000_000_000) {
///     // Safe to proceed with operation
///     createLargeFile(at: someURL)
/// } else {
///     // Not enough space - warn user
///     showDiskSpaceWarning()
/// }
///
/// // Check before downloading
/// let downloadSize: Int64 = 500_000_000 // 500 MB
/// if hasEnoughDiskSpace(at: downloadDirectory, requiredBytes: downloadSize) {
///     startDownload()
/// } else {
///     showInsufficientSpaceError()
/// }
/// ```
///
/// - Parameters:
///   - url: A URL on the volume to check (can be any path on the volume)
///   - requiredBytes: The number of bytes required for the operation
/// - Returns: `true` if enough space is available, `false` if not enough space or if space cannot be determined
public func hasEnoughDiskSpace(at url: URL, requiredBytes: Int64) -> Bool
```

**Behavior**:
- Uses `getAvailableDiskSpace(at:)` internally
- Returns `true` if: available space >= requiredBytes
- Returns `false` if: available space < requiredBytes, space cannot be determined, or error occurs
- Conservative approach: Returns `false` when in doubt (safer than returning `true`)

**Edge Cases**:
- `requiredBytes` is 0 or negative: Returns `true` (no space needed)
- Space cannot be determined: Returns `false` (conservative)
- Network volumes: May return `false` if unavailable
- iCloud volumes: May return inaccurate results on iOS

**Implementation Notes**:
```swift
// Wraps getAvailableDiskSpace(at:)
// Returns available >= requiredBytes
// Returns false if available is nil (conservative)
```

**Behavior**:
- Uses `FileManager.attributesOfFileSystem(forPath:)` with `.systemFreeSize` key
- Returns `nil` if: volume unavailable, API unavailable, or error occurs
- Returns bytes as `Int64`
- Works with any path on the volume (doesn't need to be the root)

**Edge Cases**:
- Network volumes: May return `nil` if unavailable
- iCloud volumes: May return inaccurate values on iOS
- System volumes: May return `nil` on some platforms
- Non-existent paths: Uses the volume of the path's parent directory

**Implementation Notes**:
```swift
// Uses FileManager.attributesOfFileSystem(forPath:)
// Key: .systemFreeSize
// Returns Int64? (nil on error or unavailable)
```

---

### 5. safeAppendPathComponent

**Purpose**: Safely append path components with validation.

**Signature**:
```swift
/// Safely appends a path component to a URL with validation.
///
/// This function provides additional safety over `URL.appendingPathComponent()`
/// by validating the component and preventing path traversal attacks.
///
/// **Safety Features:**
/// - Validates component doesn't contain path separators (`/` or `\`)
/// - Prevents path traversal (`..` components)
/// - Sanitizes component before appending
/// - Validates resulting path is still valid
///
/// **When to use:**
/// - When appending user-provided path components
/// - When appending components from untrusted sources
/// - When you need validation beyond basic URL construction
///
/// **When NOT to use:**
/// - For trusted, known-safe path components
/// - For simple path construction (use `URL.appendingPathComponent()`)
///
/// **Example Usage:**
/// ```swift
/// let baseURL = platformDocumentsDirectory()!
/// 
/// // Safe: user-provided component
/// if let safeURL = safeAppendPathComponent(baseURL, "user_data") {
///     // Component was valid and appended
/// } else {
///     // Component was invalid (contained path separators or ..)
/// }
///
/// // Unsafe component (will return nil)
/// safeAppendPathComponent(baseURL, "../etc/passwd") // Returns nil
/// safeAppendPathComponent(baseURL, "data/file.txt") // Returns nil (contains /)
/// ```
///
/// - Parameters:
///   - url: The base URL to append to
///   - component: The path component to append (must not contain path separators)
/// - Returns: The new URL with component appended, or `nil` if component is invalid
public func safeAppendPathComponent(_ url: URL, _ component: String) -> URL?
```

**Behavior**:
- Validates component doesn't contain `/` or `\`
- Validates component is not `..` or `.`
- Validates component is not empty (after trimming)
- Validates component doesn't start/end with whitespace (security)
- Returns `nil` if validation fails
- Returns new URL if validation passes

**Validation Rules**:
1. Component must not be empty (after trimming whitespace)
2. Component must not contain `/` or `\`
3. Component must not be `..` or `.`
4. Component must not start or end with whitespace
5. Component must not contain null bytes (`\0`)

**Edge Cases**:
- Empty string: Returns `nil`
- Whitespace only: Returns `nil`
- `..` or `.`: Returns `nil`
- Contains `/`: Returns `nil`
- Contains `\`: Returns `nil` (Windows-style, but we're cross-platform)
- Valid component: Returns new URL

---

### 6. calculateDirectorySize

**Purpose**: Calculate total size of a directory and its contents.

**Signature**:
```swift
/// Calculates the total size of a directory and all its contents recursively.
///
/// **Performance Characteristics:**
/// - **Small directories** (< 100 files): Fast (< 100ms)
/// - **Medium directories** (100-10,000 files): Moderate (100ms - 5s)
/// - **Large directories** (> 10,000 files): Slow (5s - minutes)
/// - **Network volumes**: Can be very slow or timeout
///
/// **Considerations:**
/// - This operation can be slow for large directory trees
/// - Consider using `calculateDirectorySizeAsync()` for large directories
/// - May timeout or fail on network volumes
/// - Symlinks are followed (counts target size, not link)
///
/// **Example Usage:**
/// ```swift
/// // For small directories
/// if let size = calculateDirectorySize(at: someURL) {
///     let sizeMB = Double(size) / 1_000_000.0
///     print("Directory size: \(sizeMB) MB")
/// }
///
/// // For large directories, use async version
/// Task {
///     if let size = await calculateDirectorySizeAsync(at: largeURL) {
///         // Handle result
///     }
/// }
/// ```
///
/// - Parameter url: The directory URL to calculate size for
/// - Returns: Total size in bytes, or `nil` if calculation fails or directory doesn't exist
/// - Warning: This is a synchronous operation that may block for large directories
public func calculateDirectorySize(at url: URL) -> Int64?
```

**Behavior**:
- Recursively traverses directory tree
- Sums file sizes (not directory metadata)
- Follows symlinks (counts target, not link)
- Returns `nil` if: directory doesn't exist, permission denied, or error occurs
- Returns `0` for empty directories

**Edge Cases**:
- Non-existent directory: Returns `nil`
- File (not directory): Returns `nil`
- Permission denied: Returns `nil`
- Network volume: May be slow or timeout (no timeout in sync version)
- Symlinks: Follows to target
- Circular symlinks: May cause issues (should detect and skip)

**Implementation Notes**:
- Uses `FileManager.enumerator(at:includingPropertiesForKeys:)`
- Keys: `.fileSizeKey`, `.isDirectoryKey`
- Sums `.fileSize` for all files
- Should handle errors gracefully

---

### 7. calculateDirectorySizeAsync

**Purpose**: Async version for large directories.

**Signature**:
```swift
/// Asynchronously calculates the total size of a directory and all its contents.
///
/// This is the async variant for large directories that may take significant time.
/// Use this instead of `calculateDirectorySize()` for directories with many files
/// or when called from the main thread.
///
/// **Performance:**
/// - Same performance characteristics as sync version
/// - Does not block the calling thread
/// - Can be cancelled via Task cancellation
///
/// **Example Usage:**
/// ```swift
/// Task {
///     if let size = await calculateDirectorySizeAsync(at: largeURL) {
///         updateUI(with: size)
///     }
/// }
///
/// // With cancellation
/// let task = Task {
///     if let size = await calculateDirectorySizeAsync(at: url) {
///         // Handle result
///     }
/// }
/// task.cancel() // Cancels the calculation
/// ```
///
/// - Parameter url: The directory URL to calculate size for
/// - Returns: Total size in bytes, or `nil` if calculation fails
/// - Note: Can be cancelled via Task cancellation
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func calculateDirectorySizeAsync(at url: URL) async -> Int64?
```

**Behavior**:
- Same as sync version but async
- Can be cancelled via Task cancellation
- Yields periodically to avoid blocking
- Uses `Task.yield()` for large operations

---

### 8. sanitizePath

**Purpose**: Sanitize path strings to prevent security issues.

**Signature**:
```swift
/// Sanitizes a path string to prevent security vulnerabilities.
///
/// **What it does:**
/// - Normalizes Unicode to NFC form (prevents HFS+/APFS compatibility issues)
/// - Removes all control characters (0x00-0x1F, 0x7F)
/// - Removes zero-width characters (can hide malicious content)
/// - Removes bidirectional override characters (can reverse text display)
/// - Removes path traversal sequences (`..`)
/// - Removes leading/trailing whitespace, dots, and spaces
/// - Normalizes path separators (converts `\` to `/`)
/// - Removes multiple consecutive separators
/// - Removes/replaces reserved characters (e.g., `:` on macOS)
///
/// **What it does NOT do:**
/// - Validate path exists
/// - Check permissions
/// - Resolve symlinks
/// - Validate path is within a sandbox
/// - Detect Unicode confusables (homoglyphs)
/// - Enforce maximum path length
///
/// **Security Considerations:**
/// - This function helps prevent path traversal attacks and obfuscation
/// - However, it does NOT guarantee the path is safe
/// - Always validate paths against expected directories
/// - Use `URL` instead of `String` when possible (URLs are safer)
/// - Consider using `safeAppendPathComponent()` for component-level safety
///
/// **Example Usage:**
/// ```swift
/// // User-provided path (potentially unsafe)
/// let userPath = "../../etc/passwd"
/// let sanitized = sanitizePath(userPath)
/// // Result: "etc/passwd" (removed ..)
///
/// // Path with control characters
/// let unsafePath = "file\u{200B}name.txt" // Contains zero-width space
/// let sanitized = sanitizePath(unsafePath)
/// // Result: "filename.txt" (removed zero-width space)
///
/// // Still need to validate it's within expected directory
/// let baseURL = platformDocumentsDirectory()!
/// let fullURL = baseURL.appendingPathComponent(sanitized)
/// // Validate fullURL is still within baseURL
/// ```
///
/// - Parameter path: The path string to sanitize
/// - Returns: Sanitized path string
/// - Warning: Sanitization is not a substitute for proper path validation
public func sanitizePath(_ path: String) -> String
```

**Behavior**:
- Normalizes Unicode to NFC (Normalization Form C) for filesystem compatibility
- Removes all control characters (0x00-0x1F, 0x7F) including null bytes
- Removes zero-width characters (U+200B, U+200C, U+200D, U+FEFF)
- Removes bidirectional override characters (U+202E, U+202D)
- Removes `..` sequences (path traversal)
- Removes `.` sequences (but preserves `.` at start for hidden files)
- Trims leading/trailing whitespace, dots, and spaces
- Converts `\` to `/` (normalize separators)
- Collapses multiple consecutive separators to single `/`
- Removes or replaces reserved characters (e.g., `:` on macOS)
- Does NOT validate path exists or is safe

**Sanitization Rules** (applied in order):
1. **Unicode normalization**: Convert to NFC (Normalization Form C)
2. **Control characters**: Remove all control characters (0x00-0x1F, 0x7F)
3. **Zero-width characters**: Remove U+200B (zero-width space), U+200C (zero-width non-joiner), U+200D (zero-width joiner), U+FEFF (zero-width no-break space)
4. **Bidirectional overrides**: Remove U+202E (right-to-left override), U+202D (left-to-right override)
5. **Null bytes**: Remove `\0` (redundant with step 2, but explicit)
6. **Path separators**: Convert backslashes to forward slashes (`\` → `/`)
7. **Whitespace**: Remove leading/trailing whitespace
8. **Trailing dots/spaces**: Remove trailing dots (`.`) and spaces (for cross-platform compatibility)
9. **Path traversal**: Remove `..` sequences (path traversal prevention)
10. **Current directory**: Remove `.` sequences (but preserve `.` at start for hidden files)
11. **Multiple separators**: Collapse multiple consecutive separators to single `/`
12. **Leading separators**: Remove leading separators (but preserve one if path is absolute)
13. **Reserved characters**: Replace or remove reserved characters:
    - Colon (`:`) on macOS (replaced with `-` or removed)
    - Other platform-specific reserved characters as needed

**Edge Cases**:
- Empty string: Returns empty string
- Only whitespace: Returns empty string
- `../../../etc/passwd`: Returns `etc/passwd`
- `C:\Users\Name`: Returns `C:/Users/Name`
- `/absolute/path`: Returns `/absolute/path` (preserves leading `/`)
- `relative/path`: Returns `relative/path`
- `path/with//double//slashes`: Returns `path/with/double/slashes`
- `file\u{200B}name.txt`: Returns `filename.txt` (zero-width space removed)
- `file\u{202E}exe.gpj`: Returns `fileexe.gpj` (right-to-left override removed)
- `file:name.txt`: Returns `file-name.txt` or `filename.txt` (colon removed/replaced on macOS)
- `file.`: Returns `file` (trailing dot removed)
- `file `: Returns `file` (trailing space removed)
- `.hidden`: Returns `.hidden` (leading dot preserved for hidden files)
- Unicode normalization: `é` (U+00E9) and `e\u{0301}` both normalize to same form

**Security Notes**:
- This provides comprehensive sanitization for common security issues
- However, it does NOT guarantee the path is completely safe
- Always validate paths are within expected directories
- Prefer `URL` over `String` for path manipulation
- Consider using `safeAppendPathComponent()` for component-level safety
- Unicode confusables (homoglyphs) are NOT detected - this is complex and may be overkill
- Very long paths (> 1024 chars) are not truncated - consider separate validation

---

### 9. sanitizeFilename

**Purpose**: Sanitize a string to be used as a filename or path component.

**Signature**:
```swift
/// Sanitizes a string to be safe for use as a filename or path component.
///
/// This function is designed for sanitizing individual components (filenames, directory names)
/// that will be used in file paths. For sanitizing full paths, use `sanitizePath()`.
///
/// **What it does:**
/// - Normalizes Unicode to NFC form (prevents HFS+/APFS compatibility issues)
/// - Removes all control characters (0x00-0x1F, 0x7F)
/// - Removes zero-width characters (can hide malicious content)
/// - Removes bidirectional override characters (can reverse text display)
/// - Removes/replaces path separators (`/`, `\`) - not allowed in filenames
/// - Removes path traversal sequences (`..`, `.`)
/// - Removes leading/trailing whitespace, dots, and spaces
/// - Removes/replaces reserved characters (e.g., `:` on macOS)
/// - Optionally enforces maximum length
///
/// **What it does NOT do:**
/// - Validate the resulting filename is unique
/// - Check if filename already exists
/// - Validate path exists
/// - Check permissions
/// - Detect Unicode confusables (homoglyphs)
///
/// **Differences from `sanitizePath()`:**
/// - `sanitizePath()` handles full paths with separators
/// - `sanitizeFilename()` handles single components (no separators allowed)
/// - `sanitizeFilename()` is stricter - path separators are removed/replaced, not normalized
/// - `sanitizeFilename()` can enforce maximum length
///
/// **Security Considerations:**
/// - This function helps prevent security issues in filenames
/// - However, it does NOT guarantee the filename is completely safe
/// - Always validate filenames are within expected directories
/// - Use `URL.appendingPathComponent()` with sanitized filenames
/// - Consider using `safeAppendPathComponent()` for additional validation
///
/// **Example Usage:**
/// ```swift
/// // User-provided filename (potentially unsafe)
/// let userFilename = "my:file\u{200B}name.txt"
/// let sanitized = sanitizeFilename(userFilename)
/// // Result: "my-filename.txt" or "myfilename.txt" (colon and zero-width space removed)
///
/// // Create file with sanitized name
/// let baseURL = platformDocumentsDirectory()!
/// let fileURL = baseURL.appendingPathComponent(sanitized)
///
/// // Filename with path separators (will be removed/replaced)
/// let unsafeName = "folder/file.txt"
/// let sanitized = sanitizeFilename(unsafeName)
/// // Result: "folder-file.txt" or "folder_file.txt" (separator replaced)
///
/// // For bookmark keys (like existing code)
/// let userKey = "user/documents"
/// let sanitizedKey = sanitizeFilename(userKey, replacementCharacter: "_")
/// // Result: "user_documents" (separator replaced with _)
/// ```
///
/// - Parameters:
///   - filename: The string to sanitize for use as a filename
///   - replacementCharacter: Character to replace invalid characters with (default: `"-"`)
///   - maxLength: Maximum length for the filename (default: `255`, `nil` for no limit)
/// - Returns: Sanitized filename string
/// - Warning: Sanitization is not a substitute for proper validation
public func sanitizeFilename(
    _ filename: String,
    replacementCharacter: Character = "-",
    maxLength: Int? = 255
) -> String
```

**Behavior**:
- Normalizes Unicode to NFC (Normalization Form C) for filesystem compatibility
- Removes all control characters (0x00-0x1F, 0x7F) including null bytes
- Removes zero-width characters (U+200B, U+200C, U+200D, U+FEFF)
- Removes bidirectional override characters (U+202E, U+202D)
- Removes or replaces path separators (`/`, `\`) - not allowed in filenames
- Removes `..` and `.` sequences (path traversal prevention)
- Trims leading/trailing whitespace, dots, and spaces
- Removes or replaces reserved characters (e.g., `:` on macOS)
- Optionally truncates to maximum length
- Does NOT validate filename exists or is safe

**Sanitization Rules** (applied in order):
1. **Unicode normalization**: Convert to NFC (Normalization Form C)
2. **Control characters**: Remove all control characters (0x00-0x1F, 0x7F)
3. **Zero-width characters**: Remove U+200B, U+200C, U+200D, U+FEFF
4. **Bidirectional overrides**: Remove U+202E, U+202D
5. **Path separators**: Replace `/` and `\` with `replacementCharacter` (default: `-`)
6. **Path traversal**: Remove `..` sequences
7. **Current directory**: Remove `.` sequences (but preserve `.` at start for hidden files)
8. **Whitespace**: Remove leading/trailing whitespace
9. **Trailing dots/spaces**: Remove trailing dots (`.`) and spaces
10. **Reserved characters**: Replace or remove reserved characters:
    - Colon (`:`) on macOS (replaced with `replacementCharacter`)
    - Other platform-specific reserved characters as needed
11. **Maximum length**: Truncate to `maxLength` if specified (default: 255)
12. **Empty result**: If result is empty after sanitization, return `"_"` or similar safe default

**Edge Cases**:
- Empty string: Returns `"_"` (safe default)
- Only whitespace: Returns `"_"`
- `file:name.txt`: Returns `file-name.txt` (colon replaced)
- `folder/file.txt`: Returns `folder-file.txt` (separator replaced)
- `file\u{200B}name.txt`: Returns `filename.txt` (zero-width space removed)
- `file\u{202E}exe.gpj`: Returns `fileexe.gpj` (right-to-left override removed)
- `file.`: Returns `file` (trailing dot removed)
- `file `: Returns `file` (trailing space removed)
- `.hidden`: Returns `.hidden` (leading dot preserved for hidden files)
- `..`: Returns `_` (path traversal removed)
- Very long filename: Truncated to `maxLength` (default: 255)
- All invalid characters: Returns `"_"` if nothing remains

**Use Cases**:
- User-provided filenames before creating files
- Directory names before creating directories
- Keys/identifiers used in file paths (like bookmark keys)
- Any string that will become a path component
- Filenames from untrusted sources

**Security Notes**:
- This provides comprehensive sanitization for filenames/components
- Path separators are replaced, not preserved (unlike `sanitizePath()`)
- More strict than `sanitizePath()` since it's for single components
- Always validate filenames are within expected directories
- Use with `URL.appendingPathComponent()` for safe path construction
- Consider using `safeAppendPathComponent()` for additional validation
- Unicode confusables (homoglyphs) are NOT detected
- Maximum length helps prevent filesystem issues (default: 255 is common filesystem limit)

---

## Error Handling Strategy

### Dual API Pattern

We provide both simple (optional) and detailed (throwing) variants:

1. **Simple variants** (match existing pattern):
   - `validateDirectoryAccess(at:) -> Bool`
   - `getAvailableDiskSpace(at:) -> Int64?`
   - `hasEnoughDiskSpace(at:requiredBytes:) -> Bool`
   - `calculateDirectorySize(at:) -> Int64?`
   - `safeAppendPathComponent(_:_:) -> URL?`
   - `sanitizePath(_:) -> String`
   - `sanitizeFilename(_:replacementCharacter:maxLength:) -> String`

2. **Detailed variants** (for error information):
   - `validateDirectoryAccessThrowing(at:) throws -> Bool`

### Rationale

- **Consistency**: Simple variants match existing `PlatformFileSystemUtilities` pattern
- **Flexibility**: Detailed variants provide error information when needed
- **Gradual adoption**: Users can start with simple variants, upgrade to detailed when needed

---

## Edge Cases and Platform Differences

### Symlinks

- **Behavior**: All functions follow symlinks (standard FileManager behavior)
- **Consideration**: Circular symlinks may cause issues in `calculateDirectorySize`
- **Solution**: Detect and skip circular references in size calculation

### Network Volumes

- **Behavior**: May be slow or unavailable
- **Consideration**: No timeout in sync functions
- **Solution**: Use async variants for network volumes, or implement timeouts

### Special Directories

- **System directories**: May require elevated permissions
- **Protected locations**: May be inaccessible in sandboxed apps
- **Behavior**: Functions return appropriate permissions/errors

### File vs Directory

- **Detection**: All functions check if path is directory vs file
- **Behavior**: Return appropriate errors/permissions for files
- **Example**: `checkDirectoryPermissions` returns `isFile: true` for files

### Non-Existent Paths

- **Behavior**: Return `false`, `nil`, or throw `doesNotExist` error
- **Consistency**: All functions handle non-existent paths gracefully

### Security-Scoped Resources

- **Requirement**: Functions do NOT automatically start security-scoped access
- **Usage**: Wrap calls in `platformSecurityScopedAccess()` when needed
- **Example**: User-selected directories require security-scoped access

---

## Security Considerations

### Path Traversal Prevention

- `safeAppendPathComponent`: Validates components don't contain `..`
- `sanitizePath`: Removes `..` sequences
- **Note**: Always validate final paths are within expected directories

### Input Validation

- All functions validate input URLs/paths
- Reject null bytes, invalid characters
- Validate path components before use

### Sandbox Awareness

- Functions respect sandbox boundaries
- Security-scoped resources must be handled explicitly
- TCC permissions are checked automatically by FileManager

---

## Performance Characteristics

### Fast Operations (< 10ms)
- `validateDirectoryAccess`
- `checkDirectoryPermissions`
- `getAvailableDiskSpace` (usually)
- `hasEnoughDiskSpace` (usually)
- `safeAppendPathComponent`
- `sanitizePath`

### Moderate Operations (10ms - 1s)
- `calculateDirectorySize` (small directories)

### Slow Operations (1s+)
- `calculateDirectorySize` (large directories)
- `calculateDirectorySizeAsync` (large directories, but non-blocking)

### Recommendations

- Use sync variants for small operations
- Use async variants for large directory size calculations
- Consider caching results for frequently-checked directories
- Document performance expectations in function documentation

---

## Testing Requirements

### Unit Tests Required

1. **validateDirectoryAccess**:
   - Existing directory (readable)
   - Existing directory (not readable)
   - Non-existent path
   - File (not directory)
   - Symlink to directory
   - Network volume (if testable)

2. **checkDirectoryPermissions**:
   - All permission combinations
   - Non-existent path
   - File vs directory
   - Symlinks

3. **getAvailableDiskSpace**:
   - Normal directory
   - Network volume
   - Non-existent path
   - System volume (may return nil)

4. **hasEnoughDiskSpace**:
   - Sufficient space available
   - Insufficient space available
   - Space cannot be determined (should return false)
   - Zero or negative requiredBytes
   - Network volume

4. **safeAppendPathComponent**:
   - Valid components
   - Invalid components (path separators, `..`, etc.)
   - Empty string
   - Whitespace

5. **calculateDirectorySize**:
   - Empty directory
   - Small directory
   - Large directory (if feasible in tests)
   - Non-existent directory
   - Permission denied

6. **sanitizePath**:
   - Path traversal attempts
   - Null bytes
   - Invalid characters
   - Normal paths

7. **sanitizeFilename**:
   - Valid filenames
   - Filenames with path separators
   - Filenames with control characters
   - Filenames with zero-width characters
   - Filenames with reserved characters
   - Very long filenames (truncation)
   - Empty strings (default return)

### Integration Tests

- Test with security-scoped resources
- Test with sandboxed app environment
- Test cross-platform behavior

### Edge Case Tests

- Symlinks (including circular)
- Network volumes
- Special directories
- Very long paths
- Unicode paths

---

## Implementation Plan

### Phase 1: Core Types and Simple Functions
1. Define `DirectoryPermissions` struct
2. Define `DirectoryValidationError` enum
3. Implement `validateDirectoryAccess`
4. Implement `checkDirectoryPermissions`

### Phase 2: Path Utilities
5. Implement `safeAppendPathComponent`
6. Implement `sanitizePath`
7. Implement `sanitizeFilename`

### Phase 3: Advanced Features
8. Implement `getAvailableDiskSpace`
9. Implement `hasEnoughDiskSpace`
10. Implement `calculateDirectorySize` (sync)
11. Implement `calculateDirectorySizeAsync`

### Phase 4: Error Variants
11. Implement `validateDirectoryAccessThrowing`

### Phase 5: Testing
12. Write comprehensive unit tests
13. Write integration tests
14. Test edge cases

### Phase 6: Documentation
15. Add detailed documentation to all functions
16. Add usage examples
17. Update Future Enhancements section

---

## Open Questions

1. **Timeout for network volumes**: Should we add timeout parameters?
   - **Decision**: Defer to future enhancement, document current behavior

2. **Circular symlink detection**: How to handle in `calculateDirectorySize`?
   - **Decision**: Track visited inodes, skip if already visited

3. **Progress reporting**: Should `calculateDirectorySizeAsync` support progress?
   - **Decision**: Defer to future enhancement

4. **Caching**: Should we cache permission checks?
   - **Decision**: No caching initially, can be added later if needed

---

## Future Enhancements

### Potential Additions (Post-v6.0.0)

1. **Unix-style permissions** (for debugging):
   - `checkUnixDirectoryPermissions()` - Full owner/group/other breakdown
   - macOS only, less useful in sandboxed apps

2. **Progress reporting**:
   - `calculateDirectorySizeAsync` with progress callback

3. **Timeout support**:
   - Timeout parameters for network volume operations

4. **Caching**:
   - Cache permission checks for frequently-accessed directories

5. **Batch operations**:
   - Validate multiple directories at once

---

## Approval Checklist

- [ ] Type definitions reviewed and approved
- [ ] Function signatures reviewed and approved
- [ ] Error handling strategy approved
- [ ] Edge cases documented
- [ ] Security considerations addressed
- [ ] Performance characteristics documented
- [ ] Testing requirements defined
- [ ] Implementation plan approved
- [ ] Open questions resolved

---

**Document Status**: Ready for Review  
**Last Updated**: [Current Date]  
**Next Steps**: Review and approval before implementation
