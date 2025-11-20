# ViewInspector fails to compile on macOS SDK 26

## Environment
- macOS SDK Version: 26.0
- Xcode Version: 26.0.1 (Build 17A400)
- Swift Version: 6.2 (swift-6.2-RELEASE)
- ViewInspector Version: 0.9.7 - 0.10.3 (tested)
- Platform: macOS

## Issue
ViewInspector fails to compile on macOS SDK 26 because it uses SwiftUI types that are iOS-only and not available on macOS.

## Compilation Errors

### VideoPlayer.swift
```
error: cannot find type 'VideoPlayer' in scope
extension VideoPlayer: SingleViewProvider {
           `- error: cannot find type 'VideoPlayer' in scope
```

### SignInWithAppleButton.swift
```
error: cannot find type 'SignInWithAppleButton' in scope
func labelType() throws -> SignInWithAppleButton.Label {
                               `- error: cannot find type 'SignInWithAppleButton' in scope
```

### Map.swift and MapAnnotation.swift
```
error: cannot find type 'MapAnnotation' in scope
error: cannot find type 'MapMarker' in scope
error: cannot find type 'MapPin' in scope
error: cannot find type 'MapUserTrackingMode' in scope
error: cannot find type 'MapInteractionModes' in scope
error: cannot find type '_DefaultAnnotatedMapContent' in scope
error: cannot find type '_MapAnnotationData' in scope
```

## Root Cause
**INVESTIGATION UPDATE**: Investigation findings show that ViewInspector builds successfully on macOS SDK 26.2 with no errors. All tested types (`VideoPlayer`, `SignInWithAppleButton`, `MapAnnotation`, `MapMarker`, `MapPin`) compile successfully on macOS SDK 26.2.

**Possible actual causes**:
- Internal SwiftUI types (`_MapAnnotationData`, `_DefaultAnnotatedMapContent`) that ViewInspector relies on may not be available on macOS
- Build configuration differences when ViewInspector is used as a dependency vs. building ViewInspector itself
- SDK version differences (26.0 vs 26.2) - issue may have been fixed in 26.2
- Conditional compilation edge cases with `canImport()` when used as a dependency

**Original claim** (may be incorrect): The SwiftUI types (`VideoPlayer`, `SignInWithAppleButton`, `Map` variants) are iOS-only and not available in macOS SDK 26. ViewInspector has conditional compilation guards for `canImport(AVKit)` and `canImport(AuthenticationServices)` but does not exclude these code paths for macOS.

## Reproduction
1. Create a Swift Package targeting macOS
2. Add ViewInspector as a test dependency
3. Attempt to build on macOS SDK 26
4. Observe compilation errors

## Proposed Solution
Add macOS exclusion guards to the affected files:

- `Sources/ViewInspector/SwiftUI/VideoPlayer.swift` - Wrap in `#if !os(macOS)`
- `Sources/ViewInspector/SwiftUI/SignInWithAppleButton.swift` - Wrap in `#if !os(macOS)`  
- `Sources/ViewInspector/SwiftUI/Map.swift` - Change guard to `#if !os(macOS) && canImport(MapKit)`
- `Sources/ViewInspector/SwiftUI/MapAnnotation.swift` - Change guard to `#if !os(macOS) && canImport(MapKit)`
- `Sources/ViewInspector/ViewSearchIndex.swift` - Conditionally exclude entries in view search index

## Impact
- Blocks tests from running on macOS
- Affects CI/CD pipelines targeting macOS
- Prevents cross-platform testing workflows

## Workaround
None available without modifying ViewInspector source code. Users must either:
1. Use iOS-only test targets
2. Exclude ViewInspector from macOS test targets
3. Use alternative testing frameworks for macOS tests

## Related
These SwiftUI view types were introduced for iOS and are not available on macOS. The `canImport` checks verify frameworks are available but don't check if the SwiftUI types exist in the SDK.

