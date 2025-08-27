# Function Index (Immediate Children)

- **Directory**: ./Models/Expenses
- **Generated**: 2025-08-13 19:55:13 -0700
- **Script**: Scripts/generate_function_index.sh --children

This index lists function declarations found in this directory and its first-level subdirectories only.

---

## ./Models/Expenses
- L51: ` static func createDefaultCategories(in context: NSManagedObjectContext)`
- L96: ` static func ensure(in context: NSManagedObjectContext, named rawName: String) -> ExpenseCategory`
- L47: ` func matches(searchTerm: String) -> Bool`
- L54: ` func isInDateRange(from startDate: Date, to endDate: Date) -> Bool`
- L92: ` static func groupByMonth(expenses: [Expense]) -> [String: [Expense]]`
- L113: ` static func groupByCategory(expenses: [Expense]) -> [String: [Expense]]`
- L130: ` static func calculateTotal(expenses: [Expense]) -> Double`
- L135: ` static func calculateAverage(expenses: [Expense]) -> Double`
- L140: ` func templateFieldValue(for field: String) -> String?`
- L181: ` func recalculateNextDueFields()`

