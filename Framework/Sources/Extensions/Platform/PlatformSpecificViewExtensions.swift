import SwiftUI
import UniformTypeIdentifiers

/// Semantic intent: Dismiss settings based on presentation model
/// Layer 1: Express WHAT you want to achieve
public enum SettingsDismissalType {
    case embedded      // Settings embedded in navigation (single-window)
    case sheet         // Settings presented as sheet
    case window        // Settings in separate window
}

// MARK: - Platform-Specific View Extensions



/// Extension for platform-specific view modifiers and configurations
// Consolidated orphaned functions back into the main View extension
// BEGIN consolidated View extension
public extension View {

    // MARK: - Navigation and Layout

    // Navigation functions moved to PlatformNavigationLayer4.swift

    /// Hover effect wrapper (no-op on iOS)
    func platformHoverEffect(_ onChange: @escaping (Bool) -> Void) -> some View {
        #if os(macOS)
        return self.onHover(perform: onChange)
        #else
        return self
        #endif
    }

    /// Cross-platform file importer wrapper (uses SwiftUI .fileImporter on both platforms)
    func platformFileImporter(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool = false,
        onCompletion: @escaping (Result<[URL], Error>) -> Void
    ) -> some View {
        self.fileImporter(isPresented: isPresented,
                          allowedContentTypes: allowedContentTypes,
                          allowsMultipleSelection: allowsMultipleSelection) { result in
            switch result {
            case .success(let urls): onCompletion(.success(urls))
            case .failure(let error): onCompletion(.failure(error))
            }
        }
    }
// Types and helpers moved to dedicated files (PlatformTypes.swift, PlatformTabStrip.swift, PlatformSidebarHelpers.swift)

    // Navigation title functions moved to PlatformNavigationLayer4.swift

// Consolidate orphaned functions back into the View extension

    /// Platform-specific navigation title configuration
    /// This method provides consistent navigation title behavior across platforms
    /// (moved to a dedicated View extension block below)
    // Intentionally left blank here

    // Note: platformFormStyle moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    /// Platform-specific frame constraints
    /// On macOS, applies minimum frame constraints. On iOS, returns the view unchanged.
    func platformFrame() -> some View {
        #if os(iOS)
        return self
        #elseif os(macOS)
        return self.frame(minWidth: 600, minHeight: 800)
        #else
        return self
        #endif
    }

    /// Platform-specific frame constraints with custom sizes
    /// Provides flexible frame constraints that are only applied on macOS
    ///
    /// - Parameters:
    ///   - minWidth: Minimum width constraint (macOS only)
    ///   - minHeight: Minimum height constraint (macOS only)
    ///   - maxWidth: Maximum width constraint (macOS only)
    ///   - maxHeight: Maximum height constraint (macOS only)
    /// - Returns: A view with platform-specific frame constraints
    func platformFrame(minWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> some View {
        #if os(iOS)
        return AnyView(self)
        #elseif os(macOS)
        if let minWidth = minWidth, let minHeight = minHeight {
            if let maxWidth = maxWidth, let maxHeight = maxHeight {
                return AnyView(self.frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight))
            } else {
                return AnyView(self.frame(minWidth: minWidth, minHeight: minHeight))
            }
        } else if let minWidth = minWidth {
            return AnyView(self.frame(minWidth: minWidth))
        } else if let minHeight = minHeight {
            return AnyView(self.frame(minHeight: minHeight))
        } else {
            return AnyView(self)
        }
        #else
        return AnyView(self)
        #endif
    }

    // Note: platformAdaptiveFrame moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts
    
    // Note: platformContentSpacing moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    /// Platform-specific content spacing with custom top padding
    /// Allows custom top padding while maintaining platform-specific horizontal padding
    ///
    /// - Parameter topPadding: Custom top padding value
    /// - Returns: A view with platform-specific content spacing
    func platformContentSpacing(topPadding: CGFloat) -> some View {
        #if os(iOS)
        return AnyView(self.padding(.horizontal).padding(.top, topPadding))
        #elseif os(macOS)
        return AnyView(self.padding(.horizontal).padding(.top, topPadding * 0.8))
        #else
        return AnyView(self.padding(.horizontal).padding(.top, topPadding))
        #endif
    }

    /// Platform-specific content spacing with custom directional padding
    /// Allows custom padding for any combination of directions while maintaining platform-specific scaling
    ///
    /// - Parameters:
    ///   - top: Custom top padding value (optional)
    ///   - bottom: Custom bottom padding value (optional)
    ///   - leading: Custom leading padding value (optional)
    ///   - trailing: Custom trailing padding value (optional)
    /// - Returns: A view with platform-specific content spacing
    func platformContentSpacing(
        top: CGFloat? = nil,
        bottom: CGFloat? = nil,
        leading: CGFloat? = nil,
        trailing: CGFloat? = nil
    ) -> some View {
        #if os(iOS)
        return AnyView(self
            .padding(.top, top ?? 0)
            .padding(.bottom, bottom ?? 0)
            .padding(.leading, leading ?? 0)
            .padding(.trailing, trailing ?? 0))
        #elseif os(macOS)
        return AnyView(self
            .padding(.top, (top ?? 0) * 0.8)
            .padding(.bottom, (bottom ?? 0) * 0.8)
            .padding(.leading, (leading ?? 0) * 0.8)
            .padding(.trailing, (trailing ?? 0) * 0.8))
        #else
        return AnyView(self
            .padding(.top, top ?? 0)
            .padding(.bottom, bottom ?? 0)
            .padding(.leading, leading ?? 0)
            .padding(.trailing, trailing ?? 0))
        #endif
    }

    /// Platform-specific content spacing with horizontal and vertical padding
    /// Convenient method for setting horizontal and vertical padding separately
    ///
    /// - Parameters:
    ///   - horizontal: Custom horizontal padding value (applied to leading and trailing)
    ///   - vertical: Custom vertical padding value (applied to top and bottom)
    /// - Returns: A view with platform-specific content spacing
    func platformContentSpacing(
        horizontal: CGFloat? = nil,
        vertical: CGFloat? = nil
    ) -> some View {
        #if os(iOS)
        return AnyView(self
            .padding(.horizontal, horizontal ?? 0)
            .padding(.vertical, vertical ?? 0))
        #elseif os(macOS)
        return AnyView(self
            .padding(.horizontal, (horizontal ?? 0) * 0.8)
            .padding(.vertical, (vertical ?? 0) * 0.8))
        #else
        return AnyView(self
            .padding(.horizontal, horizontal ?? 0)
            .padding(.vertical, vertical ?? 0))
        #endif
    }

