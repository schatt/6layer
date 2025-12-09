# SixLayer Framework v6.1.1 Release Documentation

**Release Date**: December 8, 2025  
**Release Type**: Patch (Color.named() Extensions)  
**Previous Release**: v6.1.0  
**Status**: ✅ **COMPLETE**

---

## 🎯 Release Summary

Patch release extending `Color.named()` API to support `systemBackground` and other commonly used color names. Adds convenience method `Color.named(_:default:)` that returns a non-optional Color with a fallback, preventing compiler type-checking issues when chaining optionals.

---

## 🆕 New Features

### **🎨 Color.named() Extensions (Issue #94)**

#### **systemBackground Support**
- Added `systemBackground` to `ColorName` enum
- Maps to `Color.backgroundColor` for platform-appropriate background colors
- Resolves issue where projects couldn't access system background via `Color.named()`

#### **Additional Color Names**
- Added `cardBackground` - Maps to `Color.cardBackground`
- Added `label` - Maps to `Color.label`
- Added `secondaryLabel` - Maps to `Color.secondaryLabel`
- Added `tertiaryLabel` - Maps to `Color.platformTertiaryLabel`
- Added `separator` - Maps to `Color.separator`

#### **Convenience Method**
- Added `Color.named(_:default:)` method that returns a non-optional `Color`
- Provides fallback color when named color is not found
- Prevents compiler type-checking timeouts when chaining multiple optionals
- Example: `Color.named("background", default: Color.backgroundColor)`

---

## 🐛 Bug Fixes

### **Compiler Type-Checking Issues**
- Fixed compiler type-checking timeouts when using `Color.named()` with multiple optional chains
- The new `named(_:default:)` method eliminates the need for complex optional chaining
- Example fix: `Color.named("background") ?? Color.named("systemBackground") ?? .background` → `Color.named("background", default: Color.backgroundColor)`

---

## 📝 API Changes

### **New Methods**
```swift
// New convenience method with default fallback
static func named(_ colorName: String?, default: Color) -> Color
```

### **New Color Names Supported**
- `systemBackground` - Maps to `Color.backgroundColor`
- `cardBackground` - Maps to `Color.cardBackground`
- `label` - Maps to `Color.label`
- `secondaryLabel` - Maps to `Color.secondaryLabel`
- `tertiaryLabel` - Maps to `Color.platformTertiaryLabel`
- `separator` - Maps to `Color.separator`

---

## ✅ Testing

- Added comprehensive tests for new color name mappings
- Added tests for `named(_:default:)` convenience method
- Added tests for all system colors (red, blue, green, etc.)
- All existing tests continue to pass

---

## 🔄 Migration Guide

### **Before (v6.1.0)**
```swift
// Complex optional chaining causing type-checking issues
.background(Color.named("background") ?? Color.named("systemBackground") ?? .background)
```

### **After (v6.1.1)**
```swift
// Simple, non-optional with default fallback
.background(Color.named("background", default: Color.backgroundColor))

// Or use systemBackground directly
.background(Color.named("systemBackground") ?? Color.backgroundColor)
```

---

## 📦 Dependencies

No dependency changes in this release.

---

## 🔗 Related Issues

- **Issue #94**: Add support for SwiftUI semantic background colors via Color.named()

---

## 📚 Documentation

- Updated `Color.named()` documentation to include new color names
- Added examples for `named(_:default:)` convenience method
- Updated API reference with new color name mappings

---

## 🙏 Acknowledgments

This patch release addresses compiler type-checking issues reported by projects using `Color.named()` and extends the API to support commonly requested color names.
