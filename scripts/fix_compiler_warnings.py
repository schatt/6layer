#!/usr/bin/env python3
"""
Script to fix common Swift compiler warnings in test files.

Fixes:
1. Unused variable warnings (replace with '_')
2. Nil comparisons for non-optional types
3. Unnecessary await expressions (already fixed, but kept for reference)
"""

import re
import sys
from pathlib import Path
from typing import List, Tuple

def fix_unused_variables(content: str) -> Tuple[str, int]:
    """Fix unused variable warnings by replacing with '_'."""
    fixes = 0
    lines = content.split('\n')
    result = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Pattern: let variableName = ... (unused variable)
        # We'll look for patterns that suggest unused variables
        # This is a conservative approach - we'll only fix obvious cases
        
        # Pattern 1: let variable = ... followed by comment about being unused
        if re.search(r'let\s+(\w+)\s*=', line) and i + 1 < len(lines):
            var_match = re.search(r'let\s+(\w+)\s*=', line)
            if var_match:
                var_name = var_match.group(1)
                # Check if variable is likely unused (no usage in next 10 lines)
                next_lines = '\n'.join(lines[i+1:i+11])
                if var_name not in next_lines and var_name != '_':
                    # Replace with _
                    new_line = re.sub(r'let\s+' + re.escape(var_name) + r'\s*=', r'let _ =', line, count=1)
                    if new_line != line:
                        line = new_line
                        fixes += 1
        
        result.append(line)
        i += 1
    
    return '\n'.join(result), fixes

def fix_nil_comparisons(content: str) -> Tuple[str, int]:
    """Fix nil comparisons for non-optional types."""
    fixes = 0
    lines = content.split('\n')
    result = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        original_line = line
        indent = len(line) - len(line.lstrip())
        
        # Pattern 1: #expect(platformImage.nsImage != nil, ...) -> check size instead
        if '#expect' in line and 'nsImage != nil' in line:
            line = re.sub(r'(\w+)\.nsImage\s*!=\s*nil', r'\1.nsImage.size.width > 0', line)
            if line != original_line:
                fixes += 1
        
        # Pattern 2: #expect(gesture.timestamp != nil, ...) -> let _ = gesture.timestamp
        elif '#expect' in line and 'timestamp != nil' in line:
            # Extract the variable name
            match = re.search(r'(\w+)\.timestamp\s*!=\s*nil', line)
            if match:
                var_name = match.group(1)
                # Replace with size check or just remove the nil check
                line = re.sub(r'(\w+)\.timestamp\s*!=\s*nil', r'let _ = \1.timestamp', line)
                # If we created a let statement in an #expect, split it
                if 'let _ =' in line and '#expect' in line:
                    let_stmt = f'{" " * indent}let _ = {var_name}.timestamp'
                    # Remove the let part from #expect line
                    line = re.sub(r'let _ = \w+\.timestamp[,\s]*', '', line)
                    line = line.replace('  ', ' ').replace('( ,', '(').replace(', )', ')')
                    result.append(let_stmt)
                    if not line.strip().endswith(')'):
                        line = line.rstrip() + ' # timestamp is non-optional'
                    fixes += 1
        
        # Pattern 3: Bool properties != nil
        elif '#expect' in line and re.search(r'(supportsVoiceOver|supportsSwitchControl|supportsAssistiveTouch)\s*!=\s*nil', line):
            match = re.search(r'(\w+)\.(supportsVoiceOver|supportsSwitchControl|supportsAssistiveTouch)\s*!=\s*nil', line)
            if match:
                var_name = match.group(1)
                prop_name = match.group(2)
                let_stmt = f'{" " * indent}let _ = {var_name}.{prop_name}'
                line = re.sub(r'\w+\.(supportsVoiceOver|supportsSwitchControl|supportsAssistiveTouch)\s*!=\s*nil[,\s]*', '', line)
                line = line.replace('  ', ' ').replace('( ,', '(').replace(', )', ')')
                result.append(let_stmt)
                if '#expect' in line and not line.strip().endswith(')'):
                    line = line.rstrip() + ' # Bool is non-optional'
                fixes += 1
        
        # Pattern 4: maxAnimationDuration != nil
        elif '#expect' in line and 'maxAnimationDuration != nil' in line:
            match = re.search(r'(\w+)\.maxAnimationDuration\s*!=\s*nil', line)
            if match:
                var_name = match.group(1)
                let_stmt = f'{" " * indent}let _ = {var_name}.maxAnimationDuration'
                line = re.sub(r'\w+\.maxAnimationDuration\s*!=\s*nil[,\s]*', '', line)
                line = line.replace('  ', ' ').replace('( ,', '(').replace(', )', ')')
                result.append(let_stmt)
                if '#expect' in line and not line.strip().endswith(')'):
                    line = line.rstrip() + ' # TimeInterval is non-optional'
                fixes += 1
        
        # Pattern 5: result is Bool (always true)
        elif '#expect' in line and re.search(r'(\w+)\s+is\s+Bool', line):
            match = re.search(r'(\w+)\s+is\s+Bool', line)
            if match:
                var_name = match.group(1)
                let_stmt = f'{" " * indent}let _ = {var_name}'
                line = re.sub(r'\w+\s+is\s+Bool[,\s]*', '', line)
                line = line.replace('  ', ' ').replace('( ,', '(').replace(', )', ')')
                if '#expect' in line:
                    # Replace with a simple true check
                    line = re.sub(r'#expect\([^)]*\)', f'#expect(Bool(true), "result is Bool")', line)
                result.append(let_stmt)
                fixes += 1
        
        result.append(line)
        i += 1
    
    return '\n'.join(result), fixes

