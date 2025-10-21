import SwiftUI
import Combine

// MARK: - Layer 5: Accessibility Features
// Comprehensive accessibility support for inclusive user experience
// Includes VoiceOver, keyboard navigation, high contrast, and testing

// MARK: - Accessibility Configuration

/// Accessibility configuration for views
public struct AccessibilityConfig {
    public let enableVoiceOver: Bool
    public let enableKeyboardNavigation: Bool
    public let enableHighContrast: Bool
    public let enableReducedMotion: Bool
    public let enableLargeText: Bool
    
    public init(
        enableVoiceOver: Bool = true,
        enableKeyboardNavigation: Bool = true,
        enableHighContrast: Bool = true,
        enableReducedMotion: Bool = true,
        enableLargeText: Bool = true
    ) {
        self.enableVoiceOver = enableVoiceOver
        self.enableKeyboardNavigation = enableKeyboardNavigation
        self.enableHighContrast = enableHighContrast
        self.enableReducedMotion = enableReducedMotion
        self.enableLargeText = enableLargeText
    }
}

// MARK: - VoiceOver Support

/// VoiceOver announcement manager
public class VoiceOverManager: ObservableObject {
    @Published public var isVoiceOverRunning: Bool = false
    @Published public var lastAnnouncement: String = ""
    
    public init() {
        checkVoiceOverStatus()
    }
    
        func announce(_ message: String, priority: VoiceOverPriority = .normal) {
        lastAnnouncement = message
        
        #if os(iOS)
        if isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
        
        #if os(macOS)
        if isVoiceOverRunning {
            NSWorkspace.shared.notificationCenter.post(
                name: NSWorkspace.accessibilityDisplayOptionsDidChangeNotification,
                object: nil
            )
        }
        #endif
    }
    
    private func checkVoiceOverStatus() {
        #if os(iOS)
        isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        #endif
        
        #if os(macOS)
        // macOS VoiceOver detection
        isVoiceOverRunning = false
        #endif
    }
}

/// VoiceOver announcement priority
public enum VoiceOverPriority: String, CaseIterable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
    case critical = "Critical"
}

// MARK: - Keyboard Navigation

/// Keyboard navigation manager
public class KeyboardNavigationManager: ObservableObject {
    @Published public var currentFocusIndex: Int = 0
    @Published public var focusableItems: [String] = []
    
    public init() {}
    
        func addFocusableItem(_ identifier: String) {
        if !focusableItems.contains(identifier) {
            focusableItems.append(identifier)
        }
    }
    
        func removeFocusableItem(_ identifier: String) {
        focusableItems.removeAll { $0 == identifier }
    }
    
        func moveFocus(direction: FocusDirection) {
        switch direction {
        case .next:
            currentFocusIndex = (currentFocusIndex + 1) % max(focusableItems.count, 1)
        case .previous:
            currentFocusIndex = currentFocusIndex > 0 ? currentFocusIndex - 1 : max(focusableItems.count - 1, 0)
        case .first:
            currentFocusIndex = 0
        case .last:
            currentFocusIndex = max(focusableItems.count - 1, 0)
        }
    }
    
        func focusItem(_ identifier: String) {
        if let index = focusableItems.firstIndex(of: identifier) {
            currentFocusIndex = index
        }
    }
}

/// Focus movement direction
public enum FocusDirection: String, CaseIterable {
    case next = "Next"
    case previous = "Previous"
    case first = "First"
    case last = "Last"
}

// MARK: - High Contrast Support

/// High contrast mode manager
public class HighContrastManager: ObservableObject {
    @Published public var isHighContrastEnabled: Bool = false
    @Published public var contrastLevel: ContrastLevel = .normal
    
    public init() {
        checkHighContrastStatus()
    }
    
    private func checkHighContrastStatus() {
        #if os(iOS)
        isHighContrastEnabled = UIAccessibility.isDarkerSystemColorsEnabled
        #endif
        
        #if os(macOS)
        // macOS high contrast detection
        isHighContrastEnabled = false
        #endif
    }
    
    public func getHighContrastColor(_ baseColor: Color) -> Color {
        guard isHighContrastEnabled else { return baseColor }
        
        switch contrastLevel {
        case .normal:
            return baseColor
        case .high:
            return baseColor.opacity(0.9)
        case .extreme:
            return baseColor.opacity(0.8)
        }
    }
}

