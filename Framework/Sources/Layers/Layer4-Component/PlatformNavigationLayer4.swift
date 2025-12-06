import SwiftUI

// MARK: - Platform Navigation Layer 4: Component Implementation
/// This layer provides platform-specific navigation components that implement
/// navigation patterns across iOS and macOS. This layer handles the specific
/// implementation of navigation components.

// MARK: - Navigation Types
// PlatformTitleDisplayMode is defined in PlatformUITypes.swift

public extension View {
    
    /// Platform-specific navigation wrapper that provides consistent navigation patterns
    /// across iOS and macOS. On iOS, this wraps content in a NavigationView.
    /// On macOS, this returns the content directly.
    func platformNavigation<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let baseView: AnyView = {
            #if os(iOS)
            if #available(iOS 16.0, *) {
                // Use NavigationStack on iOS 16+
                return AnyView(NavigationStack {
                    content()
                })
            } else {
                // Fallback to NavigationView for iOS 15 and earlier
                return AnyView(NavigationView {
                    content()
                })
            }
            #else
            return AnyView(content())
            #endif
        }()
        return baseView
            .automaticCompliance(named: "platformNavigation")
    }

    /// Wraps nested navigation in a platform-appropriate container
    /// iOS: NavigationStack; macOS: identity
    @ViewBuilder
    func platformNavigationContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            NavigationStack { content() }
                .automaticCompliance(named: "platformNavigationContainer")
        } else {
            content()
                .automaticCompliance(named: "platformNavigationContainer")
        }
        #else
        content()
            .automaticCompliance(named: "platformNavigationContainer")
        #endif
    }

    /// Platform-conditional navigation destination hook
    /// iOS: forwards to .navigationDestination; macOS: no-op passthrough
    @ViewBuilder
    func platformNavigationDestination<Item: Identifiable & Hashable, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        #if os(iOS)
        if #available(iOS 17.0, *) {
            self.navigationDestination(item: item, destination: destination)
                .automaticCompliance(named: "platformNavigationDestination")
        } else {
            // iOS 15-16 fallback: no navigation destination support
            self.automaticCompliance(named: "platformNavigationDestination")
        }
        #else
        self.automaticCompliance(named: "platformNavigationDestination")
        #endif
    }

    /// Platform-specific navigation button with consistent styling and accessibility
    /// - Parameters:
    ///   - title: The button title text
    ///   - systemImage: The SF Symbol name for the button icon
    ///   - accessibilityLabel: Accessibility label for screen readers
    ///   - accessibilityHint: Accessibility hint for screen readers
    ///   - action: The action to perform when the button is tapped
    /// - Returns: A view with platform-specific navigation button styling
    func platformNavigationButton(
        title: String,
        systemImage: String,
        accessibilityLabel: String,
        accessibilityHint: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            #if os(macOS)
            if #available(macOS 11.0, *) {
                Label(title, systemImage: systemImage)
                    .foregroundColor(.primary)
            } else {
                HStack {
                    Image(systemName: systemImage)
                    Text(title)
                }
                .foregroundColor(.primary)
            }
            #else
            Label(title, systemImage: systemImage)
                .foregroundColor(.primary)
            #endif
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
        .automaticCompliance()
    }

    /// Platform-specific navigation title configuration
    func platformNavigationTitle(_ title: String) -> some View {
        #if os(iOS)
        return self.navigationTitle(title)
            .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
            .automaticCompliance(named: "platformNavigationTitle")
        #elseif os(macOS)
        return self.navigationTitle(title)
            .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
            .automaticCompliance(named: "platformNavigationTitle")
        #else
        return self.navigationTitle(title)
            .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
            .automaticCompliance(named: "platformNavigationTitle")
        #endif
    }

    /// Platform-specific navigation title display mode
    ///
    /// Applies navigation title display mode consistently across platforms, eliminating
    /// the need for platform-specific conditional compilation.
    ///
    /// - **iOS**: Applies `.navigationBarTitleDisplayMode()` with the specified mode
    /// - **macOS**: No-op (macOS doesn't have this concept)
    /// - **Other platforms**: No-op
    ///
    /// Available modes via `PlatformTitleDisplayMode`:
    /// - `.inline` - Compact inline title
    /// - `.large` - Large title style
    /// - `.automatic` - Platform-determined style
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // ✅ Good: Use platform abstraction (no conditional compilation needed)
    /// Text("Content")
    ///     .platformNavigationTitle("My Title")
    ///     .platformNavigationTitleDisplayMode(.inline)
    ///
    /// // ❌ Avoid: Platform-specific conditional compilation
    /// Text("Content")
    ///     .navigationTitle("My Title")
    ///     #if os(iOS)
    ///     .navigationBarTitleDisplayMode(.inline)
    ///     #endif
    /// ```
    ///
    /// - Parameter displayMode: The display mode to apply (`.inline`, `.large`, or `.automatic`)
    /// - Returns: A view with the platform-appropriate navigation title display mode applied
    func platformNavigationTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(displayMode.navigationBarDisplayMode)
            .automaticCompliance(named: "platformNavigationTitleDisplayMode")
        #else
        return self
            .automaticCompliance(named: "platformNavigationTitleDisplayMode")
        #endif
    }

    /// Platform-specific navigation bar title display mode
    func platformNavigationBarTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(displayMode.navigationBarDisplayMode)
            .automaticCompliance(named: "platformNavigationBarTitleDisplayMode")
        #else
        return self
            .automaticCompliance(named: "platformNavigationBarTitleDisplayMode")
        #endif
    }

    // Note: platformNavigationBarBackButtonHidden moved to PlatformSpecificViewExtensions.swift
    // to consolidate with existing platform-specific logic and avoid naming conflicts

    /// Platform-specific navigation bar items with leading and trailing content
    /// Layer 4: Component Implementation
    func platformNavigationBarItems_L4<L: View, T: View>(
        leading: L,
        trailing: T
    ) -> some View {
        #if os(iOS)
        return self.navigationBarItems(leading: leading, trailing: trailing)
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar items with leading content only
    /// Layer 4: Component Implementation
    func platformNavigationBarItems_L4<L: View>(
        leading: L
    ) -> some View {
        #if os(iOS)
        return self.navigationBarItems(leading: leading)
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar items with trailing content only
    /// Layer 4: Component Implementation
    func platformNavigationBarItems_L4<T: View>(
        trailing: T
    ) -> some View {
        #if os(iOS)
        return self.navigationBarItems(trailing: trailing)
        #else
        return self
        #endif
    }

    /// Platform-specific navigation link that adapts to the platform
    /// iOS: NavigationLink; macOS: Button with navigation state
    /// Layer 4: Component Implementation
    @ViewBuilder
    func platformNavigationLink_L4<Destination: View>(
        title: String,
        systemImage: String,
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            Button(action: { isActive.wrappedValue = true }) {
                Label(title, systemImage: systemImage)
                    .foregroundColor(.primary)
            }
            .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
            .navigationDestination(isPresented: isActive) {
                destination()
            }
        } else {
            Button(action: { isActive.wrappedValue = true }) {
                Label(title, systemImage: systemImage)
                    .foregroundColor(.primary)
            }
            .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
            .background(
                NavigationLink(destination: destination(), isActive: isActive) {
                    EmptyView()
                }
            )
        }
        #elseif os(macOS)
        Button(action: { isActive.wrappedValue = true }) {
            #if os(macOS)
            if #available(macOS 11.0, *) {
                Label(title, systemImage: systemImage)
                    .foregroundColor(.primary)
            } else {
                HStack {
                    Image(systemName: systemImage)
                    Text(title)
                }
                .foregroundColor(.primary)
            }
            #else
            Label(title, systemImage: systemImage)
                .foregroundColor(.primary)
            #endif
        }
        .buttonStyle(PlainButtonStyle())
        .environment(\.accessibilityIdentifierLabel, title) // TDD GREEN: Pass label to identifier generation
        #endif
    }

    /// Platform-specific navigation link with destination and label
    /// Layer 4: Component Implementation
    func platformNavigationLink_L4<Destination: View, Label: View>(
        destination: Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        return NavigationLink(destination: destination, label: label)
        #elseif os(macOS)
        return NavigationLink(destination: destination, label: label)
        #else
        return NavigationLink(destination: destination, label: label)
        #endif
    }

    /// Platform-specific navigation link with value and destination
    /// Layer 4: Component Implementation
    func platformNavigationLink_L4<Value: Hashable, Destination: View, Label: View>(
        value: Value?,
        @ViewBuilder destination: @escaping (Value) -> Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return AnyView(NavigationLink(value: value, label: label)
                .navigationDestination(for: Value.self) { value in
                    destination(value)
                })
        } else {
            // iOS 15 fallback: use traditional NavigationLink
            if let value = value {
                return AnyView(NavigationLink(destination: destination(value), label: label))
            } else {
                return AnyView(NavigationLink(destination: EmptyView(), label: label))
            }
        }
        #elseif os(macOS)
        if #available(macOS 13.0, *) {
            return AnyView(NavigationLink(value: value, label: label)
                .navigationDestination(for: Value.self) { value in
                    destination(value)
                })
        } else {
            // macOS 12 fallback: use traditional NavigationLink
            if let value = value {
                return AnyView(NavigationLink(destination: destination(value), label: label))
            } else {
                return AnyView(NavigationLink(destination: EmptyView(), label: label))
            }
        }
        #else
        return AnyView(NavigationLink(value: value, label: label)
            .navigationDestination(for: Value.self) { value in
                destination(value)
            })
        #endif
    }

    /// Platform-specific navigation link with tag and destination
    /// Layer 4: Component Implementation
    func platformNavigationLink_L4<Tag: Hashable, Destination: View, Label: View>(
        tag: Tag,
        selection: Binding<Tag?>,
        @ViewBuilder destination: @escaping (Tag) -> Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return AnyView(NavigationLink(value: tag) {
                label()
            }
            .navigationDestination(for: Tag.self) { tag in
                destination(tag)
            })
        } else {
            // iOS 15 fallback: use traditional NavigationLink
            return AnyView(NavigationLink(destination: destination(tag), label: label))
        }
        #elseif os(macOS)
        if #available(macOS 13.0, *) {
            return AnyView(NavigationLink(value: tag) {
                label()
            }
            .navigationDestination(for: Tag.self) { tag in
                destination(tag)
            })
        } else {
            // macOS 12 fallback: use traditional NavigationLink
            return AnyView(NavigationLink(destination: destination(tag), label: label))
        }
        #else
        return AnyView(NavigationLink(value: tag) {
            label()
        }
        .navigationDestination(for: Tag.self) { tag in
            destination(tag)
        })
        #endif
    }

    // Note: platformNavigationWithPath functions moved to PlatformSpecificViewExtensions.swift
    // to consolidate with existing platform-specific logic and avoid naming conflicts

    // Removed duplicate function - NavigationPath can already handle [Data]

    // Note: platformNavigationSplitContainer moved to PlatformSemanticLayer1.swift
    // This follows the 6-layer architecture principle of handling platform-specific
    // navigation at the semantic intent layer rather than the implementation layer

    // Note: platformNavigationViewStyle moved to PlatformSpecificViewExtensions.swift
    // to consolidate with existing platform-specific logic and avoid naming conflicts
    
    // MARK: - App Navigation Layer 4
    
    /// Helper to create NavigationSplitView with optional column visibility
    @ViewBuilder
    private func createNavigationSplitView<SidebarContent: View, DetailContent: View>(
        columnVisibility: Binding<NavigationSplitViewVisibility>?,
        @ViewBuilder sidebar: () -> SidebarContent,
        @ViewBuilder detail: () -> DetailContent
    ) -> some View {
        if let columnVisibility = columnVisibility {
            NavigationSplitView(columnVisibility: columnVisibility) {
                sidebar()
            } detail: {
                detail()
            }
        } else {
            NavigationSplitView {
                sidebar()
            } detail: {
                detail()
            }
        }
    }
    
    /// Helper to create sidebar sheet content with platform-appropriate navigation wrapper
    @ViewBuilder
    private func createSidebarSheetContent<SidebarContent: View>(
        sidebarContent: SidebarContent
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            NavigationStack {
                sidebarContent
            }
        } else {
            NavigationView {
                sidebarContent
            }
        }
        #elseif os(macOS)
        sidebarContent
            .frame(minWidth: 400, minHeight: 300)
        #else
        sidebarContent
        #endif
    }
    
    /// Helper to create detail-only view with sidebar sheet
    @ViewBuilder
    private func createDetailOnlyWithSheet<DetailContent: View, SidebarContent: View>(
        showingNavigationSheet: Binding<Bool>?,
        @ViewBuilder detail: () -> DetailContent,
        sidebarContent: SidebarContent
    ) -> some View {
        detail()
            .sheet(isPresented: showingNavigationSheet ?? Binding(get: { false }, set: { _ in })) {
                createSidebarSheetContent(sidebarContent: sidebarContent)
            }
            .automaticCompliance(named: "platformAppNavigation_L4")
    }
    
    /// Platform-specific app navigation with intelligent device-aware pattern selection
    /// Automatically chooses between NavigationSplitView and detail-only based on device capabilities
    ///
    /// **Device-Aware Behavior:**
    /// - **iPad**: Always uses NavigationSplitView
    /// - **macOS**: Always uses NavigationSplitView
    /// - **iPhone Portrait**: Detail-only view (sidebar presented as sheet)
    /// - **iPhone Landscape (Large models)**: NavigationSplitView for Plus/Pro Max models
    /// - **iPhone Landscape (Standard models)**: Detail-only view
    ///
    /// - Parameters:
    ///   - columnVisibility: Optional binding for NavigationSplitView column visibility
    ///   - showingNavigationSheet: Optional binding for sheet presentation (iPhone detail-only mode)
    ///   - strategy: App navigation strategy from Layer 3
    ///   - sidebar: View builder for sidebar content
    ///   - detail: View builder for detail content
    /// - Returns: A view with platform-appropriate navigation pattern
    @MainActor
    @ViewBuilder
    func platformAppNavigation_L4<SidebarContent: View, DetailContent: View>(
        columnVisibility: Binding<NavigationSplitViewVisibility>? = nil,
        showingNavigationSheet: Binding<Bool>? = nil,
        strategy: AppNavigationStrategy,
        @ViewBuilder sidebar: () -> SidebarContent,
        @ViewBuilder detail: () -> DetailContent
    ) -> some View {
        switch strategy.implementation {
        case .splitView:
            // Use NavigationSplitView
            #if os(iOS)
            if #available(iOS 16.0, *) {
                createNavigationSplitView(
                    columnVisibility: columnVisibility,
                    sidebar: sidebar,
                    detail: detail
                )
                .automaticCompliance(named: "platformAppNavigation_L4")
            } else {
                // iOS 15 fallback: Use detail-only with sheet
                // Capture sidebar content before using in escaping closure
                let sidebarContent = sidebar()
                createDetailOnlyWithSheet(
                    showingNavigationSheet: showingNavigationSheet,
                    detail: detail,
                    sidebarContent: sidebarContent
                )
            }
            #elseif os(macOS)
            if #available(macOS 13.0, *) {
                createNavigationSplitView(
                    columnVisibility: columnVisibility,
                    sidebar: sidebar,
                    detail: detail
                )
                .automaticCompliance(named: "platformAppNavigation_L4")
            } else {
                // macOS 12 fallback: Use HStack layout
                HStack(spacing: 0) {
                    sidebar()
                    detail()
                }
                .automaticCompliance(named: "platformAppNavigation_L4")
            }
            #else
            // Other platforms: Use detail-only
            detail()
                .automaticCompliance(named: "platformAppNavigation_L4")
            #endif
            
        case .detailOnly:
            // Use detail-only view with optional sheet for sidebar
            // Capture sidebar content before using in escaping closure
            let sidebarContent = sidebar()
            createDetailOnlyWithSheet(
                showingNavigationSheet: showingNavigationSheet,
                detail: detail,
                sidebarContent: sidebarContent
            )
        }
    }
    
    /// Platform-specific app navigation with automatic strategy detection
    /// Convenience function that automatically determines strategy from device capabilities
    ///
    /// - Parameters:
    ///   - columnVisibility: Optional binding for NavigationSplitView column visibility
    ///   - showingNavigationSheet: Optional binding for sheet presentation (iPhone detail-only mode)
    ///   - sidebar: View builder for sidebar content
    ///   - detail: View builder for detail content
    /// - Returns: A view with platform-appropriate navigation pattern
    @MainActor
    @ViewBuilder
    func platformAppNavigation_L4<SidebarContent: View, DetailContent: View>(
        columnVisibility: Binding<NavigationSplitViewVisibility>? = nil,
        showingNavigationSheet: Binding<Bool>? = nil,
        @ViewBuilder sidebar: () -> SidebarContent,
        @ViewBuilder detail: () -> DetailContent
    ) -> some View {
        // Get current device capabilities
        let deviceType = DeviceType.current
        let deviceCapabilities = DeviceCapabilities()
        let orientation = deviceCapabilities.orientation
        let screenSize = deviceCapabilities.screenSize
        
        // Get iPhone size category if applicable
        #if os(iOS)
        let iPhoneSizeCategory: iPhoneSizeCategory? = deviceType == .phone ? iPhoneSizeCategory.from(screenSize: screenSize) : nil
        #else
        let iPhoneSizeCategory: iPhoneSizeCategory? = nil
        #endif
        
        // Layer 2: Device and orientation-aware decision making
        let l2Decision = determineAppNavigationStrategy_L2(
            deviceType: deviceType,
            orientation: orientation,
            screenSize: screenSize,
            iPhoneSizeCategory: iPhoneSizeCategory
        )
        
        // Layer 3: Platform-aware strategy selection
        let l3Strategy = selectAppNavigationStrategy_L3(
            decision: l2Decision,
            platform: SixLayerPlatform.current
        )
        
        // Use strategy-based implementation
        platformAppNavigation_L4(
            columnVisibility: columnVisibility,
            showingNavigationSheet: showingNavigationSheet,
            strategy: l3Strategy,
            sidebar: sidebar,
            detail: detail
        )
    }
}


