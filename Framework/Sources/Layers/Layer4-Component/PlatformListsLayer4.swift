import SwiftUI

// MARK: - Platform Lists Layer 3: Layout Implementation
/// This layer provides platform-specific list components that implement
/// list patterns across iOS and macOS. This layer handles the specific
/// implementation of list components.
public extension View {
    
    /// Platform-specific list row with consistent styling
    /// Provides standardized list row appearance across platforms
        func platformListRow<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack {
            content()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .automaticAccessibilityIdentifiers(named: "platformListRow")
    }
    
    /// Platform-specific list section header with consistent styling
    /// Provides standardized section header appearance across platforms
        func platformListSectionHeader(
        title: String,
        subtitle: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "platformListSectionHeader")
    }
    
    /// Platform-specific list empty state with consistent styling
    /// Provides standardized empty state appearance across platforms
    func platformListEmptyState(
        systemImage: String,
        title: String,
        message: String
    ) -> some View {
        VStack(spacing: 16) {
            #if os(macOS)
            if #available(macOS 11.0, *) {
                Image(systemName: systemImage)
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
            } else {
                // Fallback for older macOS versions
                Text("📋")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
            }
            #else
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            #endif
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "platformListEmptyState")
    }
    
    // MARK: - List-Detail Implementation
    
    /// Platform-specific list-detail container
    /// Implements the actual UI structure for list-detail patterns
    func platformListDetailContainer<ListContent: View, DetailContent: View>(
        @ViewBuilder list: () -> ListContent,
        @ViewBuilder detail: () -> DetailContent
    ) -> some View {
        #if os(macOS)
        if #available(macOS 13.0, *) {
            AnyView(NavigationSplitView {
                list()
            } detail: {
                detail()
            })
        } else {
            AnyView(HStack {
                list()
                detail()
            })
        }
        #else
        if #available(iOS 16.0, *) {
            AnyView(NavigationStack {
                list()
            })
        } else {
            AnyView(NavigationView {
                list()
            })
        }
        #endif
    }
    
    /// Platform-specific selectable list row
    /// Implements selection behavior for list-detail patterns
    func platformSelectableListRow<Content: View>(
        isSelected: Bool,
        onSelect: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        return Button(action: onSelect) {
            HStack {
                content()
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(backgroundColorForSelection(isSelected: isSelected))
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
    
    /// Platform-specific detail pane placeholder
    /// Shows when no item is selected in list-detail views
    func platformDetailPlaceholder(
        systemImage: String,
        title: String,
        message: String
    ) -> some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
        .automaticAccessibilityIdentifiers(named: "platformDetailPlaceholder")
    }
    
    // MARK: - Private Helper Functions
    
    /// Helper function to determine background color for list selection
    private func backgroundColorForSelection(isSelected: Bool) -> Color {
        #if os(macOS)
        return isSelected ? Color.accentColor.opacity(0.1) : Color.clear
        #else
        return Color.clear
        #endif
    }
}
