//
//  DesignSystemBridgeExample.swift
//  SixLayerFramework
//
//  Example demonstrating the Design System Bridge
//  Shows how to map external design tokens to SixLayer components
//

import SwiftUI

// MARK: - Example Design System Implementations

/// Example: High Contrast Design System
/// Demonstrates how to create a design system optimized for accessibility
struct HighContrastDesignSystemExample: DesignSystem {
    let name = "High Contrast Example"

    func colors(for theme: Theme) -> DesignTokens.Colors {
        switch theme {
        case .light:
            return DesignTokens.Colors(
                primary: Color.black,
                secondary: Color.gray,
                accent: Color.blue,
                destructive: Color.red,
                success: Color.green,
                warning: Color.orange,
                info: Color.blue,
                background: Color.white,
                surface: Color.white,
                surfaceElevated: Color.gray.opacity(0.1),
                text: Color.black,
                textSecondary: Color.gray,
                textTertiary: Color.gray.opacity(0.7),
                textDisabled: Color.gray.opacity(0.5),
                hover: Color.blue.opacity(0.1),
                pressed: Color.blue.opacity(0.2),
                focused: Color.blue,
                disabled: Color.gray.opacity(0.3),
                border: Color.black,
                borderSecondary: Color.gray,
                borderFocus: Color.blue,
                error: Color.red,
                warningText: Color.orange,
                successText: Color.green,
                infoText: Color.blue
            )
        case .dark:
            return DesignTokens.Colors(
                primary: Color.white,
                secondary: Color.gray,
                accent: Color.cyan,
                destructive: Color.red,
                success: Color.green,
                warning: Color.yellow,
                info: Color.cyan,
                background: Color.black,
                surface: Color.black,
                surfaceElevated: Color.gray.opacity(0.2),
                text: Color.white,
                textSecondary: Color.gray,
                textTertiary: Color.gray.opacity(0.7),
                textDisabled: Color.gray.opacity(0.5),
                hover: Color.cyan.opacity(0.1),
                pressed: Color.cyan.opacity(0.2),
                focused: Color.cyan,
                disabled: Color.gray.opacity(0.3),
                border: Color.white,
                borderSecondary: Color.gray,
                borderFocus: Color.cyan,
                error: Color.red,
                warningText: Color.yellow,
                successText: Color.green,
                infoText: Color.cyan
            )
        case .auto:
            return colors(for: .light) // Default to light
        }
    }

    func typography(for theme: Theme) -> DesignTokens.Typography {
        // High contrast typography - bolder weights
        return DesignTokens.Typography(
            largeTitle: Font.system(size: 34, weight: .black),
            title1: Font.system(size: 28, weight: .black),
            title2: Font.system(size: 22, weight: .black),
            title3: Font.system(size: 20, weight: .bold),
            headline: Font.system(size: 17, weight: .bold),
            body: Font.system(size: 17, weight: .semibold),
            callout: Font.system(size: 16, weight: .semibold),
            subheadline: Font.system(size: 15, weight: .semibold),
            footnote: Font.system(size: 13, weight: .semibold),
            caption1: Font.system(size: 12, weight: .semibold),
            caption2: Font.system(size: 11, weight: .semibold)
        )
    }

    func spacing() -> DesignTokens.Spacing {
        // Slightly larger spacing for high contrast
        return DesignTokens.Spacing(
            xs: 6, sm: 10, md: 18, lg: 28, xl: 36, xxl: 52
        )
    }

    func componentStates() -> DesignTokens.ComponentStates {
        return DesignTokens.ComponentStates(
            cornerRadius: DesignTokens.ComponentCornerRadius(
                none: 0, sm: 6, md: 10, lg: 14, xl: 20, full: 999
            ),
            borderWidth: DesignTokens.ComponentBorderWidth(
                none: 0, sm: 1, md: 2, lg: 3
            ),
            shadow: DesignTokens.ComponentShadow(
                none: (Color.clear, 0, 0, 0),
                sm: (Color.black.opacity(0.2), 4, 0, 2),
                md: (Color.black.opacity(0.2), 8, 0, 4),
                lg: (Color.black.opacity(0.2), 16, 0, 8)
            ),
            opacity: DesignTokens.ComponentOpacity(
                disabled: 0.4, pressed: 0.6, hover: 0.7
            )
        )
    }
}

/// Example: Brand Design System
/// Demonstrates how to map a brand's design tokens to SixLayer
struct BrandDesignSystemExample: DesignSystem {
    let name = "Brand Example"

    // Example brand colors (you would replace these with your actual brand tokens)
    private let brandPrimary = Color(hex: "#FF6B35")    // Brand orange
    private let brandSecondary = Color(hex: "#F7931E")  // Brand yellow
    private let brandAccent = Color(hex: "#00B4D8")    // Brand blue
    private let brandSurface = Color(hex: "#F8F9FA")   // Light gray surface
    private let brandText = Color(hex: "#212529")      // Dark gray text

