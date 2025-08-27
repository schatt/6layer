# Function Index

- **Directory**: Shared/Views/Extensions
- **Generated**: 2025-08-20 14:11:35 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## Shared/Views/Extensions/PlatformTabViewExtensions.swift
### Internal Methods
- **L15:** ` func platformTabViewStyle() -> some View`
  - *function|extension View*
  - *- Returns: A view with platform-specific tab view style\n*

## Shared/Views/Extensions/PlatformVehicleSelectionHelpers.swift
### Internal Methods
- **L13:** ` func handleVehicleSelection()`
  - *function*
- **L25:** ` static func createVehiclePickerView(`
  - *static function*
- **L84:** ` var __managedObjectID: NSManagedObjectID { objectID }`
  - *function*
  - *Stable identity for Core Data objects in lists\n*

## Shared/Views/Extensions/PlatformStylingLayer4.swift
### Internal Methods
- **L13:** ` func platformBackground() -> some View`
  - *function|extension View*
  - *Platform-specific background modifier\nApplies platform-specific background colors\n*
- **L24:** ` func platformBackground(_ color: Color) -> some View`
  - *function|extension View*
  - *Platform-specific background with custom color\n*
- **L32:** ` func platformPadding() -> some View`
  - *function|extension View*
  - *Platform-specific padding modifier\nApplies platform-specific padding values\n*
- **L43:** ` func platformPadding(_ edges: Edge.Set, _ length: CGFloat? = nil) -> some View`
  - *function|extension View*
  - *Platform-specific padding with directional control\n*
- **L48:** ` func platformPadding(_ value: CGFloat) -> some View`
  - *function|extension View*
  - *Platform-specific padding with explicit value\n*
- **L53:** ` func platformReducedPadding() -> some View`
  - *function|extension View*
  - *Platform-specific reduced padding values\n*
- **L60:** ` func platformCornerRadius() -> some View`
  - *function*
  - *Platform-specific corner radius modifier\n*
- **L71:** ` func platformCornerRadius(_ radius: CGFloat) -> some View`
  - *function*
  - *Platform-specific corner radius with custom value\n*
- **L76:** ` func platformShadow() -> some View`
  - *function*
  - *Platform-specific shadow modifier\n*
- **L87:** ` func platformShadow(color: Color = .black, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View`
  - *function*
  - *Platform-specific shadow with custom parameters\n*
- **L92:** ` func platformBorder() -> some View`
  - *function*
  - *Platform-specific border modifier\n*
- **L112:** ` func platformBorder(color: Color, width: CGFloat = 0.5) -> some View`
  - *function*
  - *Platform-specific border with custom parameters\n*
- **L122:** ` func platformFont() -> some View`
  - *function*
  - *Platform-specific font modifier\n*
- **L133:** ` func platformFont(_ style: Font) -> some View`
  - *function*
  - *Platform-specific font with custom style\n*
- **L140:** ` func platformAnimation() -> some View`
  - *function*
  - *Platform-specific animation modifier\n*
- **L151:** ` func platformAnimation(_ animation: Animation?, value: AnyHashable) -> some View`
  - *function*
  - *Platform-specific animation with custom parameters\n*
- **L158:** ` func platformMinFrame() -> some View`
  - *function*
  - *Platform-specific minimum frame constraints\n*
- **L169:** ` func platformMaxFrame() -> some View`
  - *function*
  - *Platform-specific maximum frame constraints\n*
- **L180:** ` func platformIdealFrame() -> some View`
  - *function*
  - *Platform-specific ideal frame constraints\n*
- **L191:** ` func platformAdaptiveFrame() -> some View`
  - *function*
  - *Platform-specific adaptive frame constraints\n*
- **L204:** ` func platformFormStyle() -> some View`
  - *function*
  - *Platform-specific form styling\n*
- **L217:** ` func platformContentSpacing() -> some View`
  - *function*
  - *Platform-specific content spacing\n*

## Shared/Views/Extensions/PlatformListExtensions.swift
### Internal Methods
- **L19:** ` func platformListToolbar(`
  - *function|extension View*
  - *- Parameters:\n- onAdd: Action to perform when add is tapped\n- addButtonTitle: Title for the add button (default: "Add")\n- addButtonIcon: Icon for the add button (default: "plus")\n- Returns: A view with platform-specific toolbar\n*
- **L51:** ` func platformListStyle() -> some View`
  - *function|extension View*
  - *- Returns: A view with platform-specific list style\n*
- **L63:** ` func platformSidebarListStyle() -> some View`
  - *function*
  - *- Returns: A view with platform-specific sidebar list style\n*

## Shared/Views/Extensions/PlatformNavigationViews.swift
### Internal Methods
- **L15:** ` var body: some View`
  - *function*
- **L46:** ` var body: some View`
  - *function*
- **L86:** ` var body: some View`
  - *function*
- **L9:** ` init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail)`
  - *function*
- **L39:** ` init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail)`
  - *function*
- **L74:** ` init(`
  - *function*

## Shared/Views/Extensions/PlatformSpecificViewExtensions.swift
### Internal Methods
- **L26:** ` func platformHoverEffect(_ onChange: @escaping (Bool) -> Void) -> some View`
  - *function|extension View*
  - *Hover effect wrapper (no-op on iOS)\n*
- **L35:** ` func platformFileImporter(`
  - *function|extension View*
  - *Cross-platform file importer wrapper (uses SwiftUI .fileImporter on both platforms)\n*
