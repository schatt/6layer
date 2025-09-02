import SwiftUI

// MARK: - Platform Forms Layer 4: Layout Implementation
/// This layer provides platform-specific form components that implement
/// form patterns across iOS and macOS. This layer handles the specific
/// implementation of form components.

public extension View {
    
    /// Platform-specific form section with consistent styling
    /// Provides standardized form section appearance across platforms
    func platformFormSection<Content: View>(
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Group {
            if let header = header, let footer = footer {
                Section {
                    content()
                } header: {
                    Text(header)
                        .font(.headline)
                        .foregroundColor(Color.platformLabel)
                } footer: {
                    Text(footer)
                        .font(.caption)
                        .foregroundColor(Color.platformSecondaryLabel)
                }
            } else if let header = header {
                Section {
                    content()
                } header: {
                    Text(header)
                        .font(.headline)
                        .foregroundColor(Color.platformLabel)
                }
            } else if let footer = footer {
                Section {
                    content()
                } footer: {
                    Text(footer)
                        .font(.caption)
                        .foregroundColor(Color.platformSecondaryLabel)
                }
            } else {
                Section {
                    content()
                }
            }
        }
    }
    
    /// Platform-specific form field with consistent styling
    /// Provides standardized form field appearance across platforms
    func platformFormField<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .padding(.vertical, 4)
    }
    
    /// Platform-specific form field group for related fields
    /// Groups related fields with visual separation
    func platformFormFieldGroup<Content: View>(
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.platformLabel)
                    .padding(.horizontal, 4)
            }
            
            VStack(spacing: 8) {
                content()
            }
            .padding()
            .background(Color.platformSecondaryBackground)
            .cornerRadius(8)
        }
    }
    
    /// Platform-specific validation message with consistent styling
    /// Provides standardized validation message appearance across platforms
    func platformValidationMessage(
        _ message: String,
        type: ValidationType = .error
    ) -> some View {
        HStack(spacing: 4) {
            Image(systemName: type.iconName)
                .foregroundColor(type.color)
                .font(.caption)
            
            Text(message)
                .font(.caption)
                .foregroundColor(type.color)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(type.color.opacity(0.1))
        .cornerRadius(4)
    }
    
    /// Platform-specific form divider with consistent styling
    /// Provides visual separation between form sections
    func platformFormDivider() -> some View {
        Rectangle()
            .fill(Color.platformSeparator)
            .frame(height: 1)
            .padding(.vertical, 8)
    }
    
    /// Platform-specific form spacing with consistent sizing
    /// Provides standardized spacing between form elements
    func platformFormSpacing(_ size: FormSpacing) -> some View {
        Spacer()
            .frame(height: size.rawValue)
    }
}

// MARK: - Validation Types

/// Validation message types for form fields
public enum ValidationType {
    case error, warning, success, info
    
    var color: Color {
        switch self {
        case .error: return .red
        case .warning: return .orange
        case .success: return .green
        case .info: return .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .error: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.triangle"
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle"
        }
    }
}

// MARK: - Form Spacing

/// Standardized form spacing values
public enum FormSpacing: CGFloat, CaseIterable {
    case small = 8
    case medium = 16
    case large = 24
    case extraLarge = 32
}

// MARK: - Migration Phase: Temporary Type-Specific Layer 4 Functions

/// Generic Layer 4 function for form container implementation
/// This implements the actual container based on the strategy from Layer 3
@MainActor
    func platformFormContainer_L4<Content: View>(
    strategy: FormStrategy,
    @ViewBuilder content: @escaping () -> Content
) -> some View {
    
    // Implement the container based on the strategy
    switch strategy.containerType {
    case .form:
        // Use SwiftUI Form (works well on macOS, can have issues on iOS)
        return AnyView(
            Form {
                content()
            }
            .background(Color.platformGroupedBackground)
        )
        
    case .standard:
        // Standard container implementation
        let spacing: CGFloat = {
            switch strategy.fieldLayout {
            case .compact: return 8
            case .standard: return 16
            case .spacious: return 20
            case .adaptive: return 16
            case .vertical: return 16
            case .horizontal: return 12
            case .grid: return 20
            }
        }()
        return AnyView(
            VStack(spacing: spacing) {
                content()
            }
            .padding()
            .background(Color.platformSecondaryBackground)
            .cornerRadius(8)
        )
        
    case .scrollView:
        // Use ScrollView + VStack (reliable on iOS, works on macOS too)
        let spacing: CGFloat = {
            switch strategy.fieldLayout {
            case .compact: return 8
            case .standard: return 16
            case .spacious: return 20
            case .adaptive: return 16
            case .vertical: return 16
            case .horizontal: return 12
            case .grid: return 20
            }
        }()
        
        return AnyView(
            ScrollView {
                VStack(spacing: spacing) {
                    content()
                }
                .padding(.vertical)
            }
            .background(Color.platformGroupedBackground)
        )
        
    case .custom:
        // Custom container implementation
        let spacing: CGFloat = {
            switch strategy.fieldLayout {
            case .compact: return 8
            case .standard: return 16
            case .spacious: return 20
            case .adaptive: return 16
            case .vertical: return 16
            case .horizontal: return 12
            case .grid: return 20
            }
        }()
        return AnyView(
            VStack(spacing: spacing) {
                content()
            }
            .padding()
            .background(Color.platformSecondaryBackground)
            .cornerRadius(8)
        )
        
    case .adaptive:
        // Adaptive container that adjusts based on content
        let spacing: CGFloat = {
            switch strategy.fieldLayout {
            case .compact: return 8
            case .standard: return 16
            case .spacious: return 20
            case .adaptive: return 16
            case .vertical: return 16
            case .horizontal: return 12
            case .grid: return 20
            }
        }()
        return AnyView(
            VStack(spacing: spacing) {
                content()
            }
            .padding()
            .background(Color.platformSecondaryBackground)
            .cornerRadius(12)
        )
    }
}
