//
//  PlatformFileSystemUtilitiesTests.swift
//  SixLayerFramework
//
//  Tests for directory validation and path utilities
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("Platform File System Utilities Tests")
struct PlatformFileSystemUtilitiesTests {
    
    // MARK: - DirectoryPermissions Tests
    
    @Test func testDirectoryPermissionsInitialization() {
        let permissions = DirectoryPermissions(
            readable: true,
            writable: false,
            executable: true,
            exists: true,
            isFile: false
        )
        
        #expect(permissions.readable == true)
        #expect(permissions.writable == false)
        #expect(permissions.executable == true)
        #expect(permissions.exists == true)
        #expect(permissions.isFile == false)
        #expect(permissions.accessible == true)
        #expect(permissions.canRead == true)
        #expect(permissions.canWrite == false)
        #expect(permissions.fullyAccessible == false)
    }
    
    @Test func testDirectoryPermissionsComputedProperties() {
        // Test accessible property
        let existsNotFile = DirectoryPermissions(
            readable: true,
            writable: true,
            executable: true,
            exists: true,
            isFile: false
        )
        #expect(existsNotFile.accessible == true)
        
        let isFile = DirectoryPermissions(
            readable: true,
            writable: true,
            executable: true,
            exists: true,
            isFile: true
        )
        #expect(isFile.accessible == false)
        
        let notExists = DirectoryPermissions(
            readable: false,
            writable: false,
            executable: false,
            exists: false,
            isFile: false
        )
        #expect(notExists.accessible == false)
    }
    
    // MARK: - DirectoryValidationError Tests
    
    @Test func testDirectoryValidationErrorDescriptions() {
        #expect(DirectoryValidationError.doesNotExist.errorDescription != nil)
        #expect(DirectoryValidationError.notADirectory.errorDescription != nil)
        #expect(DirectoryValidationError.notReadable.errorDescription != nil)
        #expect(DirectoryValidationError.notWritable.errorDescription != nil)
        #expect(DirectoryValidationError.notExecutable.errorDescription != nil)
        #expect(DirectoryValidationError.networkVolumeUnavailable.errorDescription != nil)
        #expect(DirectoryValidationError.networkVolumeSlow.errorDescription != nil)
        #expect(DirectoryValidationError.invalidPath.errorDescription != nil)
        #expect(DirectoryValidationError.securityScopedAccessRequired.errorDescription != nil)
    }
    
    // MARK: - validateDirectoryAccess Tests
    
    @Test func testValidateDirectoryAccessWithExistingDirectory() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent("test_validate_\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        let result = validateDirectoryAccess(at: testDir)
        #expect(result == true)
    }
    
