# 🛠️ SixLayer Framework Development Guide

*This document is for developers working on the SixLayer Framework itself - not for users of the framework.*

## 🎯 **Purpose of This Guide**

This guide covers:
- **Test-Driven Development (TDD) Practices**
- **Code Quality Standards**
- **Development Workflow**
- **Testing Requirements**
- **Code Review Standards**

## 🧪 **Test-Driven Development (TDD) Requirements**

### **Core TDD Principles**

1. **Red-Green-Refactor Cycle**
   - Write failing test first
   - Write minimal code to pass
   - Refactor while keeping tests green

2. **Test Behavior, Not Implementation**
   - Test what the code does, not how it does it
   - Focus on business value and user outcomes

3. **Deterministic Tests**
   - Same inputs must always produce same outputs
   - No random values in production code
   - Mock external dependencies

### **Required Test Categories**

#### **1. Unit Tests (Required for ALL methods)**
```swift
// ✅ GOOD: Tests actual behavior
func testVoiceOverComplianceReturnsDeterministicResult() {
    let checker = AccessibilityComplianceChecker()
    
    // Multiple calls should return the same result
    let result1 = checker.checkVoiceOverCompliance()
    let result2 = checker.checkVoiceOverCompliance()
    XCTAssertEqual(result1, result2, "Accessibility checks should be deterministic")
}

// ❌ BAD: Tests only that method exists
func testVoiceOverComplianceExists() {
    let checker = AccessibilityComplianceChecker()
    let result = checker.checkVoiceOverCompliance()
    XCTAssertNotNil(result) // This passes even with random values!
}
```

#### **2. System State Tests (Required for platform-specific code)**
```swift
// ✅ GOOD: Tests system state dependencies
func testAccessibilityChecksRespondToSystemState() {
    let checker = AccessibilityComplianceChecker()
    
    // Test with different system states
    // (This would require mocking system APIs)
    let resultWithVoiceOver = checker.checkVoiceOverCompliance()
    let resultWithoutVoiceOver = checker.checkVoiceOverCompliance()
    
    // Should behave differently based on system state
    // (Implementation would need to actually check system state)
}
```

#### **3. Platform-Specific Tests (Required for cross-platform code)**
```swift
// ✅ GOOD: Tests platform-specific behavior
func testPlatformSpecificBehavior() {
    #if os(iOS)
    // Test iOS-specific implementation
    XCTAssertTrue(checker.usesIOSAccessibilityAPI())
    #elseif os(macOS)
    // Test macOS-specific implementation
    XCTAssertTrue(checker.usesMacOSAccessibilityAPI())
    #endif
}
```

#### **4. Edge Case Tests (Required for all public APIs)**
```swift
// ✅ GOOD: Tests edge cases and error conditions
func testAccessibilityCheckWithInvalidInput() {
    let checker = AccessibilityComplianceChecker()
    
    // Test with nil, empty, or invalid inputs
    let result = checker.checkAccessibility(nil)
    XCTAssertEqual(result, .basic, "Should handle nil input gracefully")
}
```

### **Testing Anti-Patterns (FORBIDDEN)**

#### **❌ Random Values in Production Code**
```swift
// FORBIDDEN: Random values in production code
private func checkVoiceOverCompliance() -> ComplianceLevel {
    let hasLabels = Bool.random() // ❌ NEVER DO THIS
    let hasHints = Bool.random()  // ❌ NEVER DO THIS
    // ...
}
```

#### **❌ Placeholder Implementations Without Tests**
```swift
// FORBIDDEN: Placeholder without proper tests
private func checkVoiceOverCompliance() -> ComplianceLevel {
    return .intermediate // ❌ Placeholder without validation
}
```

#### **❌ Tests That Don't Validate Behavior**
```swift
// FORBIDDEN: Tests that don't catch real issues
func testMethodExists() {
    let result = someMethod()
    XCTAssertNotNil(result) // ❌ This passes even with broken implementation
}
```

### **Required Test Structure**

#### **For Every Public Method:**
1. **Happy Path Test** - Normal operation
2. **Edge Case Test** - Boundary conditions
3. **Error Handling Test** - Invalid inputs
4. **Deterministic Test** - Same input = same output

#### **For Every Private Method (if complex):**
1. **Behavior Test** - What it actually does
2. **State Test** - How it responds to different states
3. **Integration Test** - How it works with other methods

## 🔍 **Code Quality Standards**

### **Implementation Requirements**

#### **1. No Placeholder Code in Production**
```swift
// ✅ GOOD: Real implementation with TODO for enhancement
private func checkVoiceOverCompliance() -> ComplianceLevel {
    // TODO: IMPLEMENT ACTUAL CHECKS - Check VoiceOver support features
    // In a real implementation, this would:
    // 1. Check if VoiceOver is enabled: UIAccessibility.isVoiceOverRunning
    // 2. Analyze current view hierarchy for accessibility labels
    // 3. Check for proper accessibility element structure
    
    #if os(iOS)
    let isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
    return isVoiceOverRunning ? .intermediate : .basic
    #else
    return .basic
    #endif
}

// ❌ BAD: Random or hardcoded placeholders
private func checkVoiceOverCompliance() -> ComplianceLevel {
    return Bool.random() ? .expert : .basic // ❌ NEVER
}
```

