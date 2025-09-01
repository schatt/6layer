import CoreData
import Foundation
import Combine

/// Manages debounced MPG calculations for fuel purchases to improve performance
/// when multiple fuel purchases are added or updated in quick succession.
@MainActor
final class FuelPurchaseMPGManager: ObservableObject, Sendable {
    static let shared = FuelPurchaseMPGManager()
    
    private let debouncer: Debouncer
    private let debounceInterval: TimeInterval = 2.0 // 2 second debounce
    
    private init() {
        self.debouncer = Debouncer(interval: debounceInterval)
    }
    
    /// Triggers a debounced MPG calculation for all fuel purchases of a vehicle
    /// - Parameter vehicle: The vehicle whose fuel purchases should be recalculated
    /// - Parameter context: The Core Data context to use for calculations
    /// - Parameter immediate: If true, performs calculation immediately instead of debouncing
    func debouncedRecalculateMPG(for vehicle: Vehicle, in context: NSManagedObjectContext, immediate: Bool = false) {
        if immediate {
            performMPGCalculationImmediate(for: vehicle, in: context)
        } else {
            debouncer.call { [weak self] in
                self?.performMPGCalculation(for: vehicle, in: context)
            }
        }
    }
    
    /// Triggers a debounced MPG calculation for all fuel purchases in the context
    /// - Parameter context: The Core Data context to use for calculations
    /// - Parameter immediate: If true, performs calculation immediately instead of debouncing
    func debouncedRecalculateAllMPG(in context: NSManagedObjectContext, immediate: Bool = false) {
        if immediate {
            performAllMPGCalculationImmediate(in: context)
        } else {
            debouncer.call { [weak self] in
                self?.performAllMPGCalculation(in: context)
            }
        }
    }
    
    /// Immediately performs MPG calculation for all fuel purchases of a vehicle (synchronous)
    /// - Parameter vehicle: The vehicle whose fuel purchases should be recalculated
    /// - Parameter context: The Core Data context to use for calculations
    private func performMPGCalculationImmediate(for vehicle: Vehicle, in context: NSManagedObjectContext) {
        // Ensure we're on the correct queue for this context
        if context.concurrencyType == .mainQueueConcurrencyType {
            // For main queue contexts, we can save directly
            let fuelPurchases = vehicle.fuelPurchasesArray
                .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
            
            for fuelPurchase in fuelPurchases {
                fuelPurchase.recalculateMPG()
            }
            
            // Update vehicle's modification date to trigger UI updates
            vehicle.modificationDate = Date()
            
            do {
                try context.save()
                print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases (immediate)")
            } catch {
                print("[MPG Manager] Error saving MPG calculations: \(error)")
            }
        } else {
            // For private queue contexts, we need to perform on the context's queue
            context.performAndWait {
                let fuelPurchases = vehicle.fuelPurchasesArray
                    .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
                
                for fuelPurchase in fuelPurchases {
                    fuelPurchase.recalculateMPG()
                }
                
                // Update vehicle's modification date to trigger UI updates
                vehicle.modificationDate = Date()
                
                do {
                    try context.save()
                    print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases (immediate)")
                } catch {
                    print("[MPG Manager] Error saving MPG calculations: \(error)")
                }
            }
        }
    }
    
    /// Immediately performs MPG calculation for all fuel purchases of a vehicle (asynchronous)
    /// - Parameter vehicle: The vehicle whose fuel purchases should be recalculated
    /// - Parameter context: The Core Data context to use for calculations
    private func performMPGCalculation(for vehicle: Vehicle, in context: NSManagedObjectContext) {
        context.perform {
            let fuelPurchases = vehicle.fuelPurchasesArray
                .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
            
            for fuelPurchase in fuelPurchases {
                fuelPurchase.recalculateMPG()
            }
            
            // Update vehicle's modification date to trigger UI updates
            vehicle.modificationDate = Date()
            
            do {
                try context.save()
                print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases")
            } catch {
                print("[MPG Manager] Error saving MPG calculations: \(error)")
            }
        }
    }
    
