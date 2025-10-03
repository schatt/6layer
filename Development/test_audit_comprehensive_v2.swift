#!/usr/bin/env swift

import Foundation

// Comprehensive Test Audit Script v2
// Analyzes every test file and function against 5 criteria
// PLUS identifies all actual framework classes that should be tested

struct TestFunction {
    let name: String
    let lineNumber: Int
    let hasBusinessLogic: Bool
    let hasPlatformTesting: Bool
    let hasMockTesting: Bool
    let hasGenericTests: Bool
    let hasDocumentation: Bool
}

struct TestFileAudit {
    let filename: String
    let hasFileDocumentation: Bool
    let functions: [TestFunction]
    let hasHardcodedArrays: Bool
    let hasCommentedTests: Bool
    let totalFunctions: Int
    let businessLogicFunctions: Int
    let platformTestingFunctions: Int
    let mockTestingFunctions: Int
    let genericTestFunctions: Int
    let documentedFunctions: Int
}

struct FrameworkClass {
    let name: String
    let file: String
    let type: String // "class" or "struct"
    let hasTestFile: Bool
    let testFileName: String?
}

func findFrameworkClasses() -> [FrameworkClass] {
    var classes: [FrameworkClass] = []
    
    let fileManager = FileManager.default
    let frameworkPath = "Framework/Sources"
    
    guard let enumerator = fileManager.enumerator(atPath: frameworkPath) else {
        return classes
    }
    
    for case let file as String in enumerator {
        if file.hasSuffix(".swift") {
            let fullPath = "\(frameworkPath)/\(file)"
            do {
                let content = try String(contentsOfFile: fullPath)
                let lines = content.components(separatedBy: .newlines)
                
                for (index, line) in lines.enumerated() {
                    // Look for public class and struct declarations
                    if line.contains("public class ") && line.contains(":") {
                        let className = extractClassName(from: line, type: "class")
                        if let className = className {
                            classes.append(FrameworkClass(
                                name: className,
                                file: file,
                                type: "class",
                                hasTestFile: false,
                                testFileName: nil
                            ))
                        }
                    } else if line.contains("public struct ") && line.contains(":") && !line.contains("View") {
                        let structName = extractClassName(from: line, type: "struct")
                        if let structName = structName {
                            classes.append(FrameworkClass(
                                name: structName,
                                file: file,
                                type: "struct",
                                hasTestFile: false,
                                testFileName: nil
                            ))
                        }
                    }
                }
            } catch {
                // Skip files that can't be read
                continue
            }
        }
    }
    
    return classes
}

func extractClassName(from line: String, type: String) -> String? {
    let pattern = "public \(type) ([A-Za-z0-9_]+)"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: line.utf16.count)
    
    if let match = regex?.firstMatch(in: line, options: [], range: range) {
        if let nameRange = Range(match.range(at: 1), in: line) {
            return String(line[nameRange])
        }
    }
    
    return nil
}

func findTestFiles() -> [String] {
    var testFiles: [String] = []
    let fileManager = FileManager.default
    let testPath = "Development/Tests/SixLayerFrameworkTests"
    
    guard let enumerator = fileManager.enumerator(atPath: testPath) else {
        return testFiles
    }
    
    for case let file as String in enumerator {
        if file.hasSuffix("Tests.swift") {
            testFiles.append(file)
        }
    }
    
    return testFiles
}

