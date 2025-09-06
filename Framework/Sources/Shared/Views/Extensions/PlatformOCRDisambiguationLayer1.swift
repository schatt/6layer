//
//  PlatformOCRDisambiguationLayer1.swift
//  SixLayerFramework
//
//  Layer 1: Semantic Intent for OCR Disambiguation
//  Provides high-level semantic functions for OCR with disambiguation capabilities
//

import SwiftUI

// MARK: - Layer 1: Semantic Intent for OCR Disambiguation

/// Layer 1 semantic function for OCR with disambiguation capabilities
/// Determines when disambiguation is needed and provides appropriate UI
public func platformOCRWithDisambiguation_L1(
    image: PlatformImage,
    context: OCRContext,
    onResult: @escaping (OCRDisambiguationResult) -> Void
) -> some View {
    OCRDisambiguationWrapper(
        image: image,
        context: context,
        onResult: onResult
    )
}

/// Layer 1 semantic function for OCR with disambiguation and custom configuration
public func platformOCRWithDisambiguation_L1(
    image: PlatformImage,
    context: OCRContext,
    configuration: OCRDisambiguationConfiguration,
    onResult: @escaping (OCRDisambiguationResult) -> Void
) -> some View {
    OCRDisambiguationWrapper(
        image: image,
        context: context,
        configuration: configuration,
        onResult: onResult
    )
}

// MARK: - OCR Disambiguation Wrapper

/// Internal wrapper view that handles OCR processing and disambiguation logic
private struct OCRDisambiguationWrapper: View {
    let image: PlatformImage
    let context: OCRContext
    let configuration: OCRDisambiguationConfiguration
    let onResult: (OCRDisambiguationResult) -> Void
    
    @State private var isProcessing = false
    @State private var disambiguationResult: OCRDisambiguationResult?
    @State private var errorMessage: String?
    
    init(
        image: PlatformImage,
        context: OCRContext,
        configuration: OCRDisambiguationConfiguration = OCRDisambiguationConfiguration(),
        onResult: @escaping (OCRDisambiguationResult) -> Void
    ) {
        self.image = image
        self.context = context
        self.configuration = configuration
        self.onResult = onResult
    }
    
    var body: some View {
        VStack {
            if isProcessing {
                processingView
            } else if let result = disambiguationResult {
                disambiguationView(result)
            } else if let error = errorMessage {
                errorView(error)
            } else {
                initialView
            }
        }
        .onAppear {
            processImage()
        }
        .task {
            // Process immediately for testing
            if disambiguationResult == nil && !isProcessing {
                processImage()
            }
        }
    }
    
    // MARK: - Processing View
    
    private var processingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Processing OCR...")
                .font(.headline)
            
            Text("Analyzing image for text recognition")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Disambiguation View
    
    private func disambiguationView(_ result: OCRDisambiguationResult) -> some View {
        VStack {
            if result.requiresUserSelection {
                OCRDisambiguationView(result: result) { selection in
                    handleSelection(selection)
                }
            } else {
                // Auto-confirm if no disambiguation needed
                autoConfirmView
            }
        }
    }
    
