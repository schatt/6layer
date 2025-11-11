import SwiftUI

/// VisionSafety View Component
///
/// Provides safety features for visionOS platform
@MainActor
public struct VisionSafety: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 12) {
            Text("Vision Safety")
                .font(.headline)
                .automaticAccessibilityIdentifiers(named: "Title")
            
            Text("Safety features for spatial computing")
                .font(.caption)
                .foregroundColor(.secondary)
                .automaticAccessibilityIdentifiers(named: "Description")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticAccessibilityIdentifiers(named: "VisionSafety")
    }
}

#if ENABLE_PREVIEWS
#Preview {
    VisionSafety()
        .padding()
}
#endif
