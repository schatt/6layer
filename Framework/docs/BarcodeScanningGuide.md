# Barcode Scanning Guide

## Overview

The SixLayer Framework includes comprehensive barcode scanning capabilities using Apple Vision's `VNDetectBarcodesRequest`. This complements the existing OCR functionality and provides a complete document scanning solution.

## Quick Start

### Basic Barcode Scanning

```swift
import SixLayerFramework

// Create barcode context
let context = BarcodeContext(
    supportedBarcodeTypes: [.qrCode, .code128],
    confidenceThreshold: 0.8
)

// Scan barcode from image
let barcodeView = platformScanBarcode_L1(
    image: myImage,
    context: context
) { result in
    if result.hasBarcodes {
        for barcode in result.barcodes {
            print("Barcode: \(barcode.payload)")
            print("Type: \(barcode.barcodeType.displayName)")
            print("Confidence: \(barcode.confidence)")
        }
    }
}
```

### Using BarcodeService Directly

```swift
let service = BarcodeServiceFactory.create()

do {
    let result = try await service.processImage(image, context: context)
    
    if result.hasBarcodes {
        // Process detected barcodes
        for barcode in result.barcodes {
            print("Detected: \(barcode.payload)")
        }
    }
} catch {
    print("Barcode scanning error: \(error)")
}
```

## Supported Barcode Types

### 1D Barcodes
- **EAN-8** - European Article Number 8-digit
- **EAN-13** - European Article Number 13-digit
- **UPC-A** - Universal Product Code A
- **UPC-E** - Universal Product Code E
- **Code 128** - High-density linear barcode
- **Code 39** - Alphanumeric barcode
- **Code 93** - Compact alphanumeric barcode
- **Codabar** - Self-checking numeric barcode
- **Interleaved 2 of 5** - Numeric barcode
- **ITF-14** - Interleaved Two of Five 14-digit
- **MSI Plessey** - Modified Plessey barcode (iOS 17.0+, macOS 14.0+)

### 2D Barcodes
- **QR Code** - Quick Response code
- **Data Matrix** - Two-dimensional matrix barcode
- **PDF417** - Stacked linear barcode
- **Aztec** - High-density 2D barcode

## Barcode Context Configuration

```swift
let context = BarcodeContext(
    supportedBarcodeTypes: [.qrCode, .code128, .ean13],
    confidenceThreshold: 0.8,  // Minimum confidence (0.0-1.0)
    allowsMultipleBarcodes: true,
    maxImageSize: CGSize(width: 4096, height: 4096)
)
```

### Configuration Options

- **supportedBarcodeTypes**: Array of barcode types to detect (default: all types)
- **confidenceThreshold**: Minimum confidence score (0.0-1.0, default: 0.8)
- **allowsMultipleBarcodes**: Whether to detect multiple barcodes (default: true)
- **maxImageSize**: Maximum image size for processing (optional)

## Integration with Dynamic Forms

### Adding Barcode Scanning to Form Fields

```swift
let productField = DynamicFormField(
    id: "product-barcode",
    contentType: .text,
    label: "Product Barcode",
    supportsBarcodeScanning: true,
    barcodeHint: "Scan product barcode",
    supportedBarcodeTypes: [.ean13, .code128]
)
```

### Barcode Field Properties

- **supportsBarcodeScanning**: Enable barcode scanning for this field
- **barcodeHint**: Accessibility hint for barcode scanning
- **supportedBarcodeTypes**: Specific barcode types to accept
- **barcodeFieldIdentifier**: Custom identifier for mapping results

### Example: Product Entry Form

```swift
let formConfig = DynamicFormConfiguration(
    id: "product-form",
    title: "Product Entry",
    sections: [
        DynamicFormSection(
            id: "product-info",
            title: "Product Information",
            fields: [
                DynamicFormField(
                    id: "barcode",
                    contentType: .text,
                    label: "Barcode",
                    supportsBarcodeScanning: true,
                    barcodeHint: "Scan product barcode",
                    supportedBarcodeTypes: [.ean13, .qrCode]
                ),
                DynamicFormField(
                    id: "name",
                    contentType: .text,
                    label: "Product Name"
                )
            ]
        )
    ]
)
```

## Barcode Result Structure

