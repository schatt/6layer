#!/usr/bin/env swift

import Foundation

// Test Audit Script for SixLayer Framework
// Analyzes test files to identify generic vs business logic testing patterns

struct TestFileAnalysis {
    let filename: String
    let hasBusinessLogic: Bool
    let hasGenericTests: Bool
    let hasHardcodedArrays: Bool
    let hasProperDocumentation: Bool
    let issues: [String]
    let recommendations: [String]
}

func analyzeTestFile(at path: String) -> TestFileAnalysis {
    let filename = URL(fileURLWithPath: path).lastPathComponent
    var issues: [String] = []
    var recommendations: [String] = []
    
    do {
        let content = try String(contentsOfFile: path)
        
        // Check for business logic patterns
        let hasBusinessLogic = content.contains("switch") && 
                              (content.contains("case") || content.contains("XCTAssert"))
        
        // Check for generic test patterns
        let hasGenericTests = content.contains("XCTAssertNotNil") && 
                             !content.contains("XCTAssertEqual") &&
                             !content.contains("XCTAssertTrue") &&
                             !content.contains("XCTAssertFalse")
        
        // Check for hardcoded arrays instead of .allCases
        let hasHardcodedArrays = content.contains("[") && 
                                content.contains("Platform.") && 
                                !content.contains(".allCases")
        
        // Check for proper documentation
        let hasProperDocumentation = content.contains("BUSINESS PURPOSE:") || 
                                   content.contains("TESTING SCOPE:") ||
                                   content.contains("METHODOLOGY:")
        
        // Identify specific issues
        if hasGenericTests {
            issues.append("Contains generic existence-only tests")
            recommendations.append("Replace XCTAssertNotNil with business logic assertions")
        }
        
        if hasHardcodedArrays {
            issues.append("Uses hardcoded arrays instead of .allCases")
            recommendations.append("Replace hardcoded arrays with enum.allCases")
        }
        
        if !hasProperDocumentation {
            issues.append("Missing business purpose documentation")
            recommendations.append("Add BUSINESS PURPOSE, TESTING SCOPE, and METHODOLOGY headers")
        }
        
        if !hasBusinessLogic {
            issues.append("No business logic testing detected")
            recommendations.append("Add switch statements testing actual behavior")
        }
        
        return TestFileAnalysis(
            filename: filename,
            hasBusinessLogic: hasBusinessLogic,
            hasGenericTests: hasGenericTests,
            hasHardcodedArrays: hasHardcodedArrays,
            hasProperDocumentation: hasProperDocumentation,
            issues: issues,
            recommendations: recommendations
        )
        
    } catch {
        return TestFileAnalysis(
            filename: filename,
            hasBusinessLogic: false,
            hasGenericTests: false,
            hasHardcodedArrays: false,
            hasProperDocumentation: false,
            issues: ["Error reading file: \(error)"],
            recommendations: ["Fix file access issues"]
        )
    }
}

func main() {
    let testDirectory = "Development/Tests/SixLayerFrameworkTests"
    let fileManager = FileManager.default
    
    guard let enumerator = fileManager.enumerator(atPath: testDirectory) else {
        print("Error: Could not enumerate test directory")
        return
    }
    
    var allFiles: [String] = []
    var analysisResults: [TestFileAnalysis] = []
    
    // Collect all Swift test files
    for case let file as String in enumerator {
        if file.hasSuffix(".swift") {
            allFiles.append(file)
        }
    }
    
    print("🔍 SixLayer Framework Test Audit")
    print("=================================")
    print("📊 Analyzing \(allFiles.count) test files...")
    print()
    
    // Analyze each file
    for file in allFiles.sorted() {
        let fullPath = "\(testDirectory)/\(file)"
        let analysis = analyzeTestFile(at: fullPath)
        analysisResults.append(analysis)
    }
    
    // Generate summary report
    let goodFiles = analysisResults.filter { $0.hasBusinessLogic && !$0.hasGenericTests && $0.hasProperDocumentation }
    let needsWorkFiles = analysisResults.filter { !$0.hasBusinessLogic || $0.hasGenericTests || !$0.hasProperDocumentation }
    let commentedOutFiles = analysisResults.filter { $0.filename.contains("InteractiveFormTests") || $0.filename.contains("FormFieldInteractionTests") }
    
    print("📈 AUDIT SUMMARY")
    print("================")
    print("✅ Good Files (Business Logic + Documentation): \(goodFiles.count)")
    print("⚠️  Needs Work: \(needsWorkFiles.count)")
    print("💬 Commented Out: \(commentedOutFiles.count)")
    print("📊 Total Files: \(analysisResults.count)")
    print()
    
    // Show files that need work
    if !needsWorkFiles.isEmpty {
        print("⚠️  FILES NEEDING WORK")
        print("=====================")
        for file in needsWorkFiles {
            print("📄 \(file.filename)")
            for issue in file.issues {
                print("   ❌ \(issue)")
            }
            for recommendation in file.recommendations {
                print("   💡 \(recommendation)")
            }
            print()
        }
    }
    
    // Show commented out files
    if !commentedOutFiles.isEmpty {
        print("💬 COMMENTED OUT FILES")
        print("=====================")
        for file in commentedOutFiles {
            print("📄 \(file.filename) - Needs migration to DynamicFormField")
        }
        print()
    }
    
    // Show good examples
    if !goodFiles.isEmpty {
        print("✅ GOOD EXAMPLES")
        print("================")
        for file in goodFiles.prefix(5) {
            print("📄 \(file.filename) - Good business logic testing")
        }
        if goodFiles.count > 5 {
            print("   ... and \(goodFiles.count - 5) more")
        }
        print()
    }
    
    print("🎯 NEXT STEPS")
    print("=============")
    print("1. Fix files with generic tests (replace XCTAssertNotNil with business logic)")
    print("2. Replace hardcoded arrays with .allCases")
    print("3. Add proper documentation headers to all files")
    print("4. Migrate commented out files to DynamicFormField")
    print("5. Add business logic testing to files missing it")
}

main()



