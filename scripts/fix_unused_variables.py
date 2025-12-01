#!/usr/bin/env python3
"""
Script to fix unused variable warnings by replacing with '_'.

This script processes Swift files and replaces unused variables with '_'
based on common patterns found in test files.
"""

import re
import sys
from pathlib import Path
from typing import Tuple

def fix_unused_variables_in_file(content: str, file_path: Path) -> Tuple[str, int]:
    """Fix unused variables by replacing with '_'."""
    fixes = 0
    lines = content.split('\n')
    result = []
    
    # Common variable names that are often unused in tests
    common_unused_patterns = [
        r'let\s+(view|testView|hostingView|container|card|strategy|layout|config|intelligence|manager|service|suite|result|json|jsonString|fields|hints|loaded|loadedHints|testView1|testView2|testView3|navigationManager|voiceOverView|keyboardView|highContrastView|complianceManager|state|collectionView|numericView|collectionHostingView|numericHostingView|voiceOverHostingView|switchControlHostingView|assistiveTouchHostingView|allAccessibilityHostingView|settings|patterns|testing|crossPlatformOptimization|performanceView|testPhotoData|formLayoutDecision|formStrategy|modalStrategy|capturedImage|selectedImage|cameraInterface|photoPicker|photoDisplay|callbackImage|buttonPressed|imageSelected|imageCaptured|resultReceived|picker|enhancedImage|textRegions|fileList|fileRow|richTextComponent|autocompleteComponent|fileUploadComponent|formState|richTextField|toolbar|preview|autocompleteField|suggestionsView|fileUploadField|fileUploadArea|deviceType|screenSizes|zeroContentLayout|verySmallScreenLayout|phoneStrategy|tabletStrategy|desktopStrategy|expandableStrategy|staticStrategy|denseStrategy|spaciousStrategy|hoverCard|contentRevealCard|cardView|hoverCardView|contentRevealCardView|gridReorganizeCardView|focusModeCardView|layoutDecision|platformView|extremeLayout|emptyStateView|simpleDecision|moderateDecision|complexDecision|phoneDecision|padDecision|macDecision|iOSStrategy|macOSStrategy|watchOSStrategy|tvOSStrategy|visionOSStrategy|denseDensityStrategy|balancedDensityStrategy|spaciousDensityStrategy|expansionStrategy|smallContainer|mediumContainer|largeContainer|customContainer|singleHostingView|arrayHostingView|mapView|control|menu|reflection|fallbackBehavior|highContrastManager|cancellables|decodedColor|encodedData|platform|currentPlatform|delegate|protocolService|loadCompleted|currentConfig|validationResult|issues|testResults|violations|complianceStatus|originalLanguage|captureInterface|selectionInterface|displayInterface|captureStrategy|displayStrategy)\s*=',
    ]
    
    for i, line in enumerate(lines):
        original_line = line
        
        # Skip if already using _
        if re.search(r'let\s+_\s*=', line):
            result.append(line)
            continue
        
        # Check for common unused variable patterns
        for pattern in common_unused_patterns:
            match = re.search(pattern, line, re.IGNORECASE)
            if match:
                var_name = match.group(1)
                # Check if variable is used in subsequent lines (within same function scope)
                # Simple heuristic: check next 20 lines for variable usage
                next_lines = '\n'.join(lines[i+1:min(i+21, len(lines))])
                
                # Don't count if it's in a comment or string
                if var_name not in next_lines or (var_name in next_lines and '//' in next_lines.split(var_name)[0][-50:]):
                    # Replace variable name with _
                    new_line = re.sub(r'let\s+' + re.escape(var_name) + r'\s*=', r'let _ =', line, count=1)
                    if new_line != line:
                        line = new_line
                        fixes += 1
                        break
        
        result.append(line)
    
    return '\n'.join(result), fixes

def process_file(file_path: Path) -> Tuple[bool, int]:
    """Process a single Swift file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        content, fixes = fix_unused_variables_in_file(content, file_path)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, fixes
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
    
    print(f"Processing {len(swift_files)} Swift files for unused variables...")
    print("Note: This is a conservative fix. Review changes before committing.\n")
    
    for swift_file in swift_files:
        changed, fixes = process_file(swift_file)
        if changed:
            total_files += 1
            total_fixes += fixes
            print(f"Fixed {fixes} unused variable(s) in {swift_file.relative_to(test_dir.parent.parent)}")
    
    print(f"\nSummary:")
    print(f"  Files modified: {total_files}")
    print(f"  Total fixes: {total_fixes}")
    print("\nPlease review the changes and run tests to ensure nothing broke.")

if __name__ == '__main__':
    main()

