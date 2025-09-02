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
        #if os(iOS)
        return NavigationView {
            content()
        }
        #elseif os(macOS)
        return content()
        #else
        return content()
        #endif
    }

    /// Wraps nested navigation in a platform-appropriate container
    /// iOS: NavigationStack; macOS: identity
    @ViewBuilder
    func platformNavigationContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            NavigationStack { content() }
        } else {
            content()
        }
        #else
        content()
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
        } else {
            // iOS 15-16 fallback: no navigation destination support
            self
        }
        #else
        self
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
    }

    /// Platform-specific navigation title configuration
    func platformNavigationTitle(_ title: String) -> some View {
        #if os(iOS)
        return self.navigationTitle(title)
        #elseif os(macOS)
        return self.navigationTitle(title)
        #else
        return self.navigationTitle(title)
        #endif
    }

    /// Platform-specific navigation title display mode
    func platformNavigationTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(displayMode.navigationBarDisplayMode)
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar title display mode
    func platformNavigationBarTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(displayMode.navigationBarDisplayMode)
        #else
        return self
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
            .navigationDestination(isPresented: isActive) {
                destination()
            }
        } else {
            Button(action: { isActive.wrappedValue = true }) {
                Label(title, systemImage: systemImage)
                    .foregroundColor(.primary)
            }
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
}


