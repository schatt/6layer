import SwiftUI
import CoreData

// MARK: - Vehicle Selection Helper (platform independent)
@MainActor
struct VehicleSelectionHelper {
    let vehicles: [Vehicle]
    let selectedVehicle: Vehicle?
    let onAddVehicle: () -> Void
    let onVehicleSelected: (Vehicle) -> Void
    let onShowVehiclePicker: () -> Void

    func handleVehicleSelection() {
        if vehicles.isEmpty {
            onAddVehicle()
        } else if let selected = selectedVehicle {
            onVehicleSelected(selected)
        } else {
            onShowVehiclePicker()
        }
    }

    // Presents a simple vehicle picker UI inside a navigation container
    @ViewBuilder
    static func createVehiclePickerView(
        vehicles: [Vehicle],
        selectedVehicleId: UUID?,
        onVehicleSelected: @escaping (Vehicle) -> Void,
        onCancel: @escaping () -> Void
    ) -> some View {
        // Use platformNavigationContainer as a View modifier to remain platform independent
        EmptyView().platformNavigationContainer {
            if vehicles.isEmpty {
                platformVStackContainer(spacing: 12) {
                    Image(systemName: "car")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Vehicles Found")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                platformListContainer {
                    ForEach(vehicles, id: \.__managedObjectID) { vehicle in
                        Button(action: { onVehicleSelected(vehicle) }) {
                            HStack {
                                Image(systemName: "car.fill")
                                    .foregroundColor(.accentColor)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(vehicle.displayName)
                                        .font(.body)
                                    if let vid = vehicle.id, let sel = selectedVehicleId, vid == sel {
                                        Text("Currently Selected")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                if let vid = vehicle.id, let sel = selectedVehicleId, vid == sel {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .platformNavigationTitle("Select Vehicle")
        .platformNavigationTitleDisplayMode(.inline)
        .platformToolbarWithCancellationAction(
            cancellationAction: onCancel,
            cancellationTitle: "Cancel"
        )
        .platformFrame(minWidth: 820, minHeight: 640)
    }
}

// MARK: - Core Data helper for ForEach id
private extension NSManagedObject {
    /// Stable identity for Core Data objects in lists
    var __managedObjectID: NSManagedObjectID { objectID }
}


