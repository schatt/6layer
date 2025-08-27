import Foundation

// MARK: - Payment Type Enumeration
public enum PaymentType: String, CaseIterable, Codable {
    case loan = "loan"
    case lease = "lease"
    case cash = "cash"
    
    public var displayName: String {
        switch self {
        case .loan:
            return "Loan/Mortgage"
        case .lease:
            return "Lease"
        case .cash:
            return "Cash Purchase"
        }
    }
    
    public var description: String {
        switch self {
        case .loan:
            return "Traditional auto loan with monthly payments"
        case .lease:
            return "Vehicle lease with monthly payments and end-of-lease options"
        case .cash:
            return "Full cash purchase with no financing"
        }
    }
}

// MARK: - Payment Frequency Enumeration
public enum PaymentFrequency: String, CaseIterable, Codable {
    case weekly = "weekly"
    case biweekly = "biweekly"
    case monthly = "monthly"
    case every30Days = "every30Days"
    case quarterly = "quarterly"
    case annually = "annually"
    
    public var displayName: String {
        switch self {
        case .weekly:
            return "Weekly"
        case .biweekly:
            return "Bi-weekly"
        case .monthly:
            return "Monthly (same date)"
        case .every30Days:
            return "Every 30 days"
        case .quarterly:
            return "Quarterly"
        case .annually:
            return "Annually"
        }
    }
    
    public var daysBetweenPayments: Int {
        switch self {
        case .weekly:
            return 7
        case .biweekly:
            return 14
        case .monthly:
            return 30 // Approximate for calculations
        case .every30Days:
            return 30
        case .quarterly:
            return 90
        case .annually:
            return 365
        }
    }
    
    public var paymentsPerYear: Int {
        switch self {
        case .weekly:
            return 52
        case .biweekly:
            return 26
        case .monthly:
            return 12
        case .every30Days:
            return 12 // Approximately
        case .quarterly:
            return 4
        case .annually:
            return 1
        }
    }
    
    /// Whether this frequency uses calendar-based calculations (same date each period)
    public var isCalendarBased: Bool {
        switch self {
        case .weekly, .biweekly, .every30Days:
            return false
        case .monthly, .quarterly, .annually:
            return true
        }
    }
}

// MARK: - Payment Method Enumeration
public enum PaymentMethod: String, CaseIterable, Codable {
    case ach = "ACH"
    case check = "Check"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case cash = "Cash"
    case wireTransfer = "Wire Transfer"
    case other = "Other"
    
    public var displayName: String {
        return rawValue
    }
    
    public var isElectronic: Bool {
        switch self {
        case .ach, .creditCard, .debitCard, .wireTransfer:
            return true
        case .check, .cash, .other:
            return false
        }
    }
}

// MARK: - Payment Status Enumeration
public enum PaymentStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case completed = "completed"
    case failed = "failed"
    case refunded = "refunded"
    case late = "late"
    case overdue = "overdue"
    
    public var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .completed:
            return "Completed"
        case .failed:
            return "Failed"
        case .refunded:
            return "Refunded"
        case .late:
            return "Late"
        case .overdue:
            return "Overdue"
        }
    }
    
    public var isActive: Bool {
        switch self {
        case .pending, .late, .overdue:
            return true
        case .completed, .failed, .refunded:
            return false
        }
    }
}

// MARK: - Provider Type Enumeration
public enum ProviderType: String, CaseIterable, Codable {
    case lender = "lender"
    case dealership = "dealership"
    case bank = "bank"
    case creditUnion = "creditUnion"
    case onlineLender = "onlineLender"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .lender:
            return "Lender"
        case .dealership:
            return "Dealership"
        case .bank:
            return "Bank"
        case .creditUnion:
            return "Credit Union"
        case .onlineLender:
            return "Online Lender"
        case .other:
            return "Other"
        }
    }
}

// MARK: - Payment Calculation Utilities
public struct PaymentCalculator {
    
