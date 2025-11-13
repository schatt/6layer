# SixLayer Framework v5.0.1 Release Notes

## 🐛 Bug Fixes and Improvements

### CardDisplayHelper Priority Order Fix

**Fixed**: Corrected the priority order for content extraction in `CardDisplayHelper` to improve reflection-based discovery.

**Previous Behavior (v5.0.0)**:
1. Hints → CardDisplayable → Reflection → nil

**New Behavior (v5.0.1)**:
1. Hints → Reflection → CardDisplayable → nil

**Impact**: This change improves automatic content discovery by trying reflection before falling back to `CardDisplayable` protocol. Items that don't conform to `CardDisplayable` but have meaningful properties (like `title`, `name`, `description`) will now be discovered via reflection before checking the protocol.

**Migration**: No code changes required. If you were relying on `CardDisplayable` being checked before reflection, you may see different results for items that have both reflection-discoverable properties and `CardDisplayable` conformance. In most cases, this will provide better results.

### Hints Default Values Implementation Fix

**Fixed**: Default values in hints now properly work when properties are `nil`, empty strings, or have invalid types.

**What Was Fixed**:
- Default values now correctly apply when hint properties are `nil`
- Default values now correctly apply when hint properties are empty strings
- Default values now correctly apply when hint properties have non-matching types (e.g., `Int` instead of `String`)
- Default values now correctly apply when hint properties don't exist

**Example**:
```swift
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",        // Property is nil
        "itemTitleDefault": "Untitled Task"  // Now correctly used
    ]
)
```

**Impact**: Default values now work as documented. Previously, defaults might not have been used in all scenarios where they should have been.

### Test Infrastructure Improvements

**Improved**: Enhanced callback testing approach in unit tests.

**What Changed**:
- Unit tests now directly test callback functions to verify they work correctly
- API signature verification ensures callbacks accept correct parameter types
- Tests assume SwiftUI will correctly invoke callbacks during UI interactions

**Impact**: Internal testing improvements. No user-facing changes.

## 📚 Documentation Updates

- Updated priority order documentation to reflect the corrected order
- Clarified default values behavior in edge cases

## 🔧 Technical Details

### Priority Order (v5.0.1)

1. **Priority 1**: Hint Property Extraction
   - Uses property specified in `itemTitleProperty`, `itemSubtitleProperty`, etc.
   - Checks if property exists and extracts value
   - Returns `nil` if property exists but is `nil`/empty (unless default provided)

2. **Priority 1.5**: Default Values
   - Uses `itemTitleDefault`, `itemSubtitleDefault`, etc. when hint property fails
   - Applies when property is `nil`, empty, wrong type, or doesn't exist

3. **Priority 2**: Reflection Discovery
   - Uses reflection to find common property names (`title`, `name`, `description`, etc.)
   - Only used when no hints provided or hint properties don't exist

4. **Priority 3**: CardDisplayable Protocol
   - Falls back to `CardDisplayable` protocol conformance
   - Only used when reflection fails to find meaningful content

5. **Priority 4**: nil
   - Returns `nil` when no meaningful content found
   - UI layer handles `nil` with appropriate placeholders

## 🧪 Testing

- All test suites passing
- Enhanced callback testing coverage
- Improved test reliability

## 📦 Compatibility

- **Backward Compatible**: Yes
- **Breaking Changes**: None
- **Migration Required**: No

---

**Version**: 5.0.1  
**Release Date**: November 13, 2025  
**Previous Version**: 5.0.0