- **L74:** ` func platformFrame(minWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> some View`
  - *function*
  - *- Parameters:\n- minWidth: Minimum width constraint (macOS only)\n- minHeight: Minimum height constraint (macOS only)\n- maxWidth: Maximum width constraint (macOS only)\n- maxHeight: Maximum height constraint (macOS only)\n- Returns: A view with platform-specific frame constraints\n*
- **L111:** ` func platformContentSpacing(all: CGFloat? = nil) -> some View`
  - *function*
  - *- Parameter all: Custom padding value applied to all sides\n- Returns: A view with platform-specific content spacing\n*
- **L139:** ` func platformHelp(_ text: String) -> some View`
  - *function*
  - *Platform-specific help tooltip (macOS only)\nAdds help tooltip on macOS, no-op on other platforms\n*
- **L149:** ` func platformPresentationDetents(_ detents: Set<PresentationDetent>) -> some View`
  - *function*
  - *Platform-specific presentation detents (iOS only)\nApplies presentation detents on iOS, no-op on other platforms\n*
- **L162:** ` func platformPresentationDetents(_ detents: [PlatformPresentationDetent]) -> some View`
  - *function*
  - *- Parameter detents: Array of platform-specific presentation detents\n- Returns: A view with platform-specific presentation detents\n*
- **L184:** ` func platformFormToolbar(`
  - *function*
  - *- Parameters:\n- onCancel: Action to perform when cancel is tapped\n- onSave: Action to perform when save is tapped\n- saveButtonTitle: Title for the save button (default: "Save")\n- cancelButtonTitle: Title for the cancel button (default: "Cancel")\n- Returns: A view with platform-specific toolbar\n*
- **L237:** ` func platformDetailToolbar(`
  - *function*
  - *- Parameters:\n- onCancel: Action to perform when cancel is tapped\n- onSave: Action to perform when save is tapped\n- saveButtonTitle: Title for the save button (default: "Save")\n- Returns: A view with platform-specific toolbar\n*
- **L623:** ` func platformAlert(`
  - *function*
  - *- Parameters:\n- error: The error to display\n- isPresented: Binding to control alert presentation\n- Returns: A view with platform-specific error alert presentation\n*
- **L643:** ` func platformTextFieldStyle() -> some View`
  - *function*
  - *Platform-specific text field styling\nProvides consistent text field appearance across platforms\n*
- **L655:** ` func platformPickerStyle() -> some View`
  - *function*
  - *Platform-specific picker styling\nProvides consistent picker appearance across platforms\n*
- **L667:** ` func platformDatePickerStyle() -> some View`
  - *function*
  - *Platform-specific date picker styling\nProvides consistent date picker appearance across platforms\n*
- **L932:** ` func platformToolbarPlacement(_ placement: PlatformToolbarPlacement) -> ToolbarItemPlacement`
  - *function*
- **L1048:** ` func platformToolbarWithConfirmationAction(`
  - *function*
  - *Convenience method for toolbar with confirmation action only\n*
- **L1058:** ` func platformToolbarWithCancellationAction(`
  - *function*
  - *Convenience method for toolbar with cancellation action only\n*
- **L1068:** ` func platformToolbarWithActions(`
  - *function*
  - *Convenience method for toolbar with both confirmation and cancellation actions\n*
- **L1112:** ` func platformToolbarWithAddAction(`
  - *function*
  - *Convenience method for toolbar with an "Add" action button\n*
- **L1122:** ` func platformToolbarWithRefreshAction(`
  - *function*
  - *Convenience method for toolbar with a refresh action button\n*
- **L1134:** ` func platformToolbarWithEditAction(`
  - *function*
  - *Convenience method for toolbar with an edit action button\n*
- **L1144:** ` func platformToolbarWithDeleteAction(`
  - *function*
  - *Convenience method for toolbar with a delete action button (with confirmation)\n*
- **L1176:** ` func platformVehicleImage(imageData: Data?) -> some View`
  - *function*
- **L1368:** ` func platformTextField(`
  - *function*
  - *- Parameters:\n- text: Binding to the text value\n- prompt: The placeholder text\n- axis: The text field axis (iOS 16+)\n- Returns: A platform-specific text field\n*
- **L1391:** ` func platformSecureTextField(`
  - *function*
  - *- Parameters:\n- text: Binding to the text value\n- prompt: The placeholder text\n- Returns: A platform-specific secure text field\n*
- **L1409:** ` func platformTextEditor(`
  - *function*
  - *- Parameters:\n- text: Binding to the text value\n- prompt: The placeholder text\n- Returns: A platform-specific text editor\n*
- **L1446:** ` func platformNotificationReceiver(`
  - *function*
- **L1482:** ` func platformSaveFile(data: Data, fileName: String)`
  - *function*
  - *Platform-specific file save functionality\niOS: No-op; macOS: Uses NSSavePanel\n*
- **L1505:** ` func platformDismissSettings(`
  - *function*
  - *Express intent to dismiss settings\nAutomatically determines the appropriate dismissal method\n*
- **L1597:** ` func platformDetailViewFrame() -> some View`
  - *function*
  - *Platform-specific frame sizing for detail views\niOS: No frame constraints; macOS: Sets minimum width and height\n*
- **L1649:** ` static func platformSystemGray6() -> Color`
  - *static function*
  - *Platform-specific system colors\niOS: Uses UIColor; macOS: Uses NSColor\n*
- **L1688:** ` static func platformDecimalKeyboardType() -> KeyboardType`
  - *static function*
  - *Platform-specific decimal keyboard type\niOS: Uses decimalPad; macOS: Uses default\n*
