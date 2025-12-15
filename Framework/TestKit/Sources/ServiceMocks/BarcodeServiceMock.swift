//
//  BarcodeServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of BarcodeService for testing
//

import Foundation
import SixLayerFramework

/// Mock implementation of BarcodeService for testing
public class BarcodeServiceMock: BarcodeServiceDelegate {

    // MARK: - Configuration

    public enum MockMode {
        case success
        case failure(error: Error)
        case custom(handler: (BarcodeOperation) async throws -> Any)
    }

    private var mode: MockMode = .success

    // MARK: - Mock State Tracking

    public private(set) var scanBarcodeWasCalled = false
    public private(set) var mockBarcodeResult: String = "123456789"

    public private(set) var generateBarcodeWasCalled = false
    public private(set) var generatedBarcodeContent: String?
    public private(set) var mockBarcodeImage: Data = Data([1, 2, 3, 4, 5])

    // MARK: - Configuration Methods

    /// Configure mock to return success for all operations
    public func configureSuccessResponse() {
        mode = .success
    }

    /// Configure mock to return failure for all operations
    public func configureFailureResponse(error: Error = NSError(domain: "BarcodeError", code: 1, userInfo: nil)) {
        mode = .failure(error: error)
    }

    /// Configure custom response handler
    public func configureCustomResponse(handler: @escaping (BarcodeOperation) async throws -> Any) {
        mode = .custom(handler: handler)
    }

    /// Configure mock barcode result
    public func configureBarcodeResult(_ result: String) {
        mockBarcodeResult = result
    }

    /// Configure mock barcode image
    public func configureBarcodeImage(_ imageData: Data) {
        mockBarcodeImage = imageData
    }

    /// Reset all tracking state
    public func reset() {
        scanBarcodeWasCalled = false
        generateBarcodeWasCalled = false
        generatedBarcodeContent = nil
        mode = .success
    }

    // MARK: - BarcodeServiceDelegate Implementation

    public func scanBarcode() async throws -> String {
        scanBarcodeWasCalled = true

        switch mode {
        case .success:
            return mockBarcodeResult
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.scan)
            guard let barcode = result as? String else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return barcode
        }
    }

    public func generateBarcode(for content: String, format: String) async throws -> Data {
        generateBarcodeWasCalled = true
        generatedBarcodeContent = content

        switch mode {
        case .success:
            return mockBarcodeImage
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.generate(content: content, format: format))
            guard let imageData = result as? Data else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return imageData
        }
    }
}

// MARK: - Barcode Operation Types

/// Simplified barcode operation types for testing
public enum BarcodeOperation {
    case scan
    case generate(content: String, format: String)
}