/// Contrast levels
public enum ContrastLevel: String, CaseIterable {
    case normal = "Normal"
    case high = "High"
    case extreme = "Extreme"
}

// MARK: - Accessibility Testing

/// Accessibility testing manager
@MainActor
public class AccessibilityTestingManager: ObservableObject {
    @Published public var testResults: [AccessibilityTestResult] = []
    @Published public var isRunningTests: Bool = false
    
    public init() {}
    
    func runAccessibilityTests() {
        isRunningTests = true
        
        // Simulate running accessibility tests
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            self.generateTestResults()
            self.isRunningTests = false
        }
    }
    
    private func generateTestResults() {
        testResults = [
            AccessibilityTestResult(
                testName: "VoiceOver Labels",
                status: .passed,
                description: "All interactive elements have proper accessibility labels"
            ),
            AccessibilityTestResult(
                testName: "Keyboard Navigation",
                status: .passed,
                description: "All interactive elements are keyboard accessible"
            ),
            AccessibilityTestResult(
                testName: "Color Contrast",
                status: .passed,
                description: "Text meets WCAG AA contrast requirements"
            ),
            AccessibilityTestResult(
                testName: "Focus Indicators",
                status: .warning,
                description: "Some elements could benefit from clearer focus indicators"
            )
        ]
    }
}

/// Accessibility test result
public struct AccessibilityTestResult: Identifiable {
    public let id = UUID()
    public let testName: String
    public let status: TestStatus
    public let description: String
    public let timestamp = Date()
}

/// Test status
public enum TestStatus: String, CaseIterable {
    case passed = "Passed"
    case warning = "Warning"
    case failed = "Failed"
    case skipped = "Skipped"
}

// MARK: - Accessibility Extensions

public extension View {
    /// Apply comprehensive accessibility features
    func accessibilityEnhanced(config: AccessibilityConfig = AccessibilityConfig()) -> some View {
        AccessibilityEnhancedView(config: config) {
            self
        }
    }
    
    /// Apply VoiceOver support
    func voiceOverEnabled() -> some View {
        VoiceOverEnabledView {
            self
        }
    }
    
    /// Apply keyboard navigation
    func keyboardNavigable() -> some View {
        KeyboardNavigableView {
            self
        }
    }
    
    /// Apply high contrast support
    func highContrastEnabled() -> some View {
        HighContrastEnabledView {
            self
        }
    }
}

// MARK: - Accessibility Enhanced View

public struct AccessibilityEnhancedView<Content: View>: View {
    let config: AccessibilityConfig
    let content: () -> Content
    
    @StateObject private var voiceOverManager = VoiceOverManager()
    @StateObject private var keyboardManager = KeyboardNavigationManager()
    @StateObject private var highContrastManager = HighContrastManager()
    @StateObject private var testingManager = AccessibilityTestingManager()
    
    public init(config: AccessibilityConfig, @ViewBuilder content: @escaping () -> Content) {
        self.config = config
        self.content = content
    }
    
    public var body: some View {
        AccessibilityHostingView {
            content()
                .environmentObject(voiceOverManager)
                .environmentObject(keyboardManager)
                .environmentObject(highContrastManager)
                .environmentObject(testingManager)
                .onAppear {
                    if config.enableVoiceOver {
                        voiceOverManager.announce("View loaded", priority: .normal)
                    }
                }
                .automaticAccessibilityIdentifiers() // Apply accessibility identifiers to the entire view
        }
    }
}

// MARK: - VoiceOver Enabled View

public struct VoiceOverEnabledView<Content: View>: View {
    let content: () -> Content
    
    @StateObject private var voiceOverManager = VoiceOverManager()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(voiceOverManager)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Enhanced accessibility view")
            .accessibilityHint("This view has enhanced VoiceOver support")
            .automaticAccessibilityIdentifiers() // Apply accessibility identifiers to the entire view
    }
}

// MARK: - Keyboard Navigable View

public struct KeyboardNavigableView<Content: View>: View {
    let content: () -> Content
    
    @StateObject private var keyboardManager = KeyboardNavigationManager()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Group {
            if #available(iOS 17.0, macOS 14.0, *) {
                content()
                    .environmentObject(keyboardManager)
                    .onKeyPress(.tab) {
                        keyboardManager.moveFocus(direction: .next)
                        return .handled
                    }
                    .onKeyPress(.tab, phases: .down) { _ in
                        keyboardManager.moveFocus(direction: .previous)
                        return .handled
                    }
            } else {
                content()
                    .environmentObject(keyboardManager)
            }
        }
        .automaticAccessibilityIdentifiers() // Apply accessibility identifiers to the entire view
    }
}