    /// Platform-specific content spacing with uniform padding on all sides
    /// Convenient method for setting equal padding on all sides
    ///
    /// - Parameter all: Custom padding value applied to all sides
    /// - Returns: A view with platform-specific content spacing
    func platformContentSpacing(all: CGFloat? = nil) -> some View {
        #if os(iOS)
        if let all = all {
            return AnyView(self.padding(.horizontal, all).padding(.vertical, all))
        } else {
            return AnyView(self.padding(.horizontal).padding(.top, 20))
        }
        #elseif os(macOS)
        if let all = all {
            return AnyView(self.padding(.horizontal, all * 0.8).padding(.vertical, all * 0.8))
        } else {
            return AnyView(self.padding(.horizontal).padding(.top, 16))
        }
        #else
        if let all = all {
            return AnyView(self.padding(.horizontal, all).padding(.vertical, all))
        } else {
            return AnyView(self.padding(.horizontal).padding(.top, 20))
        }
        #endif
    }

    // MARK: - Navigation Configuration

    // platformNavigationTitleDisplayMode defined earlier in this extension

    /// Platform-specific help tooltip (macOS only)
    /// Adds help tooltip on macOS, no-op on other platforms
    func platformHelp(_ text: String) -> some View {
        #if os(macOS)
        return self.help(text)
        #else
        return self
        #endif
    }