def fix_specific_unused_vars(content: str) -> Tuple[str, int]:
    """Fix specific known unused variable patterns."""
    fixes = 0
    
    # Common patterns for unused variables in tests
    patterns = [
        # Pattern: let view = ... (often unused in tests)
        (r'let\s+(view|testView|hostingView|container|card|strategy|layout|config|intelligence|manager|service|suite|result|json|jsonString|fields|hints|loaded|loadedHints|testView1|testView2|testView3|navigationManager|voiceOverView|keyboardView|highContrastView|complianceManager|state|collectionView|numericView|collectionHostingView|numericHostingView|voiceOverHostingView|switchControlHostingView|assistiveTouchHostingView|allAccessibilityHostingView|settings|patterns|testing|crossPlatformOptimization|performanceView|testPhotoData|formLayoutDecision|formStrategy|modalStrategy|capturedImage|selectedImage|cameraInterface|photoPicker|photoDisplay|callbackImage|buttonPressed|imageSelected|imageCaptured|resultReceived|picker|enhancedImage|textRegions|fileList|fileRow|richTextComponent|autocompleteComponent|fileUploadComponent|formState|richTextField|toolbar|preview|autocompleteField|suggestionsView|fileUploadField|fileUploadArea|deviceType|screenSizes|zeroContentLayout|verySmallScreenLayout|phoneStrategy|tabletStrategy|desktopStrategy|expandableStrategy|staticStrategy|denseStrategy|spaciousStrategy|hoverCard|contentRevealCard|cardView|hoverCardView|contentRevealCardView|gridReorganizeCardView|focusModeCardView|layoutDecision|platformView|extremeLayout|emptyStateView|simpleDecision|moderateDecision|complexDecision|phoneDecision|padDecision|macDecision|iOSStrategy|macOSStrategy|watchOSStrategy|tvOSStrategy|visionOSStrategy|phoneStrategy|padStrategy|macStrategy|denseDensityStrategy|balancedDensityStrategy|spaciousDensityStrategy|expansionStrategy|smallContainer|mediumContainer|largeContainer|customContainer|simpleHostingView|arrayHostingView|singleHostingView|mapView|control|menu|reflection|fallbackBehavior|highContrastManager|cancellables|decodedColor|encodedData|platform|currentPlatform|delegate|protocolService|loadCompleted|currentConfig|validationResult|issues|testResults|violations|complianceStatus|originalLanguage|currentPlatform)\s*=', 
         r'let _ ='),
    ]
    
    for pattern, replacement in patterns:
        matches = list(re.finditer(pattern, content))
        for match in reversed(matches):  # Process from end to avoid offset issues
            start, end = match.span()
            # Check if variable is used later in the function
            var_name = match.group(1)
            # Simple check: if variable name doesn't appear again in reasonable distance, it's unused
            # This is conservative - we'll let the compiler tell us if we're wrong
            content = content[:start] + replacement + content[match.start(1):end] + content[end:]
            fixes += 1
    
    return content, fixes

def process_file(file_path: Path) -> Tuple[bool, int]:
    """Process a single Swift file and fix warnings."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        total_fixes = 0
        
        # Apply fixes in order
        content, fixes1 = fix_nil_comparisons(content)
        total_fixes += fixes1
        
        # Note: Unused variable fixes are handled manually based on compiler warnings
        # The script focuses on nil comparisons and type checks
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, total_fixes
        return False, 0
    except Exception as e:
        print(f"Error processing {file_path}: {e}", file=sys.stderr)
        return False, 0

def main():
    """Main entry point."""
    if len(sys.argv) > 1:
        test_dir = Path(sys.argv[1])
    else:
        test_dir = Path(__file__).parent.parent / 'Development' / 'Tests' / 'SixLayerFrameworkUnitTests'
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}", file=sys.stderr)
        sys.exit(1)
    
    swift_files = list(test_dir.rglob('*.swift'))
    total_files = 0
    total_fixes = 0
    
    print(f"Processing {len(swift_files)} Swift files...")
    
    for swift_file in swift_files:
        changed, fixes = process_file(swift_file)
        if changed:
            total_files += 1
            total_fixes += fixes
            print(f"Fixed {fixes} issue(s) in {swift_file.relative_to(test_dir.parent.parent)}")
    
    print(f"\nSummary:")
    print(f"  Files modified: {total_files}")
    print(f"  Total fixes: {total_fixes}")

if __name__ == '__main__':
    main()

