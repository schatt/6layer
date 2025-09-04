# Function Index

- **Directory**: Framework/Sources/macOS/Views/Extensions
- **Generated**: 2025-09-04 14:21:09 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## Framework/Sources/macOS/Views/Extensions/PlatformListDetailDecisionLayer2.swift
### Internal Methods
- **L24:** ` func select(_ item: T?)`
  - *function*
- **L34:** ` func deselect()`
  - *function*
- **L20:** ` init(initialSelection: T? = nil)`
  - *function*

## Framework/Sources/macOS/Views/Extensions/PlatformMacOSOptimizationsLayer5.swift
### Public Interface
- **L66:** ` public var isMacOSOptimized: Bool`
  - *function|extension MacOSOptimizationManager*
  - *Check if macOS-specific features are available\n*
- **L71:** ` public var macOSVersion: String`
  - *function|extension MacOSOptimizationManager*
  - *Get macOS version for optimization decisions\n*

### Internal Methods
- **L46:** ` func getCurrentPerformanceStrategy() -> MacOSPerformanceStrategy`
  - *function*
  - *Get current macOS performance strategy\nReturns standard strategy for now (placeholder)\n*
- **L52:** ` func applyMacOSOptimizations()`
  - *function*
  - *Apply macOS-specific optimizations\nCurrently a no-op (placeholder)\n*

### Private Implementation
- **L42:** ` private init() {}`
  - *function*

