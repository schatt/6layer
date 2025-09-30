#!/usr/bin/env swift

import Foundation

// Comprehensive Test Audit Script
// Analyzes every test file and function against 5 criteria

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
        hasCommentedTests = content.contains("// func test") || 
                           content.contains("/* func test") ||
                           content.contains(".disabled") ||
                           content.contains("_DISABLED")
        
        // Find all test functions
        for (index, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            // Look for test function definitions
            if trimmedLine.hasPrefix("func test") && trimmedLine.contains("()") {
                let functionName = extractFunctionName(from: trimmedLine)
                let lineNumber = index + 1
                
                // Analyze the function content
                let functionContent = extractFunctionContent(from: lines, startingAt: index)
                
                let hasBusinessLogic = analyzeBusinessLogic(in: functionContent)
                let hasPlatformTesting = analyzePlatformTesting(in: functionContent)
                let hasMockTesting = analyzeMockTesting(in: functionContent)
                let hasGenericTests = analyzeGenericTests(in: functionContent)
                let hasDocumentation = analyzeFunctionDocumentation(in: functionContent)
                
                let testFunction = TestFunction(
                    name: functionName,
                    lineNumber: lineNumber,
                    hasBusinessLogic: hasBusinessLogic,
                    hasPlatformTesting: hasPlatformTesting,
                    hasMockTesting: hasMockTesting,
                    hasGenericTests: hasGenericTests,
                    hasDocumentation: hasDocumentation
                )
                
                functions.append(testFunction)
            }
        }
        
        // Calculate statistics
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
        
    } catch {
        print("Error reading file \(path): \(error)")
        return TestFileAudit(
            filename: filename,
            hasFileDocumentation: false,
            functions: [],
            hasHardcodedArrays: false,
            hasCommentedTests: false,
            totalFunctions: 0,
            businessLogicFunctions: 0,
            platformTestingFunctions: 0,
            mockTestingFunctions: 0,
            genericTestFunctions: 0,
            documentedFunctions: 0
        )
    }
}

func extractFunctionName(from line: String) -> String {
    // Extract function name from "func testSomething()" -> "testSomething"
    let components = line.components(separatedBy: "(")
    if let funcPart = components.first {
        let funcComponents = funcPart.components(separatedBy: " ")
        if funcComponents.count >= 2 {
            return funcComponents[1]
        }
    }
    return "unknown"
}

func extractFunctionContent(from lines: [String], startingAt index: Int) -> String {
    var content: [String] = []
    var braceCount = 0
    var foundOpeningBrace = false
    
    for i in index..<lines.count {
        let line = lines[i]
        content.append(line)
        
        // Count braces to find function end
        for char in line {
            if char == "{" {
                braceCount += 1
                foundOpeningBrace = true
            } else if char == "}" {
                braceCount -= 1
            }
        }
        
        // If we found opening brace and now have balanced braces, we're done
        if foundOpeningBrace && braceCount == 0 {
            break
        }
    }
    
    return content.joined(separator: "\n")
}

func analyzeBusinessLogic(in content: String) -> Bool {
    // Look for business logic patterns
    let hasSwitchStatement = content.contains("switch") && content.contains("case")
    let hasConditionalLogic = content.contains("if") && content.contains("else")
    let hasAssertions = content.contains("XCTAssert") && !content.contains("XCTAssertNotNil")
    let hasValidation = content.contains("validate") || content.contains("verify")
    let hasBehaviorTesting = content.contains("behavior") || content.contains("functionality")
    
    return hasSwitchStatement || hasConditionalLogic || (hasAssertions && hasValidation) || hasBehaviorTesting
}

func analyzePlatformTesting(in content: String) -> Bool {
    // Look for platform-specific testing
    let hasPlatformSwitch = content.contains("switch") && (content.contains(".iOS") || content.contains(".macOS") || content.contains(".watchOS") || content.contains(".tvOS") || content.contains(".visionOS"))
    let hasPlatformDetection = content.contains("Platform.current") || content.contains("Platform.")
    let hasPlatformSpecific = content.contains("platform") && (content.contains("iOS") || content.contains("macOS") || content.contains("watchOS") || content.contains("tvOS") || content.contains("visionOS"))
    
    return hasPlatformSwitch || hasPlatformDetection || hasPlatformSpecific
}

func analyzeMockTesting(in content: String) -> Bool {
    // Look for mock testing patterns
    let hasSetTestPlatform = content.contains("setTestPlatform")
    let hasMockConfig = content.contains("createMockPlatformConfig") || content.contains("MockPlatformConfig")
    let hasTestUtilities = content.contains("PlatformTestUtilities")
    let hasSimulation = content.contains("simulation") || content.contains("simulate")
    
    return hasSetTestPlatform || hasMockConfig || hasTestUtilities || hasSimulation
}

