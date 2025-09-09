//
//  OCRDisambiguationView.swift
//  SixLayerFramework
//
//  OCR Disambiguation UI Component
//  Provides user interface for disambiguating ambiguous OCR results
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - OCR Disambiguation View

/// SwiftUI view for disambiguating ambiguous OCR results
public struct OCRDisambiguationView: View {
    let result: OCRDisambiguationResult
    let onSelection: (OCRDisambiguationSelection) -> Void
    
    @State private var selectedCandidates: [UUID: TextType] = [:]
    @State private var customTexts: [UUID: String] = [:]
    @State private var showingCustomTextEditor = false
    @State private var editingCandidateId: UUID?
    
    public init(
        result: OCRDisambiguationResult,
        onSelection: @escaping (OCRDisambiguationSelection) -> Void
    ) {
        self.result = result
        self.onSelection = onSelection
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Header
            headerView
            
            // Candidates list
            candidatesList
            
            // Action buttons
            actionButtons
        }
        .padding()
        .background(Color.primary.colorInvert())
        .cornerRadius(12)
        .shadow(radius: 8)
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Disambiguate OCR Results")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Please select the correct type for each detected text")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if result.confidence < 0.8 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Low confidence detected - manual verification recommended")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Candidates List
    
    private var candidatesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(result.candidates) { candidate in
                    candidateRow(candidate)
                }
            }
        }
        .frame(maxHeight: 400)
    }
    
    private func candidateRow(_ candidate: OCRDataCandidate) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Text content
            HStack {
                Text(candidate.text)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
                
                // Confidence indicator
                confidenceIndicator(candidate.confidence)
            }
            
            // Type selection
            typeSelection(for: candidate)
            
            // Bounding box info (if available)
            if candidate.boundingBox != .zero {
                boundingBoxInfo(candidate.boundingBox)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedCandidates[candidate.id] != nil ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
    
    private func confidenceIndicator(_ confidence: Float) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(confidenceColor(confidence))
            
            Text("\(Int(confidence * 100))%")
                .font(.caption)
                .foregroundColor(confidenceColor(confidence))
        }
    }
    
    private func confidenceColor(_ confidence: Float) -> Color {
        switch confidence {
        case 0.9...1.0:
            return .green
        case 0.7..<0.9:
            return .orange
        default:
            return .red
        }
    }
    
    private func typeSelection(for candidate: OCRDataCandidate) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Type:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(candidate.alternativeTypes, id: \.self) { type in
                    typeButton(type: type, candidate: candidate)
                }
            }
        }
    }
    
    private func typeButton(type: TextType, candidate: OCRDataCandidate) -> some View {
        Button(action: {
            selectedCandidates[candidate.id] = type
        }) {
            HStack {
                Image(systemName: typeIcon(type))
                Text(typeDisplayName(type))
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                selectedCandidates[candidate.id] == type ? 
                Color.accentColor : Color.secondary.opacity(0.2)
            )
            .foregroundColor(
                selectedCandidates[candidate.id] == type ? 
                .white : .primary
            )
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func typeIcon(_ type: TextType) -> String {
        switch type {
        case .price:
            return "dollarsign.circle"
        case .date:
            return "calendar"
        case .phone:
            return "phone"
        case .email:
            return "envelope"
        case .number:
            return "number"
        case .general:
            return "textformat"
        case .address:
            return "location"
        case .url:
            return "link"
        case .name:
            return "person"
        case .idNumber:
            return "creditcard"
        case .stationName:
            return "building.2"
        case .total:
            return "sum"
        case .vendor:
            return "storefront"
        case .expiryDate:
            return "calendar.badge.clock"
        case .quantity:
            return "number.circle"
        case .unit:
            return "ruler"
        case .currency:
            return "dollarsign.circle.fill"
        case .percentage:
            return "percent"
        case .postalCode:
            return "location.circle"
        case .state:
            return "map"
        case .country:
            return "globe"
        }
    }
    
    private func typeDisplayName(_ type: TextType) -> String {
        switch type {
        case .price:
            return "Price"
        case .date:
            return "Date"
        case .phone:
            return "Phone"
        case .email:
            return "Email"
        case .number:
            return "Number"
        case .general:
            return "General"
        case .address:
            return "Address"
        case .url:
            return "URL"
        case .name:
            return "Name"
        case .idNumber:
            return "ID Number"
        case .stationName:
            return "Station Name"
        case .total:
            return "Total"
        case .vendor:
            return "Vendor"
        case .expiryDate:
            return "Expiry Date"
        case .quantity:
            return "Quantity"
        case .unit:
            return "Unit"
        case .currency:
            return "Currency"
        case .percentage:
            return "Percentage"
        case .postalCode:
            return "Postal Code"
        case .state:
            return "State"
        case .country:
            return "Country"
        }
    }
    
    private func boundingBoxInfo(_ boundingBox: CGRect) -> some View {
        HStack {
            Image(systemName: "viewfinder")
                .foregroundColor(.secondary)
            
            Text("Position: (\(Int(boundingBox.origin.x)), \(Int(boundingBox.origin.y)))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("Size: \(Int(boundingBox.width))×\(Int(boundingBox.height))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button("Skip") {
                // Handle skip action
            }
            .foregroundColor(.secondary)
            
            Spacer()
            
            Button("Confirm Selection") {
                confirmSelection()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isSelectionComplete)
        }
    }
    
    private var isSelectionComplete: Bool {
        selectedCandidates.count == result.candidates.count
    }
    
    private func confirmSelection() {
        for candidate in result.candidates {
            if let selectedType = selectedCandidates[candidate.id] {
                let selection = OCRDisambiguationSelection(
                    candidateId: candidate.id,
                    selectedType: selectedType,
                    customText: customTexts[candidate.id]
                )
                onSelection(selection)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct OCRDisambiguationView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCandidates = [
            OCRDataCandidate(
                text: "12.50",
                boundingBox: CGRect(x: 100, y: 200, width: 50, height: 20),
                confidence: 0.95,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            ),
            OCRDataCandidate(
                text: "15.99",
                boundingBox: CGRect(x: 100, y: 250, width: 50, height: 20),
                confidence: 0.92,
                suggestedType: .price,
                alternativeTypes: [.price, .number]
            )
        ]
        
        let mockResult = OCRDisambiguationResult(
            candidates: mockCandidates,
            confidence: 0.85,
            requiresUserSelection: true
        )
        
        OCRDisambiguationView(result: mockResult) { selection in
            print("Selected: \(selection)")
        }
        .padding()
    }
}
#endif
