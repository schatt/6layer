# Layer 1: Semantic Intent

## Overview

Layer 1 focuses on expressing WHAT you want to achieve without worrying about implementation details. These functions provide a platform-agnostic way to express user intent.

## 📁 File Location

*`Shared/Views/Extensions/PlatformSemanticLayer1.swift`*

## 🎯 Purpose

Define the user's intent in platform-agnostic terms that can be interpreted by the decision engine and strategy layers.

## 🔧 Implementation Details

**Content:** Contains `extension View` blocks for semantic functions

## 📋 Available Functions

### **Form Presentation**
- `platformPresentForm(type:complexity:style:)` - Express intent to present a form
- `platformPresentNavigation(style:title:)` - Express intent to present navigation
- `platformPresentModal(type:content:)` - Express intent to present a modal

### **Responsive Cards**
- `platformResponsiveCard(type:content:)` - Express intent for responsive cards

### **Item Collections**
- `platformPresentItemCollection_L1(items:hints:callbacks:)` - Present collections of identifiable items with automatic row actions

### **Navigation Stack**
- `platformPresentNavigationStack_L1(content:title:hints:)` - Express intent to present content in a navigation stack
- `platformPresentNavigationStack_L1(items:hints:itemView:destination:)` - Express intent to present items in a navigation stack with list-detail pattern

## 📊 Data Types

### **FormType**
- `dataCreation` - Data creation forms
- `dataEntry` - Data entry forms
- `recordEntry` - Record entry forms
- `itemRecord` - Item record forms
- `tireChange` - Tire change forms
- `warrantyEntry` - Warranty entry forms
- `insuranceEntry` - Insurance entry forms

### **NavigationStyle**
- `embedded` - Embedded navigation within the current view
- `sheet` - Modal sheet presentation
- `window` - New window presentation (macOS)
- `sidebar` - Sidebar navigation (macOS)

### **ModalType**
- `alert` - Alert dialog
- `sheet` - Modal sheet
- `confirmationDialog` - Confirmation dialog
- `popover` - Popover presentation

### **FormIntent**
- `simple` - Simple forms with few fields
- `moderate` - Moderate complexity forms
- `complex` - Complex forms with many fields
- `veryComplex` - Very complex forms requiring special handling

### **CardType**
- `dashboard` - Dashboard-style cards
- `detail` - Detail view cards
- `summary` - Summary information cards
- `action` - Action-oriented cards
- `media` - Media-rich cards

## 💡 Usage Examples

### **Basic Form Presentation**
```swift
.platformPresentForm(
    type: .dataEntry,
    complexity: .moderate,
    style: .standard
) {
    // Form content
}
```

### **Responsive Card Intent**
```swift
.platformResponsiveCard(type: .dashboard) {
    // Card content
}
```

### **Navigation Intent**
```swift
.platformPresentNavigation(
    style: .sheet,
    title: "Add Item"
) {
    // Navigation content
}
```

### **Item Collection with Built-in Actions**
```swift
platformPresentItemCollection_L1(
    items: vehicles,
    hints: PresentationHints(
        dataType: .collection,
        context: .browse
    ),
    onCreateItem: { showAddVehicleSheet = true },
    onItemSelected: { vehicle in
        selectedVehicle = vehicle
        showDetailView = true
    },
    onItemEdited: { vehicle in
        editingVehicle = vehicle
        showEditSheet = true
    },
    onItemDeleted: { vehicle in
        deleteVehicle(vehicle)
    }
)
```

**Automatic Row Actions:**
- When `onItemEdited` is provided, an "Edit" button automatically appears in row actions (swipe actions on iOS, context menu on macOS)
- When `onItemDeleted` is provided, a "Delete" button automatically appears
- Actions are platform-appropriate: iOS uses swipe gestures, macOS uses right-click context menus
- Both actions can be provided together or individually

### **Navigation Stack with Content**
```swift
platformPresentNavigationStack_L1(
    content: MyContentView(),
    title: "Settings",
    hints: PresentationHints(
        dataType: .navigation,
        presentationPreference: .navigation,
        complexity: .simple,
        context: .navigation
    )
)
```

### **Navigation Stack with Items**
```swift
platformPresentNavigationStack_L1(
    items: items,
    hints: PresentationHints(
        dataType: .navigation,
        presentationPreference: .navigation,
        complexity: .moderate,
        context: .browse
    )
) { item in
    ItemRow(item: item)
} destination: { item in
    ItemDetailView(item: item)
}
```

**See [NavigationStackGuide.md](NavigationStackGuide.md) for complete documentation.**

### **Item Collection with Custom Actions**
For custom actions beyond Edit/Delete, use `customItemView`:

```swift
platformPresentItemCollection_L1(
    items: vehicles,
    hints: PresentationHints(
        dataType: .collection,
        context: .browse
    ),
    onItemSelected: { vehicle in
        selectedVehicle = vehicle
    },
    customItemView: { vehicle in
        HStack {
            // Your custom item view
            VStack(alignment: .leading) {
                Text(vehicle.name)
                Text(vehicle.make)
            }
            
            Spacer()
            
            // Custom actions using platformRowActions_L4
            Button("Share") {
                shareVehicle(vehicle)
            }
            .platformRowActions_L4(edge: .trailing) {
                PlatformRowActionButton(
                    title: "Share",
                    systemImage: "square.and.arrow.up",
                    action: { shareVehicle(vehicle) }
                )
                PlatformRowActionButton(
                    title: "Archive",
                    systemImage: "archivebox",
                    action: { archiveVehicle(vehicle) }
                )
                PlatformDestructiveRowActionButton(
                    title: "Delete",
                    systemImage: "trash",
                    action: { deleteVehicle(vehicle) }
                )
            }
        }
    }
)
```