func analyzeTestFile(at path: String) -> TestFileAudit {
    let filename = URL(fileURLWithPath: path).lastPathComponent
    var functions: [TestFunction] = []
    var hasFileDocumentation = false
    var hasHardcodedArrays = false
    var hasCommentedTests = false
    
    do {
        let content = try String(contentsOfFile: path)
        let lines = content.components(separatedBy: .newlines)
        
        // Check for file-level documentation
        hasFileDocumentation = content.contains("BUSINESS PURPOSE:") && 
                              content.contains("TESTING SCOPE:") && 
                              content.contains("METHODOLOGY:")
        
        // Check for hardcoded arrays
        hasHardcodedArrays = content.contains("[.iOS, .macOS, .watchOS, .tvOS, .visionOS]")
        
        // Check for commented tests
        hasCommentedTests = content.contains("// func test") || content.contains("/* func test")
        
        // Find test functions
        for (index, line) in lines.enumerated() {
            if line.contains("func test") && line.contains("()") {
                let functionName = extractFunctionName(from: line)
                let hasBusinessLogic = hasBusinessLogicPatterns(in: content, functionName: functionName)
                let hasPlatformTesting = hasPlatformTestingPatterns(in: content, functionName: functionName)
                let hasMockTesting = hasMockTestingPatterns(in: content, functionName: functionName)
                let hasGenericTests = hasGenericTestPatterns(in: content, functionName: functionName)
                let hasDocumentation = hasFunctionDocumentation(in: content, functionName: functionName)
                
                functions.append(TestFunction(
                    name: functionName,
                    lineNumber: index + 1,
                    hasBusinessLogic: hasBusinessLogic,
                    hasPlatformTesting: hasPlatformTesting,
                    hasMockTesting: hasMockTesting,
                    hasGenericTests: hasGenericTests,
                    hasDocumentation: hasDocumentation
                ))
            }
        }
    } catch {
        print("Error reading file \(path): \(error)")
    }
    
    let totalFunctions = functions.count
    let businessLogicFunctions = functions.filter { $0.hasBusinessLogic }.count
    let platformTestingFunctions = functions.filter { $0.hasPlatformTesting }.count
    let mockTestingFunctions = functions.filter { $0.hasMockTesting }.count
    let genericTestFunctions = functions.filter { $0.hasGenericTests }.count
    let documentedFunctions = functions.filter { $0.hasDocumentation }.count
    
    return TestFileAudit(
        filename: filename,
        hasFileDocumentation: hasFileDocumentation,
        functions: functions,
        hasHardcodedArrays: hasHardcodedArrays,
        hasCommentedTests: hasCommentedTests,
        totalFunctions: totalFunctions,
        businessLogicFunctions: businessLogicFunctions,
        platformTestingFunctions: platformTestingFunctions,
        mockTestingFunctions: mockTestingFunctions,
        genericTestFunctions: genericTestFunctions,
        documentedFunctions: documentedFunctions
    )
}

func extractFunctionName(from line: String) -> String {
    let pattern = "func (test[A-Za-z0-9_]*)"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: line.utf16.count)
    
    if let match = regex?.firstMatch(in: line, options: [], range: range) {
        if let nameRange = Range(match.range(at: 1), in: line) {
            return String(line[nameRange])
        }
    }
    
    return "unknown"
}

func hasBusinessLogicPatterns(in content: String, functionName: String) -> Bool {
    let patterns = [
        "switch.*case",
        "if.*else",
        "XCTAssertEqual",
        "XCTAssertTrue",
        "XCTAssertFalse",
        "XCTAssertGreaterThan",
        "XCTAssertLessThan",
        "XCTAssertNotEqual"
    ]
    
    return patterns.contains { pattern in
        content.range(of: pattern, options: .regularExpression) != nil
    }
}

func hasPlatformTestingPatterns(in content: String, functionName: String) -> Bool {
    return content.contains("switch") && 
           (content.contains("case .iOS") || content.contains("case .macOS") || 
            content.contains("case .watchOS") || content.contains("case .tvOS") || 
            content.contains("case .visionOS"))
}

func hasMockTestingPatterns(in content: String, functionName: String) -> Bool {
    return content.contains("setTestPlatform") || content.contains("RuntimeCapabilityDetection")
}

func hasGenericTestPatterns(in content: String, functionName: String) -> Bool {
    return content.contains("XCTAssertNotNil") && !content.contains("XCTAssertEqual") && 
           !content.contains("XCTAssertTrue") && !content.contains("XCTAssertFalse")
}

