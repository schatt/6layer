# Bug Report: Empty State Add Button Not Displaying

## Summary
The empty state for the vehicle collection is not displaying an "Add Vehicle" button despite providing an onCreateItem callback to platformPresentItemCollection_L1.

## Expected Behavior
When the vehicle collection is empty, the empty state should display:
- Custom empty message: "No vehicles added yet. Add your first vehicle to start tracking maintenance, expenses, and fuel records."
- An "Add Vehicle" button that calls the provided onCreateItem callback

## Actual Behavior
The empty state displays:
- Generic message: "No navigation items available. Consider organizing your content."
- No "Add Vehicle" button
- Debug output shows: onCreateItem is nil, dataType = generic, context = navigation

## Root Cause Analysis
The framework is receiving different hints than what the createVehiclePresentationHints() function returns:

Expected Hints:
- dataType: .collection
- context: .browse
- customMessage: "No vehicles added yet..."

Actual Hints Received:
- dataType: .generic
- context: .navigation
- customMessage: nil

## Code Evidence

Correct Implementation:
```swift
// Main view call (lines 93-100)
platformPresentItemCollection_L1(
    items: Array(filteredVehicles),
    hints: createVehiclePresentationHints(), // Returns correct hints
    onCreateItem: {
        onAddVehicle()
    }
)
```

Problematic Implementation:
```swift
// VehicleListItem call (lines 470-473)
platformPresentItemCollection_L1(
    items: [vehicle],
    hints: enhancedHints, // Different hints!
    // Missing: onCreateItem parameter
)
```

## Potential Causes
1. Hints Override: The VehicleListItem call might be overriding the main view's hints
2. Framework Bug: The framework might be modifying hints internally
3. Version Mismatch: Using a version that doesn't support onCreateItem parameter
4. Multiple Function Calls: Conflicting calls to the same function

## Debug Information
- Framework Version: 2.9.0
- Debug output shows hints are being overridden between creation and framework receipt
- onCreateItem parameter is being lost somewhere in the call chain

## Steps to Reproduce
1. Open the app
2. Navigate to the Vehicles view
3. Ensure no vehicles are present (empty collection)
4. Observe the empty state display

## Workaround
The toolbar "Add Vehicle" button still works as a temporary solution.

## Priority
High - Core functionality for adding vehicles is not accessible through the empty state.

## Suggested Fix
1. Investigate why hints are being overridden
2. Ensure onCreateItem parameter is properly passed through
3. Fix the VehicleListItem call to not interfere with the main view
4. Verify framework version compatibility