- **L1698:** ` func platformEditPaymentToolbar(`
  - *function*
  - *Platform-specific edit payment toolbar\niOS: Uses navigationBarLeading/navigationBarTrailing; macOS: Uses automatic\n*
- **L1725:** ` func platformComparisonViewBackground() -> some View`
  - *function*
  - *Platform-specific comparison view background\niOS: Uses systemBackground; macOS: Uses windowBackgroundColor\n*
- **L1736:** ` func deviceAwareFrame() -> some View`
  - *function*
  - *Device-aware frame sizing for optimal display across different devices\nThis function provides device-specific sizing logic\nLayer 4: Device-specific implementation for iPad vs iPhone sizing differences\n*

## Shared/Views/Extensions/PlatformAdaptiveFrameModifier.swift
### Internal Methods
- **L11:** ` func body(content: Content) -> some View`
  - *function*
- **L55:** ` static func testContentAnalysis()`
  - *static function*

### Private Implementation
- **L25:** ` private func analyzeFormContent(_ metrics: FormContentMetrics) -> (minWidth: CGFloat, minHeight: CGFloat)`
  - *function*
  - *Analyze form content and calculate appropriate dimensions\nUses intelligent algorithms to determine sizing based on content complexity\n- Parameter metrics: Form content metrics from preference keys\n- Returns: Tuple of (minWidth, minHeight) with safe bounds\n*

## Shared/Views/Extensions/PlatformListsLayer4.swift
### Internal Methods
- **L23:** ` func platformListSectionHeader(`
  - *function|extension View*
  - *Platform-specific list section header with consistent styling\nProvides standardized section header appearance across platforms\n*
- **L44:** ` func platformListEmptyState(`
  - *function|extension View*
  - *Platform-specific list empty state with consistent styling\nProvides standardized empty state appearance across platforms\n*
- **L124:** ` func platformDetailPlaceholder(`
  - *function*
  - *Platform-specific detail pane placeholder\nShows when no item is selected in list-detail views\n*

### Private Implementation
- **L151:** ` private func backgroundColorForSelection(isSelected: Bool) -> Color`
  - *function*
  - *Helper function to determine background color for list selection\n*

## Shared/Views/Extensions/PlatformStrategySelectionLayer3.swift
### Public Interface
- **L100:** `public func selectCardLayoutStrategy(`
  - *function*
  - *Select optimal card layout strategy\nLayer 3: Strategy Selection\n*
- **L146:** `public func chooseGridStrategy(`
  - *function*
  - *Choose optimal grid strategy\nLayer 3: Strategy Selection\n*
- **L192:** `public func determineResponsiveBehavior(`
  - *function*
  - *Determine responsive behavior strategy\nLayer 3: Strategy Selection\n*

### Private Implementation
- **L234:** `private func analyzeCardContent(`
  - *function*
  - *Analyze card content to determine optimal layout\n*
- **L269:** `private func calculateOptimalColumns(`
  - *function*
- **L287:** `private func calculateAdaptiveWidths(`
  - *function*
- **L310:** `private func generateCustomGridItems(`
  - *function*
- **L324:** `private func generatePerformanceConsiderations(`
  - *function*
- **L347:** `private func generateStrategyReasoning(`
  - *function*

## Shared/Views/Extensions/PlatformColorSystemExtensions.swift
### Internal Methods
- **L220:** ` func platformSecondaryBackgroundColor() -> some View`
  - *function|extension View*
  - *Apply platform secondary background color\niOS: secondarySystemBackground; macOS: controlBackgroundColor\n*
- **L226:** ` func platformGroupedBackgroundColor() -> some View`
  - *function|extension View*
  - *Apply platform grouped background color\niOS: systemGroupedBackground; macOS: controlBackgroundColor\n*
- **L232:** ` func platformForegroundColor() -> some View`
  - *function|extension View*
  - *Apply platform foreground color\niOS: label; macOS: labelColor\n*
- **L238:** ` func platformSecondaryForegroundColor() -> some View`
  - *function|extension View*
  - *Apply platform secondary foreground color\niOS: secondaryLabel; macOS: secondaryLabelColor\n*
- **L244:** ` func platformTertiaryForegroundColor() -> some View`
  - *function|extension View*
  - *Apply platform tertiary foreground color\niOS: tertiaryLabel; macOS: tertiaryLabelColor\n*
- **L250:** ` func platformTintColor() -> some View`
  - *function|extension View*
  - *Apply platform tint color\niOS: systemBlue; macOS: controlAccentColor\n*
- **L256:** ` func platformDestructiveColor() -> some View`
  - *function|extension View*
  - *Apply platform destructive color\niOS: systemRed; macOS: systemRedColor\n*
- **L262:** ` func platformSuccessColor() -> some View`
  - *function|extension View*
  - *Apply platform success color\niOS: systemGreen; macOS: systemGreenColor\n*
- **L268:** ` func platformWarningColor() -> some View`
  - *function*
  - *Apply platform warning color\niOS: systemOrange; macOS: systemOrangeColor\n*
- **L274:** ` func platformInfoColor() -> some View`
  - *function*
  - *Apply platform info color\niOS: systemBlue; macOS: systemBlueColor\n*
- **L11:** ` static var platformBackground: Color`
  - *static function|extension Color*
  - *Platform background color\niOS: systemBackground; macOS: windowBackgroundColor\n*
- **L23:** ` static var platformSecondaryBackground: Color`
  - *static function|extension Color*
  - *Platform secondary background color\niOS: secondarySystemBackground; macOS: controlBackgroundColor\n*