func hasFunctionDocumentation(in content: String, functionName: String) -> Bool {
    // Look for documentation comments before the function
    let lines = content.components(separatedBy: .newlines)
    for (index, line) in lines.enumerated() {
        if line.contains("func \(functionName)") {
            // Check previous lines for documentation
            for i in max(0, index - 5)..<index {
                if lines[i].contains("///") || lines[i].contains("/**") {
                    return true
                }
            }
            break
        }
    }
    return false
}

func generateReport() {
    print("🔍 Starting comprehensive test audit...")
    
    // Find all framework classes
    let frameworkClasses = findFrameworkClasses()
    print("📋 Found \(frameworkClasses.count) framework classes/structs")
    
    // Find all test files
    let testFiles = findTestFiles()
    print("📋 Found \(testFiles.count) test files")
    
    // Analyze each test file
    var audits: [TestFileAudit] = []
    for testFile in testFiles {
        let path = "Development/Tests/SixLayerFrameworkTests/\(testFile)"
        let audit = analyzeTestFile(at: path)
        audits.append(audit)
    }
    
    // Match test files to framework classes
    var matchedClasses = frameworkClasses
    for (index, classInfo) in matchedClasses.enumerated() {
        let testFileName = "\(classInfo.name)Tests.swift"
        if testFiles.contains(testFileName) {
            matchedClasses[index] = FrameworkClass(
                name: classInfo.name,
                file: classInfo.file,
                type: classInfo.type,
                hasTestFile: true,
                testFileName: testFileName
            )
        }
    }
    
    // Generate report
    let report = generateReportContent(audits: audits, frameworkClasses: matchedClasses)
    
    do {
        try report.write(toFile: "Development/COMPREHENSIVE_TEST_AUDIT_V2.md", 
                        atomically: true, encoding: .utf8)
        print("✅ Comprehensive test audit completed!")
        print("📊 Report written to: Development/COMPREHENSIVE_TEST_AUDIT_V2.md")
        print("📈 Total files audited: \(audits.count)")
        print("📈 Total framework classes: \(frameworkClasses.count)")
    } catch {
        print("❌ Error writing report: \(error)")
    }
}

