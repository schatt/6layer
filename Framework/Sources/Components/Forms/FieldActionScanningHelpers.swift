import SwiftUI
import Foundation

// MARK: - Field Action Scanning Helpers

/// Helper view for barcode scanning workflow in field actions
/// Presents image picker, processes barcode, and returns result
@MainActor
struct FieldActionBarcodeScanner: View {
    @Binding var isPresented: Bool
    let onResult: (String?) -> Void
    let onError: (Error) -> Void
    let hint: String?
    let supportedTypes: [BarcodeType]?
    
    @State private var showImagePicker = false
    @State private var isProcessing = false
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $showImagePicker) {
                UnifiedImagePicker { image in
                    Task {
                        await processBarcode(image: image)
                    }
                }
            }
            .onAppear {
                showImagePicker = true
            }
    }
    
    private func processBarcode(image: PlatformImage) async {
        isProcessing = true
        
        do {
            let context = BarcodeContext(
                supportedBarcodeTypes: supportedTypes ?? [.qrCode, .code128],
                confidenceThreshold: 0.8
            )
            
            let service = BarcodeServiceFactory.create()
            let result = try await service.processImage(image, context: context)
            
            if let firstBarcode = result.barcodes.first {
                isPresented = false
                onResult(firstBarcode.payload)
            } else {
                isPresented = false
                onError(NSError(
                    domain: "FieldAction",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "No barcode found in image"]
                ))
            }
        } catch {
            isPresented = false
            onError(error)
        }
        
        isProcessing = false
    }
}

/// Helper view for OCR scanning workflow in field actions
/// Presents image picker, processes OCR, and returns result
@MainActor
struct FieldActionOCRScanner: View {
    @Binding var isPresented: Bool
    let onResult: (String?) -> Void
    let onError: (Error) -> Void
    let hint: String?
    let validationTypes: [TextType]?
    
    @State private var showImagePicker = false
    @State private var isProcessing = false
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $showImagePicker) {
                UnifiedImagePicker { image in
                    Task {
                        await processOCR(image: image)
                    }
                }
            }
            .onAppear {
                showImagePicker = true
            }
    }
    
    private func processOCR(image: PlatformImage) async {
        isProcessing = true
        
        do {
            let textTypes = validationTypes ?? [.general]
            let context = OCRContext(
                textTypes: textTypes,
                language: .english,
                extractionHints: [:],
                extractionMode: .automatic,
                entityName: nil
            )
            
            let service = OCRService()
            let strategy = OCRStrategy(
                supportedTextTypes: textTypes,
                supportedLanguages: [.english],
                processingMode: .standard,
                requiresNeuralEngine: false,
                estimatedProcessingTime: 1.0
            )
            
            let result = try await service.processImage(image, context: context, strategy: strategy)
            
            // Extract text from result
            let extractedText = result.extractedText
            
            isPresented = false
            onResult(extractedText)
        } catch {
            isPresented = false
            onError(error)
        }
        
        isProcessing = false
    }
}
