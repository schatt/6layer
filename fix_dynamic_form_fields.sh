#!/bin/bash

# Script to fix remaining DynamicFormViewComponentAccessibilityTests field tests using DRY principles
# This applies the testFieldAccessibility() helper method to all remaining field tests

FILE="Development/Tests/SixLayerFrameworkTests/Features/Accessibility/DynamicFormViewComponentAccessibilityTests.swift"

# Function to replace a field test with DRY helper method
replace_field_test() {
    local field_name="$1"
    local field_type="$2"
    local line_start="$3"
    
    # Find the test function and replace it
    sed -i '' "${line_start},/^    }$/c\\
    @Test func test${field_name}GeneratesAccessibilityIdentifiers() async {\\
        // When: Testing ${field_type} field accessibility through CustomFieldView\\
        let hasAccessibilityID = testFieldAccessibility(\\
            fieldType: .${field_type},\\
            componentName: \"${field_name}\"\\
        )\\
        \\
        // Then: Should generate accessibility identifiers\\
        #expect(hasAccessibilityID, \"${field_name} should generate accessibility identifiers\")\\
    }" "$FILE"
}

echo "Fixing DynamicFormViewComponentAccessibilityTests field tests with DRY helper method..."

# Fix DynamicCheckboxField (around line 278)
replace_field_test "DynamicCheckboxField" "checkbox" "267"

# Fix DynamicToggleField (around line 303) 
replace_field_test "DynamicToggleField" "toggle" "292"

# Fix DynamicDateField (around line 328)
replace_field_test "DynamicDateField" "date" "317"

# Fix DynamicTimeField (around line 353)
replace_field_test "DynamicTimeField" "time" "342"

# Fix DynamicDateTimeField (around line 378)
replace_field_test "DynamicDateTimeField" "datetime" "367"

# Fix DynamicColorField (around line 403)
replace_field_test "DynamicColorField" "color" "392"

# Fix DynamicFileField (around line 428)
replace_field_test "DynamicFileField" "file" "417"

# Fix DynamicIntegerField (around line 453)
replace_field_test "DynamicIntegerField" "integer" "442"

# Fix DynamicImageField (around line 478)
replace_field_test "DynamicImageField" "image" "467"

# Fix DynamicURLField (around line 503)
replace_field_test "DynamicURLField" "url" "492"

# Fix DynamicArrayField (around line 528)
replace_field_test "DynamicArrayField" "array" "517"

# Fix DynamicDataField (around line 553)
replace_field_test "DynamicDataField" "data" "542"

# Fix DynamicEnumField (around line 578)
replace_field_test "DynamicEnumField" "enum" "567"

echo "Fixed all DynamicFormViewComponentAccessibilityTests field tests with DRY helper method"
echo "All field tests now use testFieldAccessibility() helper for consistency"