func analyzeGenericTests(in content: String) -> Bool {
    // Look for generic testing patterns (bad)
    let hasOnlyNotNil = content.contains("XCTAssertNotNil") && !content.contains("XCTAssertEqual") && !content.contains("XCTAssertTrue") && !content.contains("XCTAssertFalse")
    let hasOnlyExistence = content.contains("XCTAssertNotNil") && !content.contains("switch") && !content.contains("if")
    let hasNoBusinessLogic = !content.contains("switch") && !content.contains("if") && !content.contains("validate") && !content.contains("verify")
    
    return hasOnlyNotNil || hasOnlyExistence || hasNoBusinessLogic
}

func analyzeFunctionDocumentation(in content: String) -> Bool {
    // Look for function-level documentation
    let hasComment = content.contains("//") && (content.contains("Test") || content.contains("Given") || content.contains("When") || content.contains("Then"))
    let hasDocumentation = content.contains("///") || content.contains("/*")
    
    return hasComment || hasDocumentation
}

// Main execution
let testDirectory = "Development/Tests/SixLayerFrameworkTests"
let fileManager = FileManager.default

do {
    let testFiles = try fileManager.contentsOfDirectory(atPath: testDirectory)
        .filter { $0.hasSuffix(".swift") && !$0.contains("backup") }
        .sorted()
    
    var allAudits: [TestFileAudit] = []
    
    for file in testFiles {
        let fullPath = "\(testDirectory)/\(file)"
        let audit = analyzeTestFile(at: fullPath)
        allAudits.append(audit)
    }
    
    // Generate comprehensive report
    var report = """
# COMPREHENSIVE TEST AUDIT REPORT
Generated: \(Date())

## AUDIT CRITERIA
1. **File Documentation**: Has BUSINESS PURPOSE, TESTING SCOPE, METHODOLOGY headers
2. **Business Logic Testing**: Tests actual behavior, not just existence
3. **Platform Testing**: Tests platform-specific behavior with switch statements
4. **Mock Testing**: Uses setTestPlatform() to test non-macOS platforms
5. **No Generic Tests**: Avoids XCTAssertNotNil without business logic

## SUMMARY STATISTICS
Total Test Files: \(allAudits.count)
Files with Documentation: \(allAudits.filter { $0.hasFileDocumentation }.count)
Files with Hardcoded Arrays: \(allAudits.filter { $0.hasHardcodedArrays }.count)
Files with Commented Tests: \(allAudits.filter { $0.hasCommentedTests }.count)

Total Test Functions: \(allAudits.reduce(0) { $0 + $1.totalFunctions })
Functions with Business Logic: \(allAudits.reduce(0) { $0 + $1.businessLogicFunctions })
Functions with Platform Testing: \(allAudits.reduce(0) { $0 + $1.platformTestingFunctions })
Functions with Mock Testing: \(allAudits.reduce(0) { $0 + $1.mockTestingFunctions })
Functions with Generic Tests: \(allAudits.reduce(0) { $0 + $1.genericTestFunctions })
Functions with Documentation: \(allAudits.reduce(0) { $0 + $1.documentedFunctions })

## DETAILED FILE AUDIT

"""
    
    for audit in allAudits {
        report += """
### \(audit.filename)
- **File Documentation**: \(audit.hasFileDocumentation ? "✅" : "❌")
- **Hardcoded Arrays**: \(audit.hasHardcodedArrays ? "❌" : "✅")
- **Commented Tests**: \(audit.hasCommentedTests ? "❌" : "✅")
- **Total Functions**: \(audit.totalFunctions)
- **Business Logic Functions**: \(audit.businessLogicFunctions)/\(audit.totalFunctions)
- **Platform Testing Functions**: \(audit.platformTestingFunctions)/\(audit.totalFunctions)
- **Mock Testing Functions**: \(audit.mockTestingFunctions)/\(audit.totalFunctions)
- **Generic Test Functions**: \(audit.genericTestFunctions)/\(audit.totalFunctions)
- **Documented Functions**: \(audit.documentedFunctions)/\(audit.totalFunctions)

"""
        
        for function in audit.functions {
            report += """
  - **\(function.name)** (Line \(function.lineNumber))
    - Business Logic: \(function.hasBusinessLogic ? "✅" : "❌")
    - Platform Testing: \(function.hasPlatformTesting ? "✅" : "❌")
    - Mock Testing: \(function.hasMockTesting ? "✅" : "❌")
    - Generic Tests: \(function.hasGenericTests ? "❌" : "✅")
    - Documentation: \(function.hasDocumentation ? "✅" : "❌")

"""
        }
        
        report += "\n"
    }
    
    // Write report to file
    try report.write(toFile: "Development/COMPREHENSIVE_TEST_AUDIT.md", atomically: true, encoding: .utf8)
    
    print("✅ Comprehensive test audit completed!")
    print("📊 Report written to: Development/COMPREHENSIVE_TEST_AUDIT.md")
    print("📈 Total files audited: \(allAudits.count)")
    
} catch {
    print("❌ Error during audit: \(error)")
}



