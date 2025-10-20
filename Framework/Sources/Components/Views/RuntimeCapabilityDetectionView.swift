import SwiftUI

/// A view component for runtime capability detection
///
/// This component detects and displays the current platform capabilities
/// at runtime, including hardware features, software versions, and available APIs.
@MainActor
public struct RuntimeCapabilityDetectionView: View {
    @State private var capabilities: [String] = []
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Runtime Capabilities")
                .font(.headline)
                .accessibilityIdentifier("SixLayer.main.element.capabilities.title")
            
            if capabilities.isEmpty {
                Text("Detecting capabilities...")
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("SixLayer.main.element.capabilities.loading")
            } else {
                ForEach(capabilities, id: \.self) { capability in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(capability)
                            .font(.body)
                    }
                    .accessibilityIdentifier("SixLayer.main.element.capabilities.item.\(capability)")
                }
            }
            
            Button("Refresh Detection") {
                detectCapabilities()
            }
            .accessibilityIdentifier("SixLayer.main.element.capabilities.refresh")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .accessibilityIdentifier("SixLayer.main.element.capabilities.container")
        .onAppear {
            detectCapabilities()
        }
    }
    
    private func detectCapabilities() {
        capabilities = [
            "Platform: \(SixLayerPlatform.currentPlatform.rawValue)",
            "Device Type: \(SixLayerPlatform.deviceType.rawValue)",
            "Accessibility: Available",
            "Touch Support: \(SixLayerPlatform.currentPlatform == .iOS || SixLayerPlatform.currentPlatform == .visionOS)"
        ]
    }
}

#Preview {
    RuntimeCapabilityDetectionView()
        .padding()
}
