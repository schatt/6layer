//
//  ExternalDesignTokensExample.swift
//  SixLayerFramework
//
//  Example showing how to map external design tokens (Figma, JSON, etc.) to SixLayer
//

import SwiftUI

// MARK: - External Token Mapping Examples

/// Example: Mapping Figma Design Tokens
/// Shows how to convert Figma export JSON to SixLayer design tokens
struct FigmaTokenMapper {
    /// Example Figma token structure (simplified)
    /// This represents what you might get from Figma's token export
    struct FigmaTokens {
        struct ColorToken {
            let name: String
            let value: String  // hex color
            let type: String   // "color"
        }

        struct TypographyToken {
            let name: String
            let value: FigmaTypographyValue
            let type: String  // "typography"
        }

        struct FigmaTypographyValue {
            let fontFamily: String
            let fontSize: CGFloat
            let fontWeight: String
            let lineHeight: CGFloat?
        }

        struct SpacingToken {
            let name: String
            let value: CGFloat
            let type: String  // "spacing"
        }

        let colors: [ColorToken]
        let typography: [TypographyToken]
        let spacing: [SpacingToken]
    }

    /// Convert Figma tokens to SixLayer DesignTokens
    static func mapFigmaTokensToDesignTokens(
        _ figmaTokens: FigmaTokens,
        theme: Theme
    ) -> DesignTokens.Colors {
        // Map Figma color tokens to semantic SixLayer colors
        // This is where you'd implement your specific mapping logic

        var primary: Color = .blue
        var secondary: Color = .gray
        var background: Color = theme == .dark ? .black : .white
        var surface: Color = theme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)
        var text: Color = theme == .dark ? .white : .black

        // Example mapping - replace with your actual token names
        for colorToken in figmaTokens.colors {
            switch colorToken.name {
            case "brand/primary":
                primary = Color(hex: colorToken.value)
            case "brand/secondary":
                secondary = Color(hex: colorToken.value)
            case "surface/background":
                background = Color(hex: colorToken.value)
            case "surface/card":
                surface = Color(hex: colorToken.value)
            case "text/primary":
                text = Color(hex: colorToken.value)
            default:
                continue
            }
        }

        return DesignTokens.Colors(
            primary: primary,
            secondary: secondary,
            accent: primary.opacity(0.8),
            destructive: .red,
            success: .green,
            warning: .orange,
            info: .blue,
            background: background,
            surface: surface,
            surfaceElevated: surface.opacity(0.9),
            text: text,
            textSecondary: text.opacity(0.7),
            textTertiary: text.opacity(0.5),
            textDisabled: text.opacity(0.3),
            hover: primary.opacity(0.1),
            pressed: primary.opacity(0.2),
            focused: primary,
            disabled: text.opacity(0.2),
            border: text.opacity(0.2),
            borderSecondary: text.opacity(0.1),
            borderFocus: primary,
            error: .red,
            warningText: .orange,
            successText: .green,
            infoText: .blue
        )
    }
}

