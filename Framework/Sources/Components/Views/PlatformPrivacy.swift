import SwiftUI

/// PlatformPrivacy View Component
///
/// Provides platform-specific privacy features
@MainActor
public struct PlatformPrivacy: View {
    
    public init() {}
    
    public var body: some View {
        let i18n = InternationalizationService()
        return platformVStackContainer(spacing: 12) {
            Text(i18n.localizedString(for: "SixLayerFramework.platform.privacy.title"))
                .font(.headline)
                .automaticCompliance(named: "Title")
            
            Text(i18n.localizedString(for: "SixLayerFramework.platform.privacy.description"))
                .font(.caption)
                .foregroundColor(.secondary)
                .automaticCompliance(named: "Description")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticCompliance(named: "PlatformPrivacy")
    }
}

#if ENABLE_PREVIEWS
#Preview {
    PlatformPrivacy()
        .padding()
}
#endif
