# Functional Testing Guidelines

## **Core Principle: Test Behavior, Not Existence**

The SixLayerFramework follows **MANDATORY TESTING RULES** that require every function to be tested for:
1. **Correct behavior** - What the function actually does
2. **Application of all correct modifiers** - That modifiers are properly applied
3. **Platform-dependent behavior** - With proper platform mocking when needed
4. **Layered independence** - Each layer tests its own behavior

## **❌ Cosmetic Testing (FORBIDDEN)**

### **View Creation Tests**
```swift
// ❌ BAD: Only tests that view exists
let enhancedView = testView.accessibilityEnhanced()
XCTAssertNotNil(enhancedView, "Enhanced view should be created")
```

### **Configuration Tests**
```swift
// ❌ BAD: Only tests that config exists
XCTAssertNotNil(platformConfig, "Platform configuration should be valid")
```

### **Default Value Tests**
```swift
// ❌ BAD: Only tests that default is set
XCTAssertTrue(config.performance.metalRendering, "Metal rendering should be enabled by default")
```

## **✅ Functional Testing (REQUIRED)**

### **View Creation Tests**
```swift
// ✅ GOOD: Tests actual functionality
let enhancedView = testView.accessibilityEnhanced()
let hostingController = UIHostingController(rootView: enhancedView)
hostingController.view.layoutIfNeeded()

// Test that accessibility features are actually applied
XCTAssertTrue(hostingController.view.isAccessibilityElement, "View should be accessibility element")
XCTAssertNotNil(hostingController.view.accessibilityLabel, "View should have accessibility label")
XCTAssertNotNil(hostingController.view.accessibilityHint, "View should have accessibility hint")
```

### **Configuration Tests**
```swift
// ✅ GOOD: Tests that configuration actually affects behavior
let config = CardExpansionPlatformConfig()
config.supportsTouch = true

// Test that touch configuration actually enables touch behavior
let view = createTestView(with: config)
let hostingController = UIHostingController(rootView: view)
hostingController.view.layoutIfNeeded()

// Verify touch gestures are actually enabled
XCTAssertTrue(hostingController.view.gestureRecognizers?.contains { $0 is UITapGestureRecognizer } ?? false, 
              "Touch configuration should enable tap gestures")
```

### **Default Value Tests**
```swift
// ✅ GOOD: Tests that default values actually work
let config = SixLayerConfiguration()
XCTAssertTrue(config.performance.metalRendering, "Metal rendering should be enabled by default")

// Test that the default actually enables metal rendering
let view = createTestView()
let hostingController = UIHostingController(rootView: view)
hostingController.view.layoutIfNeeded()

// Verify metal rendering is actually active (platform-specific test)
#if os(macOS)
XCTAssertTrue(hostingController.view.layer?.isKind(of: CAMetalLayer.self) ?? false, 
              "Metal rendering default should enable Metal layer")
#endif
```

## **🔧 Testing Patterns by Category**

### **1. View Modifier Tests**

**MANDATORY**: Test that modifiers actually change view behavior

```swift
func testAccessibilityEnhancedModifier() {
    // Given: Base view
    let baseView = Text("Test")
    
    // When: Apply accessibility enhancement
    let enhancedView = baseView.accessibilityEnhanced()
    
    // Then: Test actual accessibility behavior
    let hostingController = UIHostingController(rootView: enhancedView)
    hostingController.view.layoutIfNeeded()
    
    // Verify accessibility properties are actually set
    XCTAssertTrue(hostingController.view.isAccessibilityElement, "Should be accessibility element")
    XCTAssertNotNil(hostingController.view.accessibilityLabel, "Should have accessibility label")
    XCTAssertNotNil(hostingController.view.accessibilityHint, "Should have accessibility hint")
    XCTAssertNotNil(hostingController.view.accessibilityValue, "Should have accessibility value")
}
```

### **2. Configuration Tests**

**MANDATORY**: Test that configurations actually affect behavior

```swift
func testPlatformConfigurationBehavior() {
    // Given: Platform configuration
    let config = CardExpansionPlatformConfig()
    config.supportsTouch = true
    config.supportsHapticFeedback = true
    
    // When: Create view with configuration
    let view = createTestView(with: config)
    
    // Then: Test that configuration actually affects behavior
    let hostingController = UIHostingController(rootView: view)
    hostingController.view.layoutIfNeeded()
    
    // Verify touch behavior is actually enabled
    XCTAssertTrue(hostingController.view.gestureRecognizers?.contains { $0 is UITapGestureRecognizer } ?? false,
                  "Touch configuration should enable tap gestures")
    
    // Verify haptic feedback is actually enabled
    XCTAssertTrue(hostingController.view.gestureRecognizers?.contains { $0 is UILongPressGestureRecognizer } ?? false,
                  "Haptic feedback configuration should enable long press gestures")
}
```

### **3. Layer Function Tests**

**MANDATORY**: Test that Layer functions actually apply their modifiers

