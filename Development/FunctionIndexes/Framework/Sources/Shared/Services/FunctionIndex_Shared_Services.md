# Function Index

- **Directory**: ./Framework/Sources/Shared/Services
- **Generated**: 2025-09-06 17:03:14 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## ./Framework/Sources/Shared/Services/OCRService.swift
### Public Interface
- **L113:** ` public func processImage(`
  - *function*
  - *Process an image for text recognition\n*
- **L344:** ` public func processImage(`
  - *function*
- **L361:** ` public static func create() -> OCRServiceProtocol`
  - *static function*
  - *Create an OCR service instance\n*
- **L366:** ` public static func createMock(result: OCRResult? = nil) -> OCRServiceProtocol`
  - *static function*
  - *Create a mock OCR service for testing\n*
- **L32:** ` public var errorDescription: String?`
  - *function*
- **L98:** ` public var isAvailable: Bool`
  - *function*
- **L102:** ` public var capabilities: OCRCapabilities`
  - *function*
- **L321:** ` public var capabilities: OCRCapabilities`
  - *function*
- **L76:** ` public init(`
  - *function*
- **L108:** ` public init() {}`
  - *function*
- **L333:** ` public init(mockResult: OCRResult? = nil)`
  - *function*

### Internal Methods
- **L53:** ` func processImage(`
  - *function*
  - *Process an image for text recognition\n*
- **L60:** ` var isAvailable: Bool { get }`
  - *function*
  - *Check if OCR is available on current platform\n*
- **L63:** ` var capabilities: OCRCapabilities { get }`
  - *function*
  - *Get platform-specific OCR capabilities\n*

### Private Implementation
- **L136:** ` private func performVisionOCR(`
  - *function*
- **L174:** ` private func configureVisionRequest(`
  - *function*
- **L204:** ` private func processVisionResults(`
  - *function*
- **L252:** ` private func detectTextType(_ text: String) -> TextType`
  - *function*
- **L269:** ` private func getCGImage(from image: PlatformImage) -> CGImage?`
  - *function*
- **L279:** ` private func getOCRCapabilities() -> OCRCapabilities`
  - *function*