    /// Calculate monthly payment for a loan using the standard amortization formula
    /// - Parameters:
    ///   - principal: The loan amount
    ///   - annualRate: Annual interest rate as a decimal (e.g., 0.05 for 5%)
    ///   - termMonths: Loan term in months
    /// - Returns: Monthly payment amount
    public static func calculateMonthlyPayment(principal: Double, annualRate: Double, termMonths: Int) -> Double {
        guard principal > 0, annualRate >= 0, termMonths > 0 else { return 0 }
        
        let monthlyRate = annualRate / 12.0
        let numberOfPayments = Double(termMonths)
        
        if monthlyRate == 0 {
            return principal / numberOfPayments
        }
        
        let payment = principal * (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) / (pow(1 + monthlyRate, numberOfPayments) - 1)
        return payment
    }
    
    /// Calculate remaining balance after a certain number of payments
    /// - Parameters:
    ///   - principal: Original loan amount
    ///   - annualRate: Annual interest rate as a decimal
    ///   - termMonths: Total loan term in months
    ///   - paymentsMade: Number of payments already made
    /// - Returns: Remaining balance
    public static func calculateRemainingBalance(principal: Double, annualRate: Double, termMonths: Int, paymentsMade: Int) -> Double {
        guard principal > 0, annualRate >= 0, termMonths > 0, paymentsMade >= 0, paymentsMade <= termMonths else { return 0 }
        
        let monthlyRate = annualRate / 12.0
        let numberOfPayments = Double(termMonths)
        let paymentsCompleted = Double(paymentsMade)
        
        if monthlyRate == 0 {
            return principal * (1 - paymentsCompleted / numberOfPayments)
        }
        
        let remainingBalance = principal * (pow(1 + monthlyRate, numberOfPayments) - pow(1 + monthlyRate, paymentsCompleted)) / (pow(1 + monthlyRate, numberOfPayments) - 1)
        return max(0, remainingBalance)
    }
    
    /// Calculate total interest paid over the life of the loan
    /// - Parameters:
    ///   - principal: Loan amount
    ///   - annualRate: Annual interest rate as a decimal
    ///   - termMonths: Loan term in months
    /// - Returns: Total interest paid
    public static func calculateTotalInterest(principal: Double, annualRate: Double, termMonths: Int) -> Double {
        let monthlyPayment = calculateMonthlyPayment(principal: principal, annualRate: annualRate, termMonths: termMonths)
        let totalPayments = monthlyPayment * Double(termMonths)
        return totalPayments - principal
    }
    
    /// Calculate early payoff savings
    /// - Parameters:
    ///   - principal: Current remaining balance
    ///   - annualRate: Annual interest rate as a decimal
    ///   - remainingMonths: Remaining months on the loan
    ///   - earlyPayoffMonths: Months to pay off early
    /// - Returns: Interest savings from early payoff
    public static func calculateEarlyPayoffSavings(principal: Double, annualRate: Double, remainingMonths: Int, earlyPayoffMonths: Int) -> Double {
        let normalInterest = calculateTotalInterest(principal: principal, annualRate: annualRate, termMonths: remainingMonths)
        let earlyInterest = calculateTotalInterest(principal: principal, annualRate: annualRate, termMonths: earlyPayoffMonths)
        return normalInterest - earlyInterest
    }
}

// MARK: - Payment Validation
public struct PaymentValidator {
    
