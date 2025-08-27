import CoreData
import Foundation
import SwiftUI

// MARK: - Coverage Limits Struct
struct CoverageLimits: Codable, Equatable {
    var liabilityBodilyInjury: Double?
    var liabilityPropertyDamage: Double?
    var collision: Double?
    var comprehensive: Double?
    var uninsuredMotorist: Double?
    var underinsuredMotorist: Double?
    var personalInjuryProtection: Double?
    var medicalPayments: Double?
    var other: [String: Double]?
}

extension InsurancePolicy {
    // MARK: - Wrapped Properties
    var wrappedProvider: String {
        provider?.name ?? "Unknown Provider"
    }
    var wrappedPolicyNumber: String {
        policyNumber ?? "Unknown"
    }
    var formattedCoverageStartDate: String {
        guard let date = coverageStartDate else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var formattedCoverageEndDate: String {
        guard let date = coverageEndDate else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var formattedRenewalDate: String {
        guard let date = renewalDate else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var formattedNextPaymentDate: String {
        guard let date = nextPaymentDate else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var formattedPaymentAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: paymentAmount)) ?? "$0.00"
    }
    var wrappedPaymentFrequency: String {
        paymentFrequency ?? "Unknown"
    }
    var wrappedPaymentInterval: Int {
        Int(paymentInterval)
    }
    // MARK: - Coverage Limits Serialization
    var coverageLimitsStruct: CoverageLimits? {
        guard let data = coverageLimits else { return nil }
        return try? JSONDecoder().decode(CoverageLimits.self, from: data)
    }
    func setCoverageLimits(_ limits: CoverageLimits) {
        coverageLimits = try? JSONEncoder().encode(limits)
    }
    // MARK: - Status
    var isActive: Bool {
        guard let end = coverageEndDate else { return false }
        return end > Date()
    }
    var daysUntilRenewal: Int {
        guard let renewal = renewalDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: renewal)
        return components.day ?? 0
    }
    var statusColor: Color {
        if !isActive {
            return Color.red
        } else if daysUntilRenewal < 30 {
            return Color.orange
        } else {
            return Color.green
        }
    }
    // MARK: - Insured Vehicles
    var insuredVehiclesArray: [Vehicle] {
        let set = insuredVehicles as? Set<Vehicle> ?? []
        return set.sorted { ($0.displayName) < ($1.displayName) }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let addInsurancePolicy = Notification.Name("addInsurancePolicy")
    static let insurancePolicyAdded = Notification.Name("insurancePolicyAdded")
    static let insurancePolicyUpdated = Notification.Name("insurancePolicyUpdated")
    static let insurancePolicyDeleted = Notification.Name("insurancePolicyDeleted")
}
