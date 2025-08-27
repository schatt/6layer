import Foundation
import SwiftUI

// MARK: - Filter Types
struct FilterOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Sort Types
struct SortOption: Identifiable {
    let id = UUID()
    let name: String
    let keyPath: String
    var ascending: Bool = true

    var sortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: keyPath, ascending: ascending)
    }
}

// MARK: - Date Range Types
enum DateRangePreset: String, CaseIterable {
    case all = "All Time"
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This Week"
    case lastWeek = "Last Week"
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    case thisYear = "This Year"
    case lastYear = "Last Year"
    case custom = "Custom Range"

    func dateRange() -> (Date, Date)? {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .all:
            return nil
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return nil }
            return (startOfDay, endOfDay)
        case .yesterday:
            guard let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now)),
                  let endOfYesterday = calendar.date(byAdding: .day, value: 1, to: startOfYesterday) else { return nil }
            return (startOfYesterday, endOfYesterday)
        case .thisWeek:
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
                  let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek) else { return nil }
            return (startOfWeek, endOfWeek)
        case .lastWeek:
            guard let startOfThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
                  let startOfLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: startOfThisWeek) else { return nil }
            let endOfLastWeek = startOfThisWeek
            return (startOfLastWeek, endOfLastWeek)
        case .thisMonth:
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
                  let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else { return nil }
            return (startOfMonth, endOfMonth)
        case .lastMonth:
            guard let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
                  let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfThisMonth) else { return nil }
            let endOfLastMonth = startOfThisMonth
            return (startOfLastMonth, endOfLastMonth)
        case .thisYear:
            guard let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now)),
                  let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear) else { return nil }
            return (startOfYear, endOfYear)
        case .lastYear:
            guard let startOfThisYear = calendar.date(from: calendar.dateComponents([.year], from: now)),
                  let startOfLastYear = calendar.date(byAdding: .year, value: -1, to: startOfThisYear) else { return nil }
            let endOfLastYear = startOfThisYear
            return (startOfLastYear, endOfLastYear)
        case .custom:
            return nil
        }
    }
}

// MARK: - Layout Types
struct SearchBar: View {
    @Binding var searchText: String
    let placeholder: String

    init(searchText: Binding<String>, placeholder: String) {
        self._searchText = searchText
        self.placeholder = placeholder
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16, weight: .medium))

            TextField(placeholder, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.secondarySystemBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