    /// Validate payment terms
    /// - Parameter terms: Payment terms to validate
    /// - Returns: Array of validation errors
    public static func validatePaymentTerms(loanAmount: Double, downPayment: Double, interestRate: Double, termMonths: Int) -> [String] {
        var errors: [String] = []
        
        if loanAmount <= 0 {
            errors.append("Loan amount must be greater than zero")
        }
        
        if downPayment < 0 {
            errors.append("Down payment cannot be negative")
        }
        
        if downPayment >= loanAmount {
            errors.append("Down payment cannot exceed loan amount")
        }
        
        if interestRate < 0 {
            errors.append("Interest rate cannot be negative")
        }
        
        if interestRate > 1.0 {
            errors.append("Interest rate appears to be in percentage format (should be decimal)")
        }
        
        if termMonths <= 0 {
            errors.append("Loan term must be greater than zero")
        }
        
        if termMonths > 84 { // 7 years
            errors.append("Loan term cannot exceed 84 months (7 years)")
        }
        
        return errors
    }
    
    /// Validate payment schedule
    /// - Parameter schedule: Payment schedule to validate
    /// - Returns: Array of validation errors
    public static func validatePaymentSchedule(startDate: Date, endDate: Date?, frequency: PaymentFrequency, paymentAmount: Double) -> [String] {
        var errors: [String] = []
        
        if startDate > Date() {
            errors.append("Start date cannot be in the future")
        }
        
        if let endDate = endDate, startDate >= endDate {
            errors.append("End date must be after start date")
        }
        
        if paymentAmount <= 0 {
            errors.append("Payment amount must be greater than zero")
        }
        
        return errors
    }
    
        /// Validate payment provider
    /// - Parameters:
    ///   - name: Provider name
    ///   - type: Provider type
    ///   - phone: Phone number (optional)
    ///   - email: Email address (optional)
    ///   - website: Website URL (optional)
    /// - Returns: Array of validation errors
    public static func validatePaymentProvider(name: String, type: ProviderType, phone: String?, email: String?, website: String?) -> [String] {
        var errors: [String] = []

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Provider name cannot be empty")
        }

        if name.count > 100 {
            errors.append("Provider name cannot exceed 100 characters")
        }

