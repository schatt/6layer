import SwiftUI

// MARK: - Platform Forms Layer 3: Layout Implementation
/// This layer provides platform-specific form components that implement
/// form patterns across iOS and macOS. This layer handles the specific
/// implementation of form components.

extension View {
    
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
                } footer: {
                    Text(footer)
                }
            } else if let header = header {
                Section {
                    content()
                } header: {
                    Text(header)
                }
            } else if let footer = footer {
                Section {
                    content()
                } footer: {
                    Text(footer)
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
    }
}

// MARK: - Validation Types

/// Validation message types for form fields
enum ValidationType {
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

// MARK: - Migration Phase: Temporary Type-Specific Layer 4 Functions

/// Generic Layer 4 function for form container implementation
/// This implements the actual container based on the strategy from Layer 3
@MainActor
public func platformFormContainer_L4<Content: View>(
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
            .background(Color.groupedBackground)
        )
        
    case .scrollView:
        // Use ScrollView + VStack (reliable on iOS, works on macOS too)
        let spacing: CGFloat = {
            switch strategy.fieldLayout {
            case .compact: return 8
            case .standard: return 16
            case .spacious: return 20
            case .adaptive: return 16
            }
        }()
        
        return AnyView(
            ScrollView {
                VStack(spacing: spacing) {
                    content()
                }
                .padding(.vertical)
            }
            .background(Color.groupedBackground)
        )
        

    }
}
