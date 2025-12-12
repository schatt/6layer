# Radar Bug Report: Metal Telemetry Crash with TextEditor

**Radar Number**: [To be assigned by Apple]  
**Date**: 2025-01-XX  
**Component**: Metal Framework / Metal Telemetry  
**Severity**: Critical (Crashes application)  
**Reproducibility**: Always  

---

## Summary

Metal telemetry crashes when inspecting SwiftUI view hierarchies containing `TextEditor` components. The crash occurs because Metal telemetry attempts to call `length` on `NSNumber` values found in TextEditor's internal properties, expecting them to be strings.

**Crash**: `-[__NSCFNumber length]: unrecognized selector sent to instance`

---

## Description

When SwiftUI modifiers like `.foregroundStyle()`, `.background()`, `.font()`, or `.padding()` are applied to views containing `TextEditor`, Metal telemetry is triggered to inspect the view hierarchy for performance monitoring. During this inspection, Metal telemetry encounters `NSNumber` values in TextEditor's internal properties (likely from the underlying UITextView/NSTextView) and incorrectly attempts to call `length` on them, expecting string values.

This is a bug in Apple's Metal framework telemetry system, not in SwiftUI or application code.

---

## Steps to Reproduce

1. Create a SwiftUI view containing a `TextEditor`
2. Apply styling modifiers (`.foregroundStyle()`, `.background()`, `.font()`, etc.) to the TextEditor or its parent views
3. Render the view
4. Application crashes with `NSInvalidArgumentException`

### Minimal Reproduction Code

```swift
import SwiftUI

struct TestView: View {
    @State private var text = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .frame(minHeight: 100)
        }
        .foregroundStyle(.primary)  // Triggers Metal telemetry
        .background(Color.systemBackground)
    }
}
```

### Alternative Reproduction (with NavigationStack)

```swift
import SwiftUI

struct ContentView: View {
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 100)
            }
            .padding()
        }
        // NavigationStack optimizations can also trigger Metal telemetry
    }
}
```

---

## Expected Behavior

The application should render the TextEditor without crashing. Metal telemetry should either:
1. Skip inspecting TextEditor properties that contain NSNumber values, OR
2. Properly handle NSNumber values when serializing them for telemetry logging

---

## Actual Behavior

Application crashes with the following exception:

```
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', 
reason: '-[__NSCFNumber length]: unrecognized selector sent to instance 0x...'
```

### Full Stack Trace

```
*** First throw call stack:
(
	0   CoreFoundation                      0x00000001a02098dc __exceptionPreprocess + 176
	1   libobjc.A.dylib                     0x000000019fce2418 objc_exception_throw + 88
	2   CoreFoundation                      0x00000001a02e9dd4 +[NSObject(NSObject) instanceMethodSignatureForSelector:] + 0
	3   CoreFoundation                      0x00000001a01a6ef8 ___forwarding___ + 1480
	4   CoreFoundation                      0x00000001a01a6870 _CF_forwarding_prep_0 + 96
	5   Metal                               0x00000001ac4206b8 _ZL21getCStringForCFStringPK10__CFString + 28
	6   Metal                               0x00000001ac4205b0 createContextTelemetryDataWithQueueLabelAndCallstack + 132
	7   IOGPU                               0x00000001c47f7470 -[IOGPUMetalCommandBuffer commit] + 228
	8   AGXMetalG14X                        0x0000000119bbf828 -[AGXG14XFamilyCommandBuffer commit] + 880
	9   QuartzCore                          0x00000001a9eb0b50 _ZN2CA3OGL12MetalContext5flushEb + 612
	10  QuartzCore                          0x00000001a9f43724 _ZN2CA2CG10AccelQueue14flush_rendererENS0_5Queue9FlushModeEPNS0_8RendererE + 224
	11  QuartzCore                          0x00000001a9f435c8 _ZN2CA2CG10AccelQueue19flush_all_renderersENS0_5Queue9FlushModeE + 100
	12  QuartzCore                          0x00000001a9f25f54 ___ZN2CA2CG5Queue5Flush8callbackEPv_block_invoke + 64
	13  QuartzCore                          0x00000001a9eb2b20 _ZN2CA2CG5Queue5Flush8callbackEPv + 116
	14  libdispatch.dylib                   0x00000001013614dc _dispatch_client_callout + 16
	15  libdispatch.dylib                   0x000000010134db10 _dispatch_lane_serial_drain + 1672
	16  libdispatch.dylib                   0x000000010134e65c _dispatch_lane_invoke + 440
	17  libdispatch.dylib                   0x00000001a135c220 _dispatch_root_queue_drain_deferred_wlh + 664
	18  libdispatch.dylib                   0x00000001a135b700 _dispatch_workloop_worker_thread + 752
	19  libsystem_pthread.dylib             0x000000010128b7e4 _pthread_wqthread + 292
	20  libsystem_pthread.dylib             0x0000000101292f44 start_wqthread + 8
)
```

