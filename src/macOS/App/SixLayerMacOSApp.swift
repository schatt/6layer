import SwiftUI
import SixLayerShared_macOS
import SixLayerMacOS

@main
struct SixLayerMacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("SixLayer Framework")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("6-Layer UI Architecture Demo")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Layer 1: Semantic Intent")
                        .font(.headline)
                    Text("Express what you want to achieve, not how")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Layer 2: Layout Decision")
                        .font(.headline)
                    Text("Intelligent layout analysis and decision making")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Layer 3: Strategy Selection")
                        .font(.headline)
                    Text("Optimal layout strategy selection")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Layer 4: Component Implementation")
                        .font(.headline)
                    Text("Platform-agnostic component implementation")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Layer 5: Platform Optimization")
                        .font(.headline)
                    Text("Platform-specific enhancements and optimizations")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Layer 6: Platform System")
                        .font(.headline)
                    Text("Direct platform system calls and native implementations")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.windowBackgroundColor))
                .cornerRadius(12)
                
                Spacer()
                
                Text("Built with SwiftUI and SixLayer Framework")
                    .font(.caption)
                    .foregroundColor(.tertiary)
            }
            .padding()
            .frame(minWidth: 600, minHeight: 500)
        }
    }
}

#Preview {
    ContentView()
}