/// Example: JSON Design Token Parser
/// Shows how to parse design tokens from JSON format
struct JSONTokenParser {
    /// Parse design tokens from JSON string
    static func parseTokens(from jsonString: String) throws -> CustomDesignSystem {
        // In a real implementation, you'd use JSONDecoder
        // This is a simplified example

        // Example JSON structure you might receive:
        /*
        {
          "colors": {
            "light": {
              "primary": "#007AFF",
              "secondary": "#6B7280",
              "background": "#FFFFFF",
              "surface": "#F9FAFB",
              "text": "#111827",
              "textSecondary": "#6B7280"
            },
            "dark": {
              "primary": "#0A84FF",
              "secondary": "#9CA3AF",
              "background": "#000000",
              "surface": "#1F2937",
              "text": "#FFFFFF",
              "textSecondary": "#9CA3AF"
            }
          },
          "typography": {
            "body": {
              "fontFamily": "System",
              "fontSize": 16,
              "fontWeight": 400
            },
            "headline": {
              "fontFamily": "System",
              "fontSize": 20,
              "fontWeight": 600
            }
          },
          "spacing": {
            "sm": 8,
            "md": 16,
            "lg": 24
          }
        }
        */

        // For this example, we'll create a mock implementation
        // In practice, you'd parse the actual JSON

        let lightColors = DesignTokens.Colors(
            primary: Color.blue,
            secondary: Color.gray,
            accent: Color.blue.opacity(0.8),
            destructive: Color.red,
            success: Color.green,
            warning: Color.orange,
            info: Color.blue,
            background: Color.white,
            surface: Color.gray.opacity(0.1),
            surfaceElevated: Color.gray.opacity(0.05),
            text: Color.black,
            textSecondary: Color.gray,
            textTertiary: Color.gray.opacity(0.7),
            textDisabled: Color.gray.opacity(0.5),
            hover: Color.blue.opacity(0.1),
            pressed: Color.blue.opacity(0.2),
            focused: Color.blue,
            disabled: Color.gray.opacity(0.3),
            border: Color.gray.opacity(0.3),
            borderSecondary: Color.gray.opacity(0.2),
            borderFocus: Color.blue,
            error: Color.red,
            warningText: Color.orange,
            successText: Color.green,
            infoText: Color.blue
        )

        let darkColors = DesignTokens.Colors(
            primary: Color.blue.opacity(0.9),
            secondary: Color.gray.opacity(0.8),
            accent: Color.blue.opacity(0.7),
            destructive: Color.red,
            success: Color.green,
            warning: Color.yellow,
            info: Color.cyan,
            background: Color.black,
            surface: Color.gray.opacity(0.2),
            surfaceElevated: Color.gray.opacity(0.3),
            text: Color.white,
            textSecondary: Color.gray.opacity(0.8),
            textTertiary: Color.gray.opacity(0.6),
            textDisabled: Color.gray.opacity(0.4),
            hover: Color.blue.opacity(0.1),
            pressed: Color.blue.opacity(0.2),
            focused: Color.blue,
            disabled: Color.gray.opacity(0.3),
            border: Color.gray.opacity(0.5),
            borderSecondary: Color.gray.opacity(0.3),
            borderFocus: Color.blue,
            error: Color.red,
            warningText: Color.yellow,
            successText: Color.green,
            infoText: Color.cyan
        )

        let typography = DesignTokens.Typography(
            largeTitle: Font.system(size: 34, weight: .bold),
            title1: Font.system(size: 28, weight: .bold),
            title2: Font.system(size: 22, weight: .bold),
            title3: Font.system(size: 20, weight: .semibold),
            headline: Font.system(size: 17, weight: .semibold),
            body: Font.system(size: 17, weight: .regular),
            callout: Font.system(size: 16, weight: .regular),
            subheadline: Font.system(size: 15, weight: .regular),
            footnote: Font.system(size: 13, weight: .regular),
            caption1: Font.system(size: 12, weight: .regular),
            caption2: Font.system(size: 11, weight: .regular)
        )

        let spacing = DesignTokens.Spacing(
            xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48
        )

        let componentStates = DesignTokens.ComponentStates(
            cornerRadius: DesignTokens.ComponentCornerRadius(
                none: 0, sm: 8, md: 12, lg: 16, xl: 24, full: 999
            ),
            borderWidth: DesignTokens.ComponentBorderWidth(
                none: 0, sm: 0.5, md: 1, lg: 2
            ),
            shadow: DesignTokens.ComponentShadow(
                none: (Color.clear, 0, 0, 0),
                sm: (Color.black.opacity(0.1), 2, 0, 1),
                md: (Color.black.opacity(0.1), 4, 0, 2),
                lg: (Color.black.opacity(0.15), 8, 0, 4)
            ),
            opacity: DesignTokens.ComponentOpacity(
                disabled: 0.5, pressed: 0.7, hover: 0.8
            )
        )

        return CustomDesignSystem(
            name: "JSON Imported",
            colorTokens: [.light: lightColors, .dark: darkColors],
            typographyTokens: [.light: typography, .dark: typography],
            spacingTokens: spacing,
            componentStatesTokens: componentStates
        )
    }
}

