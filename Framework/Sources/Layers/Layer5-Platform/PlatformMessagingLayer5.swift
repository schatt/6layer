import SwiftUI

/// Layer 5: Platform - Messaging Layer
///
/// This layer handles platform-specific messaging, notifications, and alerts.
/// It provides a unified API for displaying various types of messages (e.g., toasts, banners, system alerts)
/// that adapt to the native UI/UX patterns of each platform (iOS, macOS, visionOS, etc.).
///
/// The tests for this component need to be improved to verify:
/// - Correct display of different message types on each platform.
/// - Proper accessibility integration for notifications.
/// - Customization options for message appearance and behavior.
/// - Lifecycle management of messages (e.g., dismissal, queuing).
public class PlatformMessagingLayer5 {
    
    // MARK: - Alert Components
    
    /// Creates a platform-specific alert button
    @MainActor
    public func createAlertButton(title: String, style: AlertStyle = .default, action: @escaping () -> Void) -> some View {
        #if os(iOS)
        return Button(title, action: action)
            .buttonStyle(.bordered)
            .foregroundColor(style == .destructive ? .red : .primary)
        #elseif os(macOS)
        return Button(title, action: action)
            .buttonStyle(.bordered)
            .foregroundColor(style == .destructive ? .red : .primary)
        #else
        return Button(title, action: action)
        #endif
    }
    
    /// Creates a platform-specific toast notification
    public func createToastNotification(message: String, type: ToastType = .info) -> some View {
        #if os(iOS)
        return HStack {
            Image(systemName: iconForToastType(type))
                .foregroundColor(colorForToastType(type))
            Text(message)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
        #elseif os(macOS)
        return HStack {
            Image(systemName: iconForToastType(type))
                .foregroundColor(colorForToastType(type))
            Text(message)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(Color(.windowBackgroundColor))
        .cornerRadius(8)
        .shadow(radius: 4)
        #else
        return Text(message)
        #endif
    }
    
    // MARK: - Banner Components
    
    /// Creates a platform-specific banner notification
    public func createBannerNotification(title: String, message: String, type: BannerType = .info) -> some View {
        #if os(iOS)
        return VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            Rectangle()
                .fill(colorForBannerType(type))
                .frame(width: 4),
            alignment: .leading
        )
        #elseif os(macOS)
        return VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.windowBackgroundColor))
        .cornerRadius(8)
        .overlay(
            Rectangle()
                .fill(colorForBannerType(type))
                .frame(width: 4),
            alignment: .leading
        )
        #else
        return VStack(alignment: .leading) {
            Text(title)
            Text(message)
        }
        #endif
    }
    
    // MARK: - Helper Methods
    
    private func iconForToastType(_ type: ToastType) -> String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    private func colorForToastType(_ type: ToastType) -> Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    private func colorForBannerType(_ type: BannerType) -> Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

// MARK: - Supporting Types

public enum AlertStyle {
    case `default`
    case destructive
}

public enum ToastType {
    case success
    case error
    case warning
    case info
}

public enum BannerType {
    case success
    case error
    case warning
    case info
}
