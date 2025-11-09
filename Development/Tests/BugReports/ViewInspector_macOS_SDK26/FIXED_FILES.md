# Files Updated to Handle ViewInspector macOS Issue

This document lists all test files that have been updated to use the `ViewInspectorWrapper` and `VIEW_INSPECTOR_MAC_FIXED` compile-time flag to handle the ViewInspector macOS compilation issue (GitHub Issue #405).

## Summary
- **Total files updated**: 38 test files + 1 wrapper file
- **Approach**: Centralized wrapper with compile-time flag in `Package.swift`
- **Migration path**: When ViewInspector fixes issue #405, uncomment `.define("VIEW_INSPECTOR_MAC_FIXED")` in `Package.swift`

## Core Infrastructure

### ViewInspectorWrapper.swift
- **Location**: `Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/ViewInspectorWrapper.swift`
- **Purpose**: Centralized wrapper for ViewInspector APIs
- **Features**:
  - `tryInspect()` extension on `View`
  - `inspectView()` extension on `View`
  - `withInspectedView()` helper function
  - `withInspectedViewThrowing()` helper function
  - Compile-time flag support via `VIEW_INSPECTOR_MAC_FIXED`

### Package.swift
- **Location**: `Package.swift`
- **Change**: Added `swiftSettings` with commented-out `.define("VIEW_INSPECTOR_MAC_FIXED")`
- **When fixed**: Uncomment the define line to enable macOS support

## Updated Test Files

### Components (2 files)
1. `Development/Tests/SixLayerFrameworkTests/Components/FormCallbackFunctionalTests.swift`
2. `Development/Tests/SixLayerFrameworkTests/Components/Views/AdaptiveDetailViewRenderingTests.swift`

### Core Architecture (5 files)
3. `Development/Tests/SixLayerFrameworkTests/Core/Architecture/FrameworkComponentGlobalConfigTests.swift`
4. `Development/Tests/SixLayerFrameworkTests/Core/Architecture/GlobalDisableLocalEnableTests.swift`
5. `Development/Tests/SixLayerFrameworkTests/Core/Architecture/MetalRenderingCrashTests.swift`
6. `Development/Tests/SixLayerFrameworkTests/Core/Architecture/TestPatterns.swift`
7. `Development/Tests/SixLayerFrameworkTests/Core/Views/ViewGenerationIntegrationTests.swift`

### Core Views (3 files)
8. `Development/Tests/SixLayerFrameworkTests/Core/Views/ViewGenerationTests.swift`
9. `Development/Tests/SixLayerFrameworkTests/Core/Views/ViewGenerationVerificationTests.swift`
10. `Development/Tests/SixLayerFrameworkTests/Core/Views/ViewGenerationIntegrationTests.swift`

### Accessibility (10 files)
11. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityGlobalLocalConfigTests.swift`
12. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityIdentifierDisabledTests.swift`
13. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityIdentifierEdgeCaseTests.swift`
14. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityIdentifierGenerationTests.swift`
15. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityIdentifierGenerationVerificationTests.swift`
16. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AccessibilityIdentifierPersistenceTests.swift`
17. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/AutomaticAccessibilityIdentifierTests.swift`
18. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/ComponentLabelTextAccessibilityTests.swift`
19. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/DynamicFormViewComponentAccessibilityTests.swift`
20. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/PlatformPhotoComponentsLayer4AccessibilityTests.swift`
21. `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/SimpleAccessibilityTests.swift`

### Collections (2 files)
22. `Development/Tests/SixLayerFrameworkTests/Features/Collections/CollectionViewCallbackTests.swift`
23. `Development/Tests/SixLayerFrameworkTests/Features/Collections/IntelligentCardExpansionLayer6Tests.swift`

### Forms (3 files)
24. `Development/Tests/SixLayerFrameworkTests/Features/Forms/DynamicFieldComponentsTDDTests.swift`
25. `Development/Tests/SixLayerFrameworkTests/Features/Forms/DynamicFormViewTests.swift`
26. `Development/Tests/SixLayerFrameworkTests/Features/Forms/FormWizardViewTDDTests.swift`

### Images (1 file)
27. `Development/Tests/SixLayerFrameworkTests/Features/Images/PhotoComponentsLayer4Tests.swift`

### Intelligence (1 file)
28. `Development/Tests/SixLayerFrameworkTests/Features/Intelligence/IntelligentDetailViewSheetTests.swift`

### Navigation (1 file)
29. `Development/Tests/SixLayerFrameworkTests/Features/Navigation/NavigationLayer4Tests.swift`

### OCR (2 files)
30. `Development/Tests/SixLayerFrameworkTests/Features/OCR/OCRComponentsTDDTests.swift`
31. `Development/Tests/SixLayerFrameworkTests/Features/OCR/OCRDisambiguationTests.swift`

### Platform (1 file)
32. `Development/Tests/SixLayerFrameworkTests/Features/Platform/PlatformPresentContentL1Tests.swift`

### Integration (1 file)
33. `Development/Tests/SixLayerFrameworkTests/Integration/CrossPlatform/CrossPlatformOptimizationLayer6Tests.swift`

### Layers (4 files)
34. `Development/Tests/SixLayerFrameworkTests/Layers/Layer1CallbackFunctionalTests.swift`
35. `Development/Tests/SixLayerFrameworkTests/Layers/Layer4FormContainerTests.swift`
36. `Development/Tests/SixLayerFrameworkTests/Layers/Layer5-Platform/Layer5PlatformComponentTDDTests.swift`
37. `Development/Tests/SixLayerFrameworkTests/Layers/LocalEnableOverrideTests.swift`

### Utilities (1 file)
38. `Development/Tests/SixLayerFrameworkTests/Utilities/Debug/EnvironmentVariableDebugTests.swift`

## Implementation Pattern

All files now use one of these patterns:

### Pattern 1: Using `withInspectedView()` wrapper
```swift
#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
let inspectionResult = withInspectedView(view) { inspected in
    // ViewInspector-specific code here
    let button = try inspected.button()
    return try button.accessibilityIdentifier()
}
#else
Issue.record("ViewInspector not available on this platform")
#endif
```

### Pattern 2: Using `tryInspect()` extension
```swift
#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
if let inspectedView = view.tryInspect(),
   let buttonID = try? inspectedView.accessibilityIdentifier() {
    // Test assertions here
}
#else
Issue.record("ViewInspector not available on this platform")
#endif
```

## Benefits

1. **Single point of control**: Change one line in `Package.swift` to enable macOS support
2. **No manual file updates**: All test files automatically work when flag is enabled
3. **Centralized logic**: ViewInspector platform differences handled in one wrapper file
4. **Type safety**: Wrapper functions handle `Any` vs `InspectableView` type differences
5. **Easy migration**: When ViewInspector is fixed, uncomment one line

## Related Files

- **ViewInspector Issue**: https://github.com/nalexn/ViewInspector/issues/405
- **Wrapper Implementation**: `Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/ViewInspectorWrapper.swift`
- **Package Configuration**: `Package.swift` (swiftSettings section)