#### **2. Platform-Specific Code Must Be Tested**
```swift
// ✅ GOOD: Platform-specific with proper testing
#if os(iOS)
let isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
#elseif os(macOS)
let isVoiceOverRunning = NSWorkspace.shared.isVoiceOverEnabled
#else
let isVoiceOverRunning = false
#endif
```

#### **3. All Public APIs Must Have Comprehensive Tests**
- Every public method needs unit tests
- Every public class needs integration tests
- Every public protocol needs conformance tests

## 🚨 **Code Review Requirements**

### **Mandatory Review Checklist**

#### **Before Code Review:**
- [ ] All tests pass
- [ ] No random values in production code
- [ ] All public APIs have tests
- [ ] Platform-specific code is tested on all platforms
- [ ] No placeholder implementations without TODOs

#### **During Code Review:**
- [ ] Tests actually validate behavior (not just existence)
- [ ] Tests are deterministic
- [ ] Edge cases are covered
- [ ] Error conditions are handled
- [ ] Platform-specific behavior is correct

#### **Red Flags (Automatic Rejection):**
- Random values in production code
- Placeholder implementations without proper TODOs
- Tests that don't catch broken implementations
- Missing tests for public APIs
- Platform-specific code without platform tests

## 📋 **Development Workflow**

### **1. Feature Development Process**
1. **Write Failing Test First**
   ```swift
   func testNewFeatureBehavior() {
       // Write test that describes desired behavior
       let result = newFeature()
       XCTAssertEqual(result, expectedValue)
   }
   ```

2. **Implement Minimal Code to Pass**
   ```swift
   func newFeature() -> ExpectedType {
       // Minimal implementation to make test pass
       return expectedValue
   }
   ```

3. **Refactor While Keeping Tests Green**
   ```swift
   func newFeature() -> ExpectedType {
       // Improved implementation
       // All tests must still pass
       return calculateExpectedValue()
   }
   ```

### **2. Bug Fix Process**
1. **Write Test That Reproduces Bug**
2. **Verify Test Fails**
3. **Fix Implementation**
4. **Verify Test Passes**
5. **Add Additional Tests for Edge Cases**

### **3. Refactoring Process**
1. **Ensure All Tests Pass Before Refactoring**
2. **Refactor in Small Steps**
3. **Run Tests After Each Step**
4. **Add Tests for New Behavior If Needed**

## 🎯 **Testing Tools and Utilities**

### **Required Testing Utilities**

#### **1. Deterministic Test Helpers**
```swift
// Helper to ensure deterministic behavior
func assertDeterministic<T: Equatable>(
    _ operation: () -> T,
    iterations: Int = 10,
    file: StaticString = #file,
    line: UInt = #line
) {
    let results = (0..<iterations).map { _ in operation() }
    let firstResult = results.first!
    
    for result in results {
        XCTAssertEqual(result, firstResult, 
                      "Operation should be deterministic", 
                      file: file, line: line)
    }
}
```

#### **2. Platform-Specific Test Helpers**
```swift
// Helper to test platform-specific behavior
func testOnAllPlatforms<T>(
    _ test: () -> T,
    file: StaticString = #file,
    line: UInt = #line
) {
    #if os(iOS)
    let iosResult = test()
    #endif
    
    #if os(macOS)
    let macosResult = test()
    #endif
    
    // Validate platform-specific results
}
```

## 📊 **Quality Metrics**

### **Required Coverage**
- **Unit Test Coverage**: 100% for public APIs
- **Integration Test Coverage**: 100% for public classes
- **Platform Test Coverage**: 100% for cross-platform code

### **Quality Gates**
- All tests must pass before merge
- No random values in production code
- All public APIs must have comprehensive tests
- Platform-specific code must be tested on all platforms

## 🚀 **Continuous Integration Requirements**

### **Pre-merge Checks**
1. All tests pass on all platforms
2. No compilation warnings
3. Code coverage meets requirements
4. No random values detected in production code
5. All public APIs have tests

### **Post-merge Checks**
1. Cross-platform compatibility verified
2. Performance regression tests pass
3. Accessibility compliance tests pass
4. Memory leak tests pass

---

## 🎯 **Summary**

**The key principle**: **Tests must catch real problems, not just verify that code exists.**

If a test would pass even with a broken implementation (like random values), it's not a good test. Every test should validate actual behavior and catch real issues.

**Remember**: TDD is about **behavior-driven development**, not just **test-driven development**. We test the behavior we care about, not just that methods exist and return values.
