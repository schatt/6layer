import Foundation
import SwiftUI

// MARK: - Platform UI Integration
// Integration layer that combines platform-specific patterns with theming

/// Comprehensive platform UI integration that provides intelligent, adaptive components
public struct PlatformUIIntegration {
    
    // MARK: - Smart Navigation Container
    
    /// Intelligent navigation container that adapts to platform and content
    public struct SmartNavigationContainer<Content: View>: View {
        let content: Content
        let title: String
        let navigationStyle: NavigationStyle
        let context: NavigationContext
        
        @Environment(\.platformStyle) private var platform
        @Environment(\.colorSystem) private var colors
        @Environment(\.typographySystem) private var typography
        @Environment(\.accessibilitySettings) private var accessibility
        
        public init(
            title: String,
            style: NavigationStyle = .adaptive,
            context: NavigationContext = .standard,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.navigationStyle = style
            self.context = context
            self.content = content()
        }
        
        public var body: some View {
            AdaptiveUIPatterns.AdaptiveNavigation(
                style: navigationStyle,
                context: context
            ) {
                VStack(spacing: 0) {
                    // Header
                    if shouldShowHeader {
                        headerView
                    }
                    
                    // Content
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(adaptiveTitleDisplayMode)
            #endif
        }
        
        private var shouldShowHeader: Bool {
            switch platform {
            case .ios: return !context.isCompact
            case .macOS: return true
            case .watchOS: return false
            case .tvOS: return true
            case .visionOS: return true
            }
        }
        
        private var headerView: some View {
            HStack {
                Text(title)
                    .font(typography.largeTitle)
                    .foregroundColor(colors.text)
                    .fontWeight(.bold)
                
                Spacer()
                
                if accessibility.voiceOverSupport {
                    Button("Skip to content") {
                        // Handle skip to content
                    }
                    .font(typography.caption1)
                    .foregroundColor(colors.primary)
                }
            }
            .padding()
            .background(colors.surface)
            .overlay(
                Rectangle()
                    .fill(colors.border)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
        
        #if os(iOS)
        private var adaptiveTitleDisplayMode: NavigationBarItem.TitleDisplayMode {
            switch platform {
            case .ios:
                return context.isCompact ? .inline : .large
            case .macOS:
                return .inline
            case .watchOS:
                return .inline
            case .tvOS:
                return .large
            }
        }
        #endif
    }
    
    // MARK: - Smart Modal Container
    
    /// Intelligent modal container that adapts to platform and content
    public struct SmartModalContainer<Content: View>: View {
        let content: Content
        let title: String
        let presentationStyle: ModalPresentationStyle
        let isPresented: Binding<Bool>
        let onDismiss: (() -> Void)?
        
        @Environment(\.platformStyle) private var platform
        @Environment(\.colorSystem) private var colors
        @Environment(\.typographySystem) private var typography
        
        public init(
            title: String,
            isPresented: Binding<Bool>,
            style: ModalPresentationStyle = .adaptive,
            onDismiss: (() -> Void)? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.isPresented = isPresented
            self.presentationStyle = style
            self.onDismiss = onDismiss
            self.content = content()
        }
        
        public var body: some View {
            AdaptiveUIPatterns.AdaptiveModal(
                isPresented: isPresented,
                style: presentationStyle,
                onDismiss: onDismiss
            ) {
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Content
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        
        private var headerView: some View {
            HStack {
                Text(title)
                    .font(typography.title2)
                    .foregroundColor(colors.text)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Done") {
                    isPresented.wrappedValue = false
                    onDismiss?()
                }
                .font(typography.body)
                .foregroundColor(colors.primary)
            }
            .padding()
            .background(colors.surface)
            .overlay(
                Rectangle()
                    .fill(colors.border)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
    }
    
    // MARK: - Smart List Container
    
    /// Intelligent list container that adapts to platform and content
    public struct SmartListContainer<Data: RandomAccessCollection, Content: View>: View 
    where Data.Element: Identifiable {
        let data: Data
        let content: (Data.Element) -> Content
        let title: String
        let listStyle: ListStyle
        let context: ListContext
        let onAdd: (() -> Void)?
        
        @Environment(\.platformStyle) private var platform
        @Environment(\.colorSystem) private var colors
        @Environment(\.typographySystem) private var typography
        
        public init(
            _ data: Data,
            title: String,
            style: ListStyle = .adaptive,
            context: ListContext = .standard,
            onAdd: (() -> Void)? = nil,
            @ViewBuilder content: @escaping (Data.Element) -> Content
        ) {
            self.data = data
            self.content = content
            self.title = title
            self.listStyle = style
            self.context = context
            self.onAdd = onAdd
        }
        
        public var body: some View {
            VStack(spacing: 0) {
                // Header
                if shouldShowHeader {
                    headerView
                }
                
                // List
                AdaptiveUIPatterns.AdaptiveList(
                    data,
                    style: listStyle,
                    context: context,
                    content: content
                )
            }
        }
        
        private var shouldShowHeader: Bool {
            switch platform {
            case .ios: return !context.isCompact
            case .macOS: return true
            case .watchOS: return false
            case .tvOS: return true
            case .visionOS: return true
            }
        }
        
        private var headerView: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(typography.title2)
                        .foregroundColor(colors.text)
                        .fontWeight(.semibold)
                    
                    Text("\(data.count) items")
                        .font(typography.caption1)
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
                
                if let onAdd = onAdd {
                    AdaptiveUIPatterns.AdaptiveButton(
                        "Add",
                        icon: "plus",
                        style: .primary,
                        size: .small,
                        action: onAdd
                    )
                }
            }
            .padding()
            .background(colors.surface)
            .overlay(
                Rectangle()
                    .fill(colors.border)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
    }
    
    // MARK: - Smart Form Container
    
    /// Intelligent form container that adapts to platform and content
    public struct SmartFormContainer<Content: View>: View {
        let content: Content
        let title: String
        let onSubmit: (() -> Void)?
        let onCancel: (() -> Void)?
        
        @Environment(\.platformStyle) private var platform
        @Environment(\.colorSystem) private var colors
        @Environment(\.typographySystem) private var typography
        
        public init(
            title: String,
            onSubmit: (() -> Void)? = nil,
            onCancel: (() -> Void)? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.onSubmit = onSubmit
            self.onCancel = onCancel
            self.content = content()
        }
        
        public var body: some View {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Form content
                ScrollView {
                    VStack(spacing: 16) {
                        content
                    }
                    .padding()
                }
                .background(colors.background)
                
                // Footer
                if shouldShowFooter {
                    footerView
                }
            }
            .themedCard()
        }
        
        private var shouldShowFooter: Bool {
            onSubmit != nil || onCancel != nil
        }
        
        private var headerView: some View {
            HStack {
                Text(title)
                    .font(typography.title2)
                    .foregroundColor(colors.text)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if let onCancel = onCancel {
                    AdaptiveUIPatterns.AdaptiveButton(
                        "Cancel",
                        style: .ghost,
                        size: .small,
                        action: onCancel
                    )
                }
            }
            .padding()
            .background(colors.surface)
            .overlay(
                Rectangle()
                    .fill(colors.border)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
        
        private var footerView: some View {
            HStack {
                if let onCancel = onCancel {
                    AdaptiveUIPatterns.AdaptiveButton(
                        "Cancel",
                        style: .outline,
                        size: .medium,
                        action: onCancel
                    )
                }
                
                Spacer()
                
                if let onSubmit = onSubmit {
                    AdaptiveUIPatterns.AdaptiveButton(
                        "Submit",
                        style: .primary,
                        size: .medium,
                        action: onSubmit
                    )
                }
            }
            .padding()
            .background(colors.surface)
            .overlay(
                Rectangle()
                    .fill(colors.border)
                    .frame(height: 1),
                alignment: .top
            )
        }
    }
    
    // MARK: - Smart Card Container
    
    /// Intelligent card container that adapts to platform and content
    public struct SmartCardContainer<Content: View>: View {
        let content: Content
        let title: String?
        let subtitle: String?
        let action: (() -> Void)?
        let actionTitle: String?
        
        @Environment(\.platformStyle) private var platform
        @Environment(\.colorSystem) private var colors
        @Environment(\.typographySystem) private var typography
        
        public init(
            title: String? = nil,
            subtitle: String? = nil,
            actionTitle: String? = nil,
            action: (() -> Void)? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.subtitle = subtitle
            self.actionTitle = actionTitle
            self.action = action
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                if let title = title {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(typography.headline)
                            .foregroundColor(colors.text)
                            .fontWeight(.semibold)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(typography.subheadline)
                                .foregroundColor(colors.textSecondary)
                        }
                    }
                }
                
                // Content
                content
                
                // Action
                if let action = action, let actionTitle = actionTitle {
                    HStack {
                        Spacer()
                        AdaptiveUIPatterns.AdaptiveButton(
                            actionTitle,
                            style: .outline,
                            size: .small,
                            action: action
                        )
                    }
                }
            }
            .padding()
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(colors.border, lineWidth: 1)
            )
            .shadow(
                color: Color.black.opacity(0.1),
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
        }
        
        private var cornerRadius: CGFloat {
            switch platform {
            case .ios: return 12
            case .macOS: return 8
            case .watchOS: return 16
            case .tvOS: return 12
            case .visionOS: return 14
            }
        }
        
        private var shadowRadius: CGFloat {
            switch platform {
            case .ios: return 4
            case .macOS: return 2
            case .watchOS: return 0
            case .tvOS: return 4
            case .visionOS: return 5
            }
        }
        
        private var shadowOffset: CGFloat {
            switch platform {
            case .ios: return 2
            case .macOS: return 1
            case .watchOS: return 0
            case .tvOS: return 2
            case .visionOS: return 3
            }
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Wrap this view in a smart navigation container
    func smartNavigation(
        title: String,
        style: NavigationStyle = .adaptive,
        context: NavigationContext = .standard
    ) -> some View {
        PlatformUIIntegration.SmartNavigationContainer(
            title: title,
            style: style,
            context: context
        ) {
            self
        }
    }
    
    /// Wrap this view in a smart modal container
    func smartModal(
        title: String,
        isPresented: Binding<Bool>,
        style: ModalPresentationStyle = .adaptive,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        PlatformUIIntegration.SmartModalContainer(
            title: title,
            isPresented: isPresented,
            style: style,
            onDismiss: onDismiss
        ) {
            self
        }
    }
    
    /// Wrap this view in a smart form container
    func smartForm(
        title: String,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        PlatformUIIntegration.SmartFormContainer(
            title: title,
            onSubmit: onSubmit,
            onCancel: onCancel
        ) {
            self
        }
    }
    
    /// Wrap this view in a smart card container
    func smartCard(
        title: String? = nil,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        PlatformUIIntegration.SmartCardContainer(
            title: title,
            subtitle: subtitle,
            actionTitle: actionTitle,
            action: action
        ) {
            self
        }
    }
}
