# SixLayer Framework Testing Rules - MANDATORY

## Core Principle

**MANDATORY**: Every function must be tested to ensure it does what it's supposed to do AND applies all the correct modifiers it should.

## Rule 1: Complete Function Testing

### 1.1 Every Function Must Be Tested
- **MANDATORY**: Every public function in the framework must have comprehensive tests
- **MANDATORY**: Every function must be tested for its complete functionality
- **MANDATORY**: Every function must be tested for all modifiers it applies
- **MANDATORY**: No function can be released without complete test coverage

### 1.2 Function Behavior Testing
- **MANDATORY**: Tests must validate actual behavior, not just function existence
- **MANDATORY**: Tests must fail when functionality is broken
- **MANDATORY**: Tests must pass when functionality works correctly
- **MANDATORY**: Tests must only test behavior that actually exists (no testing of stubs or non-functional flags)
```swift
// ✅ CORRECT: Test that function does what it's supposed to do
func testPlatformPresentItemCollection_L1_DoesWhatItsSupposedToDo() {
    // Given
    let items = [TestItem(id: "1", title: "Test")]
    let hints = PresentationHints(...)
    
    // When
    let view = platformPresentItemCollection_L1(items: items, hints: hints)
    
    // Then
    XCTAssertNotNil(view, "Should create a view")
    XCTAssertTrue(view.displaysItems, "Should display the items")
    XCTAssertEqual(view.itemCount, 1, "Should display correct number of items")
}
```

### 1.3 Modifier Application Testing
- **MANDATORY**: Every function must be tested for ALL modifiers it applies
- **MANDATORY**: Tests must validate that modifiers are actually applied
- **MANDATORY**: Tests must validate modifier behavior, not just existence
```swift
// ✅ CORRECT: Test that function applies all correct modifiers
func testPlatformPresentItemCollection_L1_AppliesAllCorrectModifiers() {
    // Given
    let items = [TestItem(id: "1", title: "Test")]
    let hints = PresentationHints(...)
    
    // When
    let view = platformPresentItemCollection_L1(items: items, hints: hints)
    
    // Then
    XCTAssertTrue(view.hasAutomaticAccessibilityIdentifiers, "Should apply automatic accessibility identifiers")
    XCTAssertTrue(view.isHIGCompliant, "Should apply HIG compliance")
    XCTAssertTrue(view.hasPerformanceOptimizations, "Should apply performance optimizations")
    XCTAssertTrue(view.isCrossPlatformCompatible, "Should apply cross-platform compatibility")
}
```

## Rule 2: Platform-Dependent Testing

### 2.1 Platform Mocking Requirements
- **MANDATORY**: If any modifiers are platform-dependent, tests MUST mock those platforms
- **MANDATORY**: Tests MUST ensure correct behavior on all supported platforms
- **MANDATORY**: Platform-specific behavior MUST be validated
- **MANDATORY**: Platform mocking is required for ANY FUNCTION that contains platform-dependent behavior (not per layer, but per individual function)
- **MANDATORY**: No platform-dependent function can be released without platform mocking tests

### 2.3 Platform Mocking Examples

### 2.3 Platform Mocking Examples

#### L1 Function - Platform Dependent (Requires Mocking)
```swift
// ✅ CORRECT: L1_platformBlah does different things on different platforms
func testPlatformBlah_L1_AppliesCorrectModifiersOnIOS() {
    // Given
    let mockPlatform = MockPlatform(.iOS)
    let input = createTestInput()
    
    // When
    let result = platformBlah_L1(input: input)
    
    // Then
    XCTAssertTrue(result.hasIOSSpecificBehavior, "Should apply iOS-specific behavior")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    // Platform mocking REQUIRED - this function is platform-dependent
}
```

