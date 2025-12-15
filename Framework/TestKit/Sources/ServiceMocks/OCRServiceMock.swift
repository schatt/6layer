//
//  OCRServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of OCRService for testing
//

import Foundation
import SixLayerFramework

/// Mock implementation of OCRService for testing
/// Note: This is a standalone test utility and doesn't conform to OCRServiceProtocol
/// as it uses a different API for testing convenience
public class OCRServiceMock {

    // MARK: - Configuration

    public enum MockMode {
        case success
        case failure(error: Error)
        case custom(handler: (OCROperation) async throws -> Any)
    }

    private var mode: MockMode = .success

    // MARK: - Mock State Tracking

    public private(set) var recognizeTextWasCalled = false
    public private(set) var mockRecognizedText: String = "Mock recognized text"

    public private(set) var analyzeDocumentWasCalled = false
    public private(set) var mockAnalysisResult: [String: Any] = ["confidence": 0.95, "language": "en"]

    // MARK: - Configuration Methods

    /// Configure mock to return success for all operations
    public func configureSuccessResponse() {
        mode = .success
    }

    /// Configure mock to return failure for all operations
    public func configureFailureResponse(error: Error = NSError(domain: "OCRError", code: 1, userInfo: nil)) {
        mode = .failure(error: error)
    }

    /// Configure custom response handler
    public func configureCustomResponse(handler: @escaping (OCROperation) async throws -> Any) {
        mode = .custom(handler: handler)
    }

    /// Configure mock recognized text
    public func configureRecognizedText(_ text: String) {
        mockRecognizedText = text
    }

    /// Configure mock analysis result
    public func configureAnalysisResult(_ result: [String: Any]) {
        mockAnalysisResult = result
    }

    /// Reset all tracking state
    public func reset() {
        recognizeTextWasCalled = false
        analyzeDocumentWasCalled = false
        mode = .success
    }

    // MARK: - OCRServiceDelegate Implementation

    public func recognizeText(in imageData: Data) async throws -> String {
        recognizeTextWasCalled = true

        switch mode {
        case .success:
            return mockRecognizedText
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.recognize(imageData: imageData))
            guard let text = result as? String else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return text
        }
    }

    public func analyzeDocument(in imageData: Data) async throws -> [String: Any] {
        analyzeDocumentWasCalled = true

        switch mode {
        case .success:
            return mockAnalysisResult
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.analyze(imageData: imageData))
            guard let analysis = result as? [String: Any] else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return analysis
        }
    }
}

// MARK: - OCR Operation Types

/// Simplified OCR operation types for testing
public enum OCROperation {
    case recognize(imageData: Data)
    case analyze(imageData: Data)
}