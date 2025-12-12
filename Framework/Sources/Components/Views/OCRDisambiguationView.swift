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
        let i18n = InternationalizationService()
        
        return platformVStackContainer(spacing: 16) {
            Text(i18n.localizedString(for: "SixLayerFramework.ocr.disambiguation.title"))
                .font(.headline)
                .automaticCompliance(named: "DisambiguationTitle")
            
            if result.requiresUserSelection {
                Text(i18n.localizedString(for: "SixLayerFramework.ocr.disambiguation.prompt"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "DisambiguationPrompt")
                
                // Display all candidates
                ForEach(result.candidates) { candidate in
                    Button(action: {
                        let selection = OCRDisambiguationSelection(
                            candidateId: candidate.id,
                            selectedType: candidate.suggestedType
                        )
                        onSelection(selection)
                    }) {
                        platformVStackContainer(alignment: .leading, spacing: 4) {
                            Text(candidate.text)
                                .font(.body)
                                .bold()
                            
                            Text(i18n.localizedString(for: "SixLayerFramework.ocr.disambiguation.confidence", arguments: [String(Int(candidate.confidence * 100))]))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(i18n.localizedString(for: "SixLayerFramework.ocr.disambiguation.type", arguments: [candidate.suggestedType.rawValue]))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .automaticCompliance(named: "CandidateOption")
                }
            } else {
                // Auto-select highest confidence candidate
                if let bestCandidate = result.candidates.max(by: { $0.confidence < $1.confidence }) {
                    Text(i18n.localizedString(for: "SixLayerFramework.ocr.disambiguation.bestMatch", arguments: [bestCandidate.text]))
                        .font(.body)
                        .automaticCompliance(named: "BestMatch")
                    
                    Button(i18n.localizedString(for: "SixLayerFramework.button.confirm")) {
                        let selection = OCRDisambiguationSelection(
                            candidateId: bestCandidate.id,
                            selectedType: bestCandidate.suggestedType
                        )
                        onSelection(selection)
                    }
                    .buttonStyle(.borderedProminent)
                    .automaticCompliance(named: "ConfirmButton")
                }
            }
        }
        .padding()
        .automaticCompliance(named: "OCRDisambiguationView")
    }
}
