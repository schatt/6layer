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
                .automaticCompliance(named: "Title")
            
            if capabilities.isEmpty {
                Text("Detecting capabilities...")
                    .foregroundColor(.secondary)
                    .automaticCompliance(named: "Loading")
            } else {
                ForEach(capabilities, id: \.self) { capability in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(capability)
                            .font(.body)
                    }
                    .automaticCompliance(named: "CapabilityItem")
                }
            }
            
            Button("Refresh Detection") {
                detectCapabilities()
            }
            .automaticCompliance(named: "RefreshButton")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticCompliance(named: "RuntimeCapabilityDetectionView")
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

#if ENABLE_PREVIEWS
#Preview {
    RuntimeCapabilityDetectionView()
        .padding()
}
#endif