    func colors(for theme: Theme) -> DesignTokens.Colors {
        switch theme {
        case .light:
            return DesignTokens.Colors(
                primary: brandPrimary,
                secondary: brandSecondary,
                accent: brandAccent,
                destructive: Color.red,
                success: Color.green,
                warning: Color.orange,
                info: Color.blue,
                background: Color.white,
                surface: brandSurface,
                surfaceElevated: brandSurface.opacity(0.8),
                text: brandText,
                textSecondary: brandText.opacity(0.7),
                textTertiary: brandText.opacity(0.5),
                textDisabled: brandText.opacity(0.3),
                hover: brandPrimary.opacity(0.1),
                pressed: brandPrimary.opacity(0.2),
                focused: brandPrimary,
                disabled: brandText.opacity(0.2),
                border: brandText.opacity(0.2),
                borderSecondary: brandText.opacity(0.1),
                borderFocus: brandPrimary,
                error: Color.red,
                warningText: Color.orange,
                successText: Color.green,
                infoText: Color.blue
            )
        case .dark:
            return DesignTokens.Colors(
                primary: brandPrimary.lighter(by: 0.1),
                secondary: brandSecondary.lighter(by: 0.1),
                accent: brandAccent.lighter(by: 0.1),
                destructive: Color.red,
                success: Color.green,
                warning: Color.yellow,
                info: Color.cyan,
                background: Color.black,
                surface: Color(hex: "#2D3436"),
                surfaceElevated: Color(hex: "#34495E"),
                text: Color.white,
                textSecondary: Color.gray,
                textTertiary: Color.gray.opacity(0.7),
                textDisabled: Color.gray.opacity(0.5),
                hover: brandPrimary.opacity(0.1),
                pressed: brandPrimary.opacity(0.2),
                focused: brandPrimary,
                disabled: Color.gray.opacity(0.3),
                border: Color.gray.opacity(0.5),
                borderSecondary: Color.gray.opacity(0.3),
                borderFocus: brandPrimary,
                error: Color.red,
                warningText: Color.yellow,
                successText: Color.green,
                infoText: Color.cyan
            )
        case .auto:
            return colors(for: .light)
        }
    }

    func typography(for theme: Theme) -> DesignTokens.Typography {
        // Custom brand typography
        return DesignTokens.Typography(
            largeTitle: Font.custom("BrandFont-Bold", size: 34),
            title1: Font.custom("BrandFont-Bold", size: 28),
            title2: Font.custom("BrandFont-Bold", size: 22),
            title3: Font.custom("BrandFont-Semibold", size: 20),
            headline: Font.custom("BrandFont-Semibold", size: 17),
            body: Font.custom("BrandFont-Regular", size: 17),
            callout: Font.custom("BrandFont-Regular", size: 16),
            subheadline: Font.custom("BrandFont-Regular", size: 15),
            footnote: Font.custom("BrandFont-Regular", size: 13),
            caption1: Font.custom("BrandFont-Regular", size: 12),
            caption2: Font.custom("BrandFont-Regular", size: 11)
        )
    }

    func spacing() -> DesignTokens.Spacing {
        // Brand-specific spacing scale
        return DesignTokens.Spacing(
            xs: 4, sm: 8, md: 16, lg: 24, xl: 40, xxl: 64
        )
    }

    func componentStates() -> DesignTokens.ComponentStates {
        return DesignTokens.ComponentStates(
            cornerRadius: DesignTokens.ComponentCornerRadius(
                none: 0, sm: 4, md: 8, lg: 12, xl: 16, full: 999
            ),
            borderWidth: DesignTokens.ComponentBorderWidth(
                none: 0, sm: 1, md: 2, lg: 3
            ),
            shadow: DesignTokens.ComponentShadow(
                none: (Color.clear, 0, 0, 0),
                sm: (brandText.opacity(0.1), 2, 0, 1),
                md: (brandText.opacity(0.1), 4, 0, 2),
                lg: (brandText.opacity(0.15), 8, 0, 4)
            ),
            opacity: DesignTokens.ComponentOpacity(
                disabled: 0.5, pressed: 0.8, hover: 0.9
            )
        )
    }
}

// MARK: - Design System Bridge Example View

struct DesignSystemBridgeExample: View {
    @State private var selectedDesignSystem: DesignSystem = SixLayerDesignSystem()
    @State private var currentTheme: Theme = .light
    @StateObject private var visualDesignSystem = VisualDesignSystem.shared

    let designSystems: [DesignSystem] = [
        SixLayerDesignSystem(),
        HighContrastDesignSystemExample(),
        BrandDesignSystemExample()
    ]