#### L1 Function - Stub Implementation (No Testing of Non-Functional Flags)
```swift
// ✅ CORRECT: L1_platformStub has a flag that does nothing (stub implementation)
func testPlatformStub_L1_AppliesCorrectModifiers() {
    // Given
    let input = createTestInput()
    
    // When
    let result = platformStub_L1(input: input, enableAdvancedFeature: true)
    
    // Then
    XCTAssertTrue(result.hasBasicFunctionality, "Should have basic functionality")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    // DO NOT test enableAdvancedFeature - it's a stub that does nothing
    // Testing non-functional flags would be testing non-existent behavior
}
```

#### L1 Function - Unconditional Behavior (No Testing of Irrelevant Flags)
```swift
// ✅ CORRECT: L1_functionA returns FOO unconditionally
func testFunctionA_L1_AppliesCorrectModifiers() {
    // Given
    let input = createTestInput()
    
    // When
    let result = functionA_L1(input: input, bazFlag: true)
    
    // Then
    XCTAssertEqual(result, "FOO", "Should return FOO unconditionally")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    // DO NOT test bazFlag - it doesn't affect the unconditional behavior
    // Testing irrelevant flags would be testing non-existent behavior
}
```

#### L1 Function - Flag Passed Through Layers (Test Where Behavior Actually Changes)
```swift
// ✅ CORRECT: L1 passes flag through to L3, which passes to L6
func testPlatformFeature_L1_PassesFlagThroughLayers() {
    // Given
    let input = createTestInput()
    
    // When
    let result = platformFeature_L1(input: input, enableAdvancedFeature: true)
    
    // Then
    XCTAssertTrue(result.hasBasicFunctionality, "Should have basic functionality")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    // DO NOT test enableAdvancedFeature here - L1 just passes it through
    // The flag is tested in L6 where it actually affects behavior
}
```

#### L3 Function - Flag Passed Through (No Testing of Pass-Through Flags)
```swift
// ✅ CORRECT: L3 passes flag through to L6 without changing behavior
func testPlatformStrategy_L3_PassesFlagThrough() {
    // Given
    let input = createTestInput()
    
    // When
    let result = platformStrategy_L3(input: input, enableAdvancedFeature: true)
    
    // Then
    XCTAssertTrue(result.hasStrategyBehavior, "Should have strategy behavior")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    // DO NOT test enableAdvancedFeature here - L3 just passes it through
    // The flag is tested in L6 where it actually affects behavior
}
```

