import Foundation
import SwiftUI

// MARK: - Form Analytics Manager

/// Manages form analytics, performance monitoring, and insights
@MainActor
public class FormAnalyticsManager: ObservableObject, @unchecked Sendable {
    @MainActor
    public static let shared = FormAnalyticsManager()
    
    @Published public var analyticsData: [String: FormAnalytics] = [:]
    @Published public var performanceMetrics: [String: FormPerformanceMetrics] = [:]
    @Published public var errorLogs: [FormError] = []
    @Published public var abTestResults: [ABTestResult] = []
    
    // Removed DispatchQueue - using Task-based concurrency instead
    private let storage = AnalyticsStorage()
    
    private init() {
        loadAnalyticsData()
    }
    
    // MARK: - Analytics Tracking
    
    /// Track form view event
    func trackFormView(formId: String, userId: String? = nil) {
        Task { @MainActor in
            let event = FormEvent(
                formId: formId,
                eventType: .view,
                userId: userId,
                timestamp: Date(),
                metadata: [:]
            )
            self.recordEvent(event)
        }
    }
    
    /// Track form submission event
    func trackFormSubmission(formId: String, userId: String? = nil, success: Bool, validationErrors: [String] = []) {
        Task { @MainActor in
            let event = FormEvent(
                formId: formId,
                eventType: .submission,
                userId: userId,
                timestamp: Date(),
                metadata: [
                    "success": success,
                    "validationErrors": validationErrors,
                    "errorCount": validationErrors.count
                ]
            )
            self.recordEvent(event)
        }
    }
    
    /// Track field interaction event
    func trackFieldInteraction(formId: String, fieldId: String, userId: String? = nil, interactionType: FieldInteractionType) {
        Task { @MainActor in
            let event = FormEvent(
                formId: formId,
                eventType: .fieldInteraction,
                userId: userId,
                timestamp: Date(),
                metadata: [
                    "fieldId": fieldId,
                    "interactionType": interactionType.rawValue
                ]
            )
            self.recordEvent(event)
        }
    }
    
    /// Track form performance metrics
    func trackPerformance(formId: String, metrics: FormPerformanceMetrics) {
        Task { @MainActor in
            self.performanceMetrics[formId] = metrics
            self.storage.savePerformanceMetrics(metrics, for: formId)
        }
    }
    
    /// Track form error
    func trackError(formId: String, error: FormError) {
        Task { @MainActor in
            self.errorLogs.append(error)
            self.storage.saveError(error)
        }
    }
    
    // MARK: - A/B Testing
    
    /// Start A/B test for a form
    func startABTest(formId: String, variantA: FormVariant, variantB: FormVariant) -> ABTest {
        let test = ABTest(
            id: UUID().uuidString,
            formId: formId,
            variantA: variantA,
            variantB: variantB,
            startDate: Date(),
            status: .active
        )
        
        Task { @MainActor in
            self.storage.saveABTest(test)
        }
        
        return test
    }
    
    /// Record A/B test result
    func recordABTestResult(testId: String, variant: String, result: ABTestMetric) {
        let testResult = ABTestResult(
            testId: testId,
            variant: variant,
            metric: result,
            timestamp: Date()
        )
        
        Task { @MainActor in
            self.abTestResults.append(testResult)
            self.storage.saveABTestResult(testResult)
        }
    }
    
    // MARK: - Analytics Retrieval
    
    /// Get analytics for a specific form
    func getAnalytics(for formId: String) -> FormAnalytics? {
        return analyticsData[formId]
    }
    
    /// Get performance metrics for a form
    func getPerformanceMetrics(for formId: String) -> FormPerformanceMetrics? {
        return performanceMetrics[formId]
    }
    
    /// Get form insights and recommendations
    func getFormInsights(formId: String) -> FormInsights {
        let analytics = analyticsData[formId]
        let performance = performanceMetrics[formId]
        let errors = errorLogs.filter { $0.formId == formId }
        
        return FormInsights(
            formId: formId,
            analytics: analytics,
            performance: performance,
            errors: errors,
            recommendations: generateRecommendations(analytics: analytics, performance: performance, errors: errors)
        )
    }
    
    // MARK: - Private Methods
    
