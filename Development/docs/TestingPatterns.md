# Testing Patterns and Best Practices

## Parameterized Testing Pattern

### Overview
Use parameterized tests to reduce duplication when testing the same functionality across multiple platforms or configurations.

### When to Use
- Testing platform-specific behavior (iOS, macOS, visionOS)
- Testing multiple configurations or variants
- Testing the same logic with different input values
- Cross-platform accessibility testing

### Pattern Structure

```swift
@Test(arguments: [SixLayerPlatform.iOS, SixLayerPlatform.macOS])
func testComponentGeneratesAccessibilityIdentifiers(
    platform: SixLayerPlatform
) async {
    // Given
    let component = ComponentClass()
    
    // When & Then
    let hasAccessibilityID = await MainActor.run {
        let view = component.createView()
        return hasAccessibilityIdentifier(
            view, 
            expectedPattern: "SixLayer.main.element.*", 
            platform: platform,
            componentName: "ComponentName"
        )
    }
    
    #expect(hasAccessibilityID, "Component should generate accessibility identifiers on \(platform.rawValue)")
}
```

### Benefits
1. **Reduced Duplication**: Single test method instead of separate iOS/macOS methods
2. **Easier Maintenance**: Changes only need to be made in one place
3. **Better Coverage**: Easy to add more platforms by extending the arguments array
4. **Cleaner Code**: Less repetitive test code
5. **Consistent Testing**: Ensures all platforms are tested with identical logic

### Common Argument Types

#### Platform Testing
```swift
@Test(arguments: [SixLayerPlatform.iOS, SixLayerPlatform.macOS])
func testPlatformSpecificBehavior(platform: SixLayerPlatform) async {
    // Test logic using platform parameter
}
```

#### Configuration Testing
```swift
@Test(arguments: [Configuration.standard, Configuration.advanced, Configuration.debug])
func testConfigurationBehavior(config: Configuration) async {
    // Test logic using config parameter
}
```

#### Style Testing
```swift
@Test(arguments: Array(PhotoDisplayStyle.allCases))
func testDisplayStyles(style: PhotoDisplayStyle) async {
    // Test logic using style parameter
}
```

### Best Practices

1. **Use Descriptive Parameter Names**: `platform`, `config`, `style` instead of generic names
2. **Include Platform in Assertion Messages**: Use `\(platform.rawValue)` for clear test output
3. **Keep Arguments Focused**: Only include platforms/configurations that are actually different
4. **Document the Purpose**: Explain why parameterization is needed in the test comment
5. **Use Type Safety**: Prefer enums over strings for arguments when possible

### Example: Before and After

#### Before (Duplicated)
```swift
@Test func testComponentOnIOS() async {
    let component = ComponentClass()
    let view = component.createView()
    let hasID = hasAccessibilityIdentifier(view, platform: .iOS, componentName: "Component")
    #expect(hasID, "Component should work on iOS")
}

@Test func testComponentOnMacOS() async {
    let component = ComponentClass()
    let view = component.createView()
    let hasID = hasAccessibilityIdentifier(view, platform: .macOS, componentName: "Component")
    #expect(hasID, "Component should work on macOS")
}
```

#### After (Parameterized)
```swift
@Test(arguments: [SixLayerPlatform.iOS, SixLayerPlatform.macOS])
func testComponent(platform: SixLayerPlatform) async {
    let component = ComponentClass()
    let view = component.createView()
    let hasID = hasAccessibilityIdentifier(view, platform: platform, componentName: "Component")
    #expect(hasID, "Component should work on \(platform.rawValue)")
}
```

### Migration Guidelines

When refactoring existing duplicated tests:

1. **Identify Duplication**: Look for tests that differ only in platform/configuration
2. **Extract Common Logic**: Move shared test logic into the parameterized method
3. **Add Arguments**: Specify the platforms/configurations to test
4. **Update Assertions**: Include the parameter value in assertion messages
5. **Remove Duplicates**: Delete the old separate test methods
6. **Verify Coverage**: Ensure all intended platforms/configurations are still tested

### Testing Framework Notes

- Swift Testing automatically runs parameterized tests multiple times
- Each parameter combination appears as a separate test case in results
- Test failures will show which specific parameter value failed
- Use `@Test(arguments: [...])` syntax for Swift Testing framework

## Other Testing Patterns

### Component Testing Pattern
When testing Layer 4/5 components that are classes returning views:

```swift
@Test func testComponentMethod() async {
    // Given
    let component = ComponentClass()
    
    // When
    let view = component.methodName(parameters)
    
    // Then
    // Test the returned view
}
```

### Service Testing Pattern
When testing service classes (not views):

```swift
@Test func testServiceMethod() async {
    // Given
    let service = ServiceClass()
    
    // When & Then
    do {
        let result = try await service.methodName(parameters)
        #expect(result.property == expectedValue)
    } catch {
        #expect(error is ExpectedErrorType)
    }
}
```

## Documentation Standards

- Document testing patterns in this file
- Include examples for common scenarios
- Update patterns as new testing needs emerge
- Reference this file in test file headers when using patterns
