# Structured OCR Data Extraction Guide

## Overview

The SixLayer Framework now includes powerful structured OCR data extraction capabilities that allow you to extract specific data fields from documents using regex patterns and intelligent hints. This feature is designed to work seamlessly with the existing OCR infrastructure while maintaining the 6-layer architecture principles.

## 🚀 Quick Start

### Basic Usage

```swift
import SixLayerFramework

// Create a context for fuel receipt extraction
let context = OCRContext(
    textTypes: [.price, .stationName, .quantity, .unit],
    language: .english,
    confidenceThreshold: 0.8,
    extractionHints: [:],
    requiredFields: ["price", "gallons"],
    documentType: .fuelReceipt,
    extractionMode: .automatic
)

// Extract structured data
let view = platformExtractStructuredData_L1(image: fuelReceiptImage, context: context) { result in
    print("Extracted data: \(result.structuredData)")
    print("Confidence: \(result.extractionConfidence)")
    print("Missing fields: \(result.missingRequiredFields)")
}
```

## 📋 Document Types

The framework supports several specialized document types with built-in patterns:

### Fuel Receipts
```swift
let context = OCRContext(
    textTypes: [.price, .stationName, .quantity, .unit],
    documentType: .fuelReceipt,
    extractionMode: .automatic
)
```

**Built-in patterns:**
- `price`: `\$?\d+\.?\d*` - Price values
- `gallons`: `(\d+\.?\d*)\s*(?:gallons?|gal)` - Fuel quantity
- `station`: `Station:\s*([A-Za-z0-9\s]+)` - Station name

### ID Documents
```swift
let context = OCRContext(
    textTypes: [.name, .idNumber, .date, .address],
    documentType: .idDocument,
    extractionMode: .automatic
)
```

**Built-in patterns:**
- `name`: `Name:\s*([A-Za-z\s]+)` - Full name
- `idNumber`: `ID:\s*([A-Z0-9-]+)` - ID number
- `expiryDate`: `Exp:\s*(\d{2}/\d{2}/\d{4})` - Expiration date

### Medical Records
```swift
let context = OCRContext(
    textTypes: [.name, .date, .number],
    documentType: .medicalRecord,
    extractionMode: .automatic
)
```

### Legal Documents
```swift
let context = OCRContext(
    textTypes: [.name, .date, .address],
    documentType: .legalDocument,
    extractionMode: .automatic
)
```

## 🎯 Text Types

The framework includes 13 new structured text types for precise data extraction:

### Personal Information
- `.name` - Full names and personal identifiers
- `.idNumber` - ID numbers, SSN, passport numbers
- `.address` - Street addresses and locations

### Financial Data
- `.price` - Monetary values and prices
- `.total` - Total amounts and sums
- `.currency` - Currency codes and symbols
- `.percentage` - Percentage values

### Business Information
- `.vendor` - Company and vendor names
- `.stationName` - Gas station and business names

### Temporal Data
- `.date` - Dates in various formats
- `.expiryDate` - Expiration dates

### Quantitative Data
- `.quantity` - Numeric quantities
- `.unit` - Units of measurement
- `.number` - General numeric values

### Geographic Data
- `.postalCode` - ZIP codes and postal codes
- `.state` - State and province codes
- `.country` - Country names and codes

## 🔧 Extraction Modes

### Automatic Mode
Uses built-in patterns for common document types:

```swift
let context = OCRContext(
    documentType: .fuelReceipt,
    extractionMode: .automatic
)
```

### Custom Mode
Uses only your provided hints:

```swift
let context = OCRContext(
    extractionHints: [
        "customField": #"Custom:\s*([A-Za-z0-9]+)"#,
        "specialValue": #"Special:\s*(\d+)"#
    ],
    extractionMode: .custom
)
```

### Hybrid Mode
Combines built-in patterns with custom hints:

```swift
let context = OCRContext(
    documentType: .invoice,
    extractionHints: [
        "customField": #"Custom:\s*([A-Za-z0-9]+)"#
    ],
    extractionMode: .hybrid
)
```

## 📝 Custom Hints

Define custom regex patterns for specific extraction needs:

```swift
let context = OCRContext(
    extractionHints: [
        "invoiceNumber": #"Invoice\s*#:\s*([A-Z0-9-]+)"#,
        "taxAmount": #"Tax:\s*\$?(\d+\.?\d*)"#,
        "customerCode": #"Customer\s*Code:\s*([A-Z0-9]+)"#
    ],
    requiredFields: ["invoiceNumber", "taxAmount"],
    extractionMode: .custom
)
```

### Regex Pattern Guidelines

- Use named capture groups: `(?<fieldName>pattern)`
- Escape special characters: `\$` for literal dollar signs
- Use raw strings for complex patterns: `#"pattern"#`
- Test patterns with sample text before deployment

## ✅ Validation & Quality

### Required Fields
Specify which fields must be present for successful extraction:

```swift
let context = OCRContext(
    requiredFields: ["price", "date", "vendor"],
    documentType: .invoice,
    extractionMode: .automatic
)
```

### Confidence Scoring
The framework provides confidence scores for extraction quality:

