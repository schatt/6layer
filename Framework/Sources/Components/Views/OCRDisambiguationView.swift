import SwiftUI

/// OCR Disambiguation View - User selection interface for ambiguous OCR results
public struct OCRDisambiguationView: View {
    let result: OCRDisambiguationResult
    let onSelection: (OCRDisambiguationSelection) -> Void
    
    public init(
        result: OCRDisambiguationResult,
        onSelection: @escaping (OCRDisambiguationSelection) -> Void
    ) {
        self.result = result
        self.onSelection = onSelection
    }
    
    public var body: some View {
        Text("OCR Disambiguation View (Stub)")
            .foregroundColor(.secondary)
    }
}