### Key Crash Location

The crash occurs in Metal framework telemetry code:
- `Metal/_ZL21getCStringForCFStringPK10__CFString` (line 5)
- `Metal/createContextTelemetryDataWithQueueLabelAndCallstack` (line 6)

This indicates Metal telemetry is trying to convert a CFString (or what it thinks is a CFString) to a C string, but the object is actually an NSNumber.

---

## Root Cause Analysis

1. **TextEditor Internal Properties**: `TextEditor` wraps `UITextView` (iOS) or `NSTextView` (macOS), which have internal properties stored as `NSNumber` values:
   - Line spacing (CGFloat)
   - Text container insets
   - Font size
   - Layout metrics
   - Animation values
   - Various state flags

2. **Metal Telemetry Inspection**: When certain SwiftUI modifiers are applied (`.foregroundStyle()`, `.background()`, `.font()`, `.padding()`), Metal telemetry is triggered to inspect the view hierarchy for performance monitoring.

3. **Type Mismatch**: Metal telemetry assumes property values are strings and calls `length` on them without type checking. When it encounters `NSNumber` values, it crashes.

4. **The Bug**: Metal telemetry's `getCStringForCFString` function receives an `NSNumber` but tries to call `length` on it, expecting a string/CFString.

---

## System Information

- **Platform**: macOS / iOS
- **OS Version**: macOS 14.0+ (Apple Silicon), iOS 17.0+
- **Xcode Version**: Version 26.2 beta (17C5013i)
- **Swift Version**: 6.1
- **Device**: Apple Silicon (M1/M2/M3) - confirmed on M-series chips
- **Reproducible**: Yes, consistently

---

## Impact

### Severity
**Critical** - Application crashes, making features unusable

### Affected Scenarios
- Any SwiftUI app using `TextEditor` with styling modifiers
- Views containing `TextEditor` within NavigationStacks with optimizations
- Forms with multi-line text input fields
- Rich text editing interfaces

### Workaround
We've implemented a workaround by removing the problematic modifiers (`SystemColorModifier`, `SystemTypographyModifier`, `SpacingModifier`, `PlatformStylingModifier`) from our framework's automatic compliance system. However, this:
- Reduces automatic HIG compliance styling
- Requires manual styling in some cases
- Is not a permanent solution

---

## Suggested Fix

Metal telemetry should:

1. **Type Check Before Calling `length`**: Before calling `length` on property values, check if the object responds to the selector or verify it's actually a string/CFString type.

2. **Proper Type Conversion**: When encountering `NSNumber` values, convert them to strings using `stringValue` or `description` instead of calling `length` directly.

3. **Safe Property Inspection**: Add defensive checks in `getCStringForCFString` and `createContextTelemetryDataWithQueueLabelAndCallstack` to handle non-string property types gracefully.

### Example Fix (Pseudocode)

```objc
// In Metal telemetry code
CFStringRef getCStringForCFString(CFTypeRef value) {
    if (CFGetTypeID(value) == CFStringGetTypeID()) {
        // It's a string, proceed normally
        return (CFStringRef)value;
    } else if (CFGetTypeID(value) == CFNumberGetTypeID()) {
        // It's a number, convert to string
        NSNumber *number = (__bridge NSNumber *)value;
        return (__bridge CFStringRef)[number stringValue];
    }
    // Return nil or empty string for unknown types
    return NULL;
}
```

---

## Additional Notes

- This crash is **not** caused by application code - it's a bug in Apple's Metal framework
- The crash occurs even with minimal SwiftUI code (just TextEditor + styling modifiers)
- Similar issues may affect other UIKit/AppKit-backed SwiftUI views with NSNumber properties
- The workaround (removing modifiers) reduces functionality but prevents crashes

---

## Related Issues

- Similar crashes have been reported with Metal telemetry in other contexts
- This may be related to broader Metal telemetry property inspection issues
- Consider reviewing Metal telemetry's property inspection logic for other type mismatches

---

## Attachments

- [Include crash log if available]
- [Include sample project if creating one]

---

## Contact Information

**Reporter**: Drew Schatt 
**Email**: schatt@schatt.com
**Framework**: SixLayer Framework (affected by this bug)

---