    /// Immediately performs MPG calculation for all fuel purchases in the context (synchronous)
    /// - Parameter context: The Core Data context to use for calculations
    private func performAllMPGCalculationImmediate(in context: NSManagedObjectContext) {
        // Ensure we're on the correct queue for this context
        if context.concurrencyType == .mainQueueConcurrencyType {
            // For main queue contexts, we can save directly
            let fetchRequest: NSFetchRequest<FuelPurchase> = FuelPurchase.fetchRequest()
            
            do {
                let fuelPurchases = try context.fetch(fetchRequest)
                let vehicles = Set(fuelPurchases.compactMap { $0.vehicle })
                
                // Group fuel purchases by vehicle and sort by date
                for vehicle in vehicles {
                    let vehicleFuelPurchases = fuelPurchases
                        .filter { $0.vehicle == vehicle }
                        .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
                    
                    for fuelPurchase in vehicleFuelPurchases {
                        fuelPurchase.recalculateMPG()
                    }
                    
                    // Update vehicle's modification date to trigger UI updates
                    vehicle.modificationDate = Date()
                }
                
                try context.save()
                print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases across \(vehicles.count) vehicles (immediate)")
                NotificationCenter.default.post(name: .mpgRecalcCompleted, object: nil, userInfo: [
                    "fuelCount": fuelPurchases.count,
                    "vehicleCount": vehicles.count
                ])
            } catch {
                print("[MPG Manager] Error fetching or saving fuel purchases: \(error)")
            }
        } else {
            // For private queue contexts, we need to perform on the context's queue
            context.performAndWait {
                let fetchRequest: NSFetchRequest<FuelPurchase> = FuelPurchase.fetchRequest()
                
                do {
                    let fuelPurchases = try context.fetch(fetchRequest)
                    let vehicles = Set(fuelPurchases.compactMap { $0.vehicle })
                    
                    // Group fuel purchases by vehicle and sort by date
                    for vehicle in vehicles {
                        let vehicleFuelPurchases = fuelPurchases
                            .filter { $0.vehicle == vehicle }
                            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
                        
                        for fuelPurchase in vehicleFuelPurchases {
                            fuelPurchase.recalculateMPG()
                        }
                        
                        // Update vehicle's modification date to trigger UI updates
                        vehicle.modificationDate = Date()
                    }
                    
                    try context.save()
                    print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases across \(vehicles.count) vehicles (immediate)")
                } catch {
                    print("[MPG Manager] Error fetching or saving fuel purchases: \(error)")
                }
            }
        }
    }
    
    /// Immediately performs MPG calculation for all fuel purchases in the context (asynchronous)
    /// - Parameter context: The Core Data context to use for calculations
    private func performAllMPGCalculation(in context: NSManagedObjectContext) {
        context.perform {
            let fetchRequest: NSFetchRequest<FuelPurchase> = FuelPurchase.fetchRequest()
            
            do {
                let fuelPurchases = try context.fetch(fetchRequest)
                let vehicles = Set(fuelPurchases.compactMap { $0.vehicle })
                
                // Group fuel purchases by vehicle and sort by date
                for vehicle in vehicles {
                    let vehicleFuelPurchases = fuelPurchases
                        .filter { $0.vehicle == vehicle }
                        .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
                    
                    for fuelPurchase in vehicleFuelPurchases {
                        fuelPurchase.recalculateMPG()
                    }
                    
                    // Update vehicle's modification date to trigger UI updates
                    vehicle.modificationDate = Date()
                }
                
                try context.save()
                print("[MPG Manager] Successfully recalculated MPG for \(fuelPurchases.count) fuel purchases across \(vehicles.count) vehicles")
                NotificationCenter.default.post(name: .mpgRecalcCompleted, object: nil, userInfo: [
                    "fuelCount": fuelPurchases.count,
                    "vehicleCount": vehicles.count
                ])
            } catch {
                print("[MPG Manager] Error fetching or saving fuel purchases: \(error)")
            }
        }
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let mpgRecalcCompleted = Notification.Name("mpgRecalcCompleted")
}

// MARK: - Convenience Extensions
extension FuelPurchase {
    /// Triggers a debounced MPG calculation for this fuel purchase's vehicle
    /// - Parameter immediate: If true, performs calculation immediately instead of debouncing
    @MainActor
    func triggerDebouncedMPGCalculation(immediate: Bool = false) {
        guard let vehicle = self.vehicle,
              let context = self.managedObjectContext else { return }
        
        // Since FuelPurchaseMPGManager is @MainActor, we can call it directly
        FuelPurchaseMPGManager.shared.debouncedRecalculateMPG(for: vehicle, in: context, immediate: immediate)
    }
}

extension Vehicle {
    /// Triggers a debounced MPG calculation for all fuel purchases of this vehicle
    /// - Parameter immediate: If true, performs calculation immediately instead of debouncing
    @MainActor
    func triggerDebouncedMPGCalculation(immediate: Bool = false) {
        guard let context = self.managedObjectContext else { return }
        
        // Since FuelPurchaseMPGManager is @MainActor, we can call it directly
        FuelPurchaseMPGManager.shared.debouncedRecalculateMPG(for: self, in: context, immediate: immediate)
    }
} 