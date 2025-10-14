//
//  OCRView.swift
//  SixLayerFramework
//
//  SwiftUI Integration Layer for OCR Service
//  Provides SwiftUI views that use the OCR service
//

import SwiftUI
import Foundation

// MARK: - OCR View

/// SwiftUI view that performs OCR processing using the OCR service
public struct OCRView: View {
    
    // MARK: - Properties
    
    let service: OCRServiceProtocol
    let image: PlatformImage
    let context: OCRContext
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    let onError: (Error) -> Void
    
    @State private var isProcessing = false
    @State private var result: OCRResult?
    @State private var error: Error?
    @State private var progress: Double = 0.0
    
    // MARK: - Initialization
    
    public init(
        service: OCRServiceProtocol = OCRServiceFactory.create(),
        image: PlatformImage,
        context: OCRContext,
        strategy: OCRStrategy,
        onResult: @escaping (OCRResult) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        self.service = service
        self.image = image
        self.context = context
        self.strategy = strategy
        self.onResult = onResult
        self.onError = onError
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if isProcessing {
                OCRProgressView(progress: progress)
            } else if let result = result {
                OCRResultView(result: result)
            } else if let error = error {
                OCRErrorView(error: error)
            } else {
                OCRImageView(image: image) {
                    startOCRProcessing()
                }
            }
        }
        .task {
            startOCRProcessing()
        }
    }
    
    // MARK: - Private Methods
    
    private func startOCRProcessing() {
        guard !isProcessing else { return }
        
        isProcessing = true
        progress = 0.0
        error = nil
        result = nil
        
        Task {
            do {
                // Capture values to avoid data races
                let capturedService = service
                let capturedContext = context
                let capturedStrategy = strategy
                
                let result = try await capturedService.processImage(image, context: capturedContext, strategy: capturedStrategy)
                await MainActor.run {
                    self.result = result
                    self.isProcessing = false
                    self.progress = 1.0
                    onResult(result)
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isProcessing = false
                    self.progress = 0.0
                    onError(error)
                }
            }
        }
    }
}

// MARK: - OCR Progress View

/// View showing OCR processing progress
public struct OCRProgressView: View {
    let progress: Double
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 200)
            
            Text("Processing OCR...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - OCR Result View

/// View displaying OCR results
public struct OCRResultView: View {
    let result: OCRResult
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OCR Results")
                .font(.headline)
            
            Text(result.extractedText)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            HStack {
                Text("Confidence: \(Int(result.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Processing Time: \(String(format: "%.2f", result.processingTime))s")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - OCR Error View

/// View displaying OCR errors
public struct OCRErrorView: View {
    let error: Error
    
    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("OCR Error")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - OCR Image View

/// View displaying the image to be processed
public struct OCRImageView: View {
    let image: PlatformImage
    let onTap: () -> Void
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(platformImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .cornerRadius(8)
            
            Button("Process OCR", action: onTap)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Platform Image Extension

extension Image {
    init(platformImage: PlatformImage) {
        #if os(iOS)
        self.init(uiImage: platformImage.uiImage)
        #elseif os(macOS)
        self.init(nsImage: platformImage.nsImage)
        #else
        self.init(systemName: "photo")
        #endif
    }
}

// MARK: - Legacy OCR View (Deprecated)

/// Legacy OCR view for backward compatibility
@available(*, deprecated, message: "Use OCRView with OCRService instead")
public struct LegacyOCRView: View {
    let image: PlatformImage
    let context: OCRContext
    let strategy: OCRStrategy
    let onResult: (OCRResult) -> Void
    let onError: (Error) -> Void
    
    public var body: some View {
        OCRView(
            image: image,
            context: context,
            strategy: strategy,
            onResult: onResult,
            onError: onError
        )
    }
}
