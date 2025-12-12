import SwiftUI

/// PlatformSafety View Component
///
/// Provides platform-specific safety features
@MainActor
public struct PlatformSafety: View {
    
    public init() {}
    
    public var body: some View {
        platformVStackContainer(spacing: 12) {
            Text("Platform Safety")
                .font(.headline)
                .automaticCompliance(named: "Title")
            
            Text("Safety features across platforms")
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