#### L6 Function - Flag Actually Affects Behavior (Test the Flag)
```swift
// ✅ CORRECT: L6 actually does different things based on the flag
func testPlatformImplementation_L6_AppliesCorrectModifiersWithAdvancedFeature() {
    // Given
    let input = createTestInput()
    
    // When: Test with flag enabled
    let enabledResult = platformImplementation_L6(input: input, enableAdvancedFeature: true)
    
    // Then: Should have advanced behavior
    XCTAssertTrue(enabledResult.hasAdvancedBehavior, "Should have advanced behavior when enabled")
    XCTAssertTrue(enabledResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // When: Test with flag disabled
    let disabledResult = platformImplementation_L6(input: input, enableAdvancedFeature: false)
    
    // Then: Should have basic behavior
    XCTAssertFalse(disabledResult.hasAdvancedBehavior, "Should not have advanced behavior when disabled")
    XCTAssertTrue(disabledResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // Test enableAdvancedFeature here - L6 actually changes behavior based on this flag
}
```
```swift
// ✅ CORRECT: L1_platformComplex does different things based on BOTH data AND platform
func testPlatformComplex_L1_AppliesCorrectModifiersOnIOSWithDifferentData() {
    // Given: Both platform mocking AND different data types
    let mockPlatform = MockPlatform(.iOS)
    let simpleData = createSimpleTestData()
    let complexData = createComplexTestData()
    
    // When: Test with simple data on iOS
    let simpleResult = platformComplex_L1(data: simpleData)
    
    // Then: Should apply iOS-specific behavior for simple data
    XCTAssertTrue(simpleResult.hasIOSSpecificBehavior, "Should apply iOS-specific behavior")
    XCTAssertTrue(simpleResult.hasSimpleDataBehavior, "Should apply simple data behavior")
    XCTAssertTrue(simpleResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // When: Test with complex data on iOS
    let complexResult = platformComplex_L1(data: complexData)
    
    // Then: Should apply iOS-specific behavior for complex data
    XCTAssertTrue(complexResult.hasIOSSpecificBehavior, "Should apply iOS-specific behavior")
    XCTAssertTrue(complexResult.hasComplexDataBehavior, "Should apply complex data behavior")
    XCTAssertTrue(complexResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // Platform mocking AND data variation REQUIRED - this function is both platform AND data dependent
}

func testPlatformComplex_L1_AppliesCorrectModifiersOnMacOSWithDifferentData() {
    // Given: Both platform mocking AND different data types
    let mockPlatform = MockPlatform(.macOS)
    let simpleData = createSimpleTestData()
    let complexData = createComplexTestData()
    
    // When: Test with simple data on macOS
    let simpleResult = platformComplex_L1(data: simpleData)
    
    // Then: Should apply macOS-specific behavior for simple data
    XCTAssertTrue(simpleResult.hasMacOSSpecificBehavior, "Should apply macOS-specific behavior")
    XCTAssertTrue(simpleResult.hasSimpleDataBehavior, "Should apply simple data behavior")
    XCTAssertTrue(simpleResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // When: Test with complex data on macOS
    let complexResult = platformComplex_L1(data: complexData)
    
    // Then: Should apply macOS-specific behavior for complex data
    XCTAssertTrue(complexResult.hasMacOSSpecificBehavior, "Should apply macOS-specific behavior")
    XCTAssertTrue(complexResult.hasComplexDataBehavior, "Should apply complex data behavior")
    XCTAssertTrue(complexResult.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    
    // Platform mocking AND data variation REQUIRED - this function is both platform AND data dependent
}
```
```swift
// ✅ CORRECT: Test platform-dependent behavior with mocking
func testPlatformIOSNavigationBar_AppliesCorrectModifiersOnIOS() {
    // Given
    let mockPlatform = MockPlatform(.iOS)
    let view = Button("Test") { }
    
    // When
    let result = view.platformIOSNavigationBar(title: "Test")
    
    // Then
    XCTAssertTrue(result.hasIOSNavigationBar, "Should have iOS navigation bar on iOS")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should apply accessibility identifiers")
    XCTAssertTrue(result.isHIGCompliant, "Should apply HIG compliance")
}

func testPlatformIOSNavigationBar_NoOpOnNonIOS() {
    // Given
    let mockPlatform = MockPlatform(.macOS)
    let view = Button("Test") { }
    
    // When
    let result = view.platformIOSNavigationBar(title: "Test")
    
    // Then
    XCTAssertFalse(result.hasIOSNavigationBar, "Should not have iOS navigation bar on macOS")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should still apply accessibility identifiers")
    XCTAssertTrue(result.isHIGCompliant, "Should still apply HIG compliance")
}
```

### 2.4 Testing Requirements Summary

#### Function Types and Required Testing:

1. **Platform-Dependent Only**: **MANDATORY** - Requires platform mocking
   - `L1_platformBlah()` - Different behavior on iOS vs macOS
   - Test: `testPlatformBlah_L1_AppliesCorrectModifiersOnIOS()`
   - Test: `testPlatformBlah_L1_AppliesCorrectModifiersOnMacOS()`

2. **Data-Dependent Only**: **MANDATORY** - Requires data variation testing
   - `L1_platformFoo()` - Different behavior based on data complexity
   - Test: `testPlatformFoo_L1_AppliesCorrectModifiersWithSimpleData()`
   - Test: `testPlatformFoo_L1_AppliesCorrectModifiersWithComplexData()`

