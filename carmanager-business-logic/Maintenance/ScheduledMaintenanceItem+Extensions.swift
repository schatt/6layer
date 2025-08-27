import CoreData
import Foundation

extension ScheduledMaintenanceItem {
    /// Returns the next due odometer reading, or nil if not set.
    var nextDueOdometer: Double? {
        if isOneTime {
            return targetMileage > 0 ? targetMileage : nil
        } else if intervalMiles > 0, lastPerformedOdometer > 0 {
            return lastPerformedOdometer + intervalMiles
        }
        return nil
    }

    /// Returns the next due date, or nil if not set.
    var nextDueDate: Date? {
        if isOneTime {
            return targetDate
        } else if intervalMonths > 0, let lastDate = lastPerformedDate {
            return Calendar.current.date(byAdding: .month, value: Int(intervalMonths), to: lastDate)
        }
        return nil
    }

    /// Predicts the next due date, considering both mileage and time intervals, and returns the sooner of the two.
    /// Requires the vehicle's current odometer and miles per day.
    func predictedDueDate(vehicle: Vehicle) -> Date? {
        let now = Date()
        if isOneTime {
            if let targetDate = targetDate {
                return targetDate
            } else if targetMileage > 0, vehicle.milesPerDay > 0 {
                let milesLeft = targetMileage - vehicle.currentOdometer
                if milesLeft > 0 {
                    let daysLeft = milesLeft / vehicle.milesPerDay
                    return Calendar.current.date(byAdding: .day, value: Int(ceil(daysLeft)), to: now)
                } else {
                    return now // Already due by mileage
                }
            }
            return nil
        } else {
            let dueByDate: Date? = nextDueDate
            var dueByOdometerDate: Date?
            if let nextOdo = nextDueOdometer, vehicle.milesPerDay > 0 {
                let milesLeft = nextOdo - vehicle.currentOdometer
                if milesLeft > 0 {
                    let daysLeft = milesLeft / vehicle.milesPerDay
                    dueByOdometerDate = Calendar.current.date(byAdding: .day, value: Int(ceil(daysLeft)), to: now)
                } else {
                    dueByOdometerDate = now // Already due by mileage
                }
            }
            // If both are available, return the sooner
            if let date1 = dueByDate, let date2 = dueByOdometerDate {
                return date1 < date2 ? date1 : date2
            } else {
                return dueByDate ?? dueByOdometerDate
            }
        }
    }

    /// Returns true if the maintenance is overdue (by date or mileage)
    func isOverdue(vehicle: Vehicle) -> Bool {
        let now = Date()
        if isOneTime {
            if targetMileage > 0, vehicle.currentOdometer >= targetMileage {
                return true
            }
            if let dueDate = targetDate, now >= dueDate {
                return true
            }
            return false
        } else {
            if let nextOdo = nextDueOdometer, vehicle.currentOdometer >= nextOdo {
                return true
            }
            if let dueDate = nextDueDate, now >= dueDate {
                return true
            }
            return false
        }
    }

    /// Returns a user-friendly summary of the next due maintenance
    func nextDueSummary(vehicle: Vehicle) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if isOneTime {
            let odoString = targetMileage > 0 ? "at \(Int(targetMileage)) mi" : nil
            let dateString = targetDate != nil ? "by \(formatter.string(from: targetDate!))" : nil
            let predicted = predictedDueDate(vehicle: vehicle)
            let predictedString = predicted != nil ? "(expected: \(formatter.string(from: predicted!)))" : nil
            return [odoString, dateString, predictedString].compactMap { $0 }.joined(separator: ", ")
        } else {
            let odoString = nextDueOdometer != nil ? "at \(Int(nextDueOdometer!)) mi" : nil
            let dateString = nextDueDate != nil ? "by \(formatter.string(from: nextDueDate!))" : nil
            let predicted = predictedDueDate(vehicle: vehicle)
            let predictedString = predicted != nil ? "(expected: \(formatter.string(from: predicted!)))" : nil
            return [odoString, dateString, predictedString].compactMap { $0 }.joined(separator: ", ")
        }
    }
}
