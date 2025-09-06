# Release v2.1.1 - Cross-Platform Color Aliases

**Release Date**: September 6, 2025  
**Type**: Minor Release (Feature Addition)  
**Breaking Changes**: None  
**Compatibility**: iOS 16.0+, macOS 13.0+, tvOS 16.0+, watchOS 9.0+, visionOS 1.0+

## 🎨 New Features

### Cross-Platform Color Aliases
Added simplified color API for business logic layer that maps to platform-specific implementations.

#### Background Colors
- `Color.backgroundColor` → Maps to `Color.platformBackground`
- `Color.secondaryBackgroundColor` → Maps to `Color.platformSecondaryBackground`
- `Color.tertiaryBackgroundColor` → Maps to platform tertiary background
- `Color.groupedBackgroundColor` → Maps to `Color.platformGroupedBackground`
- `Color.secondaryGroupedBackgroundColor` → Maps to platform secondary grouped background
- `Color.tertiaryGroupedBackgroundColor` → Maps to platform tertiary grouped background

#### Foreground Colors
- `Color.foregroundColor` → Maps to `Color.platformLabel`
- `Color.secondaryForegroundColor` → Maps to `Color.platformSecondaryLabel`
- `Color.tertiaryForegroundColor` → Maps to `Color.platformTertiaryLabel`
- `Color.quaternaryForegroundColor` → Maps to `Color.platformQuaternaryLabel`
- `Color.placeholderForegroundColor` → Maps to `Color.platformPlaceholderText`

#### Other Colors
- `Color.separatorColor` → Maps to `Color.platformSeparator`
- `Color.linkColor` → Maps to platform link color

#### Custom Color Resolution
- `Color.named(_ colorName: String?) -> Color?` → Resolves color names for business logic

## 🔧 Implementation Details

### Cross-Platform Mapping
All color aliases automatically map to the appropriate platform-specific colors:

```swift
// iOS
Color.backgroundColor → Color(.systemBackground)
Color.foregroundColor → Color(.label)

// macOS  
Color.backgroundColor → Color(.windowBackgroundColor)
Color.foregroundColor → Color(.labelColor)

// Other platforms
Color.backgroundColor → Color.primary
Color.foregroundColor → Color.primary
```

### Business Logic Integration
The `Color.named()` method supports both system colors and business logic color names:

```swift
// System colors
Color.named("blue") → Color.blue
Color.named("red") → Color.red

// Business logic colors
Color.named("backgroundColor") → Color.backgroundColor
Color.named("foregroundColor") → Color.foregroundColor
```

## ✅ Verification

- **Build Status**: ✅ Successful
- **Test Status**: ✅ All 565 tests passing (25 new tests added)
- **Cross-Platform**: ✅ iOS, macOS, and other platforms tested
- **Business Logic**: ✅ ExpenseCategory integration verified
- **Backward Compatibility**: ✅ No breaking changes

## 📋 Technical Details

### Test Coverage
Added comprehensive test suite covering:
- All color alias mappings
- Cross-platform consistency
- Business logic integration
- Error handling for invalid color names
- Fallback behavior

### Performance
- Color aliases are computed properties with minimal overhead
- `Color.named()` uses efficient switch statement for resolution
- No runtime performance impact on existing code

## 🎯 Impact

### For Business Logic
- **Simplified API**: Use `Color.backgroundColor` instead of `Color.platformBackground`
- **Consistent Naming**: Aligns with business logic expectations
- **Cross-Platform**: Same API works across all platforms

### For Framework Users
- **No Breaking Changes**: Existing code continues to work
- **Enhanced Usability**: Cleaner API for color usage
- **Better Integration**: Seamless business logic color resolution

## 🔄 Migration

No migration required - this is a pure feature addition that enhances the existing API without breaking changes.

### Usage Examples

```swift
// Before (still works)
.foregroundColor(.platformLabel)
.background(Color.platformBackground)

// After (new simplified API)
.foregroundColor(.foregroundColor)
.background(Color.backgroundColor)

// Business logic color resolution
let color = Color.named("backgroundColor") ?? .blue
```

## 📚 Documentation Updates

- Updated color system documentation
- Added cross-platform color alias examples
- Enhanced business logic integration guide
- Added `Color.named()` method documentation

---

**Total Tests**: 565 (+25)  
**Test Status**: All Passing  
**Build Status**: Successful  
**Documentation**: Updated  
**Cross-Platform**: Verified
