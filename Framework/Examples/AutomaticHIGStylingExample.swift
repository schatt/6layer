import SwiftUI
import SixLayerFramework

// MARK: - Automatic HIG-Compliant Styling Examples
// Demonstrates Issue #35: Automatic HIG-compliant styling for all components

/// Example demonstrating automatic HIG-compliant styling with Layer 1 functions
/// All Layer 1 functions automatically apply styling - no manual modifiers needed!
struct AutomaticHIGStylingLayer1Example: View {
    struct ExampleItem: Identifiable {
        let id: String
        let title: String
        let subtitle: String
    }
    
    let items = [
        ExampleItem(id: "1", title: "First Item", subtitle: "Description 1"),
        ExampleItem(id: "2", title: "Second Item", subtitle: "Description 2"),
        ExampleItem(id: "3", title: "Third Item", subtitle: "Description 3")
    ]
    
    var body: some View {
        // Layer 1 functions automatically get styling!
        // Colors, spacing, typography, and platform patterns are all applied automatically
        platformPresentItemCollection_L1(
            items: items,
            hints: PresentationHints()
        )
        // That's it! No manual styling needed.
        // The framework automatically applies:
        // - System colors (platform-specific)
        // - Typography (platform-appropriate)
        // - Spacing (8pt grid)
        // - Platform-specific patterns
    }
}

/// Example demonstrating automatic styling with custom views
/// Custom views can opt-in to automatic styling using .automaticCompliance()
struct AutomaticHIGStylingCustomViewExample: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Custom Content")
                .font(.title)
            
            Text("This view uses automatic compliance to get HIG-compliant styling")
                .font(.body)
            
            Button("Action Button") {
                // Action
            }
        }
        .automaticCompliance()
        // Automatically applies:
        // - System colors (foreground and background)
        // - Typography (platform-appropriate fonts)
        // - Spacing (8pt grid padding)
        // - Platform-specific styling patterns
    }
}

/// Example showing before/after comparison
struct AutomaticHIGStylingComparisonExample: View {
    var body: some View {
        VStack(spacing: 24) {
            // BEFORE: Manual styling required
            VStack(alignment: .leading, spacing: 8) {
                Text("Before (Manual Styling)")
                    .font(.headline)
                
                Text("""
                // Had to manually apply styling:
                Text("Content")
                    .foregroundColor(.primary)
                    .font(.body)
                    .padding(16)
                    .background(Color.systemBackground)
                """)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // AFTER: Automatic styling
            VStack(alignment: .leading, spacing: 8) {
                Text("After (Automatic Styling)")
                    .font(.headline)
                
                Text("""
                // Just use .automaticCompliance():
                Text("Content")
                    .automaticCompliance()
                // Colors, typography, spacing all applied automatically!
                """)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .automaticCompliance()
            // All styling automatically applied!
        }
        .padding()
    }
}

/// Example demonstrating platform-specific automatic styling
/// The framework automatically detects the platform and applies appropriate styling
struct AutomaticHIGStylingPlatformExample: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Platform-Specific Styling")
                .font(.title2)
            
            Text("""
            On iOS: Gets iOS-appropriate colors, spacing, and typography
            On macOS: Gets macOS-appropriate colors, spacing, and typography
            
            All automatically applied - no platform checks needed!
            """)
                .font(.body)
            
            // This button automatically gets platform-appropriate styling
            Button("Platform Button") {
                // Action
            }
        }
        .automaticCompliance()
        // Automatically adapts to current platform:
        // - iOS: Touch-optimized spacing, iOS colors
        // - macOS: Pointer-optimized spacing, macOS colors
    }
}

/// Example showing automatic styling with different component types
struct AutomaticHIGStylingComponentsExample: View {
    @State private var text = ""
    @State private var toggle = false
    
    var body: some View {
        Form {
            Section("Text Components") {
                Text("This text automatically gets system colors and typography")
                    .automaticCompliance()
                
                TextField("Input field", text: $text)
                    .automaticCompliance()
            }
            
            Section("Interactive Components") {
                Button("Button") {
                    // Action
                }
                .automaticCompliance()
                
                Toggle("Toggle", isOn: $toggle)
                    .automaticCompliance()
            }
            
            Section("Layout Components") {
                VStack(spacing: 8) {
                    Text("Item 1")
                    Text("Item 2")
                    Text("Item 3")
                }
                .automaticCompliance()
                // Spacing automatically follows 8pt grid
            }
        }
        .automaticCompliance()
        // All components get consistent, HIG-compliant styling
    }
}

/// Example demonstrating automatic styling with Layer 1 functions
struct AutomaticHIGStylingLayer1FunctionsExample: View {
    let numericData = [
        GenericNumericData(value: 42.0, label: "Temperature", unit: "°C"),
        GenericNumericData(value: 75.0, label: "Humidity", unit: "%")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Collection view - automatic styling
                platformPresentItemCollection_L1(
                    items: [
                        TestItem(id: "1", title: "Item 1", subtitle: "Subtitle 1")
                    ],
                    hints: PresentationHints()
                )
                
                // Numeric data view - automatic styling
                platformPresentNumericData_L1(
                    data: numericData,
                    hints: PresentationHints()
                )
                
                // Content view - automatic styling
                platformPresentContent_L1(
                    content: "This content automatically gets HIG-compliant styling",
                    hints: PresentationHints()
                )
            }
            .padding()
        }
        // All Layer 1 functions automatically apply:
        // - Visual design (colors, spacing, typography)
        // - Platform-specific patterns
        // - Accessibility features
    }
}

// MARK: - Helper Types

struct TestItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
}