**When to Use Custom Views:**
- You need actions beyond Edit/Delete (e.g., Share, Archive, Duplicate)
- You want custom item layout/styling
- You need item-specific conditional actions
- You want full control over the row appearance

**Built-in Callbacks vs. Custom Views:**
- **Built-in callbacks** (`onItemEdited`, `onItemDeleted`): Simple, type-safe, automatically appear in row actions
- **Custom views**: More flexible, allows any actions/layout, requires more code

## 🔄 Integration with Other Layers

### **Layer 1 → Layer 2**
Layer 1 functions call Layer 2 decision functions to determine how to implement the intent.

### **Layer 1 → Layer 4**
Layer 1 can directly call Layer 4 implementation functions for immediate execution.

## 🎨 Design Principles

1. **Intent-First:** Focus on what the user wants, not how to achieve it
2. **Platform-Agnostic:** Functions work the same on all platforms
3. **Progressive Enhancement:** Can be used independently or with other layers
4. **Semantic Clarity:** Function names clearly express the user's goal

## 🔧 Item Collection Callbacks

### **Built-in Callbacks**

The framework provides four built-in callbacks for item collections:

1. **`onCreateItem: (() -> Void)?`** - Called when user wants to create a new item
   - Displays "Add Item" button in empty state
   - Optional - only shown if provided

2. **`onItemSelected: ((Item) -> Void)?`** - Called when user taps/clicks an item
   - Handles item selection/navigation
   - Optional - item is still tappable if not provided

3. **`onItemEdited: ((Item) -> Void)?`** - Called when user wants to edit an item
   - **Automatically appears as "Edit" button in row actions**
   - iOS: Swipe left to reveal
   - macOS: Right-click context menu
   - Optional - only appears if provided

4. **`onItemDeleted: ((Item) -> Void)?`** - Called when user wants to delete an item
   - **Automatically appears as "Delete" button in row actions**
   - iOS: Swipe left to reveal (destructive action)
   - macOS: Right-click context menu (destructive action)
   - Optional - only appears if provided

### **Automatic Row Actions**

When `onItemEdited` or `onItemDeleted` callbacks are provided, the framework automatically:
- Adds appropriate row actions using `platformRowActions_L4()`
- Adapts to platform conventions:
  - **iOS**: Swipe actions (swipe left/right to reveal)
  - **macOS**: Context menu (right-click to reveal)
- Uses consistent styling and icons
- Handles accessibility automatically

**Example:**
```swift
// Only Edit callback - only Edit button appears
platformPresentItemCollection_L1(
    items: items,
    hints: hints,
    onItemEdited: { item in editItem(item) }
)

// Only Delete callback - only Delete button appears
platformPresentItemCollection_L1(
    items: items,
    hints: hints,
    onItemDeleted: { item in deleteItem(item) }
)

// Both callbacks - both buttons appear
platformPresentItemCollection_L1(
    items: items,
    hints: hints,
    onItemEdited: { item in editItem(item) },
    onItemDeleted: { item in deleteItem(item) }
)
```

### **Custom Actions with `customItemView`**

For actions beyond Edit/Delete, use the `customItemView` parameter:

```swift
platformPresentItemCollection_L1(
    items: vehicles,
    hints: hints,
    customItemView: { vehicle in
        // Your fully custom view with any actions you want
        HStack {
            Text(vehicle.name)
            Spacer()
            // Use platformRowActions_L4 for custom actions
            Button("Share") { shareVehicle(vehicle) }
                .platformRowActions_L4 {
                    PlatformRowActionButton(
                        title: "Share",
                        systemImage: "square.and.arrow.up",
                        action: { shareVehicle(vehicle) }
                    )
                    PlatformRowActionButton(
                        title: "Archive",
                        systemImage: "archivebox",
                        action: { archiveVehicle(vehicle) }
                    )
                }
        }
    }
)
```

**Trade-offs:**
- ✅ Full control over actions and layout
- ✅ Can add any number of custom actions
- ✅ Can customize item appearance
- ❌ More code required
- ❌ Must handle platform differences yourself (or use `platformRowActions_L4`)

## 🚀 Future Enhancements

- **More Form Types:** Additional specialized form types
- **Custom Intent Types:** User-defined intent types
- **Intent Validation:** Validate intent parameters before processing
- **Intent Chaining:** Chain multiple intents together

## 📚 Related Documentation

- **Architecture Overview:** [README_6LayerArchitecture.md](README_6LayerArchitecture.md)
- **Layer 2:** [README_Layer2_Decision.md](README_Layer2_Decision.md)
- **Layer 4:** [README_Layer4_Implementation.md](README_Layer4_Implementation.md)
- **Usage Examples:** [README_UsageExamples.md](README_UsageExamples.md)