- **L35:** ` static var platformGroupedBackground: Color`
  - *static function|extension Color*
  - *Platform grouped background color\niOS: systemGroupedBackground; macOS: controlBackgroundColor\n*
- **L47:** ` static var platformSeparator: Color`
  - *static function|extension Color*
  - *Platform separator color\niOS: separator; macOS: separatorColor\n*
- **L59:** ` static var platformLabel: Color`
  - *static function*
  - *Platform label color\niOS: label; macOS: labelColor\n*
- **L71:** ` static var platformSecondaryLabel: Color`
  - *static function*
  - *Platform secondary label color\niOS: secondaryLabel; macOS: secondaryLabelColor\n*
- **L83:** ` static var platformTertiaryLabel: Color`
  - *static function*
  - *Platform tertiary label color\niOS: tertiaryLabel; macOS: tertiaryLabelColor\n*
- **L95:** ` static var platformQuaternaryLabel: Color`
  - *static function*
  - *Platform quaternary label color\niOS: quaternaryLabel; macOS: quaternaryLabelColor\n*
- **L107:** ` static var platformSystemFill: Color`
  - *static function*
  - *Platform system fill color\niOS: systemFill; macOS: controlColor\n*
- **L119:** ` static var platformSecondarySystemFill: Color`
  - *static function*
  - *Platform secondary system fill color\niOS: secondarySystemFill; macOS: secondaryControlColor\n*
- **L131:** ` static var platformTertiarySystemFill: Color`
  - *static function*
  - *Platform tertiary system fill color\niOS: tertiarySystemFill; macOS: tertiaryControlColor\n*
- **L143:** ` static var platformQuaternarySystemFill: Color`
  - *static function*
  - *Platform quaternary system fill color\niOS: quaternarySystemFill; macOS: quaternaryControlColor\n*
- **L155:** ` static var platformTint: Color`
  - *static function*
  - *Platform tint color\niOS: systemBlue; macOS: controlAccentColor\n*
- **L167:** ` static var platformDestructive: Color`
  - *static function*
  - *Platform destructive color\niOS: systemRed; macOS: systemRedColor\n*
- **L179:** ` static var platformSuccess: Color`
  - *static function*
  - *Platform success color\niOS: systemGreen; macOS: systemGreenColor\n*
- **L191:** ` static var platformWarning: Color`
  - *static function*
  - *Platform warning color\niOS: systemOrange; macOS: systemOrangeColor\n*
- **L203:** ` static var platformInfo: Color`
  - *static function*
  - *Platform info color\niOS: systemBlue; macOS: systemBlueColor\n*

## Shared/Views/Extensions/PlatformFormsLayer4.swift
### Internal Methods
- **L59:** ` func platformValidationMessage(`
  - *function*
  - *Platform-specific validation message with consistent styling\nProvides standardized validation message appearance across platforms\n*
- **L83:** ` var color: Color`
  - *function*
- **L92:** ` var iconName: String`
  - *function*

## Shared/Views/Extensions/PlatformResponsiveCardsLayer4.swift
### Internal Methods
- **L10:** ` func platformCardGrid(`
  - *function|extension View*
  - *Platform-adaptive card grid layout\nLayer 4: Component Implementation\n*
- **L25:** ` func platformCardMasonry(`
  - *function|extension View*
  - *Platform-adaptive masonry layout for cards\nLayer 4: Component Implementation\n*
- **L41:** ` func platformCardList(`
  - *function|extension View*
  - *Platform-adaptive list layout for cards\nLayer 4: Component Implementation\n*
- **L52:** ` func platformCardAdaptive(`
  - *function|extension View*
  - *Platform-adaptive card with dynamic sizing\nLayer 4: Component Implementation\n*
- **L71:** ` func platformCardStyle(`
  - *function|extension View*
  - *Apply responsive card styling\nLayer 4: Component Implementation\n*
- **L84:** ` func platformCardPadding() -> some View`
  - *function|extension View*
  - *Apply adaptive padding based on device\nLayer 4: Component Implementation\n*

## Shared/Views/Extensions/PlatformDragDropExtensions.swift
### Internal Methods
- **L38:** ` func platformOnDrop(`
  - *function|extension View*
  - *## Usage Example\n```swift\nText("Drop files here")\n.platformOnDrop(\nsupportedTypes: [.fileURL, .image],\nisTargeted: $isDropTarget\n) { providers in\n// Handle dropped providers\nreturn true\n}\n```\n*
- **L78:** ` func platformOnDropFiles(`
  - *function*
  - *## Usage Example\n```swift\nText("Drop files here")\n.platformOnDropFiles(isTargeted: $isDropTarget) { providers in\n// Handle dropped file providers\nreturn true\n}\n```\n*
- **L105:** ` func platformOnDropImages(`
  - *function*
  - *## Usage Example\n```swift\nText("Drop images here")\n.platformOnDropImages(isTargeted: $isDropTarget) { providers in\n// Handle dropped image providers\nreturn true\n}\n```\n*
- **L132:** ` func platformOnDropText(`
  - *function*
  - *## Usage Example\n```swift\nText("Drop text here")\n.platformOnDropText(isTargeted: $isDropTarget) { providers in\n// Handle dropped text providers\nreturn true\n}\n```\n*

## Shared/Views/Extensions/PlatformTabStrip.swift
### Internal Methods
- **L7:** ` var body: some View`
  - *function*

## Shared/Views/Extensions/PlatformAccessibilityExtensions.swift
### Internal Methods
- **L21:** ` func platformAccessibilityLabel(_ label: String) -> some View`
  - *function|extension View*
  - *## Usage Example\n```swift\nImage(systemName: "star.fill")\n.platformAccessibilityLabel("Favorite item")\n```\n*
