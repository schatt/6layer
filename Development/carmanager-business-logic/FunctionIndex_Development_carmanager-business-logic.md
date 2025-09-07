# Function Index

- **Directory**: ./Development/carmanager-business-logic
- **Generated**: 2025-09-06 16:19:20 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## ./Development/carmanager-business-logic/PaymentTypes.swift
### Public Interface
- **L199:** ` public static func calculateMonthlyPayment(principal: Double, annualRate: Double, termMonths: Int) -> Double`
  - *static function*
  - *Calculate monthly payment for a loan using the standard amortization formula\n- Parameters:\n- principal: The loan amount\n- annualRate: Annual interest rate as a decimal (e.g., 0.05 for 5%)\n- termMonths: Loan term in months\n- Returns: Monthly payment amount\n*
- **L220:** ` public static func calculateRemainingBalance(principal: Double, annualRate: Double, termMonths: Int, paymentsMade: Int) -> Double`
  - *static function*
  - *Calculate remaining balance after a certain number of payments\n- Parameters:\n- principal: Original loan amount\n- annualRate: Annual interest rate as a decimal\n- termMonths: Total loan term in months\n- paymentsMade: Number of payments already made\n- Returns: Remaining balance\n*
- **L241:** ` public static func calculateTotalInterest(principal: Double, annualRate: Double, termMonths: Int) -> Double`
  - *static function*
  - *Calculate total interest paid over the life of the loan\n- Parameters:\n- principal: Loan amount\n- annualRate: Annual interest rate as a decimal\n- termMonths: Loan term in months\n- Returns: Total interest paid\n*
- **L254:** ` public static func calculateEarlyPayoffSavings(principal: Double, annualRate: Double, remainingMonths: Int, earlyPayoffMonths: Int) -> Double`
  - *static function*
  - *Calculate early payoff savings\n- Parameters:\n- principal: Current remaining balance\n- annualRate: Annual interest rate as a decimal\n- remainingMonths: Remaining months on the loan\n- earlyPayoffMonths: Months to pay off early\n- Returns: Interest savings from early payoff\n*
- **L267:** ` public static func validatePaymentTerms(loanAmount: Double, downPayment: Double, interestRate: Double, termMonths: Int) -> [String]`
  - *static function*
  - *Validate payment terms\n- Parameter terms: Payment terms to validate\n- Returns: Array of validation errors\n*
- **L304:** ` public static func validatePaymentSchedule(startDate: Date, endDate: Date?, frequency: PaymentFrequency, paymentAmount: Double) -> [String]`
  - *static function*
  - *Validate payment schedule\n- Parameter schedule: Payment schedule to validate\n- Returns: Array of validation errors\n*
- **L330:** ` public static func validatePaymentProvider(name: String, type: ProviderType, phone: String?, email: String?, website: String?) -> [String]`
  - *static function*
  - *Validate payment provider\n- Parameters:\n- name: Provider name\n- type: Provider type\n- phone: Phone number (optional)\n- email: Email address (optional)\n- website: Website URL (optional)\n- Returns: Array of validation errors\n*
- **L376:** ` public static func validatePaymentTransaction(amount: Double, paymentMethod: PaymentMethod, paymentDate: Date?, dueDate: Date?) -> [String]`
  - *static function*
  - *Validate payment transaction\n- Parameters:\n- amount: Transaction amount\n- paymentMethod: Payment method used\n- paymentDate: Date payment was made (optional)\n- dueDate: Date payment is due (optional)\n- Returns: Array of validation errors\n*
- **L421:** ` public static func validateStoredPaymentMethod(`
  - *static function*
  - *Validate stored payment method\n- Parameters:\n- name: Payment method name\n- type: Payment method type\n- accountNumber: Account number (for ACH)\n- routingNumber: Routing number (for ACH)\n- cardLastFour: Last four digits of card (for credit/debit cards)\n- expirationDate: Card expiration date (for credit/debit cards)\n- processingFee: Processing fee amount\n- processingTimeDays: Processing time in days\n- Returns: Array of validation errors\n*
- **L518:** ` public static func validateInterestRate(`
  - *static function*
  - *Validate interest rate\n- Parameters:\n- rate: Interest rate as a percentage\n- rateType: Type of interest rate\n- effectiveDate: Date the rate becomes effective\n- source: Source of the rate information (optional)\n- Returns: Array of validation errors\n*
- **L9:** ` public var displayName: String`
  - *function*
- **L20:** ` public var description: String`
  - *function*
- **L41:** ` public var displayName: String`
  - *function*
- **L58:** ` public var daysBetweenPayments: Int`
  - *function*
- **L75:** ` public var paymentsPerYear: Int`
  - *function*
- **L93:** ` public var isCalendarBased: Bool`
  - *function*
  - *Whether this frequency uses calendar-based calculations (same date each period)\n*
- **L113:** ` public var displayName: String`
  - *function*
- **L117:** ` public var isElectronic: Bool`
  - *function*
- **L136:** ` public var displayName: String`
  - *function*
- **L153:** ` public var isActive: Bool`
  - *function*
- **L172:** ` public var displayName: String`
  - *function*

## ./Development/carmanager-business-logic/SharedTypes.swift
### Internal Methods
- **L15:** ` func hash(into hasher: inout Hasher)`
  - *function*
- **L49:** ` func dateRange() -> (Date, Date)?`
  - *function*
- **L31:** ` var sortDescriptor: NSSortDescriptor`
  - *function*
- **L107:** ` var body: some View`
  - *function*
- **L10:** ` init(name: String, value: String)`
  - *function*
- **L102:** ` init(searchText: Binding<String>, placeholder: String)`
  - *function*

