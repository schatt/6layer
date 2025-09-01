import CoreData
import Foundation
import SwiftUI

extension Expense {
    var wrappedTitle: String {
        title ?? "Untitled"
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    var wrappedCategory: String {
        categoryObject?.name ?? "Uncategorized"
    }

    var wrappedLocation: String {
        // Note: Expense model doesn't have a location property, so we'll return empty string
        // If location is needed, it should be added to the Core Data model
        ""
    }

    var wrappedDate: Date {
        date ?? Date()
    }

    var expenseCategory: ExpenseCategory? {
        wrappedCategoryObject
    }

    var templateFieldValues: [String: String] {
        guard let notes = notes else { return [:] }
        var values: [String: String] = [:]
        let lines = notes.components(separatedBy: .newlines)
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            if parts.count == 2 {
                let field = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                values[field] = value
            }
        }
        return values
    }

    func matches(searchTerm: String) -> Bool {
        let term = searchTerm.lowercased()
        return (title?.lowercased().contains(term) ?? false) ||
               (notes?.lowercased().contains(term) ?? false) ||
               (wrappedCategory.lowercased().contains(term))
    }

    func isInDateRange(from startDate: Date, to endDate: Date) -> Bool {
        guard let expenseDate = date else { return false }
        return expenseDate >= startDate && expenseDate <= endDate
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    var formattedDate: String {
        guard let date = date else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var monthYear: String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    var dayMonthYear: String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }

    var wrappedCategoryObject: ExpenseCategory? {
        return categoryObject
    }

    // Helper method to get expenses grouped by month
    static func groupByMonth(expenses: [Expense]) -> [String: [Expense]] {
        var groupedExpenses: [String: [Expense]] = [:]

        for expense in expenses {
            guard let date = expense.date else { continue }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let monthKey = formatter.string(from: date)

            if groupedExpenses[monthKey] == nil {
                groupedExpenses[monthKey] = []
            }

            groupedExpenses[monthKey]?.append(expense)
        }

        return groupedExpenses
    }

    // Helper method to get expenses grouped by category
    static func groupByCategory(expenses: [Expense]) -> [String: [Expense]] {
        var groupedExpenses: [String: [Expense]] = [:]

        for expense in expenses {
            let categoryName = expense.wrappedCategory

            if groupedExpenses[categoryName] == nil {
                groupedExpenses[categoryName] = []
            }

            groupedExpenses[categoryName]?.append(expense)
        }

        return groupedExpenses
    }

    // Helper method to calculate total expenses
    static func calculateTotal(expenses: [Expense]) -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }

    // Helper method to calculate average expense
    static func calculateAverage(expenses: [Expense]) -> Double {
        guard !expenses.isEmpty else { return 0 }
        return calculateTotal(expenses: expenses) / Double(expenses.count)
    }

    func templateFieldValue(for field: String) -> String? {
        guard let notes = notes else { return nil }
        let lines = notes.components(separatedBy: .newlines)
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            if parts.count == 2 && parts[0].trimmingCharacters(in: .whitespaces) == field {
                return parts[1].trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }

    /// The next odometer reading at which this expense is due (if mileage-based)
    var nextDueOdometer: Double? {
        if lastCompletedOdometer != 0, recurrenceMileageInterval != 0 {
            return lastCompletedOdometer + recurrenceMileageInterval
        }
        return nil
    }

    /// The next date at which this expense is due (if time-based)
    var nextDueDateValue: Date? {
        // No nextDueDate property exists; return nil
        return nil
    }

    /// The next due event (date or odometer), whichever comes first
    var nextDueEvent: (date: Date?, odometer: Double?) {
        let date = nextDueDateValue
        let odo = nextDueOdometer
        switch (date, odo) {
        case (nil, nil): return (nil, nil)
        case (let d?, nil): return (d, nil)
        case (nil, let o?): return (nil, o)
        case (let d?, let o?):
            // If both are present, return the one that will be reached first is up to the business logic
            return (d, o)
        }
    }

    /// Recalculate any computed fields after import or update (currently a no-op, but provides a hook for future logic)
    func recalculateNextDueFields() {
        // No-op: nextDueOdometer and nextDueEvent are computed properties
        // Add logic here if you later need to persist or precompute anything
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let addExpense = Notification.Name("addExpense")
    static let expenseAdded = Notification.Name("expenseAdded")
    static let expenseUpdated = Notification.Name("expenseUpdated")
    static let expenseDeleted = Notification.Name("expenseDeleted")
}