    private func recordEvent(_ event: FormEvent) {
        if analyticsData[event.formId] == nil {
            analyticsData[event.formId] = FormAnalytics(formId: event.formId)
        }
        
        analyticsData[event.formId]?.recordEvent(event)
        storage.saveAnalytics(analyticsData[event.formId]!, for: event.formId)
    }
    
    private func loadAnalyticsData() {
        // Load from storage
        analyticsData = storage.loadAllAnalytics()
        performanceMetrics = storage.loadAllPerformanceMetrics()
        errorLogs = storage.loadAllErrors()
        abTestResults = storage.loadAllABTestResults()
    }
    
    private func generateRecommendations(analytics: FormAnalytics?, performance: FormPerformanceMetrics?, errors: [FormError]) -> [FormRecommendation] {
        var recommendations: [FormRecommendation] = []
        
        // Performance recommendations
        if let perf = performance, perf.averageRenderTime > 1000 {
            recommendations.append(FormRecommendation(
                type: .performance,
                title: "Optimize Form Rendering",
                description: "Form rendering time is above 1 second. Consider lazy loading or reducing complexity.",
                priority: .high
            ))
        }
        
        // Error-based recommendations
        let validationErrors = errors.filter { $0.type == .validation }
        if validationErrors.count > 10 {
            recommendations.append(FormRecommendation(
                type: .validation,
                title: "Review Validation Rules",
                description: "High number of validation errors. Consider simplifying validation rules or improving user guidance.",
                priority: .medium
            ))
        }
        
        // Analytics-based recommendations
        if let analytics = analytics {
            let completionRate = analytics.calculateCompletionRate()
            if completionRate < 0.7 {
                recommendations.append(FormRecommendation(
                    type: .userExperience,
                    title: "Improve Form Completion",
                    description: "Form completion rate is below 70%. Consider simplifying the form or adding progress indicators.",
                    priority: .high
                ))
            }
        }
        
        return recommendations
    }
}

// MARK: - Form Analytics Data Models

/// Analytics data for a specific form
public struct FormAnalytics: Codable {
    public let formId: String
    public var events: [FormEvent] = []
    public var fieldAnalytics: [String: FieldAnalytics] = [:]
    
    public init(formId: String) {
        self.formId = formId
    }
    
    public mutating func recordEvent(_ event: FormEvent) {
        events.append(event)
        
        if event.eventType == .fieldInteraction,
           let fieldId = event.metadata["fieldId"] as? String {
            if fieldAnalytics[fieldId] == nil {
                fieldAnalytics[fieldId] = FieldAnalytics(fieldId: fieldId)
            }
            fieldAnalytics[fieldId]?.recordEvent(event)
        }
    }
    
        func calculateCompletionRate() -> Double {
        let submissions = events.filter { $0.eventType == .submission }
        let views = events.filter { $0.eventType == .view }
        
        guard !views.isEmpty else { return 0.0 }
        return Double(submissions.count) / Double(views.count)
    }
    
        func calculateAverageCompletionTime() -> TimeInterval {
        let submissions = events.filter { $0.eventType == .submission }
        let views = events.filter { $0.eventType == .view }
        
        var totalTime: TimeInterval = 0
        var validPairs = 0
        
        for submission in submissions {
            if let viewEvent = views.first(where: { $0.userId == submission.userId }) {
                totalTime += submission.timestamp.timeIntervalSince(viewEvent.timestamp)
                validPairs += 1
            }
        }
        
        return validPairs > 0 ? totalTime / Double(validPairs) : 0
    }
}

/// Individual form event
public struct FormEvent: Codable {
    public let formId: String
    public let eventType: FormEventType
    public let userId: String?
    public let timestamp: Date
    public let metadata: [String: Any]
    
    public init(formId: String, eventType: FormEventType, userId: String?, timestamp: Date, metadata: [String: Any]) {
        self.formId = formId
        self.eventType = eventType
        self.userId = userId
        self.timestamp = timestamp
        self.metadata = metadata
    }
    
    // Custom coding for metadata dictionary
    private enum CodingKeys: String, CodingKey {
        case formId, eventType, userId, timestamp, metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        formId = try container.decode(String.self, forKey: .formId)
        eventType = try container.decode(FormEventType.self, forKey: .eventType)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        metadata = [:] // Simplified for now
    }
    