- **L37:** ` func platformAccessibilityHint(_ hint: String) -> some View`
  - *function|extension View*
  - *## Usage Example\n```swift\nButton("Save") { saveData() }\n.platformAccessibilityHint("Saves your current work")\n```\n*
- **L53:** ` func platformAccessibilityValue(_ value: String) -> some View`
  - *function|extension View*
  - *## Usage Example\n```swift\nSlider(value: $progress, in: 0...100)\n.platformAccessibilityValue("\(Int(progress)) percent")\n```\n*
- **L69:** ` func platformAccessibilityAddTraits(_ traits: AccessibilityTraits) -> some View`
  - *function*
  - *## Usage Example\n```swift\nText("Clickable text")\n.platformAccessibilityAddTraits(.isButton)\n```\n*
- **L85:** ` func platformAccessibilityRemoveTraits(_ traits: AccessibilityTraits) -> some View`
  - *function*
  - *## Usage Example\n```swift\nText("Important notice")\n.platformAccessibilityRemoveTraits(.isButton)\n```\n*
- **L101:** ` func platformAccessibilitySortPriority(_ priority: Double) -> some View`
  - *function*
  - *## Usage Example\n```swift\nText("Primary action")\n.platformAccessibilitySortPriority(1)\n```\n*
- **L117:** ` func platformAccessibilityHidden(_ hidden: Bool) -> some View`
  - *function*
  - *## Usage Example\n```swift\nText("Decorative element")\n.platformAccessibilityHidden(true)\n```\n*
- **L133:** ` func platformAccessibilityIdentifier(_ identifier: String) -> some View`
  - *function*
  - *## Usage Example\n```swift\nButton("Save") { saveData() }\n.platformAccessibilityIdentifier("save-button")\n```\n*
- **L153:** ` func platformAccessibilityAction(named name: String, action: @escaping () -> Void) -> some View`
  - *function*
  - *## Usage Example\n```swift\nText("Double tap to edit")\n.platformAccessibilityAction(named: "Edit") {\neditMode = true\n}\n```\n*

## Shared/Views/Extensions/PlatformButtonExtensions.swift
### Internal Methods
- **L12:** ` func platformNavigationSheetButton(`
  - *function|extension View*

## Shared/Views/Extensions/PlatformSemanticLayer1.swift
### Public Interface
- **L94:** `public func platformPresentNumericData(`
  - *function*
- **L103:** `public func platformPresentFormFields(`
  - *function*
- **L112:** `public func platformPresentHierarchicalData(`
  - *function*
- **L121:** `public func platformPresentMediaCollection(`
  - *function*
- **L130:** `public func platformPresentTemporalData(`
  - *function*
- **L61:** ` public init(`
  - *function*
- **L316:** ` public init(value: Double, label: String)`
  - *function*
- **L327:** ` public init(id: String, label: String, type: String)`
  - *function*
- **L339:** ` public init(id: String, title: String, children: [GenericHierarchicalItem] = [])`
  - *function*
- **L351:** ` public init(id: String, url: String, type: String)`
  - *function*
- **L363:** ` public init(id: String, date: Date, title: String)`
  - *function*
- **L377:** ` public init(id: String, name: String, make: String, model: String)`
  - *function*
- **L391:** ` public init(id: String, date: Date, gallons: Double, cost: Double)`
  - *function*
- **L405:** ` public init(id: String, date: Date, amount: Double, category: String)`
  - *function*
- **L419:** ` public init(id: String, date: Date, type: String, cost: Double)`
  - *function*

### Internal Methods
- **L143:** ` static func forVehicles(`
  - *static function*
  - *Hints for vehicle collections\n*
- **L164:** ` static func forFuelRecords(`
  - *static function*
  - *Hints for fuel record collections\n*
- **L185:** ` static func forExpenses(`
  - *static function*
  - *Hints for expense collections\n*
- **L206:** ` static func forMaintenance(`
  - *static function*
  - *Hints for maintenance collections\n*
- **L234:** ` var body: some View`
  - *function*
- **L265:** ` var body: some View`
  - *function*
- **L274:** ` var body: some View`
  - *function*
- **L283:** ` var body: some View`
  - *function*
- **L292:** ` var body: some View`
  - *function*
- **L301:** ` var body: some View`
  - *function*

### Private Implementation
- **L248:** ` private func determineOptimalLayout(for hints: PresentationHints) -> GenericLayoutDecision`
  - *function*
- **L253:** ` private func selectPlatformStrategy(for decision: GenericLayoutDecision) -> GenericPlatformStrategy`
  - *function*

## Shared/Views/Extensions/PlatformHapticFeedbackExtensions.swift
### Internal Methods
- **L44:** ` func platformHapticFeedback(_ feedback: PlatformHapticFeedback) -> some View`
  - *function|extension View*
  - *## Usage Example\n```swift\nButton("Tap me") { }\n.platformHapticFeedback(.light)\n```\n*
- **L96:** ` func platformHapticFeedback(`
  - *function*
  - *## Usage Example\n```swift\nButton("Tap me") {\n// This will trigger haptic feedback on iOS and execute the action\n}\n.platformHapticFeedback(.light) {\n// Custom action after haptic feedback\nprint("Button tapped with haptic feedback")\n}\n```\n*

## Shared/Views/Extensions/PlatformToolbarHelpers.swift
### Internal Methods
- **L3:** `func platformConfirmationActionPlacement() -> ToolbarItemPlacement`
  - *function*