    /// Platform-specific presentation detents (iOS only)
    /// Applies presentation detents on iOS, no-op on other platforms
    func platformPresentationDetents(_ detents: [Any]) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            if let presentationDetents = detents.compactMap({ $0 as? PresentationDetent }) as? [PresentationDetent] {
                return AnyView(self.presentationDetents(Set(presentationDetents)))
            } else {
                return AnyView(self)
            }
        } else {
            return AnyView(self)
        }
        #else
        return AnyView(self)
        #endif
    }

    /// Platform-specific presentation detents using custom enum (iOS only)
    /// Provides a more convenient way to specify presentation detents
    ///
    /// - Parameter detents: Array of platform-specific presentation detents
    /// - Returns: A view with platform-specific presentation detents
    func platformPresentationDetents(_ detents: [PlatformPresentationDetent]) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            // Map to native detents on iOS
            let presentationDetents = Set(detents.map { $0.presentationDetent })
            return self.presentationDetents(presentationDetents)
        } else {
            return self
        }
        #else
        // No-op on macOS and others
        return self
        #endif
    }

    // MARK: - Toolbar Configuration

    /// Platform-specific toolbar for form views with save/cancel actions
    /// Provides consistent toolbar behavior across platforms with appropriate button placement
    ///
    /// - Parameters:
    ///   - onCancel: Action to perform when cancel is tapped
    ///   - onSave: Action to perform when save is tapped
    ///   - saveButtonTitle: Title for the save button (default: "Save")
    ///   - cancelButtonTitle: Title for the cancel button (default: "Cancel")
    /// - Returns: A view with platform-specific toolbar
    func platformFormToolbar(
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void,
        saveButtonTitle: String = "Save",
        cancelButtonTitle: String = "Cancel"
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(cancelButtonTitle) {
                    onCancel()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(saveButtonTitle) {
                    onSave()
                }
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(cancelButtonTitle) {
                    onCancel()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 12) {
                    Button("Select") {
                        onSave()
                    }
                    .buttonStyle(.borderedProminent)

                    Button(saveButtonTitle) {
                        onSave()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        #else
        return self
        #endif
    }

    /// Platform-specific toolbar for detail views
    /// Simplified toolbar for detail views with save/cancel actions
    ///
    /// - Parameters:
    ///   - onCancel: Action to perform when cancel is tapped
    ///   - onSave: Action to perform when save is tapped
    ///   - saveButtonTitle: Title for the save button (default: "Save")
    /// - Returns: A view with platform-specific toolbar
    func platformDetailToolbar(
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void,
        saveButtonTitle: String = "Save"
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onCancel()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(saveButtonTitle) {
                    onSave()
                }
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onCancel()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(saveButtonTitle) {
                    onSave()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        #else
        return self
        #endif
    }


    ///
    /// - Parameters:
    ///   - onAdd: Action to perform when add is tapped
    ///   - addButtonTitle: Title for the add button (default: "Add")
    ///   - addButtonIcon: Icon for the add button (default: "plus")
    /// - Returns: A view with platform-specific toolbar


    // MARK: - Layout Containers

    /// Platform-specific container for form content
    /// Provides consistent form layout across platforms
    ///
    /// - Parameter content: The form content to be contained
    /// - Returns: A view with platform-specific form container
    ///
    /// ## Usage Example
    /// ```swift
    /// platformFormContainer {
    ///     VStack(spacing: 16) {
    ///         TextField("Name", text: $name)
    ///         TextField("Email", text: $email)
    ///         Button("Save") { }
    ///     }
    /// }
    /// ```
    // Duplicate platformFormContainer removed to avoid ambiguity; see the later
    // single-source-of-truth implementation that returns Form on iOS and a
    // styled VStack on macOS.

















    // Note: platformBackground moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformPadding moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformPadding(_:_:) moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformPadding(_:) moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformReducedPadding moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformCornerRadius moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformShadow moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformBorder moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts



    // Note: platformFont moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformAnimation moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformMinFrame moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformMaxFrame moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts

    // Note: platformIdealFrame moved to PlatformStylingLayer4.swift
    // to consolidate with existing styling logic and avoid naming conflicts



    /// Platform-specific card container
    /// Provides consistent card styling across platforms
    ///
    /// - Parameter content: The card content to be contained
    /// - Returns: A view with platform-specific card container
    func platformCardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        #if os(iOS)
        return VStack {
            content()
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(12)
        #elseif os(macOS)
        return VStack {
            content()
        }
        .padding()
        .background(Color.platformSecondaryBackground)
        .cornerRadius(8)
        #else
        return VStack {
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        #endif
    }

    /// Platform-specific section container
    /// Provides consistent section styling for form groups and content sections
    ///
    /// - Parameter content: The section content to be contained
    /// - Returns: A view with platform-specific section container
    func platformSectionContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        #if os(iOS)
        return VStack {
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.platformGroupedBackground)
        .cornerRadius(8)
        #elseif os(macOS)
        return VStack {
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.platformSecondaryBackground)
        .cornerRadius(6)
        #else
        return VStack {
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(6)
        #endif
    }

    // MARK: - Sheet and Alert Modifiers

    /// Platform-specific sheet presentation with navigation wrapper
    /// Provides consistent sheet presentation across platforms
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control sheet presentation
    ///   - detents: Platform-specific presentation detents (iOS only)
    ///   - content: The sheet content
    /// - Returns: A view with platform-specific sheet presentation
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformSheet(isPresented: $showingSheet, detents: [.medium, .large]) {
    ///     VStack {
    ///         Text("Sheet Content")
    ///         Button("Dismiss") { showingSheet = false }
    ///     }
    ///     .navigationTitle("Sheet Title")
    /// }
    /// ```
    func platformSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        detents: [PlatformPresentationDetent] = [.large],
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        #if os(iOS)
        return self.sheet(isPresented: isPresented) {
            NavigationView {
                content()
            }
            .platformPresentationDetents(detents)
            .deviceAwareFrame() // Layer 4: Device-aware sizing for iPad vs iPhone
        }
        #elseif os(macOS)
        // Compute desired macOS sheet size outside the ViewBuilder closure
        let hasLarge = detents.contains { detent in
            if case .large = detent { return true } else { return false }
        }
        let hasMedium = detents.contains { detent in
            if case .medium = detent { return true } else { return false }
        }
        let customHeights: [CGFloat] = detents.compactMap { detent in
            if case .custom(let h) = detent { return h } else { return nil }
        }
        let minWidth: CGFloat
        let minHeight: CGFloat
        if let maxCustom = customHeights.max() {
            minWidth = max(800, min(1400, maxCustom * 1.0))
            minHeight = max(640, min(1100, maxCustom))
        } else if hasLarge {
            minWidth = 1024
            minHeight = 800
        } else if hasMedium {
            minWidth = 820
            minHeight = 640
        } else {
            minWidth = 820
            minHeight = 640
        }
        return self.sheet(isPresented: isPresented) {
            content()
                .frame(minWidth: minWidth, minHeight: minHeight)
        }
        #else
        return self.sheet(isPresented: isPresented) {
            content()
        }
        #endif
    }

    /// Conditional view modifier for platform-specific customization
    /// Applies a modifier only when a condition is true
    ///
    /// - Parameters:
    ///   - condition: Boolean condition to determine if modifier should be applied
    ///   - transform: Closure that returns the modified view
    /// - Returns: A view with conditional modifications applied
    ///
    /// ## Usage Example
    /// ```swift
    /// .if(SixLayerPlatform.deviceType == .pad) { view in
    ///     view.frame(maxWidth: .infinity, maxHeight: .infinity)
    /// }
    /// ```
    // Note: `if` function is already defined in PlatformExtensions.swift

    /// Platform-adaptive sheet presentation with intelligent sizing
    /// Automatically calculates appropriate dimensions based on content analysis
    /// Provides optimal sizing for iPad, iPhone, and macOS
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control sheet presentation
    ///   - detents: Array of presentation detents for iOS (defaults to large)
    ///   - content: The sheet content view
    /// - Returns: A view with platform-adaptive sheet presentation
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformAdaptiveSheet(isPresented: $showingSheet, detents: [.medium, .large]) {
    ///     VStack {
    ///         Text("Sheet Content")
    ///         Button("Dismiss") { showingSheet = false }
    ///     }
    ///     .navigationTitle("Sheet Title")
    /// }
    /// ```
    func platformAdaptiveSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        detents: [PlatformPresentationDetent] = [.large],
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        #if os(iOS)
        // iOS: Use detents with intelligent device-aware sizing
        return self.sheet(isPresented: isPresented) {
            NavigationView {
                content()
            }
            .platformPresentationDetents(detents)
            .deviceAwareFrame() // Layer 4: Device-aware sizing for iPad vs iPhone
        }
        #elseif os(macOS)
        // macOS: Use content-aware adaptive sizing
        return self.sheet(isPresented: isPresented) {
            content()
                .platformAdaptiveFrame() // Uses content analysis for optimal sizing
        }
        #else
        return self.sheet(isPresented: isPresented) {
            content()
        }
        #endif
    }

    /// Platform-specific alert presentation
    /// Provides consistent alert presentation across platforms
    ///
    /// - Parameters:
    ///   - title: The alert title
    ///   - isPresented: Binding to control alert presentation
    ///   - actions: The alert actions
    ///   - message: The alert message
    /// - Returns: A view with platform-specific alert presentation
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformAlert(
    ///     Text("Delete Item"),
    ///     isPresented: $showingDeleteAlert
    /// ) {
    ///     Button("Delete", role: .destructive) { deleteItem() }
    ///     Button("Cancel", role: .cancel) { }
    /// } message: {
    ///     Text("Are you sure you want to delete this item?")
    /// }
    /// ```
    func platformAlert<A: View, M: View>(
        _ title: Text,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        #if os(iOS)
        return self.alert(title, isPresented: isPresented, actions: actions, message: message)
        #elseif os(macOS)
        return self.alert(title, isPresented: isPresented, actions: actions, message: message)
        #else
        return self.alert(title, isPresented: isPresented, actions: actions, message: message)
        #endif
    }

    /// Platform-specific alert presentation with string title
    /// Convenience method for alerts with string titles
    ///
    /// - Parameters:
    ///   - title: The alert title as a string
    ///   - isPresented: Binding to control alert presentation
    ///   - actions: The alert actions
    ///   - message: The alert message
    /// - Returns: A view with platform-specific alert presentation
    func platformAlert<A: View, M: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        return self.platformAlert(Text(title), isPresented: isPresented, actions: actions, message: message)
    }

    /// Platform-specific alert presentation with error
    /// Convenience method for error alerts
    ///
    /// - Parameters:
    ///   - error: The error to display
    ///   - isPresented: Binding to control alert presentation
    ///   - actions: The alert actions (optional, defaults to OK button)
    /// - Returns: A view with platform-specific error alert presentation
    func platformAlert<A: View>(
        error: Error?,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> A
    ) -> some View {
        return self.platformAlert(
            Text("Error"),
            isPresented: isPresented
        ) {
            actions()
        } message: {
            Text(error?.localizedDescription ?? "An unknown error occurred")
        }
    }

    /// Platform-specific alert presentation with error (simplified)
    /// Convenience method for error alerts with just an OK button
    ///
    /// - Parameters:
    ///   - error: The error to display
    ///   - isPresented: Binding to control alert presentation
    /// - Returns: A view with platform-specific error alert presentation
    func platformAlert(
        error: Error?,
        isPresented: Binding<Bool>
    ) -> some View {
        return self.platformAlert(
            error: error,
            isPresented: isPresented
        ) {
            Button("OK") { }
        }
    }





    // MARK: - Input Controls

    /// Platform-specific text field styling
    /// Provides consistent text field appearance across platforms
    func platformTextFieldStyle() -> some View {
        #if os(iOS)
        return self.textFieldStyle(.roundedBorder)
        #elseif os(macOS)
        return self.textFieldStyle(.roundedBorder)
        #else
        return self.textFieldStyle(.roundedBorder)
        #endif
    }

    /// Platform-specific picker styling
    /// Provides consistent picker appearance across platforms
    func platformPickerStyle() -> some View {
        #if os(iOS)
        return self.pickerStyle(.menu)
        #elseif os(macOS)
        return self.pickerStyle(.menu)
        #else
        return self.pickerStyle(.menu)
        #endif
    }

    /// Platform-specific date picker styling
    /// Provides consistent date picker appearance across platforms
    func platformDatePickerStyle() -> some View {
        #if os(iOS)
        return self.datePickerStyle(.compact)
        #elseif os(macOS)
        return self.datePickerStyle(.compact)
        #else
        return self.datePickerStyle(.compact)
        #endif
    }

    // MARK: - Platform-Specific View Builders

/// Protocol for platform-specific view builders
// Moved to dedicated navigation views/helpers files

// Provide explicit overloads for SecureField and TextField to ensure availability across contexts
// Moved to dedicated files: PlatformSpecificSecureFieldExtensions.swift and PlatformSpecificTextFieldExtensions.swift

/// iOS-specific view builder
// Moved to dedicated navigation views/helpers files

// Moved Color extensions to PlatformColorExtensions.swift

// Non-View helpers moved to PlatformExtensions/PlatformSpacing/PlatformNavigationViews files
// MARK: - Platform-Specific Navigation Extensions
    // Removed duplicate platformNavigationContainer overload to avoid ambiguous resolution on iOS

    // Duplicate platformNavigationDestination removed

    /// Platform-specific navigation bar title display mode
    /// Provides consistent navigation bar styling across platforms
    ///
    /// - Parameter displayMode: The title display mode
    /// - Returns: A view with platform-specific navigation bar styling
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformNavigationBarTitleDisplayMode(.large)
    /// ```
    // Navigation bar title display mode moved to PlatformNavigationLayer4.swift

    /// Platform-specific navigation bar back button hidden
    /// Controls back button visibility across platforms
    ///
    /// - Parameter hidden: Whether to hide the back button
    /// - Returns: A view with platform-specific back button visibility
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformNavigationBarBackButtonHidden(true)
    /// ```
    func platformNavigationBarBackButtonHidden(_ hidden: Bool) -> some View {
        #if os(iOS)
        return self.navigationBarBackButtonHidden(hidden)
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar items
    /// Provides consistent navigation bar item placement across platforms
    ///
    /// - Parameters:
    ///   - leading: Leading navigation bar items
    ///   - trailing: Trailing navigation bar items
    /// - Returns: A view with platform-specific navigation bar items
    ///
    /// ## Usage Example
    /// ```swift
    /// .platformNavigationBarItems(
    ///     leading: Button("Cancel") { dismiss() },
    ///     trailing: Button("Save") { save() }
    /// )
    /// ```
    func platformNavigationBarItems<L: View, T: View>(
        @ViewBuilder leading: @escaping () -> L,
        @ViewBuilder trailing: @escaping () -> T
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leading()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                trailing()
            }
        }
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar items (leading only)
    /// Convenience method for leading-only navigation bar items
    ///
    /// - Parameter leading: Leading navigation bar items
    /// - Returns: A view with platform-specific navigation bar items
    func platformNavigationBarItems<L: View>(
        @ViewBuilder leading: @escaping () -> L
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leading()
            }
        }
        #else
        return self
        #endif
    }

    /// Platform-specific navigation bar items (trailing only)
    /// Convenience method for trailing-only navigation bar items
    ///
    /// - Parameter trailing: Trailing navigation bar items
    /// - Returns: A view with platform-specific navigation bar items
    func platformNavigationBarItems<T: View>(
        @ViewBuilder trailing: @escaping () -> T
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                trailing()
            }
        }
        #else
        return self
        #endif
    }



    /// Platform-specific navigation link
    /// Provides consistent navigation link behavior across platforms
    ///
    /// - Parameters:
    ///   - destination: The destination view
    ///   - label: The navigation link label
    /// - Returns: A platform-specific navigation link
    ///
    /// ## Usage Example
    /// ```swift
    /// platformNavigationLink(destination: DetailView()) {
    ///     Text("Go to Detail")
    /// }
    /// ```
    func platformNavigationLink<Destination: View, Label: View>(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        return NavigationLink(destination: destination, label: label)
        #else
        return NavigationLink(destination: destination, label: label)
        #endif
    }

    /// Platform-specific navigation link with value
    /// Provides consistent navigation link behavior with value navigation across platforms
    ///
    /// - Parameters:
    ///   - value: The navigation value
    ///   - destination: The destination view
    ///   - label: The navigation link label
    /// - Returns: A platform-specific navigation link with value
    func platformNavigationLink<Value: Hashable, Destination: View, Label: View>(
        value: Value,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return NavigationLink(value: value, label: label)
        } else {
            // iOS 15 fallback: use destination-based NavigationLink
            return NavigationLink(destination: destination(), label: label)
        }
        #else
        return NavigationLink(value: value, label: label)
        #endif
    }

    /// Platform-specific navigation link with tag
    /// Provides consistent navigation link behavior with tag selection across platforms
    ///
    /// - Parameters:
    ///   - tag: The tag for selection
    ///   - selection: Binding to the selected tag
    ///   - destination: The destination view
    ///   - label: The navigation link label
    /// - Returns: A platform-specific navigation link with tag
    func platformNavigationLink<Tag: Hashable, Destination: View, Label: View>(
        tag: Tag,
        selection: Binding<Tag?>,
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return NavigationLink(value: tag) {
                label()
            }
            .navigationDestination(for: Tag.self) { _ in
                destination()
            }
        } else {
            // iOS 15 fallback: use selection-based NavigationLink
            return NavigationLink(tag: tag, selection: selection, destination: destination, label: label)
        }
        #else
        return NavigationLink(value: tag) {
            label()
        }
        .navigationDestination(for: Tag.self) { _ in
            destination()
        }
        #endif
    }



    /// Platform-specific navigation with path (iOS 16+ only)
    /// iOS: Uses NavigationStack with path; macOS: Returns content directly
    func platformNavigationWithPath<Root: View>(
        path: Binding<NavigationPath>,
        @ViewBuilder root: () -> Root
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return AnyView(NavigationStack(path: path, root: root))
        } else {
            // iOS 15 fallback: ignore path, just return root
            return AnyView(root())
        }
        #else
        // macOS: return content directly
        return AnyView(root())
        #endif
    }

    /// Platform-specific navigation with typed path (iOS 16+ only)
    /// iOS: Uses NavigationStack with typed path; macOS: Returns content directly
    func platformNavigationWithPath<Data: Hashable, Root: View>(
        path: Binding<[Data]>,
        @ViewBuilder root: () -> Root
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return NavigationStack(path: path, root: root)
        } else {
            // iOS 15 fallback: ignore path, just return root
            return root()
        }
        #else
        // macOS: return content directly
        return root()
        #endif
    }

    /// Platform-specific navigation state management with multiple data types
    /// Provides consistent navigation state handling with multiple typed data across platforms
    ///
    /// - Parameters:
    ///   - path: Binding to the navigation path
    ///   - root: The root view
    /// - Returns: A platform-specific navigation container with multiple typed state management
    func platformNavigationWithPath<Data: Hashable, Root: View>(
        path: Binding<NavigationPath>,
        @ViewBuilder root: () -> Root
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return AnyView(NavigationStack(path: path, root: root))
        } else {
            // iOS 15 fallback: ignore path, just return root
            return AnyView(root())
        }
        #else
        // macOS: return content directly
        return AnyView(root())
        #endif
    }

