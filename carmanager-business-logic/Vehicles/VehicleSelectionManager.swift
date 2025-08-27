import CoreData
import Foundation
import SwiftUI

@MainActor
final class VehicleSelectionManager: ObservableObject {
    static let shared = VehicleSelectionManager()

    @Published public var selectedVehicleId: UUID? {
        didSet {
            if let id = selectedVehicleId {
                UserDefaults.standard.set(id.uuidString, forKey: "selectedVehicleId")
            } else {
                UserDefaults.standard.removeObject(forKey: "selectedVehicleId")
            }
        }
    }

    private init() {
        // Load the saved vehicle ID on initialization
        if let savedId = UserDefaults.standard.string(forKey: "selectedVehicleId"),
           let uuid = UUID(uuidString: savedId) {
            selectedVehicleId = uuid
        } else {
            selectedVehicleId = nil // Explicitly ensure no selection by default
        }

        // Add observer for vehicle deletion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleVehicleDeleted),
            name: .vehicleDeleted,
            object: nil
        )
    }

    @objc private func handleVehicleDeleted(_ notification: Notification) {
        if let deletedVehicle = notification.object as? Vehicle,
           deletedVehicle.id == selectedVehicleId {
            clearSelection()
        }
    }

    public func selectVehicle(_ vehicle: Vehicle) {
        selectedVehicleId = vehicle.id
        NotificationCenter.default.post(name: .vehicleSelected, object: vehicle)
    }

    public func clearSelection() {
        selectedVehicleId = nil
        NotificationCenter.default.post(name: .vehicleSelected, object: nil)
    }

    public func getSelectedVehicle(in context: NSManagedObjectContext) -> Vehicle? {
        guard let id = selectedVehicleId else { return nil }

        let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching selected vehicle: \(error)")
            return nil
        }
    }
}