3. **Both Platform AND Data Dependent**: **MANDATORY** - Requires BOTH platform mocking AND data variation
   - `L1_platformComplex()` - Different behavior based on BOTH platform AND data
   - Test: `testPlatformComplex_L1_AppliesCorrectModifiersOnIOSWithSimpleData()`
   - Test: `testPlatformComplex_L1_AppliesCorrectModifiersOnIOSWithComplexData()`
   - Test: `testPlatformComplex_L1_AppliesCorrectModifiersOnMacOSWithSimpleData()`
   - Test: `testPlatformComplex_L1_AppliesCorrectModifiersOnMacOSWithComplexData()`

4. **Neither Platform Nor Data Dependent**: **MANDATORY** - Requires basic functionality testing
   - `L1_platformSimple()` - Same behavior regardless of platform or data
   - Test: `testPlatformSimple_L1_AppliesCorrectModifiers()`

## Rule 3: Layered Testing Architecture

### 3.1 Layer Independence
- **MANDATORY**: Each layer's tests assume lower layers are correct
- **MANDATORY**: L5 tests do NOT test L6 component behavior (L6 tests handle that)
- **MANDATORY**: Each layer tests its complete functionality and modifier application
- **MANDATORY**: No layer can be released without complete test coverage

### 3.2 Layer Testing Responsibilities

#### Layer 1 Tests
```swift
// ✅ CORRECT: L1 tests focus on L1 functionality
func testPlatformPresentItemCollection_L1_CompleteFunctionality() {
    // Test L1 semantic intent
    // Test L1 modifier application (accessibility, HIG compliance, etc.)
    // Platform mocking REQUIRED if THIS SPECIFIC FUNCTION is platform-dependent
    // DO NOT test L2-L6 behavior (those are tested in their respective layers)
}
```

#### Layer 2 Tests
```swift
// ✅ CORRECT: L2 tests focus on L2 functionality
func testDetermineOptimalLayout_L2_CompleteFunctionality() {
    // Test L2 layout decision logic
    // Test L2 modifier application
    // Platform mocking REQUIRED if THIS SPECIFIC FUNCTION is platform-dependent
    // Assume L1 functions work correctly (tested in L1 tests)
    // DO NOT test L3-L6 behavior
}
```

#### Layer 4 Tests
```swift
// ✅ CORRECT: L4 tests focus on L4 functionality
func testPlatformFormContainer_L4_CompleteFunctionality() {
    // Test L4 component implementation
    // Test L4 modifier application
    // Platform mocking REQUIRED if THIS SPECIFIC FUNCTION is platform-dependent
    // Assume L1-L3 functions work correctly
    // DO NOT test L5-L6 behavior
}
```

#### Layer 5 Tests
```swift
// ✅ CORRECT: L5 tests focus on L5 functionality
func testPlatformMemoryOptimization_L5_CompleteFunctionality() {
    // Test L5 performance optimization
    // Test L5 modifier application
    // Platform mocking REQUIRED if THIS SPECIFIC FUNCTION is platform-dependent
    // Assume L1-L4 functions work correctly
    // DO NOT test L6 behavior (L6 tests handle that)
}
```

#### Layer 6 Tests
```swift
// ✅ CORRECT: L6 tests focus on L6 functionality
func testPlatformIOSHapticFeedback_L6_CompleteFunctionality() {
    // Test L6 platform-specific features
    // Test L6 modifier application
    // Platform mocking REQUIRED if THIS SPECIFIC FUNCTION is platform-dependent
    // Assume L1-L5 functions work correctly
}
```

## Rule 4: Modifier Application Testing

### 4.1 Complete Modifier Coverage
- **MANDATORY**: Every function must be tested for ALL modifiers it applies
- **MANDATORY**: Tests must validate that modifiers are actually applied
- **MANDATORY**: Tests must validate modifier behavior, not just existence
- **MANDATORY**: No function can be released without testing all its modifiers

