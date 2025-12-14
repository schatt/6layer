import SwiftUI

/// VisionSafety View Component
///
/// Provides safety features for visionOS platform
@MainActor
public struct VisionSafety: View {
    
    public init() {}
    
    public var body: some View {
        let i18n = InternationalizationService()
        return platformVStackContainer(spacing: 12) {
            Text(i18n.localizedString(for: "SixLayerFramework.vision.safety.title"))
                .font(.headline)
                .automaticCompliance(named: "Title")
            
            Text(i18n.localizedString(for: "SixLayerFramework.vision.safety.description"))
                .font(.caption)
                .foregroundColor(.secondary)
                .automaticCompliance(named: "Description")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticCompliance(named: "VisionSafety")
    }
}

#if ENABLE_PREVIEWS
#Preview {
    VisionSafety()
        .padding()
}
#endif