    var body: some View {
        ThemedFrameworkView {
            NavigationView {
                VStack(spacing: 20) {
                    // Design System Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Design System")
                            .font(.headline)
                        Picker("Design System", selection: $selectedDesignSystem) {
                            ForEach(designSystems, id: \.name) { system in
                                Text(system.name).tag(system as DesignSystem)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedDesignSystem) { newSystem in
                            visualDesignSystem.switchDesignSystem(newSystem)
                        }
                    }
                    .padding(.horizontal)

                    // Theme Toggle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Theme")
                            .font(.headline)
                        Picker("Theme", selection: $currentTheme) {
                            Text("Light").tag(Theme.light)
                            Text("Dark").tag(Theme.dark)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: currentTheme) { newTheme in
                            visualDesignSystem.currentTheme = newTheme
                        }
                    }
                    .padding(.horizontal)

                    // Component Showcase
                    ScrollView {
                        VStack(spacing: 24) {
                            componentShowcaseSection()
                            typographyShowcaseSection()
                            spacingShowcaseSection()
                        }
                        .padding()
                    }
                }
                .navigationTitle("Design System Bridge")
            }
        }
    }

    private func componentShowcaseSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Components")
                .font(.title2)
                .fontWeight(.bold)

            // Cards
            VStack(alignment: .leading, spacing: 8) {
                Text("Cards").font(.headline)
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Surface Card").font(.subheadline)
                        Text("Shows themed card styling").font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .themedCard()

                    VStack(alignment: .leading) {
                        Text("Elevated Card").font(.subheadline)
                        Text("Shows elevated surface").font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(visualDesignSystem.currentColors.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            // Form Elements
            VStack(alignment: .leading, spacing: 8) {
                Text("Form Elements").font(.headline)
                VStack(spacing: 12) {
                    TextField("Enter text", text: .constant(""))
                        .themedTextField()

                    ThemedProgressBar(progress: 0.7, variant: .primary)
                        .frame(height: 4)
                }
            }

            // Buttons
            VStack(alignment: .leading, spacing: 8) {
                Text("Interactive States").font(.headline)
                HStack(spacing: 12) {
                    Text("Primary")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(visualDesignSystem.currentColors.primary)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text("Secondary")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(visualDesignSystem.currentColors.secondary.opacity(0.2))
                        .foregroundColor(visualDesignSystem.currentColors.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text("Disabled")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(visualDesignSystem.currentColors.disabled)
                        .foregroundColor(visualDesignSystem.currentColors.textDisabled)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private func typographyShowcaseSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Typography")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                Text("Large Title")
                    .font(visualDesignSystem.currentTypography.largeTitle)
                    .foregroundColor(visualDesignSystem.currentColors.text)

                Text("Title")
                    .font(visualDesignSystem.currentTypography.title1)
                    .foregroundColor(visualDesignSystem.currentColors.text)

                Text("Headline")
                    .font(visualDesignSystem.currentTypography.headline)
                    .foregroundColor(visualDesignSystem.currentColors.text)

                Text("Body")
                    .font(visualDesignSystem.currentTypography.body)
                    .foregroundColor(visualDesignSystem.currentColors.text)

                Text("Caption")
                    .font(visualDesignSystem.currentTypography.caption1)
                    .foregroundColor(visualDesignSystem.currentColors.textSecondary)
            }
        }
    }

    private func spacingShowcaseSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spacing Scale")
                .font(.title2)
                .fontWeight(.bold)

            let spacing = visualDesignSystem.currentSpacing

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: spacing.xs) {
                    Text("xs:").fontWeight(.semibold)
                    Text("\(Int(spacing.xs))pt").font(.caption)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(visualDesignSystem.currentColors.primary)
                        .frame(width: spacing.xs, height: 16)
                }

                HStack(spacing: spacing.sm) {
                    Text("sm:").fontWeight(.semibold)
                    Text("\(Int(spacing.sm))pt").font(.caption)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(visualDesignSystem.currentColors.primary)
                        .frame(width: spacing.sm, height: 16)
                }

                HStack(spacing: spacing.md) {
                    Text("md:").fontWeight(.semibold)
                    Text("\(Int(spacing.md))pt").font(.caption)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(visualDesignSystem.currentColors.primary)
                        .frame(width: spacing.md, height: 16)
                }

                HStack(spacing: spacing.lg) {
                    Text("lg:").fontWeight(.semibold)
                    Text("\(Int(spacing.lg))pt").font(.caption)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(visualDesignSystem.currentColors.primary)
                        .frame(width: spacing.lg, height: 16)
                }
            }
        }
    }
}

// MARK: - Helper Extensions

extension Color {
    /// Initialize Color from hex string
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

struct DesignSystemBridgeExample_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystemBridgeExample()
    }
}