        if let phone = phone, !phone.isEmpty {
            // Basic phone validation - allows various formats
            let phoneRegex = #"^[\+]?[1-9][\d]{0,15}$"#
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            if !phoneTest.evaluate(with: phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)) {
                errors.append("Invalid phone number format")
            }
        }

        if let email = email, !email.isEmpty {
            // Basic email validation
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            if !emailTest.evaluate(with: email) {
                errors.append("Invalid email address format")
            }
        }

        if let website = website, !website.isEmpty {
            // Basic URL validation
            if !website.hasPrefix("http://") && !website.hasPrefix("https://") {
                errors.append("Website URL must start with http:// or https://")
            }
        }

        return errors
    }
    
    /// Validate payment transaction
    /// - Parameters:
    ///   - amount: Transaction amount
    ///   - paymentMethod: Payment method used
    ///   - paymentDate: Date payment was made (optional)
    ///   - dueDate: Date payment is due (optional)
    /// - Returns: Array of validation errors
    public static func validatePaymentTransaction(amount: Double, paymentMethod: PaymentMethod, paymentDate: Date?, dueDate: Date?) -> [String] {
        var errors: [String] = []
        
        if amount <= 0 {
            errors.append("Transaction amount must be greater than zero")
        }
        
        if amount > 1_000_000 {
            errors.append("Transaction amount cannot exceed $1,000,000")
        }
        
        if let paymentDate = paymentDate, let dueDate = dueDate {
            if paymentDate > dueDate.addingTimeInterval(24 * 60 * 60) { // Allow 1 day grace period
                errors.append("Payment date cannot be more than 1 day after due date")
            }
        }
        
        if let paymentDate = paymentDate {
            let calendar = Calendar.current
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            let oneYearFromNow = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
            
            if paymentDate < oneYearAgo {
                errors.append("Payment date cannot be more than 1 year in the past")
            }
            
            if paymentDate > oneYearFromNow {
                errors.append("Payment date cannot be more than 1 year in the future")
            }
        }
        
        return errors
    }
    
    /// Validate stored payment method
    /// - Parameters:
    ///   - name: Payment method name
    ///   - type: Payment method type
    ///   - accountNumber: Account number (for ACH)
    ///   - routingNumber: Routing number (for ACH)
    ///   - cardLastFour: Last four digits of card (for credit/debit cards)
    ///   - expirationDate: Card expiration date (for credit/debit cards)
    ///   - processingFee: Processing fee amount
    ///   - processingTimeDays: Processing time in days
    /// - Returns: Array of validation errors
    public static func validateStoredPaymentMethod(
        name: String,
        type: PaymentMethod,
        accountNumber: String?,
        routingNumber: String?,
        cardLastFour: String?,
        expirationDate: Date?,
        processingFee: Double,
        processingTimeDays: Int
    ) -> [String] {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Payment method name cannot be empty")
        }
        
        if name.count > 100 {
            errors.append("Payment method name cannot exceed 100 characters")
        }
        
        // Validate based on payment method type
        switch type {
        case .ach:
            if let accountNumber = accountNumber, !accountNumber.isEmpty {
                if accountNumber.count < 4 || accountNumber.count > 17 {
                    errors.append("Account number must be between 4 and 17 digits")
                }
                
                if !accountNumber.allSatisfy({ $0.isNumber }) {
                    errors.append("Account number must contain only digits")
                }
            }
            
            if let routingNumber = routingNumber, !routingNumber.isEmpty {
                if routingNumber.count != 9 {
                    errors.append("Routing number must be exactly 9 digits")
                }
                
                if !routingNumber.allSatisfy({ $0.isNumber }) {
                    errors.append("Routing number must contain only digits")
                }
            }
            
        case .creditCard, .debitCard:
            if let cardLastFour = cardLastFour, !cardLastFour.isEmpty {
                if cardLastFour.count != 4 {
                    errors.append("Card last four digits must be exactly 4 digits")
                }
                
                if !cardLastFour.allSatisfy({ $0.isNumber }) {
                    errors.append("Card last four digits must contain only digits")
                }
            }
            
            if let expirationDate = expirationDate {
                if expirationDate < Date() {
                    errors.append("Card expiration date cannot be in the past")
                }
                
                let calendar = Calendar.current
                let fiveYearsFromNow = calendar.date(byAdding: .year, value: 5, to: Date()) ?? Date()
                if expirationDate > fiveYearsFromNow {
                    errors.append("Card expiration date cannot be more than 5 years in the future")
                }
            }
            
        case .check, .cash, .wireTransfer, .other:
            // No specific validation for these types
            break
        }
        
        if processingFee < 0 {
            errors.append("Processing fee cannot be negative")
        }
        
        if processingFee > 1000 {
            errors.append("Processing fee cannot exceed $1,000")
        }
        
        if processingTimeDays < 0 {
            errors.append("Processing time cannot be negative")
        }
        
        if processingTimeDays > 30 {
            errors.append("Processing time cannot exceed 30 days")
        }
        
        return errors
    }
    
    /// Validate interest rate
    /// - Parameters:
    ///   - rate: Interest rate as a percentage
    ///   - rateType: Type of interest rate
    ///   - effectiveDate: Date the rate becomes effective
    ///   - source: Source of the rate information (optional)
    /// - Returns: Array of validation errors
    public static func validateInterestRate(
        rate: Double,
        rateType: InterestRateType,
        effectiveDate: Date,
        source: String? = nil
    ) -> [String] {
        var errors: [String] = []

        // Validate rate
        if rate < 0 {
            errors.append("Interest rate cannot be negative")
        }
        if rate > 100 {
            errors.append("Interest rate cannot exceed 100%")
        }

        // Validate effective date
        if effectiveDate > Date().addingTimeInterval(365 * 24 * 60 * 60) { // 1 year in future
            errors.append("Effective date cannot be more than 1 year in the future")
        }

        // Validate source (optional but if provided, should not be empty)
        if let source = source, source.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Source cannot be empty if provided")
        }

        return errors
    }
} 