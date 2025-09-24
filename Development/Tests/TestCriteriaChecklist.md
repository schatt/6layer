# Test Criteria Checklist

## **Complete Test Quality Standards - All 10 Criteria**

Every test should meet ALL of these criteria to ensure comprehensive, high-quality testing:

---

## **1. Capability-Based Testing** ✅
**Question**: Does the function do anything different based on capabilities? If so, it needs to have tests for each case.

**Requirements**:
- [ ] Test each platform capability variation (iOS, macOS, watchOS, tvOS, visionOS)
- [ ] Test each data type variation (generic, form, collection, media, etc.)
- [ ] Test each context variation (dashboard, modal, sheet, etc.)
- [ ] Use switch statements to test specific logic for each case
- [ ] Test both enabled and disabled states of capabilities

**Example**:
```swift
func testPlatformCapabilities_BusinessLogic() {
    switch Platform.current {
    case .iOS:
        XCTAssertTrue(config.supportsTouch, "iOS should support touch")
        XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptics")
    case .macOS:
        XCTAssertTrue(config.supportsHover, "macOS should support hover")
        XCTAssertFalse(config.supportsTouch, "macOS should not support touch")
    // ... test each case
    }
}
```

---

## **2. Real Use Testing** ✅
**Question**: Does the test actually test the real use of that function?

**Requirements**:
- [ ] Test actual business logic, not just existence
- [ ] Test the function's intended purpose and behavior
- [ ] Test how the function is used in real applications
- [ ] Test the function's return values and side effects
- [ ] Avoid `XCTAssertNotNil` without additional business logic

**Example**:
```swift
// ❌ BAD: Only tests existence
XCTAssertNotNil(view, "Should return a view")

// ✅ GOOD: Tests actual business logic
XCTAssertTrue(view is AnyView, "Should return AnyView for internationalization")
XCTAssertTrue(view is Text, "Should return Text for string content")
```

---

## **3. Positive and Negative Cases** ✅
**Question**: Does it test both positive and negative cases?

**Requirements**:
- [ ] Test successful execution paths (positive cases)
- [ ] Test failure scenarios and error conditions (negative cases)
- [ ] Test edge cases and boundary conditions
- [ ] Test invalid input handling
- [ ] Test recovery from error states

**Example**:
```swift
func testFormValidation_PositiveAndNegative() {
    // POSITIVE CASES
    XCTAssertTrue(validator.isValid("valid@email.com"), "Valid email should pass")
    XCTAssertTrue(validator.isValid("user@domain.co.uk"), "Valid email with subdomain should pass")
    
    // NEGATIVE CASES
    XCTAssertFalse(validator.isValid("invalid-email"), "Invalid email should fail")
    XCTAssertFalse(validator.isValid(""), "Empty email should fail")
    XCTAssertFalse(validator.isValid("@domain.com"), "Email without user should fail")
}
```

---

## **4. Documentation** ✅
**Question**: Do we have the comment at the top of the file that describes it as requested in the todo?

**Requirements**:
- [ ] File header with business purpose
- [ ] Testing scope description
- [ ] Methodology explanation
- [ ] Clear test function names
- [ ] Inline comments explaining complex logic

**Example**:
```swift
//
//  PlatformCapabilityTests.swift
//  SixLayerFrameworkTests
//
//  BUSINESS PURPOSE:
//  - Tests platform-specific behavior variations
//  - Tests capability detection and configuration
//  - Tests cross-platform compatibility
//
//  TESTING SCOPE:
//  - All platform capabilities (touch, hover, haptic, etc.)
//  - All platform types (iOS, macOS, watchOS, tvOS, visionOS)
//  - Error handling and edge cases
//
//  METHODOLOGY:
//  - Use switch statements to test each platform case
//  - Test both positive and negative scenarios
//  - Test actual business logic, not just existence
//  - Use .allCases instead of hardcoded arrays
//
```

---

## **5. Edge Cases and Boundary Conditions** ✅
**Question**: Does it test edge cases and boundary conditions?

**Requirements**:
- [ ] Test minimum and maximum values
- [ ] Test empty and null inputs
- [ ] Test very large and very small values
- [ ] Test special characters and unicode
- [ ] Test boundary conditions that might cause overflow

