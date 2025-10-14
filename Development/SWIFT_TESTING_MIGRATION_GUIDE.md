# Swift Testing Migration Guide

## Overview

This guide provides patterns for migrating from XCTest to Swift Testing while maintaining the SixLayer Framework's mandatory testing requirements.

## Migration Strategy

**Gradual Migration**: Convert tests to Swift Testing as we work on them, maintaining both frameworks during transition.

## Basic Conversion Patterns

### 1. Test Function Conversion

#### XCTest Pattern
```swift
import XCTest
@testable import SixLayerFramework

final class PlatformLogicTests: XCTestCase {
    func testPlatformDetectionLogic() {
        // Given
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases)
        
        // When & Then
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            
            switch platform {
            case .iOS:
                XCTAssertTrue(config.supportsTouch, "iOS should support touch")
                XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptic feedback")
            case .macOS:
                XCTAssertFalse(config.supportsTouch, "macOS should not support touch")
            }
        }
    }
}
```

#### Swift Testing Pattern
```swift
import Testing
@testable import SixLayerFramework

struct PlatformLogicTests {
    @Test func platformDetectionLogic() {
        // Given
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases)
        
        // When & Then
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            
            switch platform {
            case .iOS:
                #expect(config.supportsTouch, "iOS should support touch")
                #expect(config.supportsHapticFeedback, "iOS should support haptic feedback")
            case .macOS:
                #expect(!config.supportsTouch, "macOS should not support touch")
            }
        }
    }
}
```

### 2. Assertion Conversion

| XCTest | Swift Testing |
|--------|---------------|
| `XCTAssertTrue(condition, "message")` | `#expect(condition, "message")` |
| `XCTAssertFalse(condition, "message")` | `#expect(!condition, "message")` |
| `XCTAssertEqual(a, b, "message")` | `#expect(a == b, "message")` |
| `XCTAssertNotNil(value, "message")` | `#expect(value != nil, "message")` |
| `XCTAssertNil(value, "message")` | `#expect(value == nil, "message")` |

### 3. Test Organization

#### XCTest Pattern
```swift
final class AccessibilityTests: XCTestCase {
    func testVoiceOverCompliance() { }
    func testSwitchControlSupport() { }
    func testAssistiveTouchIntegration() { }
}
```

#### Swift Testing Pattern
```swift
struct AccessibilityTests {
    @Test func voiceOverCompliance() { }
    @Test func switchControlSupport() { }
    @Test func assistiveTouchIntegration() { }
}
```

## Mandatory Testing Requirements Compliance

### 1. Complete Function Testing
```swift
// ✅ Swift Testing - Tests actual behavior
@Test func platformPresentItemCollection_L1_DoesWhatItsSupposedToDo() {
    // Given
    let items = [TestItem(id: "1", title: "Test")]
    let hints = PresentationHints(...)
    
    // When
    let view = platformPresentItemCollection_L1(items: items, hints: hints)
    
    // Then
    #expect(view != nil, "Should create a view")
    #expect(view.displaysItems == true, "Should display the items")
    #expect(view.itemCount == 1, "Should display correct number of items")
}
```

### 2. Modifier Application Testing
```swift
// ✅ Swift Testing - Tests all modifiers
@Test func platformPresentItemCollection_L1_AppliesAllCorrectModifiers() {
    // Given
    let items = [TestItem(id: "1", title: "Test")]
    let hints = PresentationHints(...)
    
    // When
    let view = platformPresentItemCollection_L1(items: items, hints: hints)
    
    // Then
    #expect(view.hasAutomaticAccessibilityIdentifiers == true, "Should apply automatic accessibility identifiers")
    #expect(view.isHIGCompliant == true, "Should apply HIG compliance")
    #expect(view.hasPerformanceOptimizations == true, "Should apply performance optimizations")
    #expect(view.isCrossPlatformCompatible == true, "Should apply cross-platform compatibility")
}
```

### 3. Platform-Dependent Testing
```swift
// ✅ Swift Testing - Platform mocking
@Test func platformBlah_L1_AppliesCorrectModifiersOnIOS() {
    // Given
    let mockPlatform = MockPlatform(.iOS)
    let input = createTestInput()
    
    // When
    let result = platformBlah_L1(input: input)
    
    // Then
    #expect(result.hasIOSSpecificBehavior == true, "Should apply iOS-specific behavior")
    #expect(result.hasAutomaticAccessibilityIdentifiers == true, "Should apply accessibility identifiers")
}
```

## Migration Checklist

### For Each Test File:
- [ ] Add `import Testing` alongside `import XCTest`
- [ ] Convert `XCTestCase` class to `struct`
- [ ] Convert `func test*()` to `@Test func *()`
- [ ] Convert `XCTAssert*` to `#expect`
- [ ] Maintain all mandatory testing requirements
- [ ] Ensure test behavior validation (not just existence)
- [ ] Keep platform mocking where required
- [ ] Preserve layered testing architecture

### Quality Gates:
- [ ] Tests must pass with `swift test`
- [ ] Maintain 100% test coverage
- [ ] Preserve mandatory testing rules compliance
- [ ] No cosmetic testing (test behavior, not existence)

## Benefits of Migration

1. **Cleaner Syntax**: `#expect` is more readable than `XCTAssert*`
2. **Better Error Messages**: Swift Testing provides more descriptive failures
3. **Modern Swift**: Uses Swift's modern concurrency and language features
4. **Maintainability**: Easier to read and maintain test code

## Coexistence Strategy

During migration, both frameworks will coexist:
- Keep existing XCTest tests unchanged
- Add new tests using Swift Testing
- Migrate tests incrementally as we work on them
- Both frameworks run with `swift test`

## Example Migration

Here's a complete example of migrating a test file:

### Before (XCTest)
```swift
import XCTest
@testable import SixLayerFramework

final class PlatformLogicTests: XCTestCase {
    func testPlatformDetectionLogic() {
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases)
        
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            
            switch platform {
            case .iOS:
                XCTAssertTrue(config.supportsTouch, "iOS should support touch")
                XCTAssertTrue(config.supportsHapticFeedback, "iOS should support haptic feedback")
            case .macOS:
                XCTAssertFalse(config.supportsTouch, "macOS should not support touch")
            }
        }
    }
}
```

### After (Swift Testing)
```swift
import Testing
@testable import SixLayerFramework

struct PlatformLogicTests {
    @Test func platformDetectionLogic() {
        let platforms: [SixLayerPlatform] = Array(SixLayerPlatform.allCases)
        
        for platform in platforms {
            let config = createMockPlatformConfig(for: platform)
            
            switch platform {
            case .iOS:
                #expect(config.supportsTouch, "iOS should support touch")
                #expect(config.supportsHapticFeedback, "iOS should support haptic feedback")
            case .macOS:
                #expect(!config.supportsTouch, "macOS should not support touch")
            }
        }
    }
}
```

This migration maintains all mandatory testing requirements while providing cleaner, more maintainable test code.