// Keep the extension open for subsequent View helpers below

/// Platform-specific navigation split view builder
/// Creates a NavigationSplitView on macOS and NavigationStack on iOS
/// This function should be used when you need both content and detail views
// Moved to PlatformNavigationViews.swift

/// Platform-specific navigation split view builder with sidebar, content, and detail
/// Creates a NavigationSplitView on macOS and NavigationStack on iOS
/// This function should be used when you need sidebar, content, and detail views
// Moved to PlatformNavigationViews.swift

// Moved to PlatformNavigationViews.swift

/// Convenience function to create platform-specific navigation split views with sidebar, content, and detail
// Moved to PlatformNavigationViews.swift

// MARK: - Platform-Specific App Navigation

/// Platform-specific main app navigation container
/// On iOS: NavigationStack with sheet-based sidebar
/// On macOS: NavigationSplitView with traditional sidebar
@MainActor
// Moved to PlatformNavigationViews.swift

/// Convenience function to create platform-specific app navigation
// Moved to PlatformNavigationViews.swift

/// Platform-specific navigation action helper
/// Handles navigation and sidebar closing consistently across platforms
// Moved to PlatformNavigationHelpers.swift

// MARK: - Navigation State Management

/// Toggles the sidebar visibility in a NavigationSplitView
/// - Parameter columnVisibility: Binding to the NavigationSplitViewVisibility state
/// - Returns: Updated visibility state
// Moved to PlatformNavigationHelpers.swift