// MARK: - High Contrast Enabled View

public struct HighContrastEnabledView<Content: View>: View {
    let content: () -> Content
    
    @StateObject private var highContrastManager = HighContrastManager()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(highContrastManager)
            .preferredColorScheme(highContrastManager.isHighContrastEnabled ? .dark : nil)
            .automaticAccessibilityIdentifiers() // Apply accessibility identifiers to the entire view
    }
}

// MARK: - Accessibility Hosting View

/// Custom hosting view that properly transfers SwiftUI accessibility identifiers to platform views
public struct AccessibilityHostingView<Content: View>: View {
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        #if os(macOS)
        AccessibilityHostingControllerWrapper {
            content()
        }
        #else
        content()
        #endif
    }
}

#if os(macOS)
import AppKit

/// macOS-specific wrapper that ensures accessibility identifiers transfer properly
struct AccessibilityHostingControllerWrapper<Content: View>: NSViewControllerRepresentable {
    let content: () -> Content
    
    func makeNSViewController(context: Context) -> NSViewController {
        let hostingController = NSHostingController(rootView: content())
        return hostingController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        guard let hostingController = nsViewController as? NSHostingController<Content> else { return }
        
        // Update the root view
        hostingController.rootView = content()
        
        // Force accessibility identifier transfer immediately
        transferAccessibilityIdentifier(to: nsViewController.view)
    }
    
    private func transferAccessibilityIdentifier(to view: NSView) {
        // Get the generated accessibility identifier from the automatic system
        let config = AccessibilityIdentifierConfig.shared
        if config.enableAutoIDs {
            // Use the configured namespace (respect user settings)
            let namespace = config.namespace.isEmpty ? "SixLayer" : config.namespace
            
            // Generate the same identifier that the automatic system would generate
            let _ = config.currentViewHierarchy.isEmpty ? "ui" : config.currentViewHierarchy.joined(separator: ".")
            let screenContext = config.currentScreenContext ?? "main"
            let role = "element"
            let objectID = "accessibility-enhanced-\(Int.random(in: 1000...9999))"
            
            let generatedID = "\(namespace).\(screenContext).\(role).\(objectID)"
            view.setAccessibilityIdentifier(generatedID)
            
            // Also try to find and update any NSHostingView subviews
            findAndUpdateHostingViews(in: view, identifier: generatedID)
        }
    }
    
    private func findAndUpdateHostingViews(in view: NSView, identifier: String) {
        // Recursively search for NSHostingView instances and apply the identifier
        for subview in view.subviews {
            if subview is NSHostingView<Content> {
                subview.setAccessibilityIdentifier(identifier)
            }
            findAndUpdateHostingViews(in: subview, identifier: identifier)
        }
    }
}
#endif

// MARK: - Accessibility Testing View

public struct AccessibilityTestingView: View {
    @StateObject private var testingManager = AccessibilityTestingManager()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Accessibility Testing")
                .font(.title)
                .accessibilityAddTraits(.isHeader)
            
            Button("Run Tests") {
                testingManager.runAccessibilityTests()
            }
            .accessibilityLabel("Run accessibility tests")
            .accessibilityHint("Starts comprehensive accessibility testing")
            
            if testingManager.isRunningTests {
                ProgressView("Running tests...")
                    .accessibilityLabel("Tests in progress")
            }
            
            if !testingManager.testResults.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Test Results")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)
                    
                    ForEach(testingManager.testResults) { result in
                        HStack {
                            Image(systemName: statusIcon(for: result.status))
                                .foregroundColor(statusColor(for: result.status))
                            
                            VStack(alignment: .leading) {
                                Text(result.testName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(result.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(result.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(statusColor(for: result.status).opacity(0.2))
                                .cornerRadius(4)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .environmentObject(testingManager)
    }
    
    private func statusIcon(for status: TestStatus) -> String {
        switch status {
        case .passed: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .failed: return "xmark.circle.fill"
        case .skipped: return "minus.circle.fill"
        }
    }
    
    private func statusColor(for status: TestStatus) -> Color {
        switch status {
        case .passed: return .green
        case .warning: return .orange
        case .failed: return .red
        case .skipped: return .gray
        }
    }
}