```swift
let result = try await OCRService().processStructuredExtraction(image, context: context)

if result.extractionConfidence >= 0.8 {
    print("High confidence extraction")
} else {
    print("Low confidence - manual review recommended")
}
```

### Missing Fields Detection
Check which required fields were not found:

```swift
if !result.missingRequiredFields.isEmpty {
    print("Missing required fields: \(result.missingRequiredFields)")
}
```

## 🏗️ Architecture Integration

### Layer 1: Semantic Intent
The `platformExtractStructuredData_L1` function provides the semantic interface:

```swift
@ViewBuilder
public func platformExtractStructuredData_L1(
    image: PlatformImage,
    context: OCRContext,
    onResult: @escaping (OCRResult) -> Void
) -> some View
```

### Layer 2: Layout Decision Engine
Document type requirements are handled by the layout decision engine:

```swift
private func getDocumentRequirements(_ documentType: DocumentType) -> DocumentRequirements {
    switch documentType {
    case .fuelReceipt:
        return DocumentRequirements(
            requiredFields: ["price", "gallons"],
            recommendedTextTypes: [.price, .stationName, .quantity, .unit]
        )
    // ... other document types
    }
}
```

### Layer 3: Strategy Selection
Extraction strategies are selected based on document complexity and user preferences.

### Layer 4: Implementation
The `OCRService.processStructuredExtraction` method handles the core extraction logic.

## 🔄 Advanced Usage

### Batch Processing
Process multiple documents with different contexts:

```swift
let documents = [
    (image: fuelReceiptImage, context: fuelReceiptContext),
    (image: invoiceImage, context: invoiceContext),
    (image: idDocumentImage, context: idDocumentContext)
]

for (image, context) in documents {
    let result = try await OCRService().processStructuredExtraction(image, context: context)
    processExtractedData(result)
}
```

### Error Handling
Comprehensive error handling for extraction failures:

```swift
do {
    let result = try await OCRService().processStructuredExtraction(image, context: context)
    handleSuccess(result)
} catch OCRError.noTextFound {
    handleNoTextFound()
} catch OCRError.lowConfidence {
    handleLowConfidence()
} catch {
    handleGenericError(error)
}
```

### Performance Optimization
For high-volume processing, consider these optimizations:

```swift
// Use appropriate confidence thresholds
let context = OCRContext(
    confidenceThreshold: 0.7, // Lower for faster processing
    extractionMode: .automatic // Use built-in patterns for speed
)

// Process in background
Task.detached {
    let result = try await OCRService().processStructuredExtraction(image, context: context)
    await MainActor.run {
        updateUI(with: result)
    }
}
```

## 🧪 Testing

The framework includes comprehensive tests for all extraction functionality:

```swift
func testStructuredExtraction_EndToEnd() {
    let image = createTestImage()
    let context = createFuelReceiptContext()
    
    let expectation = XCTestExpectation(description: "Extraction completes")
    
    let view = platformExtractStructuredData_L1(image: image, context: context) { result in
        XCTAssertFalse(result.structuredData.isEmpty)
        XCTAssertTrue(result.isStructuredExtractionComplete)
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5.0)
}
```

## 🔧 Extensibility

### Custom Document Types
Extend the framework with new document types:

```swift
extension DocumentType {
    static let customDocument = DocumentType("custom_document")
}

// Add patterns for custom document type
extension BuiltInPatterns {
    static let customPatterns: [DocumentType: [String: String]] = [
        .customDocument: [
            "customField": #"Custom:\s*([A-Za-z0-9]+)"#,
            "specialValue": #"Special:\s*(\d+)"#
        ]
    ]
}
```

### Custom Text Types
Add new text types for specific use cases:

```swift
extension TextType {
    static let customField = TextType("custom_field")
}
```

## 📊 Best Practices

1. **Start with Automatic Mode**: Use built-in patterns for common document types
2. **Validate Required Fields**: Always specify required fields for critical data
3. **Test Patterns**: Validate regex patterns with sample documents
4. **Handle Errors Gracefully**: Implement proper error handling and fallbacks
5. **Monitor Confidence**: Use confidence scores to determine data quality
6. **Optimize for Performance**: Choose appropriate extraction modes for your use case

## 🚀 Migration from Basic OCR

If you're migrating from basic OCR to structured extraction:

```swift
// Old approach
let result = try await OCRService().processImage(image, context: basicContext)
let text = result.extractedText

// New approach
let result = try await OCRService().processStructuredExtraction(image, context: structuredContext)
let price = result.structuredData["price"]
let vendor = result.structuredData["vendor"]
```

## 📚 Additional Resources

- [OCR Overlay Guide](OCROverlayGuide.md) - Visual text correction
- [Hints System Extensibility](HintsSystemExtensibility.md) - Custom hints and patterns
- [6-Layer Architecture](README_6LayerArchitecture.md) - Framework architecture
- [Usage Examples](README_UsageExamples.md) - Practical implementation examples

---

**Last Updated**: September 9, 2025  
**Version**: 2.6.0  
**Compatibility**: iOS 14.0+, macOS 11.0+, watchOS 7.0+, tvOS 14.0+, visionOS 1.0+