        public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(formId, forKey: .formId)
        try container.encode(eventType, forKey: .eventType)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encode(timestamp, forKey: .timestamp)
        // Simplified for now
    }
}

/// Types of form events
public enum FormEventType: String, Codable, CaseIterable {
    case view = "view"
    case submission = "submission"
    case fieldInteraction = "fieldInteraction"
    case validation = "validation"
    case error = "error"
}

/// Field interaction types
public enum FieldInteractionType: String, Codable, CaseIterable, Sendable {
    case focus = "focus"
    case blur = "blur"
    case change = "change"
    case validation = "validation"
}

/// Field-specific analytics
public struct FieldAnalytics: Codable {
    public let fieldId: String
    public var interactionCount: Int = 0
    public var errorCount: Int = 0
    public var averageInteractionTime: TimeInterval = 0
    
    public init(fieldId: String) {
        self.fieldId = fieldId
    }
    
    public mutating func recordEvent(_ event: FormEvent) {
        interactionCount += 1
        
        if event.eventType == .validation,
           let hasErrors = event.metadata["hasErrors"] as? Bool,
           hasErrors {
            errorCount += 1
        }
    }
}

// MARK: - Performance Metrics

/// Form performance metrics for rendering and interaction
public struct FormPerformanceMetrics: Codable, Sendable {
    public let formId: String
    public let timestamp: Date
    public let averageRenderTime: TimeInterval
    public let averageValidationTime: TimeInterval
    public let memoryUsage: Int64
    public let cpuUsage: Double
    
    public init(formId: String, averageRenderTime: TimeInterval, averageValidationTime: TimeInterval, memoryUsage: Int64, cpuUsage: Double) {
        self.formId = formId
        self.timestamp = Date()
        self.averageRenderTime = averageRenderTime
        self.averageValidationTime = averageValidationTime
        self.memoryUsage = memoryUsage
        self.cpuUsage = cpuUsage
    }
}

// MARK: - Error Tracking

/// Form error information
public struct FormError: Codable, Identifiable, Sendable {
    public let id: UUID
    public let formId: String
    public let fieldId: String?
    public let type: FormErrorType
    public let message: String
    public let timestamp: Date
    public let stackTrace: String?
    
    public init(id: UUID = UUID(), formId: String, fieldId: String? = nil, type: FormErrorType, message: String, stackTrace: String? = nil) {
        self.id = id
        self.formId = formId
        self.fieldId = fieldId
        self.type = type
        self.message = message
        self.timestamp = Date()
        self.stackTrace = stackTrace
    }
}

/// Types of form errors
public enum FormErrorType: String, Codable, CaseIterable, Sendable {
    case validation = "validation"
    case submission = "submission"
    case rendering = "rendering"
    case network = "network"
    case unknown = "unknown"
}

// MARK: - A/B Testing

/// A/B test configuration
public struct ABTest: Codable, Identifiable, Sendable {
    public let id: String
    public let formId: String
    public let variantA: FormVariant
    public let variantB: FormVariant
    public let startDate: Date
    public var status: ABTestStatus
    public var endDate: Date?
    
    public init(id: String, formId: String, variantA: FormVariant, variantB: FormVariant, startDate: Date, status: ABTestStatus) {
        self.id = id
        self.formId = formId
        self.variantA = variantA
        self.variantB = variantB
        self.startDate = startDate
        self.status = status
    }
}

/// Form variant for A/B testing
public struct FormVariant: Codable, Sendable {
    public let name: String
    public let configuration: [String: String] // Changed from Any to String for Sendable conformance
    public let description: String
    
    public init(name: String, configuration: [String: String], description: String) {
        self.name = name
        self.configuration = configuration
        self.description = description
    }
    
    // Custom coding for configuration dictionary
    private enum CodingKeys: String, CodingKey {
        case name, configuration, description
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        configuration = [:] // Simplified for now
        description = try container.decode(String.self, forKey: .description)
    }
    
        public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        // Simplified for now
    }
}

/// A/B test status
public enum ABTestStatus: String, Codable, CaseIterable, Sendable {
    case active = "active"
    case paused = "paused"
    case completed = "completed"
    case cancelled = "cancelled"
}

