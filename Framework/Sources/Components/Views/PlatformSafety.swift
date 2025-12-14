import SwiftUI

/// PlatformSafety View Component
///
/// Provides platform-specific safety features
@MainActor
public struct PlatformSafety: View {
    
    public init() {}
    
    public var body: some View {
        let i18n = InternationalizationService()
        return platformVStackContainer(spacing: 12) {
            Text(i18n.localizedString(for: "SixLayerFramework.platform.safety.title"))
                .font(.headline)
                .automaticCompliance(named: "Title")
            
            Text(i18n.localizedString(for: "SixLayerFramework.platform.safety.description"))
                .font(.caption)
                .foregroundColor(.secondary)
                .automaticCompliance(named: "Description")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticCompliance(named: "PlatformSafety")
    }
}

#if ENABLE_PREVIEWS
#Preview {
    PlatformSafety()
        .padding()
}
#endif
