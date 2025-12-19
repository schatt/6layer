# Bundle Identifier Fix for SixLayerFramework

## Status: ✅ Resolved in v6.6.1

The bundle identifier issue has been **permanently fixed** in v6.6.1. No workarounds or fix scripts are needed.

## What Was Fixed

### v6.6.1 Changes

1. **Bundle.module Support**: Updated `InternationalizationService` to use `Bundle.module` for Swift Package builds with proper conditional compilation
2. **CFBundleName Correction**: Fixed `CFBundleName` in Info.plist from `SixLayerFramework_SixLayerFramework` to `SixLayerFramework` (proper display name)
3. **Repository Rename**: Repository renamed from `6layer` to `sixlayer` to align with package naming conventions

## For Users

**No action required** - The fix is built into v6.6.1 and later versions. Simply update to v6.6.1 or later:

```swift
dependencies: [
    .package(url: "https://github.com/schatt/sixlayer.git", from: "6.6.1")
]
```

## Historical Context

Previously, SPM could generate invalid bundle identifiers (e.g., `-layer.SixLayerFramework.resources`) when the repository name didn't match package naming conventions. This has been resolved by:
- Using proper `Bundle.module` access for Swift Package builds
- Correcting the `CFBundleName` in the framework's Info.plist
- Aligning repository and package naming

## Previous Workarounds (No Longer Needed)

If you were using fix scripts or manual workarounds, you can remove them. The framework now handles bundle access correctly out of the box.
