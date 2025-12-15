//
// Migration Tool for SixLayer Framework
//
// This module provides migration and change-management tooling to help
// consumers safely upgrade between major/minor SixLayer versions.
//

import Foundation

/// Represents a migration issue found in code
public struct MigrationIssue: Sendable, Equatable {
    /// The deprecated API that was found
    public let deprecatedAPI: String
    /// The suggested replacement
    public let replacement: String
    /// Reason for the migration
    public let reason: String
    /// Line number where the issue was found (optional)
    public let lineNumber: Int?
    /// File path where the issue was found
    public let filePath: String

    public init(deprecatedAPI: String, replacement: String, reason: String, lineNumber: Int? = nil, filePath: String) {
        self.deprecatedAPI = deprecatedAPI
        self.replacement = replacement
        self.reason = reason
        self.lineNumber = lineNumber
        self.filePath = filePath
    }
}

/// Main migration tool class for detecting and managing API migrations
public final class MigrationTool: Sendable {

    /// Detect accessibility API migrations in the given code
    public static func detectAccessibilityAPIMigrations(in code: String, filePath: String = "inline") -> [MigrationIssue] {
        var issues: [MigrationIssue] = []

        // Split code into lines for line number tracking
        let lines = code.components(separatedBy: .newlines)

        for (index, line) in lines.enumerated() {
            // Check for deprecated accessibility APIs
            if line.contains(".automaticAccessibilityIdentifiers()") {
                issues.append(MigrationIssue(
                    deprecatedAPI: ".automaticAccessibilityIdentifiers()",
                    replacement: ".automaticCompliance()",
                    reason: "Function renamed to include HIG compliance features",
                    lineNumber: index + 1,
                    filePath: filePath
                ))
            }

            if line.contains(".enableGlobalAutomaticAccessibilityIdentifiers()") {
                issues.append(MigrationIssue(
                    deprecatedAPI: ".enableGlobalAutomaticAccessibilityIdentifiers()",
                    replacement: ".enableGlobalAutomaticCompliance()",
                    reason: "Function renamed to include HIG compliance features",
                    lineNumber: index + 1,
                    filePath: filePath
                ))
            }

            // Check for .named() calls which might need updating context
            if line.contains(".named(") && !line.contains(".automaticCompliance(named:") {
                // This is a more complex case - we need to check if it's part of a deprecated chain
                // For now, we'll flag it for manual review
                issues.append(MigrationIssue(
                    deprecatedAPI: ".named() modifier",
                    replacement: "Review if part of deprecated accessibility chain",
                    reason: "Check if this is part of a deprecated accessibility API chain",
                    lineNumber: index + 1,
                    filePath: filePath
                ))
            }
        }

        return issues
    }

    /// Suggest migration for a specific deprecated accessibility API
    public static func suggestAccessibilityAPIMigration(for deprecatedCall: String) -> (replacement: String, reason: String) {
        switch deprecatedCall {
        case ".automaticAccessibilityIdentifiers()":
            return (".automaticCompliance()", "Function renamed to include HIG compliance features")
        case ".enableGlobalAutomaticAccessibilityIdentifiers()":
            return (".enableGlobalAutomaticCompliance()", "Function renamed to include HIG compliance features")
        default:
            return ("Manual review required", "This API may need manual migration review")
        }
    }

    /// Scan a file or directory for migration issues
    /// - Parameter path: File or directory path to scan
    /// - Returns: Array of migration issues found
    public static func scanForMigrations(at path: String) -> [MigrationIssue] {
        var allIssues: [MigrationIssue] = []

        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            return []
        }

        let url = URL(fileURLWithPath: path)
        var isDirectory: ObjCBool = false

        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                // Scan directory recursively
                guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil) else {
                    return []
                }

                for case let fileURL as URL in enumerator {
                    if fileURL.pathExtension == "swift" {
                        if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                            let issues = detectAccessibilityAPIMigrations(in: content, filePath: fileURL.path)
                            allIssues.append(contentsOf: issues)
                        }
                    }
                }
            } else {
                // Scan single file
                if let content = try? String(contentsOf: url, encoding: .utf8) {
                    let issues = detectAccessibilityAPIMigrations(in: content, filePath: url.path)
                    allIssues.append(contentsOf: issues)
                }
            }
        }

        return allIssues
    }
}