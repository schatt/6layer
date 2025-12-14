import SwiftUI

/// PlatformSecurity View Component
///
/// Provides platform-specific security features
@MainActor
public struct PlatformSecurity: View {
    
    public init() {}
    
    public var body: some View {
        let i18n = InternationalizationService()
        return platformVStackContainer(spacing: 12) {
            Text(i18n.localizedString(for: "SixLayerFramework.platform.security.title"))
                .font(.headline)
                .automaticCompliance(named: "Title")
            
            Text(i18n.localizedString(for: "SixLayerFramework.platform.security.description"))
                .font(.caption)
                .foregroundColor(.secondary)
                .automaticCompliance(named: "Description")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .automaticCompliance(named: "PlatformSecurity")
    }
}

#if ENABLE_PREVIEWS
#Preview {
    PlatformSecurity()
        .padding()
}
#endif