- **L11:** `func platformCancellationActionPlacement() -> ToolbarItemPlacement`
  - *function*
- **L19:** `func platformPrimaryActionPlacement() -> ToolbarItemPlacement`
  - *function*
- **L27:** `func platformSecondaryActionPlacement() -> ToolbarItemPlacement`
  - *function*
- **L35:** `func platformToolbarPlacement() -> ToolbarItemPlacement`
  - *function*

## Shared/Views/Extensions/PlatformOptimizationExtensions.swift
### Internal Methods
- **L293:** ` func platformFormOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific form styling\n*
- **L300:** ` func platformFieldOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific field styling\n*
- **L307:** ` func platformNavigationOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific navigation styling\n*
- **L314:** ` func platformToolbarOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific toolbar styling\n*
- **L321:** ` func platformModalOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific modal styling\n*
- **L328:** ` func platformListOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific list styling\n*
- **L335:** ` func platformGridOptimized() -> some View`
  - *function|extension View*
  - *Apply platform-specific grid styling\n*
- **L342:** ` func platformPerformanceOptimized(for platform: Platform) -> some View`
  - *function*
  - *Apply platform-specific performance optimizations\n*
- **L347:** ` func platformMemoryOptimized(for platform: Platform) -> some View`
  - *function*
  - *Apply platform-specific memory optimizations\n*
- **L352:** ` func platformAccessibilityEnhanced(for platform: Platform) -> some View`
  - *function*
  - *Apply platform-specific accessibility enhancements\n*
- **L357:** ` func platformDeviceOptimized(for device: DeviceType) -> some View`
  - *function*
  - *Optimize for specific device\n*
- **L362:** ` func platformFeatures(_ features: [PlatformFeature]) -> some View`
  - *function*
  - *Apply platform-specific features\n*

## Shared/Views/Extensions/PlatformModalsLayer4.swift
### Internal Methods
- **L35:** ` func platformAlert(`
  - *function|extension View*
  - *Platform-specific alert presentation with consistent styling\nProvides standardized alert appearance across platforms\n*
- **L99:** ` func platformDismissEmbeddedSettings(`
  - *function*
  - *Platform-specific settings dismissal for embedded navigation\nHandles dismissal when settings are presented as embedded views in navigation\n*
- **L115:** ` func platformDismissSheetSettings(`
  - *function*
  - *Platform-specific settings dismissal for sheet presentation\nHandles dismissal when settings are presented as sheets\n*
- **L133:** ` func platformDismissWindowSettings(`
  - *function*
  - *Platform-specific settings dismissal for window presentation\nHandles dismissal when settings are presented in separate windows\n*

## Shared/Views/Extensions/PlatformButtonsLayer4.swift
### Internal Methods
- **L11:** ` func platformPrimaryButtonStyle() -> some View`
  - *function|extension View*
  - *Platform-specific primary button style\nProvides consistent primary button appearance across platforms\n*
- **L29:** ` func platformSecondaryButtonStyle() -> some View`
  - *function|extension View*
  - *Platform-specific secondary button style\nProvides consistent secondary button appearance across platforms\n*
- **L46:** ` func platformDestructiveButtonStyle() -> some View`
  - *function|extension View*
  - *Platform-specific destructive button style\nProvides consistent destructive button appearance across platforms\n*
- **L67:** ` func platformIconButton(`
  - *function*
  - *Platform-specific icon button with consistent styling\nProvides standardized icon button appearance across platforms\n*

## Shared/Views/Extensions/PlatformColorExtensions.swift
### Internal Methods
- **L221:** ` func platformColorEncode() -> Data?`
  - *function*
  - *Platform-specific color encoding\niOS: Uses UIColor; macOS: Uses NSColor\n*
- **L5:** ` static var cardBackground: Color`
  - *static function|extension Color*
- **L13:** ` static var secondaryBackground: Color`
  - *static function|extension Color*
- **L21:** ` static var tertiaryBackground: Color`
  - *static function|extension Color*
- **L29:** ` static var primaryBackground: Color`
  - *static function|extension Color*
- **L39:** ` static var groupedBackground: Color`
  - *static function|extension Color*
- **L49:** ` static var secondaryGroupedBackground: Color`
  - *static function|extension Color*
- **L59:** ` static var separator: Color`
  - *static function*
- **L69:** ` static var label: Color`
  - *static function*
- **L79:** ` static var secondaryLabel: Color`
  - *static function*
- **L89:** ` static var tertiaryLabel: Color`
  - *static function*
- **L99:** ` static var systemBlue: Color`
  - *static function*
- **L109:** ` static var systemRed: Color`
  - *static function*
- **L119:** ` static var systemGreen: Color`
  - *static function*
- **L129:** ` static var systemOrange: Color`
  - *static function*
- **L139:** ` static var systemYellow: Color`
  - *static function*
- **L149:** ` static var systemPurple: Color`
  - *static function*
- **L159:** ` static var systemPink: Color`
  - *static function*
- **L169:** ` static var systemIndigo: Color`
  - *static function*
- **L179:** ` static var systemTeal: Color`
  - *static function*
- **L189:** ` static var systemMint: Color`
  - *static function*
- **L199:** ` static var systemCyan: Color`
  - *static function*
- **L209:** ` static var systemBrown: Color`
  - *static function*

## Shared/Views/Extensions/PlatformSpecificSecureFieldExtensions.swift
### Internal Methods
- **L4:** ` func platformTextFieldStyle() -> some View`
  - *function|extension SecureField*

