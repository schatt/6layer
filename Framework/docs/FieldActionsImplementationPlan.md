# Field Actions Implementation Plan

## Overview

This plan implements custom field actions for `DynamicFormView`, unifying existing OCR/barcode functionality with a new extensible action system. The implementation follows TDD principles and addresses layout, accessibility, state management, and cross-platform concerns.

## Goals

1. **Unify existing functionality**: Replace hardcoded OCR/barcode buttons with extensible action system
2. **Support simple actions**: Protocol-based actions for common cases (scan, lookup, generate)
3. **Support complex actions**: View builder for custom UI needs
4. **Maintain backward compatibility**: Existing `supportsOCR`/`supportsBarcodeScanning` flags continue to work
5. **Handle layout gracefully**: Menu system for multiple actions to avoid UI crowding
6. **Full accessibility**: Proper labels, hints, and VoiceOver support
7. **Async support**: Handle long-running actions (scanners, network lookups) properly

## Architecture

### Core Components

1. **FieldAction Protocol**: Simple action interface for common cases
2. **Built-in Action Types**: Predefined actions (barcodeScan, ocrScan, lookup, generate, etc.)
3. **View Builder Support**: `trailingView` closure for complex custom actions
4. **Action Renderer**: Unified rendering system that handles layout and accessibility
5. **Action State Management**: Async action handling with loading states and error handling

## Implementation Phases

### Phase 1: Design & Types (TDD Red)

**Files to Create:**
- `Framework/Sources/Components/Forms/FieldActions.swift` - Protocol and types
- `Framework/Sources/Core/Models/DynamicFormTypes.swift` - Add action properties to `DynamicFormField`

**Types to Define:**

```swift
// Simple action protocol
@MainActor
public protocol FieldAction: Sendable {
    var id: String { get }
    var icon: String { get }
    var label: String { get }
    var accessibilityLabel: String { get }
    var accessibilityHint: String { get }
    
    /// Perform the action and optionally return a new field value
    func perform(fieldId: String, currentValue: Any?, formState: DynamicFormState) async throws -> Any?
}

// Built-in action types
public enum BuiltInFieldAction {
    case barcodeScan(hint: String?, supportedTypes: [BarcodeType]?)
    case ocrScan(hint: String?, validationTypes: [TextType]?)
    case lookup(label: String, perform: @Sendable (String, Any?) async throws -> Any?)
    case generate(label: String, perform: @Sendable () async throws -> Any?)
    case custom(id: String, icon: String, label: String, perform: @Sendable (String, Any?) async throws -> Any?)
}

// Action result for error handling
public enum FieldActionResult {
    case success(value: Any?)
    case failure(error: Error)
    case cancelled
}
```

**Properties to Add to DynamicFormField:**

```swift
public struct DynamicFormField: Identifiable {
    // ... existing properties ...
    
    // NEW: Unified action system
    /// Simple action for common cases (replaces/supplements supportsOCR/supportsBarcodeScanning)
    public let fieldAction: (any FieldAction)?
    
    /// View builder for complex custom actions
    /// Provides field and formState for building custom trailing UI
    public let trailingView: ((DynamicFormField, DynamicFormState) -> AnyView)?
    
    // Action configuration
    /// Maximum number of actions to show as buttons before using menu
    public let maxVisibleActions: Int // Default: 2
    
    /// Whether to show actions in a menu when there are multiple
    public let useActionMenu: Bool // Default: true when actions > maxVisibleActions
}
```