    @Test func testValidateDirectoryAccessWithNonExistentPath() {
        let nonExistent = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID().uuidString)")
        let result = validateDirectoryAccess(at: nonExistent)
        #expect(result == false)
    }
    
    @Test func testValidateDirectoryAccessWithFile() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_file_\(UUID().uuidString).txt")
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        try "test".write(to: testFile, atomically: true, encoding: .utf8)
        
        let result = validateDirectoryAccess(at: testFile)
        #expect(result == false) // File, not directory
    }
    
    // MARK: - validateDirectoryAccessThrowing Tests
    
    @Test func testValidateDirectoryAccessThrowingWithExistingDirectory() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent("test_validate_throw_\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        let result = try validateDirectoryAccessThrowing(at: testDir)
        #expect(result == true)
    }
    
    @Test func testValidateDirectoryAccessThrowingWithNonExistentPath() throws {
        let nonExistent = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID().uuidString)")
        
        do {
            _ = try validateDirectoryAccessThrowing(at: nonExistent)
            #expect(Bool(false), "Should have thrown doesNotExist error")
        } catch DirectoryValidationError.doesNotExist {
            // Expected
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
    
    @Test func testValidateDirectoryAccessThrowingWithFile() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_file_\(UUID().uuidString).txt")
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        try "test".write(to: testFile, atomically: true, encoding: .utf8)
        
        do {
            _ = try validateDirectoryAccessThrowing(at: testFile)
            #expect(Bool(false), "Should have thrown notADirectory error")
        } catch DirectoryValidationError.notADirectory {
            // Expected
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }
    
    // MARK: - checkDirectoryPermissions Tests
    
    @Test func testCheckDirectoryPermissionsWithExistingDirectory() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent("test_perms_\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        let permissions = checkDirectoryPermissions(at: testDir)
        #expect(permissions.exists == true)
        #expect(permissions.isFile == false)
        #expect(permissions.accessible == true)
        // Permissions may vary, but should be consistent
    }
    
    @Test func testCheckDirectoryPermissionsWithNonExistentPath() {
        let nonExistent = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID().uuidString)")
        let permissions = checkDirectoryPermissions(at: nonExistent)
        #expect(permissions.exists == false)
        #expect(permissions.readable == false)
        #expect(permissions.writable == false)
        #expect(permissions.executable == false)
    }
    
    @Test func testCheckDirectoryPermissionsWithFile() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_file_\(UUID().uuidString).txt")
        
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        
        try "test".write(to: testFile, atomically: true, encoding: .utf8)
        
        let permissions = checkDirectoryPermissions(at: testFile)
        #expect(permissions.exists == true)
        #expect(permissions.isFile == true)
        #expect(permissions.accessible == false)
    }
    
    // MARK: - getAvailableDiskSpace Tests
    
    @Test func testGetAvailableDiskSpace() {
        let tempDir = FileManager.default.temporaryDirectory
        if let space = getAvailableDiskSpace(at: tempDir) {
            #expect(space >= 0)
        } else {
            // May return nil on some platforms/volumes - that's acceptable
        }
    }
    
    @Test func testGetAvailableDiskSpaceWithNonExistentPath() {
        let nonExistent = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID().uuidString)")
        // Should still work - uses volume of parent
        let space = getAvailableDiskSpace(at: nonExistent)
        // May return nil or a value - both are acceptable
    }
    
    // MARK: - hasEnoughDiskSpace Tests
    
    @Test func testHasEnoughDiskSpaceWithZeroBytes() {
        let tempDir = FileManager.default.temporaryDirectory
        let result = hasEnoughDiskSpace(at: tempDir, requiredBytes: 0)
        #expect(result == true) // Zero bytes always available
    }
    
    @Test func testHasEnoughDiskSpaceWithNegativeBytes() {
        let tempDir = FileManager.default.temporaryDirectory
        let result = hasEnoughDiskSpace(at: tempDir, requiredBytes: -100)
        #expect(result == true) // Negative bytes means no space needed
    }
    
    @Test func testHasEnoughDiskSpaceWithLargeRequirement() {
        let tempDir = FileManager.default.temporaryDirectory
        // Request an impossibly large amount
        let result = hasEnoughDiskSpace(at: tempDir, requiredBytes: Int64.max)
        // Should return false (either not enough space or can't determine)
        #expect(result == false)
    }
    
    // MARK: - safeAppendPathComponent Tests
    
    @Test func testSafeAppendPathComponentWithValidComponent() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "test_component")
        #expect(result != nil)
        #expect(result?.lastPathComponent == "test_component")
    }
    
    @Test func testSafeAppendPathComponentWithEmptyString() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "")
        #expect(result == nil)
    }
    
    @Test func testSafeAppendPathComponentWithWhitespaceOnly() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "   ")
        #expect(result == nil)
    }
    
    @Test func testSafeAppendPathComponentWithPathSeparator() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "folder/file")
        #expect(result == nil) // Contains /
    }
    
    @Test func testSafeAppendPathComponentWithBackslash() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "folder\\file")
        #expect(result == nil) // Contains \
    }
    
    @Test func testSafeAppendPathComponentWithPathTraversal() {
        let baseURL = FileManager.default.temporaryDirectory
        let result1 = safeAppendPathComponent(baseURL, "..")
        #expect(result1 == nil)
        
        let result2 = safeAppendPathComponent(baseURL, ".")
        #expect(result2 == nil)
    }
    
    @Test func testSafeAppendPathComponentWithLeadingWhitespace() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "  component")
        #expect(result == nil) // Leading whitespace
    }
    
    @Test func testSafeAppendPathComponentWithTrailingWhitespace() {
        let baseURL = FileManager.default.temporaryDirectory
        let result = safeAppendPathComponent(baseURL, "component  ")
        #expect(result == nil) // Trailing whitespace
    }
    
    // MARK: - calculateDirectorySize Tests
    
    @Test func testCalculateDirectorySizeWithEmptyDirectory() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent("test_size_empty_\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        if let size = calculateDirectorySize(at: testDir) {
            #expect(size == 0) // Empty directory should be 0
        } else {
            // May return nil in some cases
        }
    }
    
    @Test func testCalculateDirectorySizeWithFiles() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent("test_size_files_\(UUID().uuidString)")
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        // Create a test file
        let testFile = testDir.appendingPathComponent("test.txt")
        let testContent = "Hello, World!"
        try testContent.write(to: testFile, atomically: true, encoding: .utf8)
        
        if let size = calculateDirectorySize(at: testDir) {
            #expect(size >= Int64(testContent.utf8.count))
        } else {
            // May return nil in some cases
        }
    }
    
    @Test func testCalculateDirectorySizeWithNonExistentDirectory() {
        let nonExistent = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID().uuidString)")
        let size = calculateDirectorySize(at: nonExistent)
        #expect(size == nil)
    }
    
    // MARK: - sanitizePath Tests
    
    @Test func testSanitizePathWithPathTraversal() {
        let result = sanitizePath("../../../etc/passwd")
        #expect(result == "etc/passwd")
    }
    
    @Test func testSanitizePathWithNormalPath() {
        let result = sanitizePath("path/to/file")
        #expect(result == "path/to/file")
    }
    
    @Test func testSanitizePathWithBackslashes() {
        let result = sanitizePath("C:\\Users\\Name")
        #expect(result == "C:/Users/Name")
    }
    
    @Test func testSanitizePathWithDoubleSlashes() {
        let result = sanitizePath("path//with//slashes")
        #expect(result == "path/with/slashes")
    }
    
    @Test func testSanitizePathWithZeroWidthSpace() {
        let result = sanitizePath("file\u{200B}name")
        #expect(result == "filename")
    }
    
    @Test func testSanitizePathWithControlCharacter() {
        let result = sanitizePath("file\u{0001}name")
        #expect(result == "filename")
    }
    
    @Test func testSanitizePathWithTrailingDot() {
        let result = sanitizePath("file.")
        #expect(result == "file")
    }
    
    @Test func testSanitizePathWithTrailingSpace() {
        let result = sanitizePath("file ")
        #expect(result == "file")
    }
    
    @Test func testSanitizePathWithHiddenFile() {
        let result = sanitizePath(".hidden")
        #expect(result == ".hidden") // Should preserve leading dot
    }
    
    @Test func testSanitizePathWithAbsolutePath() {
        let result = sanitizePath("/absolute/path")
        #expect(result.hasPrefix("/"))
    }
    
    // MARK: - sanitizeFilename Tests
    
    @Test func testSanitizeFilenameWithValidName() {
        let result = sanitizeFilename("test_file.txt")
        #expect(result == "test_file.txt")
    }
    
    @Test func testSanitizeFilenameWithPathSeparator() {
        let result = sanitizeFilename("folder/file.txt")
        #expect(result == "folder-file.txt") // Separator replaced
    }
    
    @Test func testSanitizeFilenameWithColon() {
        #if os(macOS)
        let result = sanitizeFilename("file:name.txt")
        #expect(result == "file-name.txt") // Colon replaced on macOS
        #endif
    }
    
    @Test func testSanitizeFilenameWithZeroWidthSpace() {
        let result = sanitizeFilename("file\u{200B}name.txt")
        #expect(result == "filename.txt")
    }
    
    @Test func testSanitizeFilenameWithTrailingDot() {
        let result = sanitizeFilename("file.")
        #expect(result == "file")
    }
    
    @Test func testSanitizeFilenameWithEmptyString() {
        let result = sanitizeFilename("")
        #expect(result == "_") // Safe default
    }
    
    @Test func testSanitizeFilenameWithMaxLength() {
        let longName = String(repeating: "a", count: 300)
        let result = sanitizeFilename(longName, maxLength: 255)
        #expect(result.count == 255)
    }
    
    @Test func testSanitizeFilenameWithCustomReplacement() {
        let result = sanitizeFilename("folder/file.txt", replacementCharacter: "_")
        #expect(result == "folder_file.txt")
    }
}
