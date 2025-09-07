# Function Index

- **Directory**: ./Development/carmanager-business-logic/Expenses
- **Generated**: 2025-09-06 16:40:35 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## ./Development/carmanager-business-logic/Expenses/ExpenseCategory.swift
### Internal Methods
- **L51:** ` static func createDefaultCategories(in context: NSManagedObjectContext)`
  - *static function|extension ExpenseCategory*
- **L96:** ` static func ensure(in context: NSManagedObjectContext, named rawName: String) -> ExpenseCategory`
  - *static function*
- **L6:** ` var wrappedName: String`
  - *function|extension ExpenseCategory*
- **L10:** ` var wrappedIcon: String`
  - *function|extension ExpenseCategory*
- **L14:** ` var wrappedColor: Color`
  - *function|extension ExpenseCategory*
- **L38:** ` var expensesArray: [Expense]`
  - *function|extension ExpenseCategory*
- **L43:** ` var templateFieldsArray: [String]`
  - *function|extension ExpenseCategory*

## ./Development/carmanager-business-logic/Expenses/CostCategory.swift
### Internal Methods
- **L10:** ` init(name: String, amount: Double, color: Color = .accentColor)`
  - *function*

## ./Development/carmanager-business-logic/Expenses/Expense+Extensions.swift
### Internal Methods
- **L47:** ` func matches(searchTerm: String) -> Bool`
  - *function|extension Expense*
- **L54:** ` func isInDateRange(from startDate: Date, to endDate: Date) -> Bool`
  - *function|extension Expense*
- **L92:** ` static func groupByMonth(expenses: [Expense]) -> [String: [Expense]]`
  - *static function*
- **L113:** ` static func groupByCategory(expenses: [Expense]) -> [String: [Expense]]`
  - *static function*
- **L130:** ` static func calculateTotal(expenses: [Expense]) -> Double`
  - *static function*
- **L135:** ` static func calculateAverage(expenses: [Expense]) -> Double`
  - *static function*
- **L140:** ` func templateFieldValue(for field: String) -> String?`
  - *function*
- **L181:** ` func recalculateNextDueFields()`
  - *function*
  - *Recalculate any computed fields after import or update (currently a no-op, but provides a hook for future logic)\n*
- **L6:** ` var wrappedTitle: String`
  - *function|extension Expense*
- **L10:** ` var wrappedNotes: String`
  - *function|extension Expense*
- **L14:** ` var wrappedCategory: String`
  - *function|extension Expense*
- **L18:** ` var wrappedLocation: String`
  - *function|extension Expense*
- **L24:** ` var wrappedDate: Date`
  - *function|extension Expense*
- **L28:** ` var expenseCategory: ExpenseCategory?`
  - *function|extension Expense*
- **L32:** ` var templateFieldValues: [String: String]`
  - *function|extension Expense*
- **L59:** ` var formattedAmount: String`
  - *function*
- **L66:** ` var formattedDate: String`
  - *function*
- **L73:** ` var monthYear: String`
  - *function*
- **L80:** ` var dayMonthYear: String`
  - *function*
- **L87:** ` var wrappedCategoryObject: ExpenseCategory?`
  - *function*
- **L153:** ` var nextDueOdometer: Double?`
  - *function*
  - *The next odometer reading at which this expense is due (if mileage-based)\n*
- **L161:** ` var nextDueDateValue: Date?`
  - *function*
  - *The next date at which this expense is due (if time-based)\n*
- **L167:** ` var nextDueEvent: (date: Date?, odometer: Double?)`
  - *function*
  - *The next due event (date or odometer), whichever comes first\n*