func generateReportContent(audits: [TestFileAudit], frameworkClasses: [FrameworkClass]) -> String {
    var report = ""
    
    // Header
    report += "# COMPREHENSIVE TEST AUDIT REPORT V2\n"
    report += "Generated: \(Date())\n\n"
    
    // Audit criteria
    report += "## AUDIT CRITERIA\n"
    report += "1. **File Documentation**: Has BUSINESS PURPOSE, TESTING SCOPE, METHODOLOGY headers\n"
    report += "2. **Business Logic Testing**: Tests actual behavior, not just existence\n"
    report += "3. **Platform Testing**: Tests platform-specific behavior with switch statements\n"
    report += "4. **Mock Testing**: Uses setTestPlatform() to test non-macOS platforms\n"
    report += "5. **No Generic Tests**: Avoids XCTAssertNotNil without business logic\n\n"
    
    // Summary statistics
    let totalFiles = audits.count
    let filesWithDocumentation = audits.filter { $0.hasFileDocumentation }.count
    let filesWithHardcodedArrays = audits.filter { $0.hasHardcodedArrays }.count
    let filesWithCommentedTests = audits.filter { $0.hasCommentedTests }.count
    
    let totalFunctions = audits.reduce(0) { $0 + $1.totalFunctions }
    let businessLogicFunctions = audits.reduce(0) { $0 + $1.businessLogicFunctions }
    let platformTestingFunctions = audits.reduce(0) { $0 + $1.platformTestingFunctions }
    let mockTestingFunctions = audits.reduce(0) { $0 + $1.mockTestingFunctions }
    let genericTestFunctions = audits.reduce(0) { $0 + $1.genericTestFunctions }
    let documentedFunctions = audits.reduce(0) { $0 + $1.documentedFunctions }
    
    report += "## SUMMARY STATISTICS\n"
    report += "Total Test Files: \(totalFiles)\n"
    report += "Files with Documentation: \(filesWithDocumentation)\n"
    report += "Files with Hardcoded Arrays: \(filesWithHardcodedArrays)\n"
    report += "Files with Commented Tests: \(filesWithCommentedTests)\n\n"
    
    report += "Total Test Functions: \(totalFunctions)\n"
    report += "Functions with Business Logic: \(businessLogicFunctions)\n"
    report += "Functions with Platform Testing: \(platformTestingFunctions)\n"
    report += "Functions with Mock Testing: \(mockTestingFunctions)\n"
    report += "Functions with Generic Tests: \(genericTestFunctions)\n"
    report += "Functions with Documentation: \(documentedFunctions)\n\n"
    
    // Framework classes analysis
    let classesWithTests = frameworkClasses.filter { $0.hasTestFile }.count
    let classesWithoutTests = frameworkClasses.filter { !$0.hasTestFile }.count
    
    report += "## FRAMEWORK CLASSES ANALYSIS\n"
    report += "Total Framework Classes/Structs: \(frameworkClasses.count)\n"
    report += "Classes with Test Files: \(classesWithTests)\n"
    report += "Classes without Test Files: \(classesWithoutTests)\n\n"
    
    // Classes that need test files
    report += "### CLASSES NEEDING TEST FILES\n"
    for classInfo in frameworkClasses.filter({ !$0.hasTestFile }) {
        report += "- **\(classInfo.name)** (\(classInfo.type)) - in \(classInfo.file)\n"
    }
    report += "\n"
    
    // Classes that have test files
    report += "### CLASSES WITH TEST FILES\n"
    for classInfo in frameworkClasses.filter({ $0.hasTestFile }) {
        report += "- **\(classInfo.name)** (\(classInfo.type)) - tested in \(classInfo.testFileName ?? "unknown")\n"
    }
    report += "\n"
    
    // Detailed file audit
    report += "## DETAILED FILE AUDIT\n"
    for audit in audits.sorted(by: { $0.filename < $1.filename }) {
        report += "### \(audit.filename)\n"
        report += "- **File Documentation**: \(audit.hasFileDocumentation ? "✅" : "❌")\n"
        report += "- **Hardcoded Arrays**: \(audit.hasHardcodedArrays ? "✅" : "❌")\n"
        report += "- **Commented Tests**: \(audit.hasCommentedTests ? "✅" : "❌")\n"
        report += "- **Total Functions**: \(audit.totalFunctions)\n"
        report += "- **Business Logic Functions**: \(audit.businessLogicFunctions)/\(audit.totalFunctions)\n"
        report += "- **Platform Testing Functions**: \(audit.platformTestingFunctions)/\(audit.totalFunctions)\n"
        report += "- **Mock Testing Functions**: \(audit.mockTestingFunctions)/\(audit.totalFunctions)\n"
        report += "- **Generic Test Functions**: \(audit.genericTestFunctions)/\(audit.totalFunctions)\n"
        report += "- **Documented Functions**: \(audit.documentedFunctions)/\(audit.totalFunctions)\n"
        
        for function in audit.functions {
            report += "  - **\(function.name)** (Line \(function.lineNumber))\n"
            report += "    - Business Logic: \(function.hasBusinessLogic ? "✅" : "❌")\n"
            report += "    - Platform Testing: \(function.hasPlatformTesting ? "✅" : "❌")\n"
            report += "    - Mock Testing: \(function.hasMockTesting ? "✅" : "❌")\n"
            report += "    - Generic Tests: \(function.hasGenericTests ? "✅" : "❌")\n"
            report += "    - Documentation: \(function.hasDocumentation ? "✅" : "❌")\n"
        }
        report += "\n"
    }
    
    return report
}

// Run the audit
generateReport()







