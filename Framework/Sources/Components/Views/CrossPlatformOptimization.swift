import SwiftUI

/// CrossPlatformOptimization View Component
///
/// Provides cross-platform layout optimization - picking the optimal way to do something
/// across different platforms (iOS, macOS, visionOS, etc.)
@MainActor
public struct CrossPlatformOptimization: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 12) {
            Text("Cross-Platform Layout Optimization")
                .font(.headline)
                .accessibilityIdentifier("SixLayer.main.element.crossplatform.title")
            
            Text("Optimal layouts for \(SixLayerPlatform.currentPlatform.rawValue)")
                .font(.caption)
                .foregroundColor(.secondary)
                .accessibilityIdentifier("SixLayer.main.element.crossplatform.description")
            
            // Show platform-specific optimization examples
            VStack(alignment: .leading, spacing: 8) {
                Text("• Adaptive spacing")
                Text("• Platform-specific layouts")
                Text("• Optimal component sizing")
            }
            .font(.caption)
            .accessibilityIdentifier("SixLayer.main.element.crossplatform.features")
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .accessibilityIdentifier("SixLayer.main.element.crossplatform.container")
    }
}

#Preview {
    CrossPlatformOptimization()
        .padding()
}