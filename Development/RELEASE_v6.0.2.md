# 🎯 **v6.0.2 - Critical Bug Fix: Infinite Recursion Crash in Accessibility Identifiers**

**Release Date**: December 8, 2025  
**Release Type**: Patch  
**Status**: ✅ **COMPLETE**

---

## 🐛 **Critical Bug Fix**

### **🚨 Infinite Recursion Crash in Accessibility Identifier Generation**

**Problem**: Infinite recursion causing stack overflow (thousands of stack frames) in `AutomaticComplianceModifier.EnvironmentAccessor.generateIdentifier()`.

**Root Cause**: Accessing `@Published` properties (`currentViewHierarchy`, `currentScreenContext`, etc.) from `AccessibilityIdentifierConfig` during SwiftUI view body evaluation created reactive dependencies. This triggered a view update cycle that called `body` again, which called `generateIdentifier` again, creating an infinite loop.

**Solution**: Modified all `generateIdentifier` methods to capture `@Published` property values as local variables before calling the identifier generation logic. This breaks the reactive dependency chain and prevents the infinite recursion.

**Affected Components**:
- `AutomaticComplianceModifier.EnvironmentAccessor.generateIdentifier()`
- `NamedEnvironmentAccessor.generateIdentifier()`
- `ForcedEnvironmentAccessor.generateIdentifier()`

**Impact**: 
- **Severity**: Critical - caused app crashes
- **Platforms**: iOS and macOS
- **Users Affected**: All views using automatic accessibility identifier generation

**Migration**: No code changes required - upgrade to v6.0.2 to fix the crash.

---

## 📝 **Additional Changes**

- Fixed compilation error in `DynamicFieldComponentsTests` (duplicate variable definition)

---

## ✅ **Testing**

- All unit tests pass
- Crash reproduction verified and fixed
- Build verification successful

---

## 🔗 **Related Issues**

- Fixes infinite recursion crash in accessibility identifier generation

---

## 📦 **Upgrade Instructions**

Update your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", from: "6.0.2")
]
```

Or update to the specific version:

```swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", exact: "6.0.2")
]
```

---

**Previous Release**: [v6.0.1](RELEASE_v6.0.1.md)  
**Next Release**: TBD
