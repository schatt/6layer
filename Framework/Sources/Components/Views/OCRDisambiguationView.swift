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
        // GREEN PHASE: Full implementation of OCR disambiguation interface
        VStack(spacing: 16) {
            Text("Multiple interpretations found")
                .font(.headline)
                .automaticAccessibilityIdentifiers(named: "DisambiguationTitle")
            
            if result.requiresUserSelection {
                Text("Please select the correct interpretation:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticAccessibilityIdentifiers(named: "DisambiguationPrompt")
                
                // Display all candidates
                ForEach(result.candidates) { candidate in
                    Button(action: {
                        let selection = OCRDisambiguationSelection(
                            candidateId: candidate.id,
                            selectedType: candidate.suggestedType
                        )
                        onSelection(selection)
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(candidate.text)
                                .font(.body)
                                .bold()
                            
                            Text("Confidence: \(Int(candidate.confidence * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Type: \(candidate.suggestedType.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .automaticAccessibilityIdentifiers(named: "CandidateOption")
                }
            } else {
                // Auto-select highest confidence candidate
                if let bestCandidate = result.candidates.max(by: { $0.confidence < $1.confidence }) {
                    Text("Best match: \(bestCandidate.text)")
                        .font(.body)
                        .automaticAccessibilityIdentifiers(named: "BestMatch")
                    
                    Button("Confirm") {
                        let selection = OCRDisambiguationSelection(
                            candidateId: bestCandidate.id,
                            selectedType: bestCandidate.suggestedType
                        )
                        onSelection(selection)
                    }
                    .buttonStyle(.borderedProminent)
                    .automaticAccessibilityIdentifiers(named: "ConfirmButton")
                }
            }
        }
        .padding()
        .automaticAccessibilityIdentifiers(named: "OCRDisambiguationView")
    }
}