/// Creates a sidebar toggle button for NavigationSplitView
/// - Parameter columnVisibility: Binding to the NavigationSplitViewVisibility state
/// - Returns: A button that toggles sidebar visibility
// Moved to PlatformSidebarHelpers.swift

// MARK: - Platform-Specific Toolbar Extensions

/// Platform-specific toolbar placement for confirmation actions (Done, Save, etc.)
// Moved to PlatformToolbarHelpers.swift

/// Platform-specific toolbar placement for cancellation actions (Cancel, etc.)
// Moved to PlatformToolbarHelpers.swift

/// Platform-specific toolbar placement for primary actions (Add, etc.)
// Moved to PlatformToolbarHelpers.swift

/// Platform-specific toolbar placement for secondary actions
// Moved to PlatformToolbarHelpers.swift

    func platformToolbarPlacement(_ placement: PlatformToolbarPlacement) -> ToolbarItemPlacement {
        #if os(iOS)
        switch placement {
        case .leading: return .navigationBarLeading
        case .trailing: return .navigationBarTrailing
        case .automatic: return .navigationBarTrailing
        }
        #else
        return .automatic
        #endif
    }

// Merged into consolidated View extension above
    /// Comprehensive platform-specific toolbar modifier that supports all types of actions
    /// This is the main method that all convenience methods should call
    func platformToolbar<Content: View>(
        @ViewBuilder content: () -> Content,
        leadingActions: (() -> some View)? = nil,
        trailingActions: (() -> some View)? = nil
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let leadingActions = leadingActions {
                    leadingActions()
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .principal) {
                content()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if let trailingActions = trailingActions {
                    trailingActions()
                } else {
                    EmptyView()
                }
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            HStack {
                if let leadingActions = leadingActions {
                    leadingActions()
                }
                content()
                if let trailingActions = trailingActions {
                    trailingActions()
                }
            }
        }
        #else
        return self.toolbar {
            if let leadingActions = leadingActions {
                ToolbarItem(placement: .navigationBarLeading) {
                    leadingActions()
                }
            }
            content()
            if let trailingActions = trailingActions {
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingActions()
                }
            }
        }
        #endif
    }

    /// Convenience method for toolbar with trailing actions only
    func platformToolbarWithTrailingActions<Content: View>(@ViewBuilder trailingActions: @escaping () -> Content) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingActions()
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            HStack {
                trailingActions()
            }
        }
        #else
        return self.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingActions()
            }
        }
        #endif
    }

    /// Convenience method for toolbar with leading actions only
    func platformToolbarWithLeadingActions<Content: View>(@ViewBuilder leadingActions: @escaping () -> Content) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leadingActions()
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            HStack {
                leadingActions()
            }
        }
        #else
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leadingActions()
            }
        }
        #endif
    }

    /// Convenience method for toolbar with confirmation action only
    func platformToolbarWithConfirmationAction(
        confirmationAction: @escaping () -> Void,
        confirmationTitle: String = "Done"
    ) -> some View {
        return self.platformToolbarWithTrailingActions {
            Button(confirmationTitle, action: confirmationAction)
        }
    }

    /// Convenience method for toolbar with cancellation action only
    func platformToolbarWithCancellationAction(
        cancellationAction: @escaping () -> Void,
        cancellationTitle: String = "Cancel"
    ) -> some View {
        return self.platformToolbarWithLeadingActions {
            Button(cancellationTitle, action: cancellationAction)
        }
    }

    /// Convenience method for toolbar with both confirmation and cancellation actions
    func platformToolbarWithActions(
        confirmationAction: @escaping () -> Void,
        confirmationTitle: String = "Done",
        cancellationAction: @escaping () -> Void,
        cancellationTitle: String = "Cancel",
        isConfirmationDisabled: Bool = false
    ) -> some View {
        #if os(iOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(cancellationTitle, action: cancellationAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(confirmationTitle, action: confirmationAction)
                    .disabled(isConfirmationDisabled)
            }
        }
        #elseif os(macOS)
        return self.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(cancellationTitle, action: cancellationAction)
                    .fixedSize()
            }
            ToolbarItem(placement: .primaryAction) {
                Button(confirmationTitle, action: confirmationAction)
                    .disabled(isConfirmationDisabled)
                    .buttonStyle(.borderedProminent)
                    .fixedSize()
            }
        }
        #else
        return self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(cancellationTitle, action: cancellationAction)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(confirmationTitle, action: confirmationAction)
                    .disabled(isConfirmationDisabled)
            }
        }
        #endif
    }

    /// Convenience method for toolbar with an "Add" action button
    func platformToolbarWithAddAction(
        addAction: @escaping () -> Void,
        addTitle: String = "Add"
    ) -> some View {
        return self.platformToolbarWithTrailingActions {
            Button(addTitle, action: addAction)
        }
    }

    /// Convenience method for toolbar with a refresh action button
    func platformToolbarWithRefreshAction(
        refreshAction: @escaping () -> Void,
        refreshTitle: String = "Refresh"
    ) -> some View {
        return self.platformToolbarWithTrailingActions {
            Button(action: refreshAction) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }

    /// Convenience method for toolbar with an edit action button
    func platformToolbarWithEditAction(
        editAction: @escaping () -> Void,
        editTitle: String = "Edit"
    ) -> some View {
        return self.platformToolbarWithTrailingActions {
            Button(editTitle, action: editAction)
        }
    }

    /// Convenience method for toolbar with a delete action button (with confirmation)
    func platformToolbarWithDeleteAction(
        deleteAction: @escaping () -> Void,
        deleteTitle: String = "Delete",
        confirmationMessage: String = "Are you sure you want to delete this item?"
    ) -> some View {
        return self.platformToolbarWithTrailingActions {
            Button(deleteTitle, action: deleteAction)
                .foregroundColor(.red)
        }
    }



    /// Platform-specific document browser sheet
    /// iOS: Shows document browser; macOS: no-op
    @ViewBuilder
    func platformDocumentBrowserSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        self.sheet(isPresented: isPresented) {
            content()
        }
        #else
        self
        #endif
    }






    /// Platform-specific form container
    /// Provides consistent form styling across platforms
    ///
    /// - Parameter content: The form content
    /// - Returns: A platform-specific form container
    func platformFormContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        #if os(iOS)
        return Form(content: content)
        #else
        return VStack(spacing: PlatformSpacing.large) {
            content()
        }
        .padding(PlatformSpacing.padding)
        #endif
    }

    /// Platform-specific form section
    /// Provides consistent form section styling across platforms
    ///
    /// - Parameters:
    ///   - header: The section header
    ///   - footer: The section footer (optional)
    ///   - content: The section content
    /// - Returns: A platform-specific form section
    func platformFormSection<Header: View, Footer: View, Content: View>(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        return Section(header: header(), footer: footer(), content: content)
        #else
        return VStack(alignment: .leading, spacing: PlatformSpacing.medium) {
            header()
                .font(.headline)
                .foregroundColor(.platformSecondaryLabel)
            content()
            footer()
                .font(.caption)
                .foregroundColor(.platformTertiaryLabel)
        }
        .padding(.vertical, PlatformSpacing.medium)
        #endif
    }

    /// Platform-specific form section (header only)
    /// Convenience method for form sections with header only
    ///
    /// - Parameters:
    ///   - header: The section header
    ///   - content: The section content
    /// - Returns: A platform-specific form section
    func platformFormSection<Header: View, Content: View>(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        return Section(header: header(), content: content)
        #else
        return VStack(alignment: .leading, spacing: PlatformSpacing.medium) {
            header()
                .font(.headline)
                .foregroundColor(.platformSecondaryLabel)
            content()
        }
        .padding(.vertical, PlatformSpacing.medium)
        #endif
    }

    /// Platform-specific form section (content only)
    /// Convenience method for form sections with content only
    ///
    /// - Parameter content: The section content
    /// - Returns: A platform-specific form section
    func platformFormSection<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        #if os(iOS)
        return Section(content: content)
        #else
        return VStack(alignment: .leading, spacing: PlatformSpacing.medium) {
            content()
        }
        .padding(.vertical, PlatformSpacing.medium)
        #endif
    }

    /// Platform-specific disclosure group
    /// Provides consistent disclosure group behavior across platforms
    ///
    /// - Parameters:
    ///   - isExpanded: Binding to control expansion state
    ///   - content: The disclosure group content
    ///   - label: The disclosure group label
    /// - Returns: A platform-specific disclosure group
    func platformDisclosureGroup<Content: View, Label: View>(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) -> some View {
        #if os(iOS)
        return DisclosureGroup(isExpanded: isExpanded, content: content, label: label)
        #else
        return DisclosureGroup(isExpanded: isExpanded, content: content, label: label)
        #endif
    }

    /// Platform-specific picker with selection
    /// Provides consistent picker behavior across platforms
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected value
    ///   - content: The picker content
    ///   - label: The picker label
    /// - Returns: A platform-specific picker
    func platformPicker<SelectionValue: Hashable, Content: View, Label: View>(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        return Picker(selection: selection, content: content, label: label)
        #else
        return Picker(selection: selection, content: content, label: label)
        #endif
    }

    /// Platform-specific date picker
    /// Provides consistent date picker behavior across platforms
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected date
    ///   - displayedComponents: The date components to display
    ///   - label: The date picker label
    /// - Returns: A platform-specific date picker
    func platformDatePicker<Label: View>(
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = [.date],
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        return DatePicker(selection: selection, displayedComponents: displayedComponents, label: label)
        #else
        return DatePicker(selection: selection, displayedComponents: displayedComponents, label: label)
        #endif
    }

    /// Platform-specific toggle
    /// Provides consistent toggle behavior across platforms
    ///
    /// - Parameters:
    ///   - isOn: Binding to the toggle state
    ///   - label: The toggle label
    /// - Returns: A platform-specific toggle
    func platformToggle<Label: View>(
        isOn: Binding<Bool>,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS)
        return Toggle(isOn: isOn, label: label)
        #else
        return Toggle(isOn: isOn, label: label)
        #endif
    }

    /// Platform-specific text field
    /// Provides consistent text field behavior across platforms
    ///
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - prompt: The placeholder text
    ///   - axis: The text field axis (iOS 16+)
    /// - Returns: A platform-specific text field
    func platformTextField(
        text: Binding<String>,
        prompt: String? = nil,
        axis: Axis = .horizontal
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            return TextField(prompt ?? "", text: text, axis: axis)
        } else {
            return TextField(prompt ?? "", text: text)
        }
        #else
        return TextField(prompt ?? "", text: text)
        #endif
    }

    /// Platform-specific secure text field
    /// Provides consistent secure text field behavior across platforms
    ///
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - prompt: The placeholder text
    /// - Returns: A platform-specific secure text field
    func platformSecureTextField(
        text: Binding<String>,
        prompt: String? = nil
    ) -> some View {
        #if os(iOS)
        return SecureField(prompt ?? "", text: text)
        #else
        return SecureField(prompt ?? "", text: text)
        #endif
    }

    /// Platform-specific text editor
    /// Provides consistent text editor behavior across platforms
    ///
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - prompt: The placeholder text
    /// - Returns: A platform-specific text editor
    func platformTextEditor(
        text: Binding<String>,
        prompt: String? = nil
    ) -> some View {
        #if os(iOS)
        return TextEditor(text: text)
            .overlay(
                Group {
                    if text.wrappedValue.isEmpty {
                        Text(prompt ?? "")
                            .foregroundColor(.platformTertiaryLabel)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                },
                alignment: .topLeading
            )
        #else
        return TextEditor(text: text)
            .overlay(
                Group {
                    if text.wrappedValue.isEmpty {
                        Text(prompt ?? "")
                            .foregroundColor(.platformTertiaryLabel)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                },
                alignment: .topLeading
            )
        #endif
    }
    /// Platform-specific notification receiver for iOS-only features
    /// iOS: Handles notification; macOS: no-op
    @ViewBuilder
    func platformNotificationReceiver(
        for name: Notification.Name,
        action: @escaping () -> Void
    ) -> some View {
        #if os(iOS)
        self.onReceive(NotificationCenter.default.publisher(for: name)) { _ in
            action()
        }
        #else
        self
        #endif
    }

    /// Platform-specific navigation split view container
    /// iOS: Returns content directly; macOS: Wraps in NavigationSplitView
    /// Layer 4: Component Implementation
    @ViewBuilder
    func platformNavigationSplitContainer_L4<Sidebar: View, Detail: View>(
        columnVisibility: Binding<NavigationSplitViewVisibility>?,
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder detail: @escaping () -> Detail
    ) -> some View {
        #if os(iOS)
        // iOS: Return content directly, parent provides navigation
        sidebar()
        #else
        // macOS: Wrap in NavigationSplitView
        if #available(macOS 13.0, *) {
            NavigationSplitView(columnVisibility: columnVisibility ?? .constant(.all)) {
                sidebar()
            } detail: {
                detail()
            }
        } else {
            // Fallback for older macOS versions
            HStack {
                sidebar()
                detail()
            }
        }
        #endif
    }
    
    /// Platform-specific navigation split container (simplified version)
    /// Layer 4: Component Implementation - No column visibility control
    @ViewBuilder
    func platformNavigationSplitContainer_L4<Sidebar: View, Detail: View>(
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder detail: @escaping () -> Detail
    ) -> some View {
        #if os(iOS)
        // iOS: Return content directly, parent provides navigation
        sidebar()
        #else
        // macOS: Wrap in NavigationSplitView with default visibility
        NavigationSplitView(columnVisibility: .constant(.all)) {
            sidebar()
        } detail: {
            detail()
        }
        #endif
    }

    /// Platform-specific file save functionality
    /// iOS: No-op; macOS: Uses NSSavePanel
    func platformSaveFile(data: Data, fileName: String) {
        #if os(macOS)
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = fileName
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try data.write(to: url)
                } catch {
                    print("Error saving file: \(error)")
                }
            }
        }
        #endif
    }

    /// Platform-specific color encoding

    /// Express intent to dismiss settings
    /// Automatically determines the appropriate dismissal method
    func platformDismissSettings(
        type: SettingsDismissalType,
        onClose: (() -> Void)?,
        presentationMode: Binding<PresentationMode>? = nil
    ) {
        switch type {
        case .embedded:
            // For embedded navigation, just call the onClose callback
            onClose?()
        case .sheet:
            if let presentationMode = presentationMode {
                // For sheet presentation, dismiss the sheet
                presentationMode.wrappedValue.dismiss()
            } else {
                // Fallback to embedded if no presentationMode
                onClose?()
            }
        case .window:
            // For window presentation, close the window (macOS only)
            #if os(macOS)
            // Note: This would require passing window as a parameter
            // For now, we'll just call onClose as a fallback
            onClose?()
            #else
            onClose?()
            #endif
        }
    }









    /// Platform-specific export sheet
    /// iOS: Wraps in NavigationStack with detents; macOS: Returns content directly
    @ViewBuilder
    func platformExportSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            self.sheet(isPresented: isPresented) {
                NavigationStack {
                    content()
                }
                .platformPresentationDetents([.medium, .large])
            }
        } else {
            self.sheet(isPresented: isPresented) {
                content()
            }
        }
        #else
        self.sheet(isPresented: isPresented) {
            content()
        }
        #endif
    }

    /// Platform-specific help sheet
    /// iOS: Wraps in NavigationStack; macOS: Returns content directly
    @ViewBuilder
    func platformHelpSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        if #available(iOS 16.0, *) {
            self.sheet(isPresented: isPresented) {
                NavigationStack {
                    content()
                }
            }
        } else {
            self.sheet(isPresented: isPresented) {
                content()
            }
        }
        #else
        self.sheet(isPresented: isPresented) {
            content()
        }
        #endif
    }



    /// Platform-specific frame sizing for detail views
    /// iOS: No frame constraints; macOS: Sets minimum width and height
    func platformDetailViewFrame() -> some View {
        #if os(macOS)
        self.frame(minWidth: 800, minHeight: 600)
        #else
        self
        #endif
    }



    /// Platform-specific file picker
    /// iOS: Shows document picker sheet; macOS: Shows open panel
    @ViewBuilder
    func platformFilePicker<Content: View>(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        onFileSelected: @escaping (URL) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        #if os(iOS)
        if #available(iOS 14.0, *) {
            self.sheet(isPresented: isPresented) {
                VStack {
                    Text("File Picker")
                        .font(.title)
                    Text("Select a file")
                        .foregroundColor(.secondary)
                    Button("Select File") {
                        // Placeholder for file selection
                        onFileSelected(URL(fileURLWithPath: "/tmp/placeholder.txt"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        } else {
            // iOS 13 fallback: show alert
            self.alert("File Picker", isPresented: isPresented) {
                Button("OK") { }
            } message: {
                Text("File picker requires iOS 14 or later")
            }
        }
        #else
        if #available(macOS 11.0, *) {
            // Use SwiftUI's native fileImporter for modern macOS
            self.fileImporter(
                isPresented: isPresented,
                allowedContentTypes: allowedContentTypes,
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        if url.startAccessingSecurityScopedResource() {
                            defer { url.stopAccessingSecurityScopedResource() }
                            onFileSelected(url)
                        } else {
                            print("Failed to access security-scoped resource for \(url)")
                        }
                    }
                case .failure(let error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
        } else {
            // Fallback for older macOS versions - use async approach to avoid blocking
            EmptyView()
                .onAppear {
                    Task {
                        await handleFilePickerFallbackAsync(allowedContentTypes: allowedContentTypes, onFileSelected: onFileSelected, isPresented: isPresented)
                    }
                }
        }
        #endif
    }

    /// Platform-specific navigation view style
    /// iOS: Uses StackNavigationViewStyle; macOS: No-op
    func platformNavigationViewStyle() -> some View {
        #if os(iOS)
        self.navigationViewStyle(StackNavigationViewStyle())
        #else
        self
        #endif
    }

    /// Platform-specific system colors
    /// iOS: Uses UIColor; macOS: Uses NSColor
    static func platformSystemGray6() -> Color {
        #if os(iOS)
        return Color.platformSecondaryBackground
        #else
        return Color.platformSecondaryBackground
        #endif
    }








    // MARK: - Device-Aware Frame Sizing (Layer 4: Device-Specific Sizing)
    /// Device-aware frame sizing for optimal display across different devices
    /// This function provides device-specific sizing logic
    /// Layer 4: Device-specific implementation for iPad vs iPhone sizing differences
    func deviceAwareFrame() -> some View {
        #if os(iOS)
        // iOS: Device-aware sizing based on device type and orientation
        if SixLayerPlatform.deviceType == .pad {
            // iPad: Fill available space for optimal tablet experience
            // Supports Split View, Stage Manager, and orientation changes
            return AnyView(self.frame(maxWidth: .infinity, maxHeight: .infinity))
        } else {
            // iPhone: Standard sizing - no special constraints
            // Fixed screen size means we don't need adaptive frame behavior
            return AnyView(self)
        }
        #elseif os(macOS)
        // macOS: Use content-aware adaptive sizing (Layer 4)
        // This delegates to platformAdaptiveFrame for intelligent content analysis
            return AnyView(self.platformAdaptiveFrame())
        #else
            return AnyView(self)
        #endif
    }
}

// MARK: - Migration Phase: Temporary Type-Specific Layer 4 Functions
// These functions provide immediate component implementation during migration while building toward
// the full intelligent component system. They will be consolidated into generic
// functions once the system is mature.



/// Temporary Layer 4 function for implementing modal container for forms
/// This handles sheet presentation with proper sizing
@MainActor
    func platformModalContainer_Form_L4(
    strategy: ModalStrategy
) -> some View {
    // Hardcoded for now, will become intelligent later
    // Implement the modal container based on the strategy
    // Convert SheetDetent to PlatformPresentationDetent
    let platformDetents: [PlatformPresentationDetent] = strategy.detents.map { detent in
        switch detent {
        case .small:
            return .medium // Map small to medium for compatibility
        case .medium:
            return .medium
        case .large:
            return .large
        case .custom(let height):
            return .custom(height)
        }
    }
    
    return EmptyView()
        .platformSheet(isPresented: .constant(true), detents: platformDetents) {
            EmptyView()
        }
}

// MARK: - Helper Functions

/// Helper function to handle file picker fallback for older macOS versions using async approach
@MainActor
private func handleFilePickerFallbackAsync(
    allowedContentTypes: [UTType],
    onFileSelected: @escaping (URL) -> Void,
    isPresented: Binding<Bool>
) async {
    #if os(macOS)
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    panel.allowedContentTypes = allowedContentTypes

    // Use beginSheetModal instead of runModal to avoid blocking the main thread
    if let window = NSApplication.shared.keyWindow {
        await withCheckedContinuation { continuation in
            panel.beginSheetModal(for: window) { response in
                if response == .OK, let url = panel.url {
                    let shouldStopAccess = url.startAccessingSecurityScopedResource()
                    onFileSelected(url)
                    if shouldStopAccess {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                isPresented.wrappedValue = false
                continuation.resume()
            }
        }
    } else {
        // Fallback to runModal only if no key window is available
        let response = panel.runModal()
        if response == .OK, let url = panel.url {
            let shouldStopAccess = url.startAccessingSecurityScopedResource()
            onFileSelected(url)
            if shouldStopAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        isPresented.wrappedValue = false
    }
    #else
    isPresented.wrappedValue = false
    #endif
}
