#!/bin/bash

# SixLayer Framework - Cosmetic Testing Pattern Detection Script
# This script identifies cosmetic testing patterns that don't catch bugs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 SixLayer Framework - Cosmetic Testing Pattern Detection${NC}"
echo "=================================================================="

# Counters
total_files=0
cosmetic_files=0
total_patterns=0

# Function to check if a file contains cosmetic patterns
check_file() {
    local file="$1"
    local pattern_count=0
    
    echo -e "\n${YELLOW}📁 Checking: $file${NC}"
    
    # Check for view creation patterns (exclude functional hosting tests)
    local view_creation=$(grep -n -i "XCTAssertNotNil.*should be created" "$file" 2>/dev/null | grep -v "hostable" | wc -l)
    if [ "$view_creation" -gt 0 ]; then
        echo -e "  ${RED}❌ View Creation: $view_creation instances${NC}"
        grep -n -i "XCTAssertNotNil.*should be created" "$file" 2>/dev/null | grep -v "hostable" | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + view_creation))
    fi
    
    # Check for config validity patterns
    local config_validity=$(grep -n -i "XCTAssertNotNil.*should be valid" "$file" 2>/dev/null | wc -l)
    if [ "$config_validity" -gt 0 ]; then
        echo -e "  ${RED}❌ Config Validity: $config_validity instances${NC}"
        grep -n -i "XCTAssertNotNil.*should be valid" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + config_validity))
    fi
    
    # Check for config existence patterns
    local config_exists=$(grep -n -i "XCTAssertNotNil.*configuration" "$file" 2>/dev/null | wc -l)
    if [ "$config_exists" -gt 0 ]; then
        echo -e "  ${RED}❌ Config Exists: $config_exists instances${NC}"
        grep -n -i "XCTAssertNotNil.*configuration" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + config_exists))
    fi
    
    # Check for result existence patterns
    local result_exists=$(grep -n -i "XCTAssertNotNil.*result" "$file" 2>/dev/null | wc -l)
    if [ "$result_exists" -gt 0 ]; then
        echo -e "  ${RED}❌ Result Exists: $result_exists instances${NC}"
        grep -n -i "XCTAssertNotNil.*result" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + result_exists))
    fi
    
    # Check for default value patterns
    local default_values=$(grep -n -i "XCTAssertTrue.*should be.*by default" "$file" 2>/dev/null | wc -l)
    if [ "$default_values" -gt 0 ]; then
        echo -e "  ${RED}❌ Default Values: $default_values instances${NC}"
        grep -n -i "XCTAssertTrue.*should be.*by default" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + default_values))
    fi
    
    # Check for default enabled patterns
    local default_enabled=$(grep -n -i "XCTAssertTrue.*should be enabled" "$file" 2>/dev/null | wc -l)
    if [ "$default_enabled" -gt 0 ]; then
        echo -e "  ${RED}❌ Default Enabled: $default_enabled instances${NC}"
        grep -n -i "XCTAssertTrue.*should be enabled" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + default_enabled))
    fi
    
    # Check for default equal patterns
    local default_equal=$(grep -n -i "XCTAssertEqual.*should be" "$file" 2>/dev/null | wc -l)
    if [ "$default_equal" -gt 0 ]; then
        echo -e "  ${RED}❌ Default Equal: $default_equal instances${NC}"
        grep -n -i "XCTAssertEqual.*should be" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + default_equal))
    fi
    
    # Check for view not nil patterns (exclude functional hosting tests)
    local view_not_nil=$(grep -n -i "XCTAssertNotNil.*view" "$file" 2>/dev/null | grep -v "hostable" | wc -l)
    if [ "$view_not_nil" -gt 0 ]; then
        echo -e "  ${RED}❌ View Not Nil: $view_not_nil instances${NC}"
        grep -n -i "XCTAssertNotNil.*view" "$file" 2>/dev/null | grep -v "hostable" | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + view_not_nil))
    fi
    
    # Check for config not nil patterns
    local config_not_nil=$(grep -n -i "XCTAssertNotNil.*config" "$file" 2>/dev/null | wc -l)
    if [ "$config_not_nil" -gt 0 ]; then
        echo -e "  ${RED}❌ Config Not Nil: $config_not_nil instances${NC}"
        grep -n -i "XCTAssertNotNil.*config" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + config_not_nil))
    fi
    
    # Check for enhanced view patterns
    local enhanced_view=$(grep -n -i "XCTAssertNotNil.*enhanced" "$file" 2>/dev/null | wc -l)
    if [ "$enhanced_view" -gt 0 ]; then
        echo -e "  ${RED}❌ Enhanced View: $enhanced_view instances${NC}"
        grep -n -i "XCTAssertNotNil.*enhanced" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + enhanced_view))
    fi
    
    # Check for platform config patterns (exclude functional hosting tests)
    local platform_config=$(grep -n -i "XCTAssertNotNil.*platform" "$file" 2>/dev/null | grep -v "hostable" | wc -l)
    if [ "$platform_config" -gt 0 ]; then
        echo -e "  ${RED}❌ Platform Config: $platform_config instances${NC}"
        grep -n -i "XCTAssertNotNil.*platform" "$file" 2>/dev/null | grep -v "hostable" | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + platform_config))
    fi
    
    # Check for test config patterns
    local test_config=$(grep -n -i "XCTAssertNotNil.*test" "$file" 2>/dev/null | wc -l)
    if [ "$test_config" -gt 0 ]; then
        echo -e "  ${RED}❌ Test Config: $test_config instances${NC}"
        grep -n -i "XCTAssertNotNil.*test" "$file" 2>/dev/null | while read -r line; do
            echo -e "    ${RED}   $line${NC}"
        done
        pattern_count=$((pattern_count + test_config))
    fi
    
    # Check for hosting controller usage (indicates functional testing)
    local hosting_usage=$(grep -c "UIHostingController\|NSHostingController" "$file" 2>/dev/null || echo "0")
    
    if [ "$pattern_count" -gt 0 ]; then
        cosmetic_files=$((cosmetic_files + 1))
        total_patterns=$((total_patterns + pattern_count))
        
        echo -e "  ${RED}🚨 COSMETIC TESTING DETECTED: $pattern_count patterns${NC}"
        
        if [ "$hosting_usage" -gt 0 ]; then
            echo -e "  ${GREEN}   ✅ Has hosting controller usage: $hosting_usage instances${NC}"
        else
            echo -e "  ${RED}   ❌ No hosting controller usage detected${NC}"
        fi
        
        return 1
    else
        echo -e "  ${GREEN}✅ No cosmetic patterns detected${NC}"
        if [ "$hosting_usage" -gt 0 ]; then
            echo -e "  ${GREEN}   ✅ Has hosting controller usage: $hosting_usage instances${NC}"
        fi
        return 0
    fi
}