```swift
func testLayer1FunctionAppliesModifiers() {
    // Given: Layer 1 function parameters
    let items = [TestItem(id: "test", title: "Test", subtitle: "Test")]
    let hints = PresentationHints(dataType: .generic, presentationPreference: .grid, complexity: .moderate, context: .list, customPreferences: [:])
    
    // When: Call Layer 1 function
    let view = platformPresentItemCollection_L1(items: items, hints: hints)
    
    // Then: Test that modifiers are actually applied
    let hostingController = UIHostingController(rootView: view)
    hostingController.view.layoutIfNeeded()
    
    // Verify HIG compliance is actually applied
    XCTAssertTrue(hostingController.view.layer?.cornerRadius ?? 0 > 0, "HIG compliance should apply corner radius")
    
    // Verify accessibility identifiers are actually applied
    XCTAssertNotNil(hostingController.view.accessibilityIdentifier, "Should have accessibility identifier")
    XCTAssertFalse(hostingController.view.accessibilityIdentifier?.isEmpty ?? true, "Accessibility identifier should not be empty")
}
```

### **4. Platform-Dependent Tests**

**MANDATORY**: Test platform-dependent behavior with proper mocking

```swift
func testPlatformSpecificBehavior() {
    // Test each platform
    for platform in SixLayerPlatform.allCases {
        // Given: Platform-specific configuration
        RuntimeCapabilityDetection.setTestPlatform(platform)
        let config = getCardExpansionPlatformConfig()
        
        // When: Create view with platform config
        let view = createTestView(with: config)
        
        // Then: Test platform-specific behavior
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.layoutIfNeeded()
        
        // Verify platform-specific behavior is actually applied
        switch platform {
        case .iOS:
            XCTAssertTrue(config.supportsTouch, "iOS should support touch")
            XCTAssertTrue(hostingController.view.gestureRecognizers?.contains { $0 is UITapGestureRecognizer } ?? false,
                         "iOS should have tap gestures")
        case .macOS:
            XCTAssertTrue(config.supportsHover, "macOS should support hover")
            XCTAssertFalse(config.supportsTouch, "macOS should not support touch")
        // ... test each platform
        }
        
        RuntimeCapabilityDetection.clearAllCapabilityOverrides()
    }
}
```

## **🚨 Common Anti-Patterns to Avoid**

### **1. Existence-Only Tests**
```swift
// ❌ BAD
XCTAssertNotNil(view, "View should be created")
XCTAssertNotNil(config, "Config should be valid")
XCTAssertNotNil(result, "Result should exist")
```

### **2. Configuration-Only Tests**
```swift
// ❌ BAD
XCTAssertTrue(config.enableAutoIDs, "Auto IDs should be enabled")
XCTAssertEqual(config.namespace, "MyApp", "Namespace should be set")
XCTAssertTrue(config.enableViewHierarchyTracking, "View hierarchy tracking should be enabled")
```

### **3. Default-Value-Only Tests**
```swift
// ❌ BAD
XCTAssertEqual(config.sensitivity, .medium, "Sensitivity should be medium")
XCTAssertEqual(config.dwellTime, 1.0, "Dwell time should be 1.0")
XCTAssertTrue(config.visualFeedback, "Visual feedback should be enabled")
```

## **✅ Required Test Structure**

Every test must follow this pattern:

```swift
func testFunctionName() {
    // Given: Setup test data and configuration
    let testData = createTestData()
    let config = createTestConfig()
    
    // When: Call the function being tested
    let result = functionUnderTest(data: testData, config: config)
    
    // Then: Test actual behavior and functionality
    // 1. Test that the result has the expected properties
    // 2. Test that modifiers are actually applied
    // 3. Test that configuration actually affects behavior
    // 4. Test platform-specific behavior if applicable
    
    // Use hosting controllers to test actual view behavior
    let hostingController = UIHostingController(rootView: result)
    hostingController.view.layoutIfNeeded()
    
    // Test actual functionality, not just existence
    XCTAssertTrue(hostingController.view.isAccessibilityElement, "Should be accessibility element")
    XCTAssertNotNil(hostingController.view.accessibilityIdentifier, "Should have accessibility identifier")
    // ... more functional tests
}
```

## **🎯 Success Criteria**

A test is **functional** if it:
- ✅ Tests actual behavior, not just existence
- ✅ Verifies that modifiers are actually applied
- ✅ Confirms that configurations actually affect behavior
- ✅ Tests platform-specific behavior when applicable
- ✅ Uses hosting controllers to test real view behavior
- ✅ Would catch bugs if the functionality was broken

A test is **cosmetic** if it:
- ❌ Only checks that objects exist
- ❌ Only verifies configuration values are set
- ❌ Only tests default values without testing they work
- ❌ Doesn't test actual functionality
- ❌ Wouldn't catch bugs if the functionality was broken

## **🔧 Implementation Checklist**

For each test file:
- [ ] Replace all `XCTAssertNotNil(view, "Should be created")` with functional tests
- [ ] Replace all `XCTAssertNotNil(config, "Should be valid")` with behavior tests
- [ ] Replace all default value tests with functionality tests
- [ ] Add hosting controller tests for view behavior
- [ ] Add platform-specific tests where applicable
- [ ] Verify tests would catch bugs if functionality was broken

---

**Remember**: The goal is to catch bugs before they reach production. Cosmetic tests don't catch bugs - functional tests do! 🎯



