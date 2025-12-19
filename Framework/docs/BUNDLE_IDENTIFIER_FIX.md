# Bundle Identifier Fix for SixLayerFramework

## Problem

Swift Package Manager (SPM) automatically generates bundle identifiers for resource bundles, but in some cases it generates an invalid identifier that starts with a dash (e.g., `-layer.SixLayerFramework.resources`). This causes the bundle to be marked as invalid and can prevent the framework from working correctly.

## Solution

### Option 1: Add Build Script to Your Xcode Project (Recommended)

1. Open your Xcode project
2. Select your app target
3. Go to **Build Phases**
4. Click **+** and select **New Run Script Phase**
5. Add this script:

```bash
# Fix SixLayerFramework bundle identifier
if [ -f "${SRCROOT}/../6layer/Scripts/fix_spm_bundle_identifier.sh" ]; then
    "${SRCROOT}/../6layer/Scripts/fix_spm_bundle_identifier.sh" "${BUILT_PRODUCTS_DIR}"
elif [ -f "${SRCROOT}/Scripts/fix_spm_bundle_identifier.sh" ]; then
    "${SRCROOT}/Scripts/fix_spm_bundle_identifier.sh" "${BUILT_PRODUCTS_DIR}"
fi
```

**Note:** Adjust the path to the script based on where you have the SixLayerFramework package located.

### Option 2: Manual Fix

After building, run:

```bash
plutil -replace CFBundleIdentifier -string "com.sixlayer.framework.resources" \
  "${BUILT_PRODUCTS_DIR}/SixLayerFramework_SixLayerFramework.bundle/Info.plist"
```

### Option 3: Use the Script Directly

```bash
./Scripts/fix_spm_bundle_identifier.sh "${BUILT_PRODUCTS_DIR}"
```

## What This Fixes

- Changes invalid bundle identifier from `-layer.SixLayerFramework.resources` to `com.sixlayer.framework.resources`
- Makes the bundle valid for code signing and validation
- Allows the framework to load resources correctly

## Root Cause

This is a known issue with Swift Package Manager's automatic bundle identifier generation. SPM generates bundle identifiers based on package and target names, but in some cases (particularly with package names starting with certain patterns), it generates invalid identifiers.

## Status

This is a workaround for an SPM limitation. The framework team is monitoring this issue and will update if SPM provides a better solution.