**Migration Strategy:**
- Keep `supportsOCR` and `supportsBarcodeScanning` for backward compatibility
- Auto-convert these flags to `BuiltInFieldAction` instances when `fieldAction` is nil
- Deprecate flags in favor of explicit actions (but don't remove yet)

### Phase 2: Tests (TDD Red)

**Test File:** `Development/Tests/SixLayerFrameworkUnitTests/Features/Forms/FieldActionsTests.swift`

**Test Cases:**

1. **Simple Action Tests:**
   - `testFieldActionProtocolConformance()`
   - `testBuiltInBarcodeScanAction()`
   - `testBuiltInOCRScanAction()`
   - `testCustomFieldAction()`
   - `testActionPerformsAndUpdatesFieldValue()`

2. **View Builder Tests:**
   - `testTrailingViewBuilderRenders()`
   - `testTrailingViewHasAccessToFieldAndFormState()`
   - `testTrailingViewCanUpdateFormState()`

3. **Layout Tests:**
   - `testSingleActionRendersAsButton()`
   - `testMultipleActionsUseMenu()`
   - `testMaxVisibleActionsRespected()`
   - `testActionMenuAccessibility()`

4. **Backward Compatibility Tests:**
   - `testSupportsOCRCreatesOCRAction()`
   - `testSupportsBarcodeCreatesBarcodeAction()`
   - `testExplicitActionOverridesFlags()`

5. **Async Action Tests:**
   - `testAsyncActionShowsLoadingState()`
   - `testAsyncActionHandlesErrors()`
   - `testAsyncActionCanCancel()`

6. **Accessibility Tests:**
   - `testActionButtonHasAccessibilityLabel()`
   - `testActionMenuIsAccessible()`
   - `testActionErrorsAnnouncedToVoiceOver()`

7. **Integration Tests:**
   - `testFieldActionInDynamicTextField()`
   - `testMultipleActionsInForm()`
   - `testActionUpdatesFieldValueAndTriggersValidation()`

### Phase 3: Protocol & Built-in Actions (TDD Green)

**Implementation Steps:**

1. **Create FieldAction Protocol** (`FieldActions.swift`)
   - Define protocol with required properties and methods
   - Make it `@MainActor` for UI safety
   - Make it `Sendable` for async support

2. **Implement BuiltInFieldAction** (`FieldActions.swift`)
   - Create struct conforming to `FieldAction`
   - Implement each case (barcodeScan, ocrScan, lookup, generate, custom)
   - Each action should:
     - Have proper icons (SF Symbols)
     - Have accessibility labels/hints
     - Handle async operations
     - Return values or throw errors

3. **Add Convenience Initializers** (`DynamicFormTypes.swift`)
   - Add initializer that converts `supportsOCR` → `BuiltInFieldAction.ocrScan`
   - Add initializer that converts `supportsBarcodeScanning` → `BuiltInFieldAction.barcodeScan`
   - Add initializer for explicit actions

4. **Update DynamicFormField** (`DynamicFormTypes.swift`)
   - Add `fieldAction` property
   - Add `trailingView` property
   - Add `maxVisibleActions` property (default: 2)
   - Add `useActionMenu` property (default: true)
   - Update all initializers to support new properties
   - Add computed property `effectiveActions` that:
     - Returns `fieldAction` if set
     - Otherwise converts `supportsOCR`/`supportsBarcodeScanning` to actions
     - Returns empty array if none

### Phase 4: Action Rendering (TDD Green)

**File:** `Framework/Sources/Components/Forms/FieldActionRenderer.swift` (new)

**Component:** `FieldActionRenderer`

**Responsibilities:**
- Render actions based on count and configuration
- Handle single action (button)
- Handle multiple actions (menu or horizontal buttons)
- Manage loading states during async actions
- Display errors from failed actions
- Ensure accessibility

**Implementation:**

```swift
@MainActor
struct FieldActionRenderer: View {
    let field: DynamicFormField
    let formState: DynamicFormState
    @State private var isActionMenuPresented = false
    @State private var actionLoadingState: [String: Bool] = [:]
    @State private var actionErrors: [String: Error] = [:]
    
    var body: some View {
        let actions = field.effectiveActions
        
        if actions.isEmpty {
            EmptyView()
        } else if actions.count == 1, let action = actions.first {
            singleActionButton(action: action)
        } else if actions.count <= field.maxVisibleActions {
            horizontalActionButtons(actions: actions)
        } else {
            actionMenu(actions: actions)
        }
    }
    
    // Render single action as button
    @ViewBuilder
    private func singleActionButton(action: any FieldAction) -> some View {
        Button(action: {
            Task {
                await performAction(action)
            }
        }) {
            Image(systemName: action.icon)
                .foregroundColor(.blue)
        }
        .buttonStyle(.borderless)
        .disabled(actionLoadingState[action.id] == true)
        .accessibilityLabel(action.accessibilityLabel)
        .accessibilityHint(action.accessibilityHint)
        .overlay {
            if actionLoadingState[action.id] == true {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
    
    // Render multiple actions horizontally (when count <= maxVisibleActions)
    @ViewBuilder
    private func horizontalActionButtons(actions: [any FieldAction]) -> some View {
        HStack(spacing: 8) {
            ForEach(actions, id: \.id) { action in
                singleActionButton(action: action)
            }
        }
    }
    
    // Render actions in menu (when count > maxVisibleActions or useActionMenu is true)
    @ViewBuilder
    private func actionMenu(actions: [any FieldAction]) -> some View {
        Menu {
            ForEach(actions, id: \.id) { action in
                Button(action: {
                    Task {
                        await performAction(action)
                    }
                }) {
                    Label(action.label, systemImage: action.icon)
                }
                .disabled(actionLoadingState[action.id] == true)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(.blue)
        }
        .accessibilityLabel("Field actions")
        .accessibilityHint("Tap to see available actions for this field")
    }
    
    // Perform action with loading state and error handling
    private func performAction(_ action: any FieldAction) async {
        actionLoadingState[action.id] = true
        actionErrors.removeValue(forKey: action.id)
        
        do {
            let result = try await action.perform(
                fieldId: field.id,
                currentValue: formState.getValue(for: field.id),
                formState: formState
            )
            
            // Update field value if action returned one
            if let newValue = result {
                formState.setValue(newValue, for: field.id)
            }
            
            actionLoadingState[action.id] = false
        } catch {
            actionErrors[action.id] = error
            actionLoadingState[action.id] = false
            // TODO: Show error to user (could use formState.addError or show alert)
        }
    }
}
```

### Phase 5: Integrate with DynamicTextField (TDD Green)

**File:** `Framework/Sources/Components/Forms/DynamicFieldComponents.swift`

**Changes:**

1. **Replace hardcoded OCR/barcode buttons** (lines 257-293)
   - Remove the `if field.supportsOCR || field.supportsBarcodeScanning` block
   - Replace with unified action rendering

2. **Add FieldActionRenderer** to text field view:

```swift
// In DynamicTextField.body, replace the OCR/barcode block with:
HStack {
    textFieldView
    
    // Render actions (unified system)
    FieldActionRenderer(field: field, formState: formState)
    
    // Render custom trailing view if provided
    if let trailingView = field.trailingView {
        trailingView(field, formState)
    }
}
```

3. **Handle view builder** for custom trailing views:
   - If `trailingView` is provided, render it after actions
   - Ensure proper spacing and layout

### Phase 6: Error Handling & Async Support

**Enhancements:**

1. **Error Display:**
   - Show action errors in field error area
   - Use `formState.addError()` for validation-style errors
   - Use alert/toast for critical errors

2. **Loading States:**
   - Show progress indicator on action button during async operations
   - Disable action button while loading
   - Prevent multiple simultaneous actions on same field

3. **Cancellation:**
   - Support cancellation for long-running actions
   - Use `Task` with cancellation support

### Phase 7: Accessibility

**Requirements:**

1. **Action Buttons:**
   - Every action button must have `accessibilityLabel`
   - Every action button must have `accessibilityHint`
   - Loading states must be announced to VoiceOver
   - Errors must be announced to VoiceOver

2. **Action Menu:**
   - Menu must be keyboard navigable
   - Menu items must have proper labels
   - Menu state (open/closed) must be announced

3. **Error Announcements:**
   - Use `UIAccessibility.post(notification: .announcement, argument: errorMessage)` on iOS
   - Use appropriate macOS accessibility APIs

### Phase 8: Cross-Platform Support

**Considerations:**

1. **Platform-Specific Actions:**
   - Some actions may only work on iOS (e.g., camera-based scanning)
   - Use `#if os(iOS)` for platform-specific action implementations
   - Provide fallbacks or disable actions on unsupported platforms

2. **UI Differences:**
   - Menu style may differ between iOS and macOS
   - Button styles should adapt to platform conventions
   - Use platform-appropriate icons and layouts

### Phase 9: Documentation & Examples

**Documentation to Create:**

1. **API Documentation:**
   - Document `FieldAction` protocol
   - Document `BuiltInFieldAction` cases
   - Document `DynamicFormField` action properties
   - Document migration from flags to actions

2. **Usage Examples:**
   - Simple barcode scan action
   - Custom lookup action
   - View builder for complex UI
   - Multiple actions with menu
   - Async action with error handling

3. **Migration Guide:**
   - How to migrate from `supportsOCR` to explicit actions
   - How to add custom actions
   - Best practices for action design

## Backward Compatibility

**Strategy:**

1. **Keep existing flags:** Don't remove `supportsOCR` or `supportsBarcodeScanning`
2. **Auto-conversion:** Automatically convert flags to actions when `fieldAction` is nil
3. **Precedence:** Explicit `fieldAction` takes precedence over flags
4. **Deprecation:** Mark flags as deprecated with migration guidance, but don't remove

**Migration Path:**

```swift
// Old way (still works):
DynamicFormField(
    id: "vin",
    label: "VIN",
    supportsBarcodeScanning: true,
    barcodeHint: "Scan VIN"
)

// New way (preferred):
DynamicFormField(
    id: "vin",
    label: "VIN",
    fieldAction: BuiltInFieldAction.barcodeScan(
        hint: "Scan VIN",
        supportedTypes: [.code128, .qrCode]
    )
)
```

## Testing Strategy

**Unit Tests:**
- Protocol conformance
- Action execution
- Error handling
- State management

**Integration Tests:**
- Action rendering in forms
- Multiple actions layout
- Async action completion
- Error display

**UI Tests:**
- Action button visibility
- Menu interaction
- Accessibility navigation
- Error announcements

## Risk Mitigation

**Risks:**

1. **Layout crowding with multiple actions**
   - **Mitigation:** Menu system for >2 actions, configurable max visible

2. **Async action complexity**
   - **Mitigation:** Clear loading states, error handling, cancellation support

3. **Backward compatibility breakage**
   - **Mitigation:** Auto-conversion, deprecation warnings, migration guide

4. **Accessibility regressions**
   - **Mitigation:** Comprehensive accessibility tests, VoiceOver testing

5. **Performance with many actions**
   - **Mitigation:** Lazy rendering, efficient state management

## Success Criteria

- [ ] All existing OCR/barcode functionality works via new action system
- [ ] Simple actions (scan, lookup, generate) work correctly
- [ ] View builder supports complex custom actions
- [ ] Multiple actions display in menu when appropriate
- [ ] Async actions show loading states and handle errors
- [ ] Full accessibility support (VoiceOver, keyboard navigation)
- [ ] Cross-platform compatibility (iOS/macOS)
- [ ] Backward compatibility maintained
- [ ] All tests pass
- [ ] Documentation complete with examples

## Timeline Estimate

- **Phase 1 (Design)**: 2-3 hours
- **Phase 2 (Tests)**: 4-6 hours
- **Phase 3 (Protocol)**: 3-4 hours
- **Phase 4 (Rendering)**: 4-6 hours
- **Phase 5 (Integration)**: 2-3 hours
- **Phase 6 (Error/Async)**: 3-4 hours
- **Phase 7 (Accessibility)**: 2-3 hours
- **Phase 8 (Cross-platform)**: 2-3 hours
- **Phase 9 (Documentation)**: 2-3 hours

**Total Estimate**: 24-35 hours

## Next Steps

1. Review and approve this plan
2. Start with Phase 1 (Design & Types) - TDD Red
3. Write tests (Phase 2) before implementation
4. Implement incrementally, ensuring tests pass at each step
5. Test on both iOS and macOS
6. Update documentation as we go