/// Example: Design Token Service
/// Shows how to create a service that loads design tokens at runtime
class DesignTokenService {
    private var loadedDesignSystems: [String: DesignSystem] = [:]

    /// Load design system from remote URL
    func loadDesignSystem(from url: URL, name: String) async throws -> DesignSystem {
        if let cached = loadedDesignSystems[name] {
            return cached
        }

        // In a real implementation, you'd fetch JSON from the URL
        // For this example, we'll simulate loading

        let jsonString = """
        {
          "name": "\(name)",
          "colors": {
            "light": {
              "primary": "#007AFF",
              "background": "#FFFFFF"
            }
          }
        }
        """

        // Parse and create design system
        let designSystem = try JSONTokenParser.parseTokens(from: jsonString)
        loadedDesignSystems[name] = designSystem

        return designSystem
    }

    /// Switch to a loaded design system
    func switchToDesignSystem(_ designSystem: DesignSystem) {
        VisualDesignSystem.shared.switchDesignSystem(designSystem)
    }
}

// MARK: - Example Usage View

struct ExternalDesignTokensExample: View {
    @StateObject private var designTokenService = DesignTokenService()
    @State private var selectedSystem: DesignSystem = SixLayerDesignSystem()
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ThemedFrameworkView {
            NavigationView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("External Design Tokens")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Map Figma, JSON, or other design tokens to SixLayer components")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)

                    // System Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Systems")
                            .font(.headline)

                        VStack(spacing: 8) {
                            Button(action: { switchToSystem(SixLayerDesignSystem()) }) {
                                HStack {
                                    Text("SixLayer Default")
                                    Spacer()
                                    if selectedSystem.name == "SixLayer" {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Button(action: { switchToSystem(HighContrastDesignSystem()) }) {
                                HStack {
                                    Text("High Contrast")
                                    Spacer()
                                    if selectedSystem.name == "HighContrast" {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Button(action: { loadRemoteSystem() }) {
                                HStack {
                                    Text("Load from Remote JSON")
                                    Spacer()
                                    if isLoading {
                                        ProgressView()
                                    }
                                }
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Current System Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current System: \(selectedSystem.name)")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Colors: ✓ Configured")
                            Text("Typography: ✓ Configured")
                            Text("Spacing: ✓ Configured")
                            Text("Component States: ✓ Configured")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    // Component Preview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Component Preview")
                            .font(.headline)

                        ScrollView {
                            VStack(spacing: 16) {
                                // Sample components using current design system
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading) {
                                        Text("Primary Button")
                                            .font(.subheadline)
                                        Text("Using design tokens")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .themedCard()

                                    VStack(alignment: .leading) {
                                        Text("Text Field")
                                            .font(.subheadline)
                                        Text("Styled input")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .themedCard()
                                }

                                ThemedProgressBar(progress: 0.6, variant: .primary)
                                    .frame(height: 4)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .navigationTitle("External Tokens")
                .alert(item: Binding(
                    get: { errorMessage.map { ErrorContainer(message: $0) } },
                    set: { _ in errorMessage = nil }
                )) { error in
                    Alert(
                        title: Text("Error"),
                        message: Text(error.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    private func switchToSystem(_ system: DesignSystem) {
        selectedSystem = system
        designTokenService.switchToDesignSystem(system)
    }

    private func loadRemoteSystem() {
        isLoading = true
        errorMessage = nil

        // Simulate loading a remote design system
        Task {
            do {
                // In a real app, you'd load from an actual URL
                let mockURL = URL(string: "https://example.com/design-tokens.json")!
                let system = try await designTokenService.loadDesignSystem(from: mockURL, name: "Remote System")
                await MainActor.run {
                    switchToSystem(system)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to load remote design system: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Helper Types

struct ErrorContainer: Identifiable {
    let id = UUID()
    let message: String
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

struct ExternalDesignTokensExample_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDesignTokensExample()
    }
}