**Example**:
```swift
func testEdgeCases_BoundaryConditions() {
    // Test minimum values
    let minNumber = Double.leastNormalMagnitude
    XCTAssertNotNil(processNumber(minNumber), "Should handle minimum values")
    
    // Test maximum values
    let maxNumber = Double.greatestFiniteMagnitude
    XCTAssertNotNil(processNumber(maxNumber), "Should handle maximum values")
    
    // Test empty input
    XCTAssertNotNil(processText(""), "Should handle empty strings")
    
    // Test special characters
    let specialText = "Hello! @#$%^&*()_+-=[]{}|;':\",./<>?`~"
    XCTAssertNotNil(processText(specialText), "Should handle special characters")
}
```

---

## **6. Error Handling and Recovery** ✅
**Question**: Does it test error handling and recovery?

**Requirements**:
- [ ] Test invalid input handling
- [ ] Test error recovery mechanisms
- [ ] Test graceful degradation
- [ ] Test error message generation
- [ ] Test system recovery from error states

**Example**:
```swift
func testErrorHandling_Recovery() {
    // Test invalid input
    let invalidResult = processInvalidInput("invalid")
    XCTAssertNotNil(invalidResult, "Should handle invalid input gracefully")
    
    // Test error recovery
    let recoveredResult = recoverFromError()
    XCTAssertTrue(recoveredResult.isSuccess, "Should recover from errors")
    
    // Test error messages
    let errorMessage = getErrorMessage(for: .invalidInput)
    XCTAssertFalse(errorMessage.isEmpty, "Should provide error messages")
}
```

---

## **7. Performance Characteristics** ✅
**Question**: Does it test performance characteristics?

**Requirements**:
- [ ] Test execution time for normal operations
- [ ] Test memory usage and leaks
- [ ] Test performance with large datasets
- [ ] Test performance under load
- [ ] Set performance thresholds and validate them

**Example**:
```swift
func testPerformance_Characteristics() {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = processLargeDataset(largeData)
    let endTime = CFAbsoluteTimeGetCurrent()
    
    let executionTime = endTime - startTime
    XCTAssertLessThan(executionTime, 1.0, "Should complete within 1 second")
    
    // Test memory usage
    let memoryBefore = getMemoryUsage()
    let _ = processLargeDataset(largeData)
    let memoryAfter = getMemoryUsage()
    
    let memoryIncrease = memoryAfter - memoryBefore
    XCTAssertLessThan(memoryIncrease, 1024 * 1024, "Memory increase should be less than 1MB")
}
```

---

## **8. Accessibility Compliance** ✅
**Question**: Does it test accessibility compliance?

**Requirements**:
- [ ] Test VoiceOver compatibility
- [ ] Test Switch Control compatibility
- [ ] Test high contrast mode
- [ ] Test dynamic type support
- [ ] Test screen reader compatibility

**Example**:
```swift
func testAccessibility_Compliance() {
    let view = createAccessibleView()
    
    // Test VoiceOver compatibility
    XCTAssertTrue(view.isAccessibilityElement, "Should be accessible to VoiceOver")
    XCTAssertFalse(view.accessibilityLabel?.isEmpty ?? true, "Should have accessibility label")
    
    // Test Switch Control compatibility
    XCTAssertTrue(view.isAccessibilityElement, "Should be accessible to Switch Control")
    
    // Test high contrast mode
    let highContrastView = createHighContrastView()
    XCTAssertNotNil(highContrastView, "Should support high contrast mode")
}
```

---

## **9. Cross-Platform Compatibility** ✅
**Question**: Does it test cross-platform compatibility?

**Requirements**:
- [ ] Test behavior on all supported platforms
- [ ] Test platform-specific optimizations
- [ ] Test platform-specific UI patterns
- [ ] Test platform-specific capabilities
- [ ] Test consistent behavior across platforms

**Example**:
```swift
func testCrossPlatform_Compatibility() {
    let platform = Platform.current
    
    switch platform {
    case .iOS:
        XCTAssertTrue(config.supportsTouch, "iOS should support touch")
        XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptics")
    case .macOS:
        XCTAssertTrue(config.supportsHover, "macOS should support hover")
        XCTAssertFalse(config.supportsTouch, "macOS should not support touch by default")
    case .watchOS:
        XCTAssertTrue(config.supportsTouch, "watchOS should support touch")
        XCTAssertTrue(config.supportsHapticFeedback, "watchOS should support haptics")
    // ... test each platform
    }
}
```

---

## **10. Proper Test Data** ✅
**Question**: Does it use proper test data and avoid hardcoded values?

**Requirements**:
- [ ] Use `.allCases` instead of hardcoded arrays
- [ ] Use realistic test data
- [ ] Avoid magic numbers and strings
- [ ] Use proper test data generation
- [ ] Test with real-world scenarios

**Example**:
```swift
func testProperTestData_NoHardcodedValues() {
    // ✅ GOOD: Use .allCases
    let dataTypes = DataTypeHint.allCases
    let contexts = PresentationContext.allCases
    let platforms = Platform.allCases
    
    // ✅ GOOD: Use realistic test data
    let realisticTexts = [
        "Welcome to our application!",
        "Please enter your email address:",
        "Error: Invalid input provided"
    ]
    
    // ❌ BAD: Hardcoded arrays
    // let platforms = [Platform.iOS, Platform.macOS] // Don't do this!
}
```

---

## **Implementation Checklist**

For each test file, verify:

- [ ] **File Header**: Contains business purpose, testing scope, and methodology
- [ ] **Capability Testing**: Tests all relevant capability variations
- [ ] **Real Use Testing**: Tests actual business logic, not just existence
- [ ] **Positive/Negative Cases**: Tests both success and failure scenarios
- [ ] **Edge Cases**: Tests boundary conditions and extreme values
- [ ] **Error Handling**: Tests error conditions and recovery
- [ ] **Performance**: Tests execution time and memory usage
- [ ] **Accessibility**: Tests accessibility compliance
- [ ] **Cross-Platform**: Tests behavior on all supported platforms
- [ ] **Proper Test Data**: Uses .allCases and realistic data

---

## **Quality Gates**

A test file should NOT be considered complete until it meets ALL 10 criteria.

**Red Flags** (immediate fixes needed):
- ❌ Only `XCTAssertNotNil` without business logic
- ❌ Hardcoded arrays instead of `.allCases`
- ❌ No error handling or edge case testing
- ❌ No documentation or unclear purpose
- ❌ No accessibility or performance testing

**Green Flags** (high-quality tests):
- ✅ Comprehensive switch statement testing
- ✅ Real business logic validation
- ✅ Complete positive/negative case coverage
- ✅ Thorough documentation and comments
- ✅ All 10 criteria met

---

## **Next Steps**

1. **Audit existing tests** against this checklist
2. **Fix deficiencies** in current test files
3. **Apply criteria** to all new tests
4. **Review and validate** test quality regularly
5. **Update checklist** as needed based on experience