### 4.2 Modifier Testing Pattern
```swift
// ✅ CORRECT: Test all modifiers a function should apply
func testFunction_AppliesAllRequiredModifiers() {
    // Given
    let input = createTestInput()
    
    // When
    let result = functionUnderTest(input)
    
    // Then
    XCTAssertTrue(result.hasModifierA, "Should apply modifier A")
    XCTAssertTrue(result.hasModifierB, "Should apply modifier B")
    XCTAssertTrue(result.hasModifierC, "Should apply modifier C")
    // Test ALL modifiers the function should apply
}
```

## Rule 5: Real-World Scenario Testing

### 5.1 User Scenario Coverage
- **MANDATORY**: Tests must cover real-world usage scenarios
- **MANDATORY**: Tests must validate the framework's own documented patterns
- **MANDATORY**: Tests must catch the exact issues users encounter
- **MANDATORY**: No function can be released without real-world scenario testing

### 5.2 Scenario Testing Pattern
```swift
// ✅ CORRECT: Test real-world usage scenarios
func testCustomViewWithAllSixLayers_CompleteFunctionality() {
    // Given: The exact pattern from framework documentation
    let view = createCustomViewWithAllSixLayers()
    
    // When: Apply the complete pattern
    let result = view
        .platformPresentItemCollection_L1(...)  // L1
        .onAppear {
            let decision = determineOptimalCardLayout_L2(...)  // L2
            let strategy = selectCardLayoutStrategy_L3(...)    // L3
        }
        .platformMemoryOptimization()  // L5
        .platformIOSHapticFeedback()  // L6
    
    // Then: Validate complete functionality
    XCTAssertTrue(result.hasAllLayerFeatures, "Should have all layer features")
    XCTAssertTrue(result.hasAutomaticAccessibilityIdentifiers, "Should have accessibility identifiers")
    XCTAssertTrue(result.isHIGCompliant, "Should be HIG compliant")
    XCTAssertTrue(result.hasPerformanceOptimizations, "Should have performance optimizations")
    XCTAssertTrue(result.hasPlatformSpecificFeatures, "Should have platform-specific features")
}
```

## Rule 6: Test Quality Standards

### 6.1 Test Completeness
- **MANDATORY**: Tests must validate actual behavior, not just function existence
- **MANDATORY**: Tests must fail when functionality is broken
- **MANDATORY**: Tests must pass when functionality works correctly
- **MANDATORY**: No test can be released without validating actual behavior

### 6.2 Test Validation
```swift
// ❌ BAD: Test only checks function exists
func testFunction_Exists() {
    let result = functionUnderTest()
    XCTAssertNotNil(result, "Function should exist")
}

// ✅ GOOD: Test validates actual behavior
func testFunction_DoesWhatItsSupposedToDo() {
    let result = functionUnderTest()
    XCTAssertNotNil(result, "Should create result")
    XCTAssertTrue(result.hasExpectedBehavior, "Should have expected behavior")
    XCTAssertTrue(result.hasRequiredModifiers, "Should have required modifiers")
}
```

## Rule 7: Enforcement

### 7.1 Mandatory Compliance
- **MANDATORY**: All new functions must follow these testing rules
- **MANDATORY**: All existing functions must be updated to follow these rules
- **MANDATORY**: No function can be released without complete test coverage
- **MANDATORY**: No exception to these rules is allowed

### 7.2 Quality Gates
- **MANDATORY**: Tests must pass before any release
- **MANDATORY**: Test coverage must be 100% for all functions
- **MANDATORY**: All modifiers must be tested for all functions
- **MANDATORY**: No release can proceed without meeting all quality gates

## Rule 7: Cosmetic vs Functional Testing

### 7.1 Cosmetic Testing (FORBIDDEN)
**MANDATORY**: The following testing patterns are FORBIDDEN as they don't catch bugs:

