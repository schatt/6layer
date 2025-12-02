# SixLayer Framework - TODO List

## 🔄 Current Active Todos

**Last Updated**: December 2, 2025

### Accessibility Test Fixes (Green Phase)
- [ ] **Fix remaining failing accessibility test suites** [#31](https://github.com/schatt/6layer/issues/31) (in_progress - 72 tests fixed, ~150+ components still need attention)
  - **Note**: Many accessibility ID test failures on macOS are due to ViewInspector limitation (SwiftUI identifiers don't propagate to platform views). Tests pass on iOS simulator.
- [ ] **Fix Apple HIG Compliance Component Accessibility** (in_progress - some tests fixed, remaining issues need investigation)
- [ ] **Fix Remaining Components Accessibility** (in_progress - ~150+ components still need verification)
- [ ] **Fix Dynamic Form View Component Accessibility** (in_progress - some tests fixed with TODO comments)
- [ ] **Fix framework components missing .automaticAccessibilityIdentifiers()** (in_progress - ~150+ components need modifiers added)
  - **Note**: `.automaticCompliance()` is now the recommended modifier (includes both accessibility IDs and HIG compliance), with `.automaticAccessibilityIdentifiers()` maintained for backward compatibility

### Completed Recent Work
- [x] **Fix Intelligent Card Expansion Component Accessibility** (16 issues) ✅
- [x] **Replace ALL remaining SwiftUI types with framework components** ✅
- [x] **Verify all patterns start with SixLayer and fix any remaining wildcard patterns** ✅
- [x] **Add missing .automaticAccessibilityIdentifiers() to visionOSExpandableCardView and OCRWithVisualCorrectionWrapper** ✅
- [x] **Refactor accessibility ID generation: namespace.prefix.main.ui order, skip empty values, allow duplication** ✅
- [x] **Fix resetToDefaults() to not force framework values** ✅
- [x] **Update BaseTestClass to only set namespace (not prefix)** ✅
- [x] **Make AccessibilityIdentifierConfig injectable via environment for testing** ✅
- [x] **Fix accumulating data stores in resetToDefaults() to prevent test leakage** ✅
- [x] **Fix HintsCache to use thread-local storage for parallel test safety** ✅
- [x] **Fix static testCallCounter in AssistiveTouchManager and SwitchControlManager to use thread-local storage** ✅
- [x] **Implement factory pattern for CustomFieldRegistry to enable GREEN phase** ✅
- [x] **Wire CustomFieldRegistry into CustomFieldView rendering pipeline** ✅
- [x] **Fix CustomFieldRegistry and HintsCache to use global state in production, thread-local only in test mode** ✅

---

## PlatformImage Standardization Plan

### **Architecture: Currency Exchange Model**

**Core Principle**: Standardize on `PlatformImage` throughout the framework, with platform-specific conversions happening only at system boundaries.

**Currency Exchange Analogy**:
- **At the airport (system boundary)**: Convert `UIImage`/`NSImage` → `PlatformImage`
- **In the country (framework logic)**: Use `PlatformImage` everywhere
- **When leaving (system boundary)**: Convert `PlatformImage` → `UIImage`/`NSImage`

### **Implementation Strategy**

#### **1. Implicit Conversions for System API Returns**
```swift
// System APIs return platform-specific types
let uiImage = UIImagePickerController().image  // Returns UIImage
let nsImage = NSImage(contentsOfFile: path)   // Returns NSImage

// Implicit conversion standardizes them to PlatformImage
let platformImage = PlatformImage(uiImage)    // UIImage → PlatformImage
let platformImage = PlatformImage(nsImage)    // NSImage → PlatformImage
```

#### **2. Framework Standardization**
```swift
// All framework variables use PlatformImage
var image: PlatformImage? = nil

// System API calls use inline conversion
image = PlatformImage(UIImagePickerController().image)
image = PlatformImage(NSImage(contentsOfFile: path))

// Framework works with PlatformImage only
parent.onImageCaptured(image)
parent.onImageSelected(image)
```

#### **3. Layer 4 Implementation**
```swift
// Current (fixed)
if let image = info[.originalImage] as? UIImage {
    parent.onImageCaptured(PlatformImage(image))  // Inline conversion
}

// Future (standardized)
var image: PlatformImage? = PlatformImage(UIImagePickerController().image)
image.map { parent.onImageCaptured($0) }
```

### **Benefits**

1. **Single Responsibility**: All image operations use `PlatformImage`
2. **Consistent API**: Framework only deals with `PlatformImage`
3. **Easy Extensions**: Add PNG/JPEG/bitmap exports in one place
4. **Future-Proof**: Add new platforms by extending `PlatformImage`
5. **Clean Architecture**: Platform-specific details at boundaries only

### **Testing Strategy**

#### **Architecture Enforcement Tests**
- `PlatformImageArchitectureTests.swift` - Enforces `PlatformImage`-only usage
- `Layer4PlatformImageArchitectureTests.swift` - Verifies Layer 4 compliance
- `PlatformImageImplicitConversionTests.swift` - Tests conversion functionality

#### **Breaking Change Detection**
- `PlatformImageBreakingChangeDetectionTests.swift` - Would have caught the bug
- `TestingFailureDemonstrationTests.swift` - Shows testing gaps
- `PlatformImageFixVerificationTests.swift` - Verifies fix works

### **Migration Plan**

#### **Phase 1: Foundation (Completed)**
- ✅ Add implicit conversions `PlatformImage(UIImage)` and `PlatformImage(NSImage)`
- ✅ Fix Layer 4 breaking change with inline conversions
- ✅ Create comprehensive test suite

#### **Phase 2: Standardization (In Progress)** [#32](https://github.com/schatt/6layer/issues/32)
- ✅ Implicit conversions implemented (`PlatformImage(UIImage)` and `PlatformImage(NSImage)`)
- ✅ Layer 4 callbacks use `PlatformImage` (verified in tests)
- 🔄 Update remaining framework code to use `PlatformImage` variables consistently
- 🔄 Replace explicit conversions with inline implicit conversions where possible
- 🔄 Ensure all system API calls use `PlatformImage()` wrapper

#### **Phase 3: Enhancement (Future)** [#33](https://github.com/schatt/6layer/issues/33)
- ⏳ Add export methods to `PlatformImage` (PNG, JPEG, bitmap)
- ⏳ Add image processing methods to `PlatformImage`
- ⏳ Add metadata extraction to `PlatformImage`

### **Code Examples**

#### **Before (Platform-Specific)**
```swift
// iOS
if let image = info[.originalImage] as? UIImage {
    parent.onImageCaptured(PlatformImage(uiImage: image))
}

// macOS
if let image = NSImage(contentsOfFile: path) {
    parent.onImageSelected(PlatformImage(nsImage: image))
}
```

#### **After (Standardized)**
```swift
// Cross-platform
var image: PlatformImage? = PlatformImage(UIImagePickerController().image)
image = PlatformImage(NSImage(contentsOfFile: path))

image.map { parent.onImageCaptured($0) }
image.map { parent.onImageSelected($0) }
```

### **Success Criteria**

1. **Framework Purity**: No `UIImage`/`NSImage` variables inside framework
2. **System Boundary**: All conversions happen at system boundaries
3. **Test Coverage**: Comprehensive tests enforce architecture
4. **Breaking Change Prevention**: Tests catch API changes
5. **Single Source of Truth**: `PlatformImage` handles all image operations

---

## API Testing Strategy

### **Critical Gap Identified**

The PlatformImage breaking change bug revealed a **fundamental testing failure**: we had 253 test files but **ZERO tests that would have caught the breaking change**.

### **Root Cause Analysis**

#### **What We Were Testing (Wrong)**
```swift
// Existing tests only verified view creation
let cameraInterface = photoComponents.platformCameraInterface_L4 { _ in }
#expect(cameraInterface != nil, "View should be created")
```

#### **What We Should Have Been Testing (Right)**
```swift
// Tests should execute actual callback code
var capturedImage: PlatformImage?
let cameraInterface = photoComponents.platformCameraInterface_L4 { image in
    capturedImage = image  // This would have caught the breaking change
}

// Simulate delegate method execution
let coordinator = try cameraInterface.inspect().view(CameraView.self).actualView().makeCoordinator()
let mockInfo: [UIImagePickerController.InfoKey: Any] = [.originalImage: testUIImage]
coordinator.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: mockInfo)

#expect(capturedImage != nil, "Callback should execute")  // This would have FAILED
```

### **API Testing Requirements**

#### **1. API Signature Tests**
**Purpose**: Verify all public API signatures exist and work
**Scope**: Test existence and basic functionality of all public APIs
**Methodology**: Attempt to call each public API and assert success

```swift
@Test func testPlatformImageAllInitializersExist() {
    // Test all public initializers
    let defaultImage = PlatformImage()
    let dataImage = PlatformImage(data: imageData)
    let uiImageInit = PlatformImage(uiImage: uiImage)
    let implicitInit = PlatformImage(uiImage)  // This would have caught the breaking change
    
    #expect(defaultImage != nil)
    #expect(dataImage != nil)
    #expect(uiImageInit != nil)
    #expect(implicitInit != nil)  // Would have FAILED in 4.6.2
}
```

#### **2. Integration Tests**
**Purpose**: Test actual execution of callback functions
**Scope**: Verify callbacks work with real data flow
**Methodology**: Execute delegate methods and verify callback execution

```swift
@Test func testLayer4CallbackExecution() {
    var capturedImage: PlatformImage?
    let photoComponents = PlatformPhotoComponentsLayer4()
    
    let cameraInterface = photoComponents.platformCameraInterface_L4 { image in
        capturedImage = image  // Test actual callback execution
    }
    
    // Simulate delegate method call
    let coordinator = try cameraInterface.inspect().view(CameraView.self).actualView().makeCoordinator()
    let mockInfo: [UIImagePickerController.InfoKey: Any] = [.originalImage: testUIImage]
    coordinator.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: mockInfo)
    
    #expect(capturedImage != nil, "Callback should execute")  // Would have caught the bug
}
```

#### **3. Breaking Change Detection Tests**
**Purpose**: Detect API changes that violate semantic versioning
**Scope**: Test patterns that would break with API changes
**Methodology**: Execute exact code patterns used in production

```swift
@Test func testPlatformImageImplicitParameterBreakingChangeDetection() {
    let uiImage = createTestUIImage()
    
    // Test the EXACT pattern that was broken in 4.6.2
    let platformImage = PlatformImage(uiImage)  // This would have FAILED
    
    #expect(platformImage != nil, "Implicit parameter should work")
    #expect(platformImage.uiImage == uiImage, "Should preserve UIImage")
}
```

#### **4. Backward Compatibility Tests**
**Purpose**: Ensure old API patterns still work
**Scope**: Test deprecated APIs and migration paths
**Methodology**: Test both old and new patterns

```swift
@Test func testPlatformImageBackwardCompatibility() {
    let uiImage = createTestUIImage()
    
    // Test explicit parameter label (current API)
    let explicitInit = PlatformImage(uiImage: uiImage)
    #expect(explicitInit != nil)
    
    // Test implicit parameter (backward compatibility)
    let implicitInit = PlatformImage(uiImage)
    #expect(implicitInit != nil)
    
    // Verify both produce equivalent results
    #expect(explicitInit.uiImage == implicitInit.uiImage)
}
```

### **Testing Architecture Requirements**

#### **1. Callback Execution Testing**
- **MUST**: Execute actual callback functions, not just verify view creation
- **MUST**: Simulate delegate method calls with real data
- **MUST**: Verify callback parameters are correct types
- **MUST**: Test error handling in callbacks

#### **2. API Signature Testing**
- **MUST**: Test all public initializers exist
- **MUST**: Test all public methods work
- **MUST**: Test parameter label changes
- **MUST**: Test return type changes

#### **3. Integration Testing**
- **MUST**: Test actual data flow through components
- **MUST**: Test delegate method implementations
- **MUST**: Test callback parameter types
- **MUST**: Test error propagation

#### **4. Breaking Change Detection**
- **MUST**: Test exact production code patterns
- **MUST**: Test implicit parameter usage
- **MUST**: Test delegate method implementations
- **MUST**: Test callback execution paths

### **Implementation Strategy**

#### **Phase 1: Critical API Tests (Completed)**
- ✅ `PlatformImageAPISignatureTests.swift` - All public API signatures
- ✅ `PlatformImageBreakingChangeDetectionTests.swift` - Breaking change detection
- ✅ `TestingFailureDemonstrationTests.swift` - Testing gap demonstration
- ✅ `PlatformImageFixVerificationTests.swift` - Fix verification

#### **Phase 2: Architecture Tests (Completed)**
- ✅ `PlatformImageArchitectureTests.swift` - Architecture enforcement
- ✅ `Layer4PlatformImageArchitectureTests.swift` - Layer 4 compliance
- ✅ `PlatformImageImplicitConversionTests.swift` - Conversion testing

#### **Phase 3: Comprehensive Coverage (Pending)** [#34](https://github.com/schatt/6layer/issues/34)
- ⏳ API signature tests for all public APIs
- ⏳ Integration tests for all callback functions
- ⏳ Breaking change detection for all critical patterns
- ⏳ Backward compatibility tests for all deprecated APIs

### **Success Criteria**

1. **API Coverage**: 100% of public APIs have signature tests
2. **Callback Coverage**: 100% of callback functions have integration tests
3. **Breaking Change Detection**: Tests catch all API signature changes
4. **Backward Compatibility**: All deprecated APIs have compatibility tests
5. **Production Code Coverage**: All production code patterns are tested

### **Testing Anti-Patterns to Avoid**

#### **❌ View-Only Testing**
```swift
// BAD: Only tests view creation
let view = component.createView()
#expect(view != nil)
```

#### **❌ Mock-Based Testing**
```swift
// BAD: Uses mocks instead of real APIs
let mockImage = MockImage()
let result = component.processImage(mockImage)
```

#### **❌ Empty Callback Testing**
```swift
// BAD: Callbacks are empty, never executed
let component = Component { _ in }  // Empty callback
```

### **Testing Best Practices**

#### **✅ Real API Testing**
```swift
// GOOD: Tests real API usage
let realImage = PlatformImage(uiImage: createTestUIImage())
let result = component.processImage(realImage)
```

#### **✅ Callback Execution Testing**
```swift
// GOOD: Executes actual callbacks
var capturedData: Data?
let component = Component { data in
    capturedData = data  // Callback actually executes
}
```

#### **✅ Production Pattern Testing**
```swift
// GOOD: Tests exact production code patterns
let image = info[.originalImage] as? UIImage
let platformImage = PlatformImage(image)  // Exact production pattern
```

---

## Previous TODO Items

### **Bug Fix: PlatformImage Breaking Change (Completed)**

#### **Problem**
- `PlatformImage` initializer changed from implicit to explicit parameter labels
- Caused compilation failures in Layer 4 callbacks
- Violated semantic versioning (breaking change in minor version)

#### **Root Cause**
- Existing tests never executed the broken callback code
- Tests only verified view creation, not callback execution
- No API signature tests to catch breaking changes

#### **Solution**
- ✅ Added backward-compatible implicit conversions
- ✅ Fixed Layer 4 code to use explicit conversions
- ✅ Created comprehensive test suite that would have caught the bug
- ✅ Implemented architecture enforcement tests

#### **Tests Created**
- `PlatformImageAPISignatureTests.swift` - API signature verification
- `PlatformImageBreakingChangeDetectionTests.swift` - Breaking change detection
- `TestingFailureDemonstrationTests.swift` - Testing gap demonstration
- `PlatformImageFixVerificationTests.swift` - Fix verification
- `PlatformImageArchitectureTests.swift` - Architecture enforcement
- `Layer4PlatformImageArchitectureTests.swift` - Layer 4 compliance
- `PlatformImageImplicitConversionTests.swift` - Conversion testing

#### **Architecture Lessons**
- Framework should use `PlatformImage` as sole image type
- System boundaries should handle platform-specific conversions
- Tests must execute actual callback code, not just verify view creation
- API signature tests prevent breaking changes
- Implicit conversions enable clean system API integration
