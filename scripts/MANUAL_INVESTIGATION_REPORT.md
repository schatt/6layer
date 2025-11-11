# Manual Investigation Report - Remaining Accessibility Components

## Summary
- **3 components** where modifiers are reported missing (but components exist)
- **131 components** not found in framework at all

## Category 1: Components with Missing Modifiers (3)

### 1. NamedModifier
**Status:** ❌ Modifier not found  
**Location:** `Framework/Sources/Extensions/Accessibility/AutomaticAccessibilityIdentifiers.swift:403`

**Analysis:**
- This is a `ViewModifier` that applies accessibility identifiers to content
- It doesn't need `.automaticAccessibilityIdentifiers()` itself because it IS the modifier
- The test checks if views using `.named()` get identifiers, not if NamedModifier has one
- **Action:** Test is checking the wrong thing - should verify views using NamedModifier get identifiers

### 2. PlatformNavigation  
**Status:** ❌ Modifier not found  
**Location:** `Framework/Sources/Extensions/Accessibility/AppleHIGComplianceModifiers.swift`

**Analysis:**
- Test looks for component named "PlatformNavigation"
- Actual component is `platformNavigation()` function in `PlatformNavigationLayer4.swift:16`
- Function DOES have modifier at line 29: `.automaticAccessibilityIdentifiers(named: "platformNavigation")`
- **Action:** Name mismatch - test should look for "platformNavigation" (lowercase) or script needs better matching

### 3. RuntimeCapabilityDetection
**Status:** ❌ Modifier not found  
**Location:** `Framework/Sources/Components/Views/RuntimeCapabilityDetectionView.swift`

**Analysis:**
- Test looks for "RuntimeCapabilityDetection"
- Actual struct is "RuntimeCapabilityDetectionView" 
- Struct DOES have modifier at line 43: `.automaticAccessibilityIdentifiers(named: "RuntimeCapabilityDetectionView")`
- **Action:** Name mismatch - test expects "RuntimeCapabilityDetection" but struct is "RuntimeCapabilityDetectionView"

## Category 2: Components Not Found in Framework (131)

These appear to be:
1. **Test-only components** - Created in tests, not framework code
2. **Utility classes** - Helper classes, not Views
3. **Test helper functions** - Functions that create test views
4. **Name mismatches** - Tests looking for wrong names

### Examples:
- `AccessibilityIdentifierValidation` - Likely a test helper class
- `AccessibilityIdentifierPatternMatching` - Test utility
- `AccessibilityIdentifierExactMatching` - Test utility
- `AccessibilityEnhancedView` - Test-only view
- `AccessibilityHostingView` - Test helper

## Recommendations

### For Category 1 (3 components):
1. **NamedModifier** - Fix test to check if views using NamedModifier get identifiers
2. **PlatformNavigation** - Update script to handle function name matching (platformNavigation vs PlatformNavigation)
3. **RuntimeCapabilityDetection** - Update script to handle name variations (RuntimeCapabilityDetection vs RuntimeCapabilityDetectionView)

### For Category 2 (131 components):
1. **Investigate each** - Check if they're test-only or actually missing
2. **If test-only** - Update tests to not expect framework components
3. **If missing** - Add modifiers to actual framework components
4. **If name mismatch** - Fix test names or improve script matching

## Next Steps
1. Fix the 3 name mismatches in script
2. Sample 10-20 of the 131 missing components to understand pattern
3. Create categorization script to auto-classify remaining components

