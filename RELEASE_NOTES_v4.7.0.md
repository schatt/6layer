# Release v4.7.0 - Core Data Introspection Fix

## Summary
This release fixes critical Core Data introspection issues and improves macOS compatibility.

## 🐛 Bug Fixes

### Core Data Introspection (Issue #1 - RESOLVED)
- **Fixed**: `IntelligentDetailView` now correctly introspects Core Data managed objects
- **Root Cause**: `Mirror` cannot see `@NSManaged` properties in Core Data entities
- **Solution**: Implemented `NSEntityDescription`-based introspection for `NSManagedObject` instances
- **Impact**: Core Data entities can now be automatically displayed using `platformDetailView`

### ViewInspector macOS Compatibility (Issue #405)
- **Fixed**: ViewInspector excluded from macOS test target to prevent compilation errors
- **Root Cause**: ViewInspector uses iOS-only SwiftUI types (`VideoPlayer`, `SignInWithAppleButton`, `Map`) not available on macOS SDK 26
- **Solution**: Conditional dependency that excludes ViewInspector from macOS builds
- **Status**: Upstream issue filed on ViewInspector project

## 📝 Documented Issues

### Sheet Rendering Behavior (Issue #2 - RESOLVED)
- **Clarified**: Blank sheet rendering is not a framework bug but a SwiftUI API usage issue
- **Explanation**: Using `.sheet(isPresented:)` with optional binding inside closure causes macOS layout issues
- **Recommendation**: Use `.sheet(item:)` instead for optional data presentation
- **Status**: Documented in issue comments

## 🔧 Technical Changes

### Core Data Introspection Implementation
```swift
// NEW: Core Data-specific introspection path
public static func analyze<T>(_ data: T) -> DataAnalysisResult {
    if let managedObject = data as? NSManagedObject {
        return analyzeCoreData(managedObject)  // Uses NSEntityDescription
    }
    return analyzeWithMirror(data)  // Standard Mirror introspection
}
```

**Features**:
- Automatic detection of `NSManagedObject` instances
- Uses `NSEntityDescription` to introspect entity properties
- Proper field type inference for Core Data attribute types
- Maintains compatibility with non-Core Data objects

### Platform-Specific Dependencies
```swift
// ViewInspector only on iOS
.product(name: "ViewInspector", package: "ViewInspector", 
         condition: .when(platforms: [.iOS]))
```

## 📊 Testing

### Core Data Tests Added
- `testCoreDataEntityReturnsProperAnalysis()` - Verifies Core Data entity properties are detected
- `testCoreDataFieldTypesAreCorrect()` - Ensures proper field type inference
- `testRegularObjectsStillWorkWithMirror()` - Confirms non-Core Data objects still work

### Build Status
- ✅ Framework builds successfully on all platforms
- ✅ Core Data introspection tests pass
- ⚠️ Tests that import ViewInspector cannot run on macOS (by design)

## 🚀 Migration Guide

### No Breaking Changes
This release is fully backward compatible.

### For Core Data Users
If you were experiencing blank detail views with Core Data entities, they should now work automatically:

```swift
// Before: Would render blank
.sheet(item: $selectedTask) { task in
    IntelligentDetailView.platformDetailView(for: task)
}

// After: Works correctly with Core Data entities
.sheet(item: $selectedTask) { task in
    IntelligentDetailView.platformDetailView(for: task)
}
```

### For macOS Test Users
Tests that use ViewInspector will not compile on macOS. This is expected until ViewInspector adds macOS SDK 26 support. Use iOS test targets or tests that don't require ViewInspector.

## 📦 Dependencies

- **ViewInspector**: 0.9.7+ (iOS only)
- **Swift**: 6.0+
- **iOS**: 16.0+
- **macOS**: 13.0+

## 🔗 Related Issues

- Resolves: #1 (Core Data introspection)
- Documents: #2 (Sheet rendering - not a framework bug)
- Upstream: https://github.com/nalexn/ViewInspector/issues/405

## 👥 Contributors

- Core Data introspection fix
- Test suite updates
- macOS compatibility improvements
- Documentation updates

## 📅 Release Date

October 28, 2025