# Main execution
echo -e "${BLUE}🔍 Scanning test files for cosmetic testing patterns...${NC}"

# Find all test files
test_files=$(find Development/Tests -name "*.swift" -type f | grep -v ".backup" | sort)

if [ -z "$test_files" ]; then
    echo -e "${RED}❌ No test files found in Development/Tests${NC}"
    exit 1
fi

# Check each file
cosmetic_files_list=()
for file in $test_files; do
    total_files=$((total_files + 1))
    if ! check_file "$file"; then
        cosmetic_files_list+=("$file")
    fi
done

# Summary
echo -e "\n${BLUE}📊 SUMMARY${NC}"
echo "=========="
echo -e "Total files scanned: ${BLUE}$total_files${NC}"
echo -e "Files with cosmetic patterns: ${RED}$cosmetic_files${NC}"
echo -e "Total cosmetic patterns found: ${RED}$total_patterns${NC}"

if [ "$cosmetic_files" -gt 0 ]; then
    echo -e "\n${RED}🚨 COSMETIC TESTING DETECTED IN $cosmetic_files FILES${NC}"
    echo -e "${YELLOW}These tests don't catch bugs and need to be fixed!${NC}"
    
    echo -e "\n${BLUE}📋 Files requiring fixes:${NC}"
    for file in "${cosmetic_files_list[@]}"; do
        echo -e "  ${RED}❌ $file${NC}"
    done
    
    echo -e "\n${BLUE}🔧 Next Steps:${NC}"
    echo "1. Review FUNCTIONAL_TESTING_GUIDELINES.md"
    echo "2. Update MANDATORY_TESTING_RULES.md"
    echo "3. Fix each file to use functional testing patterns"
    echo "4. Add hosting controller tests for view behavior"
    echo "5. Verify tests would catch bugs if functionality was broken"
    
    echo -e "\n${YELLOW}💡 Quick Fix Template:${NC}"
    echo "Replace: XCTAssertNotNil(view, 'should be created')"
    echo "With:    let hostingController = UIHostingController(rootView: view)"
    echo "         hostingController.view.layoutIfNeeded()"
    echo "         XCTAssertTrue(hostingController.view.isAccessibilityElement, 'should be accessibility element')"
    
    exit 1
else
    echo -e "\n${GREEN}✅ No cosmetic testing patterns detected!${NC}"
    echo -e "${GREEN}All tests appear to be functional and would catch bugs.${NC}"
    exit 0
fi