```swift
public struct BarcodeResult {
    public let barcodes: [Barcode]           // Array of detected barcodes
    public let confidence: Float              // Average confidence (0.0-1.0)
    public let processingTime: TimeInterval    // Processing time in seconds
    
    public var hasBarcodes: Bool              // Whether any barcodes were found
}

public struct Barcode {
    public let payload: String                // Barcode payload string
    public let barcodeType: BarcodeType        // Type of barcode
    public let boundingBox: CGRect             // Bounding box coordinates
    public let confidence: Float              // Detection confidence (0.0-1.0)
}
```

## Error Handling

```swift
do {
    let result = try await service.processImage(image, context: context)
    // Process result
} catch BarcodeError.visionUnavailable {
    print("Vision framework not available on this platform")
} catch BarcodeError.invalidImage {
    print("Invalid or unprocessable image")
} catch BarcodeError.noBarcodeFound {
    print("No barcodes detected in image")
} catch BarcodeError.processingFailed {
    print("Barcode processing failed")
} catch BarcodeError.unsupportedPlatform {
    print("Barcode scanning not supported on this platform")
} catch {
    print("Unknown error: \(error)")
}
```

## Barcode Overlay View

Display barcode scanning results with visual overlay:

```swift
let overlayView = BarcodeOverlayView(
    image: scannedImage,
    result: barcodeResult,
    configuration: BarcodeOverlayConfiguration(
        showBoundingBoxes: true,
        showConfidenceIndicators: true,
        highlightColor: .blue,
        showBarcodeType: true,
        showPayload: true
    ),
    onBarcodeSelect: { barcode in
        // Handle barcode selection
        print("Selected: \(barcode.payload)")
    }
)
```

## Platform Support

- **iOS**: 11.0+
- **macOS**: 10.15+
- **visionOS**: 1.0+

## Capabilities Detection

```swift
let service = BarcodeServiceFactory.create()

// Check availability
if service.isAvailable {
    // Barcode scanning is available
    
    // Get capabilities
    let capabilities = service.capabilities
    print("Supported types: \(capabilities.supportedBarcodeTypes)")
    print("Max image size: \(capabilities.maxImageSize)")
}
```

## Best Practices

### 1. Specify Barcode Types
Limit detection to expected types for better performance:

```swift
let context = BarcodeContext(
    supportedBarcodeTypes: [.qrCode],  // Only QR codes
    confidenceThreshold: 0.8
)
```

### 2. Handle Multiple Barcodes
When multiple barcodes are detected, allow user selection:

```swift
if result.barcodes.count > 1 {
    // Show selection UI
    showBarcodeSelection(result.barcodes)
} else if let barcode = result.barcodes.first {
    // Use single barcode
    processBarcode(barcode)
}
```

### 3. Validate Confidence
Check confidence scores before using results:

```swift
for barcode in result.barcodes {
    if barcode.confidence >= 0.9 {
        // High confidence - use directly
        useBarcode(barcode)
    } else {
        // Lower confidence - show for verification
        showForVerification(barcode)
    }
}
```

### 4. Combine with OCR
Use both OCR and barcode scanning for complete document processing:

```swift
// Scan for barcodes
let barcodeResult = try await barcodeService.processImage(image, context: barcodeContext)

// Also perform OCR
let ocrResult = try await ocrService.processImage(image, context: ocrContext)

// Combine results
processDocument(barcodeResult: barcodeResult, ocrResult: ocrResult)
```

## Examples

### QR Code Scanner

```swift
struct QRCodeScanner: View {
    @State private var scannedCode: String?
    
    var body: some View {
        VStack {
            if let code = scannedCode {
                Text("Scanned: \(code)")
            } else {
                platformScanBarcode_L1(
                    image: capturedImage,
                    context: BarcodeContext(
                        supportedBarcodeTypes: [.qrCode],
                        confidenceThreshold: 0.9
                    )
                ) { result in
                    if let qrCode = result.barcodes.first {
                        scannedCode = qrCode.payload
                    }
                }
            }
        }
    }
}
```

### Product Barcode Lookup

```swift
func lookupProduct(barcode: String) async throws -> Product {
    // Scan barcode
    let result = try await barcodeService.processImage(image, context: context)
    
    guard let barcode = result.barcodes.first else {
        throw BarcodeError.noBarcodeFound
    }
    
    // Lookup product by barcode
    return try await productService.lookup(barcode: barcode.payload)
}
```

## Related Documentation

- [OCR Guide](OCROverlayGuide.md) - OCR functionality
- [Structured OCR Extraction](StructuredOCRExtractionGuide.md) - Structured data extraction
- [Dynamic Forms Guide](FieldHintsGuide.md) - Form field configuration
