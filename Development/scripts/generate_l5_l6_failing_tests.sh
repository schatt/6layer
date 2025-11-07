#!/bin/bash

# TDD Red Phase: Generate Missing L5 and L6 Function Tests
# This script creates individual test files for L5 and L6 functions that were missed

echo "🔴 TDD Red Phase: Generating failing tests for missing L5 and L6 functions..."

# Function to create test for any function
create_function_test() {
    local func_name=$1
    local test_name=$(echo $func_name | sed 's/platform//' | sed 's/_L[56]//')
    local test_file="Development/Tests/SixLayerFrameworkTests/${test_name}L5L6AccessibilityTDDTests.swift"
    
    cat > "$test_file" << EOF
import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// TDD Red Phase: Individual Function Test
/// This test SHOULD FAIL - proving $func_name doesn't generate accessibility IDs
@MainActor
final class ${test_name}L5L6AccessibilityTDDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
        config.namespace = "TDDTest"
        config.mode = .automatic
        config.enableDebugLogging = true
        config.enableAutoIDs = true
    }
    
    override func tearDown() {
        super.tearDown()
        let config = AccessibilityIdentifierConfig.shared
        config.resetToDefaults()
    }
    
    func test${test_name}L5L6GeneratesAccessibilityID() {
        // TDD Red Phase: This SHOULD FAIL - $func_name needs accessibility support
        // TODO: Add proper test implementation for $func_name
        
        // Placeholder test that will fail
        let testView = VStack {
            Text("Placeholder for $func_name")
        }
        
        // TDD Red Phase: This assertion SHOULD FAIL
        XCTAssertTrue(hasAccessibilityIdentifier(testView), "$func_name should generate accessibility ID")
        print("🔴 TDD Red Phase: $func_name should FAIL - needs proper implementation")
    }
    
    // MARK: - Helper Methods
    
    private func hasAccessibilityIdentifier<T: View>(_ view: T) -> Bool {
        do {
            let inspectedView = try view.inspect()
            return try inspectedView.accessibilityIdentifier() != ""
        } catch {
            return false
        }
    }
}
EOF
    
    echo "Created: $test_file"
}

# L5 Functions (Configuration functions - these don't return Views, but let's test them anyway)
create_function_test "getCardExpansionPlatformConfig_L5"
create_function_test "getCardExpansionPerformanceConfig_L5"
create_function_test "getCardExpansionAccessibilityConfig_L5"

# L6 Functions (These return some View)
create_function_test "optimizeView_L6"
create_function_test "platformSpecificOptimizations_L6"
create_function_test "performanceOptimizations_L6"
create_function_test "uiPatternOptimizations_L6"

echo "🔴 TDD Red Phase: Generated failing tests for missing L5 and L6 functions!"
echo "Total L5/L6 test files created: $(ls Development/Tests/SixLayerFrameworkTests/*L5L6AccessibilityTDDTests.swift | wc -l)"
echo ""
echo "Next: Run all tests to prove they fail (TDD Red Phase)"
echo "Then: Implement fixes to make them pass (TDD Green Phase)"
