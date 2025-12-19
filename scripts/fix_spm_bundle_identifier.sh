#!/bin/bash
# Fix invalid bundle identifier in SPM resource bundles
# This script corrects the malformed bundle identifier that SPM generates
# for SixLayerFramework resource bundles.
#
# Usage: Add this as a Run Script build phase in your Xcode project
# or run it manually after building.

set -e

# Default to BUILT_PRODUCTS_DIR if not set (for Xcode build phases)
BUILT_PRODUCTS_DIR="${BUILT_PRODUCTS_DIR:-${1}}"

if [ -z "${BUILT_PRODUCTS_DIR}" ]; then
    echo "Error: BUILT_PRODUCTS_DIR not set"
    echo "Usage: $0 [BUILT_PRODUCTS_DIR]"
    exit 1
fi

# Find all SixLayerFramework resource bundles
find "${BUILT_PRODUCTS_DIR}" -name "SixLayerFramework_SixLayerFramework.bundle" -type d 2>/dev/null | while read bundle_path; do
    info_plist="${bundle_path}/Info.plist"
    
    if [ -f "${info_plist}" ]; then
        # Check if bundle identifier starts with dash (invalid)
        current_id=$(plutil -extract CFBundleIdentifier raw "${info_plist}" 2>/dev/null || echo "")
        
        if [[ "${current_id}" == -* ]]; then
            echo "Fixing invalid bundle identifier: ${current_id}"
            # Set valid bundle identifier
            plutil -replace CFBundleIdentifier -string "com.sixlayer.framework.resources" "${info_plist}"
            echo "✅ Fixed bundle identifier to: com.sixlayer.framework.resources"
        fi
        
        # Also ensure CFBundleName is correct (should be "SixLayerFramework", not "SixLayerFramework_SixLayerFramework")
        current_name=$(plutil -extract CFBundleName raw "${info_plist}" 2>/dev/null || echo "")
        if [[ "${current_name}" == "SixLayerFramework_SixLayerFramework" ]]; then
            echo "Fixing bundle name: ${current_name}"
            plutil -replace CFBundleName -string "SixLayerFramework" "${info_plist}"
            echo "✅ Fixed bundle name to: SixLayerFramework"
        fi
    fi
done

echo "Bundle identifier fix complete"
