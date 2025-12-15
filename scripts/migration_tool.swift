#!/usr/bin/env swift
//
// Migration Tool for SixLayer Framework
//
// This tool helps detect deprecated API usage and suggests migrations
// for safer framework upgrades.
//
// Usage:
//   swift run migration_tool.swift [file_or_directory]
//
// Example:
//   swift run migration_tool.swift MyApp/Sources/
//   swift run migration_tool.swift SpecificFile.swift

import Foundation

/// Represents a migration issue found in code
struct MigrationIssue: Sendable {
    let deprecatedAPI: String
    let replacement: String
    let reason: String
    let lineNumber: Int?
    let filePath: String
}

/// Main migration tool class
class MigrationTool {

    /// Detect accessibility API migrations in the given code
    static func detectAccessibilityAPIMigrations(in code: String, filePath: String = "inline") -> [MigrationIssue] {
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

            // Check for .named() calls which might need updating
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
    static func suggestAccessibilityAPIMigration(for deprecatedCall: String) -> (replacement: String, reason: String) {
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
    static func scanForMigrations(at path: String) -> [MigrationIssue] {
        var allIssues: [MigrationIssue] = []

        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            print("Error: Path does not exist: \(path)")
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

    /// Print migration issues in a readable format
    static func printMigrationReport(_ issues: [MigrationIssue]) {
        if issues.isEmpty {
            print("✅ No migration issues found!")
            return
        }

        print("🔍 Migration Issues Found: \(issues.count)")
        print("")

        for issue in issues {
            if let lineNumber = issue.lineNumber {
                print("📍 \(issue.filePath):\(lineNumber)")
            } else {
                print("📍 \(issue.filePath)")
            }
            print("   ❌ \(issue.deprecatedAPI)")
            print("   ✅ \(issue.replacement)")
            print("   💡 \(issue.reason)")
            print("")
        }

        print("💡 Run this tool after making changes to verify all issues are resolved.")
    }
}

// MARK: - Main Script Execution

// Check if we're being run as a script
if CommandLine.arguments.count > 1 {
    let path = CommandLine.arguments[1]
    let issues = MigrationTool.scanForMigrations(at: path)
    MigrationTool.printMigrationReport(issues)
} else {
    print("SixLayer Framework Migration Tool")
    print("")
    print("Usage: swift run migration_tool.swift [file_or_directory]")
    print("")
    print("Examples:")
    print("  swift run migration_tool.swift MyApp/Sources/")
    print("  swift run migration_tool.swift SpecificFile.swift")
    print("")
    print("This tool detects deprecated API usage and suggests migrations")
    print("for safer framework upgrades.")
}