## Shared/Views/Extensions/PlatformTechnicalExtensions.swift
### Internal Methods
- **L226:** ` func platformFormTechnical(`
  - *function|extension View*
  - *Apply technical form implementation with performance optimization\n*
- **L236:** ` func platformFieldTechnical(label: String) -> some View`
  - *function|extension View*
  - *Apply technical field implementation with performance optimization\n*
- **L243:** ` func platformNavigationTechnical(title: String) -> some View`
  - *function|extension View*
  - *Apply technical navigation implementation with performance optimization\n*
- **L250:** ` func platformToolbarTechnical(placement: ToolbarItemPlacement) -> some View`
  - *function|extension View*
  - *Apply technical toolbar implementation with performance optimization\n*
- **L257:** ` func platformModalTechnical(isPresented: Binding<Bool>) -> some View`
  - *function|extension View*
  - *Apply technical modal implementation with performance optimization\n*
- **L264:** ` func platformListTechnical() -> some View`
  - *function|extension View*
  - *Apply technical list implementation with performance optimization\n*
- **L271:** ` func platformGridTechnical(columns: Int, spacing: CGFloat = 16) -> some View`
  - *function|extension View*
  - *Apply technical grid implementation with performance optimization\n*

## Shared/Views/Extensions/PlatformAdvancedContainerExtensions.swift
### Internal Methods
- **L37:** ` func platformLazyVGridContainer() -> some View`
  - *function|extension View*
  - *## Usage Example\n```swift\nLazyVGrid(columns: columns) {\nForEach(items) { item in\nItemView(item: item)\n}\n}\n.platformLazyVGridContainer()\n```\n*
- **L66:** ` func platformTabContainer() -> some View`
  - *function*
  - *## Usage Example\n```swift\nTabView {\nFirstTab()\nSecondTab()\n}\n.platformTabContainer()\n```\n*
- **L97:** ` func platformScrollContainer(showsIndicators: Bool = true) -> some View`
  - *function*
  - *## Usage Example\n```swift\nScrollView {\nVStack {\nForEach(items) { item in\nItemView(item: item)\n}\n}\n}\n.platformScrollContainer()\n```\n*
- **L125:** ` func platformListContainer() -> some View`
  - *function*
  - *## Usage Example\n```swift\nList {\nForEach(items) { item in\nItemRow(item: item)\n}\n}\n.platformListContainer()\n```\n*
- **L154:** ` func platformFormContainer() -> some View`
  - *function*
  - *## Usage Example\n```swift\nForm {\nSection("Personal Information") {\nTextField("Name", text: $name)\nTextField("Email", text: $email)\n}\n}\n.platformFormContainer()\n```\n*

## Shared/Views/Extensions/PlatformContextMenuExtensions.swift
### Public Interface
- **L91:** ` public init(_ title: String, action: @escaping () -> Void)`
  - *function*

### Internal Methods
- **L75:** ` func platformContextMenu(actions: [ContextMenuAction]) -> some View`
  - *function*

## Shared/Views/Extensions/PlatformLayoutDecisionLayer2.swift
### Public Interface
- **L84:** `public func determineOptimalFormLayout(`
  - *function*
  - *Determine optimal form layout based on content analysis\nLayer 2: Layout Decision Engine\n*
- **L107:** `public func analyzeFormContent(`
  - *function*
  - *Analyze form content to determine optimal layout\nLayer 2: Layout Decision Engine\n*
- **L158:** `public func decideFormLayout(`
  - *function*
  - *Decide form layout based on analysis\nLayer 2: Layout Decision Engine\n*
- **L177:** `public func analyzeCardContent(`
  - *function*
  - *Analyze card content for responsive layout decisions\nLayer 2: Layout Decision Engine\n*
- **L226:** `public func determineOptimalCardLayout(`
  - *function*
  - *Determine optimal card layout based on screen dimensions and device type\nLayer 2: Layout Decision Engine\n*

### Private Implementation
- **L276:** `private func analyzeFormComplexity(fieldCount: Int, complexity: FormIntent) -> FormLayout`
  - *function*
- **L293:** `private func chooseValidationStrategy(complexity: FormIntent, deviceType: DeviceType) -> ValidationStrategy`
  - *function*
- **L310:** `private func chooseAccessibilityStrategy(complexity: FormIntent, deviceType: DeviceType) -> AccessibilityStrategy`
  - *function*
- **L325:** `private func choosePerformanceStrategy(complexity: FormIntent, deviceType: DeviceType) -> PerformanceStrategy`
  - *function*
- **L342:** `private func choosePerformanceStrategy(complexity: ContentComplexity, deviceType: DeviceType) -> PerformanceStrategy`
  - *function*
- **L379:** `private func assessFieldComplexity(_ fields: [FormFieldData]) -> FormIntent`
  - *function*
- **L384:** `private func assessCardComplexity(_ cards: [CardContent]) -> ContentComplexity`
  - *function*
- **L389:** `private func assessCardCountComplexity(_ cardCount: Int) -> ContentComplexity`
  - *function*
- **L402:** `private func analyzeDeviceCapabilities(deviceType: DeviceType, screenSize: CGSize) -> DeviceCapabilities`
  - *function*
- **L407:** `private func chooseLayoutApproach(fieldCount: Int, complexity: FormIntent, capabilities: DeviceCapabilities) -> LayoutApproach`
  - *function*
- **L412:** `private func calculateOptimalColumns(fieldCount: Int, complexity: FormIntent, capabilities: DeviceCapabilities) -> Int`
  - *function*