/// A/B test result
public struct ABTestResult: Codable, Identifiable, Sendable {
    public let id: UUID
    public let testId: String
    public let variant: String
    public let metric: ABTestMetric
    public let timestamp: Date
    
    public init(id: UUID = UUID(), testId: String, variant: String, metric: ABTestMetric, timestamp: Date) {
        self.id = id
        self.testId = testId
        self.variant = variant
        self.metric = metric
        self.timestamp = timestamp
    }
}

/// A/B test metric
public struct ABTestMetric: Codable, Sendable {
    public let name: String
    public let value: Double
    public let unit: String
    
    public init(name: String, value: Double, unit: String) {
        self.name = name
        self.value = value
        self.unit = unit
    }
}

// MARK: - Form Insights

/// Insights and recommendations for form optimization
public struct FormInsights {
    public let formId: String
    public let analytics: FormAnalytics?
    public let performance: FormPerformanceMetrics?
    public let errors: [FormError]
    public let recommendations: [FormRecommendation]
    
    public init(formId: String, analytics: FormAnalytics?, performance: FormPerformanceMetrics?, errors: [FormError], recommendations: [FormRecommendation]) {
        self.formId = formId
        self.analytics = analytics
        self.performance = performance
        self.errors = errors
        self.recommendations = recommendations
    }
}

/// Form optimization recommendation
public struct FormRecommendation: Identifiable {
    public let id = UUID()
    public let type: FormRecommendationType
    public let title: String
    public let description: String
    public let priority: FormRecommendationPriority
    
    public init(type: FormRecommendationType, title: String, description: String, priority: FormRecommendationPriority) {
        self.type = type
        self.title = title
        self.description = description
        self.priority = priority
    }
}

/// Types of form recommendations
public enum FormRecommendationType: String, CaseIterable {
    case performance = "performance"
    case validation = "validation"
    case userExperience = "userExperience"
    case accessibility = "accessibility"
    case security = "security"
}

/// Form recommendation priority levels
public enum FormRecommendationPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
}

// MARK: - Analytics Storage

/// Storage layer for analytics data
private class AnalyticsStorage {
    private let userDefaults = UserDefaults.standard
    private let analyticsKey = "FormAnalytics"
    private let performanceKey = "FormPerformance"
    private let errorsKey = "FormErrors"
    private let abTestsKey = "ABTests"
    private let abTestResultsKey = "ABTestResults"
    
    func saveAnalytics(_ analytics: FormAnalytics, for formId: String) {
        var allAnalytics = loadAllAnalytics()
        allAnalytics[formId] = analytics
        saveData(allAnalytics, forKey: analyticsKey)
    }
    
    func loadAllAnalytics() -> [String: FormAnalytics] {
        return loadData(forKey: analyticsKey) ?? [:]
    }
    
    func savePerformanceMetrics(_ metrics: FormPerformanceMetrics, for formId: String) {
        var allMetrics = loadAllPerformanceMetrics()
        allMetrics[formId] = metrics
        saveData(allMetrics, forKey: performanceKey)
    }
    
    func loadAllPerformanceMetrics() -> [String: FormPerformanceMetrics] {
        return loadData(forKey: performanceKey) ?? [:]
    }
    
    func saveError(_ error: FormError) {
        var allErrors = loadAllErrors()
        allErrors.append(error)
        saveData(allErrors, forKey: errorsKey)
    }
    
    func loadAllErrors() -> [FormError] {
        return loadData(forKey: errorsKey) ?? []
    }
    
    func saveABTest(_ test: ABTest) {
        var allTests = loadAllABTests()
        allTests[test.id] = test
        saveData(allTests, forKey: abTestsKey)
    }
    
    func loadAllABTests() -> [String: ABTest] {
        return loadData(forKey: abTestsKey) ?? [:]
    }
    
    func saveABTestResult(_ result: ABTestResult) {
        var allResults = loadAllABTestResults()
        allResults.append(result)
        saveData(allResults, forKey: abTestResultsKey)
    }
    
    func loadAllABTestResults() -> [ABTestResult] {
        return loadData(forKey: abTestResultsKey) ?? []
    }
    
    private func saveData<T: Codable>(_ data: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    private func loadData<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }
}