#### 7.1.1 View Creation Tests
```swift
// ❌ FORBIDDEN: Only tests that view exists
let enhancedView = testView.accessibilityEnhanced()
XCTAssertNotNil(enhancedView, "Enhanced view should be created")
```

#### 7.1.2 Configuration Tests
```swift
// ❌ FORBIDDEN: Only tests that config exists
XCTAssertNotNil(platformConfig, "Platform configuration should be valid")
```

#### 7.1.3 Default Value Tests
```swift
// ❌ FORBIDDEN: Only tests that default is set
XCTAssertTrue(config.performance.metalRendering, "Metal rendering should be enabled by default")
```

### 7.2 Functional Testing (REQUIRED)
**MANDATORY**: All tests must validate actual behavior and functionality:

#### 7.2.1 View Creation Tests
```swift
// ✅ REQUIRED: Tests actual functionality
let enhancedView = testView.accessibilityEnhanced()
let hostingController = UIHostingController(rootView: enhancedView)
hostingController.view.layoutIfNeeded()

// Test that accessibility features are actually applied
XCTAssertTrue(hostingController.view.isAccessibilityElement, "View should be accessibility element")
XCTAssertNotNil(hostingController.view.accessibilityLabel, "View should have accessibility label")
XCTAssertNotNil(hostingController.view.accessibilityHint, "View should have accessibility hint")
```

#### 7.2.2 Configuration Tests
```swift
// ✅ REQUIRED: Tests that configuration actually affects behavior
let config = CardExpansionPlatformConfig()
config.supportsTouch = true

let view = createTestView(with: config)
let hostingController = UIHostingController(rootView: view)
hostingController.view.layoutIfNeeded()

// Verify touch behavior is actually enabled
XCTAssertTrue(hostingController.view.gestureRecognizers?.contains { $0 is UITapGestureRecognizer } ?? false, 
              "Touch configuration should enable tap gestures")
```

#### 7.2.3 Default Value Tests
```swift
// ✅ REQUIRED: Tests that default values actually work
let config = SixLayerConfiguration()
XCTAssertTrue(config.performance.metalRendering, "Metal rendering should be enabled by default")

// Test that the default actually enables metal rendering
let view = createTestView()
let hostingController = UIHostingController(rootView: view)
hostingController.view.layoutIfNeeded()

// Verify metal rendering is actually active
#if os(macOS)
XCTAssertTrue(hostingController.view.layer?.isKind(of: CAMetalLayer.self) ?? false, 
              "Metal rendering default should enable Metal layer")
#endif
```

### 7.3 Test Quality Validation
**MANDATORY**: Every test must meet these criteria:
- ✅ Tests actual behavior, not just existence
- ✅ Verifies that modifiers are actually applied
- ✅ Confirms that configurations actually affect behavior
- ✅ Tests platform-specific behavior when applicable
- ✅ Uses hosting controllers to test real view behavior
- ✅ Would catch bugs if the functionality was broken

**MANDATORY**: A test is cosmetic if it:
- ❌ Only checks that objects exist
- ❌ Only verifies configuration values are set
- ❌ Only tests default values without testing they work
- ❌ Doesn't test actual functionality
- ❌ Wouldn't catch bugs if the functionality was broken

## Summary

**MANDATORY**: Every function must be tested to ensure:
1. ✅ It does what it's supposed to do
2. ✅ It applies all the correct modifiers it should
3. ✅ Platform-dependent behavior is properly mocked and tested
4. ✅ Each layer is tested independently (L5 doesn't test L6 behavior)
5. ✅ Real-world usage scenarios are covered
6. ✅ Tests actually validate behavior, not just existence
7. ✅ Tests are functional, not cosmetic

**MANDATORY**: This ensures that bugs like the automatic accessibility identifier failure cannot go undetected.

**MANDATORY**: No function can be released without meeting ALL these requirements.