- **L417:** `private func calculateOptimalSpacing(deviceType: DeviceType, complexity: FormIntent) -> CGFloat`
  - *function*
- **L422:** `private func chooseCardStrategy(cardCount: Int, complexity: ContentComplexity, capabilities: DeviceCapabilities) -> CardStrategy`
  - *function*
- **L431:** `private func calculateOptimalCardColumns(cardCount: Int, complexity: ContentComplexity, capabilities: DeviceCapabilities) -> Int`
  - *function*
- **L436:** `private func calculateOptimalCardSpacing(deviceType: DeviceType, complexity: ContentComplexity) -> CGFloat`
  - *function*
- **L441:** `private func determineResponsiveBehavior(deviceType: DeviceType, complexity: ContentComplexity) -> ResponsiveBehavior`
  - *function*
- **L450:** `private func generateLayoutReasoning(approach: LayoutApproach, columns: Int, spacing: CGFloat, performance: PerformanceStrategy) -> String`
  - *function*

## Shared/Views/Extensions/PlatformSidebarHelpers.swift
### Internal Methods
- **L5:** `func platformSidebarPullIndicator(isVisible: Bool) -> some View`
  - *function*
- **L52:** `func platformSidebarToggleButton(columnVisibility: Binding<NavigationSplitViewVisibility>) -> some View`
  - *function*

## Shared/Views/Extensions/PlatformUITypes.swift
### Public Interface
- **L44:** ` public init(title: String, systemImage: String? = nil)`
  - *function*

### Internal Methods
- **L10:** ` var navigationBarDisplayMode: NavigationBarItem.TitleDisplayMode`
  - *function*
- **L18:** ` var navigationBarDisplayMode: Any { self }`
  - *function*
- **L29:** ` var presentationDetent: PresentationDetent`
  - *function*

## Shared/Views/Extensions/PlatformListDetailDecisionLayer2.swift
### Internal Methods
- **L27:** ` func select(_ item: T?)`
  - *function*
- **L39:** ` func deselect()`
  - *function*
- **L23:** ` init(initialSelection: T? = nil)`
  - *function*

## Shared/Views/Extensions/PlatformAnimationSystemExtensions.swift
### Internal Methods
- **L22:** ` func platformAnimation(_ animation: PlatformAnimation) -> some View`
  - *function|extension View*
- **L41:** ` func platformAnimation(`
  - *function|extension View*
- **L65:** ` func platformAnimation(`
  - *function*
- **L114:** ` func swiftUIAnimation(duration: Double) -> Animation`
  - *function*
  - *Convert to SwiftUI animation with duration\n*
- **L133:** ` func swiftUIAnimation(`
  - *function*
  - *Convert to SwiftUI animation with spring parameters\n*
- **L95:** ` var swiftUIAnimation: Animation`
  - *function*
  - *Convert to SwiftUI animation\n*

## Shared/Views/Extensions/PlatformSpecificTextFieldExtensions.swift
### Internal Methods
- **L4:** ` func platformTextFieldStyle() -> some View`
  - *function|extension TextField*

## Shared/Views/Extensions/PlatformPerformanceExtensionsLayer5.swift
### Internal Methods
- **L13:** ` func platformMemoryOptimization() -> some View`
  - *function|extension View*
  - *Platform-specific memory optimization with consistent behavior\nProvides memory optimization strategies across platforms\n*
- **L47:** ` func platformRenderingOptimization() -> some View`
  - *function|extension View*
  - *Platform-specific rendering optimization with consistent behavior\nProvides rendering optimization strategies across platforms\n*
- **L61:** ` func platformAnimationOptimization() -> some View`
  - *function*
  - *Platform-specific animation optimization with consistent behavior\nProvides animation optimization strategies across platforms\n*
- **L75:** ` func platformCachingOptimization() -> some View`
  - *function*
  - *Platform-specific caching optimization with consistent behavior\nProvides caching optimization strategies across platforms\n*
- **L128:** ` var multiplier: Double`
  - *function*
- **L146:** ` var cacheSize: Int`
  - *function*
- **L163:** ` var useMetal: Bool`
  - *function*
- **L112:** ` init(renderTime: TimeInterval = 0, memoryUsage: Int64 = 0, frameRate: Double = 60.0)`
  - *function*

## Shared/Views/Extensions/PlatformNavigationLayer4.swift
### Internal Methods
- **L63:** ` func platformNavigationButton(`
  - *function*
  - *Platform-specific navigation button with consistent styling and accessibility\n- Parameters:\n- title: The button title text\n- systemImage: The SF Symbol name for the button icon\n- accessibilityLabel: Accessibility label for screen readers\n- accessibilityHint: Accessibility hint for screen readers\n- action: The action to perform when the button is tapped\n- Returns: A view with platform-specific navigation button styling\n*
- **L94:** ` func platformNavigationTitle(_ title: String) -> some View`
  - *function*
  - *Platform-specific navigation title configuration\n*
- **L105:** ` func platformNavigationTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View`
  - *function*
  - *Platform-specific navigation title display mode\n*
- **L114:** ` func platformNavigationBarTitleDisplayMode(_ displayMode: PlatformTitleDisplayMode) -> some View`
  - *function*
  - *Platform-specific navigation bar title display mode\n*
- **L123:** ` func platformNavigationBarBackButtonHidden(_ hidden: Bool) -> some View`
  - *function*
  - *Platform-specific navigation bar back button hidden\n*
- **L315:** ` func platformNavigationViewStyle() -> some View`
  - *function*
  - *Platform-specific navigation view style\n*