    private var autoConfirmView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)
            
            Text("OCR Complete")
                .font(.headline)
            
            Text("High confidence results detected - no disambiguation needed")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("View Results") {
                // Handle viewing results
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Error View
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("OCR Error")
                .font(.headline)
            
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                processImage()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Initial View
    
    private var initialView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Ready to Process")
                .font(.headline)
            
            Text("Tap to start OCR processing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Start OCR") {
                processImage()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Processing Logic
    
    private func processImage() {
        isProcessing = true
        errorMessage = nil
        disambiguationResult = nil
        
        // Simulate OCR processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Create mock candidates based on context
            let mockCandidates = self.createMockCandidates(for: self.context)
            
            // Create disambiguation result
            let result = createDisambiguationResult(
                from: mockCandidates,
                configuration: self.configuration
            )
            
            self.isProcessing = false
            self.disambiguationResult = result
            self.onResult(result)
        }
    }
    
    private func createMockCandidates(for context: OCRContext) -> [OCRDataCandidate] {
        // This is a mock implementation - in real usage, this would call actual OCR
        var candidates: [OCRDataCandidate] = []
        
        // Generate mock candidates based on requested text types
        for textType in context.textTypes {
            switch textType {
            case .price:
                candidates.append(OCRDataCandidate(
                    text: "$12.50",
                    boundingBox: CGRect(x: 100, y: 200, width: 60, height: 20),
                    confidence: 0.95,
                    suggestedType: .price,
                    alternativeTypes: [.price, .number]
                ))
                candidates.append(OCRDataCandidate(
                    text: "$15.99",
                    boundingBox: CGRect(x: 100, y: 250, width: 60, height: 20),
                    confidence: 0.92,
                    suggestedType: .price,
                    alternativeTypes: [.price, .number]
                ))
                
            case .date:
                candidates.append(OCRDataCandidate(
                    text: "2024-01-15",
                    boundingBox: CGRect(x: 200, y: 100, width: 80, height: 20),
                    confidence: 0.88,
                    suggestedType: .date,
                    alternativeTypes: [.date, .general]
                ))
                
            case .phone:
                candidates.append(OCRDataCandidate(
                    text: "(555) 123-4567",
                    boundingBox: CGRect(x: 50, y: 150, width: 120, height: 20),
                    confidence: 0.90,
                    suggestedType: .phone,
                    alternativeTypes: [.phone, .general]
                ))
                
            case .email:
                candidates.append(OCRDataCandidate(
                    text: "john@company.com",
                    boundingBox: CGRect(x: 50, y: 180, width: 150, height: 20),
                    confidence: 0.94,
                    suggestedType: .email,
                    alternativeTypes: [.email, .general]
                ))
                
            case .number:
                candidates.append(OCRDataCandidate(
                    text: "12345",
                    boundingBox: CGRect(x: 300, y: 200, width: 50, height: 20),
                    confidence: 0.85,
                    suggestedType: .number,
                    alternativeTypes: [.number, .general]
                ))
                
            case .general:
                candidates.append(OCRDataCandidate(
                    text: "Sample Text",
                    boundingBox: CGRect(x: 50, y: 300, width: 100, height: 20),
                    confidence: 0.80,
                    suggestedType: .general,
                    alternativeTypes: [.general]
                ))
                
            case .address:
                candidates.append(OCRDataCandidate(
                    text: "123 Main St, City, State",
                    boundingBox: CGRect(x: 50, y: 350, width: 200, height: 20),
                    confidence: 0.85,
                    suggestedType: .address,
                    alternativeTypes: [.address, .general]
                ))
                
            case .url:
                candidates.append(OCRDataCandidate(
                    text: "https://example.com",
                    boundingBox: CGRect(x: 50, y: 380, width: 150, height: 20),
                    confidence: 0.90,
                    suggestedType: .url,
                    alternativeTypes: [.url, .general]
                ))
            }
        }
        
        return candidates
    }
    
    private func handleSelection(_ selection: OCRDisambiguationSelection) {
        // Handle user selection
        print("User selected: \(selection)")
        
        // In a real implementation, this would process the selection
        // and potentially call the onResult callback with the final result
    }
}

// MARK: - Helper Functions

/// Create mock disambiguation result for testing
private func createMockDisambiguationResult() -> OCRDisambiguationResult {
    let mockCandidates = [
        OCRDataCandidate(
            text: "$12.50",
            boundingBox: CGRect(x: 100, y: 200, width: 60, height: 20),
            confidence: 0.95,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        ),
        OCRDataCandidate(
            text: "$15.99",
            boundingBox: CGRect(x: 100, y: 250, width: 60, height: 20),
            confidence: 0.92,
            suggestedType: .price,
            alternativeTypes: [.price, .number]
        )
    ]
    
    return createDisambiguationResult(
        from: mockCandidates,
        configuration: OCRDisambiguationConfiguration()
    )
}
