import CoreData
import Foundation
import SwiftUI

extension ExpenseCategory {
    var wrappedName: String {
        name ?? "Unnamed Category"
    }

    var wrappedIcon: String {
        icon ?? "tag.fill"
    }

    var wrappedColor: Color {
        guard let colorData = color,
              let colorName = try? JSONDecoder().decode(String.self, from: colorData) else { return .blue }

        switch colorName {
        case "backgroundColor": return Color.backgroundColor
        case "secondaryBackgroundColor": return Color.secondaryBackgroundColor
        case "tertiaryBackgroundColor": return Color.tertiaryBackgroundColor
        case "groupedBackgroundColor": return Color.groupedBackgroundColor
        case "secondaryGroupedBackgroundColor": return Color.secondaryGroupedBackgroundColor
        case "tertiaryGroupedBackgroundColor": return Color.tertiaryGroupedBackgroundColor
        case "foregroundColor": return Color.foregroundColor
        case "secondaryForegroundColor": return Color.secondaryForegroundColor
        case "tertiaryForegroundColor": return Color.tertiaryForegroundColor
        case "quaternaryForegroundColor": return Color.quaternaryForegroundColor
        case "placeholderForegroundColor": return Color.placeholderForegroundColor
        case "separatorColor": return Color.separatorColor
        case "linkColor": return Color.linkColor
        default:
            // Use a custom extension to resolve named colors, or fallback to .blue
            return Color.named(colorName) ?? .blue
        }
    }

    var expensesArray: [Expense] {
        let set = expenses as? Set<Expense> ?? []
        return Array(set)
    }

    var templateFieldsArray: [String] {
        if let fieldsData = templateFields,
           let fields = try? JSONDecoder().decode([String].self, from: fieldsData) {
            return fields
        }
        return []
    }

    static func createDefaultCategories(in context: NSManagedObjectContext) {
        let defaultCategories = [
            ("Fuel", "fuelpump.fill", "blue"),
            ("Maintenance", "wrench.fill", "orange"),
            ("Insurance", "shield.fill", "green"),
            ("Registration", "doc.text.fill", "purple"),
            ("Parking", "parkingsign", "red"),
            ("Tolls", "road.lanes", "yellow"),
            ("Other", "tag.fill", "gray")
        ]

        var didChange = false
        for (name, icon, colorName) in defaultCategories {
            // Case-insensitive lookup for existing category by name
            let req: NSFetchRequest<ExpenseCategory> = ExpenseCategory.fetchRequest()
            req.predicate = NSPredicate(format: "name ==[c] %@", name)
            req.fetchLimit = 1
            let existing = try? context.fetch(req).first

            if let category = existing {
                // Ensure canonical casing and default flag
                if category.name != name { category.name = name; didChange = true }
                if category.isDefault == false { category.isDefault = true; didChange = true }
                // Do not override user-customized icon/color if already set
                if category.icon == nil { category.icon = icon; didChange = true }
                if category.color == nil, let data = try? JSONEncoder().encode(colorName) { category.color = data; didChange = true }
            } else {
                let category = ExpenseCategory(context: context)
                category.id = UUID()
                category.name = name
                category.icon = icon
                category.isDefault = true
                if let colorData = try? JSONEncoder().encode(colorName) { category.color = colorData }
                didChange = true
            }
        }

        if didChange {
            do { try context.save() } catch { print("Error saving default categories: \(error)") }
        }
    }

    // Ensure a category exists for a given name (trimmed, case-insensitive match).
    // Returns the existing category or creates a new one.
    @discardableResult
    static func ensure(in context: NSManagedObjectContext, named rawName: String) -> ExpenseCategory {
        let normalizedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)

        // Try to find an existing category by case-insensitive name match
        let fetchRequest: NSFetchRequest<ExpenseCategory> = ExpenseCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", normalizedName)
        fetchRequest.fetchLimit = 1

        if let found = try? context.fetch(fetchRequest).first, let _ = found.name {
            // Update stored name to trimmed version for consistency
            if found.name != normalizedName {
                found.name = normalizedName
            }
            return found
        }

        // Create a new category if one doesn't already exist
        let category = ExpenseCategory(context: context)
        category.id = UUID()
        category.name = normalizedName
        return category
    }
}
