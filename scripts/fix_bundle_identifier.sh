#!/bin/bash
# Fix invalid bundle identifier in SPM resource bundles
# This script corrects the malformed bundle identifier that SPM generates

set -e

# Find all SixLayerFramework resource bundles
find "${BUILT_PRODUCTS_DIR}" -name "SixLayerFramework_SixLayerFramework.bundle" -type d | while read bundle_path; do
    info_plist="${bundle_path}/Info.plist"
    
    if [ -f "${info_plist}" ]; then
        # Check if bundle identifier starts with dash (invalid)
        current_id=$(plutil -extract CFBundleIdentifier raw "${info_plist}" 2>/dev/null || echo "")
        
        if [[ "${current_id}" == -* ]]; then
            echo "Fixing invalid bundle identifier: ${current_id}"
            # Set valid bundle identifier
            plutil -replace CFBundleIdentifier -string "com.sixlayer.framework.resources" "${info_plist}"
            echo "Fixed bundle identifier to: com.sixlayer.framework.resources"
        fi
    fi
done
