import SwiftUI
import Charts

// MARK: - Form Insights Dashboard

/// Dashboard for viewing form analytics, performance, and insights
public struct FormInsightsDashboard: View {
    @StateObject private var analyticsManager = FormAnalyticsManager.shared
    @State private var selectedFormId: String?
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingFormSelector = false
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with form selector
                dashboardHeader
                
                if let formId = selectedFormId {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Overview cards
                            overviewCards(formId: formId)
                            
                            // Performance metrics
                            performanceSection(formId: formId)
                            
                            // Analytics charts
                            analyticsSection(formId: formId)
                            
                            // Error tracking
                            errorSection(formId: formId)
                            
                            // A/B testing
                            abTestingSection(formId: formId)
                            
                            // Recommendations
                            recommendationsSection(formId: formId)
                        }
                        .padding()
                    }
                } else {
                    // No form selected
                    noFormSelectedView
                }
            }
            .navigationTitle("Form Insights")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Settings") {
                        // Settings action
                    }
                }
            }
        }
        .onAppear {
            if selectedFormId == nil && !analyticsManager.analyticsData.isEmpty {
                selectedFormId = analyticsManager.analyticsData.keys.first
            }
        }
    }
    
    // MARK: - Dashboard Header
    
    private var dashboardHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Form Analytics Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Monitor performance and user behavior")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { showingFormSelector = true }) {
                    HStack {
                        Text(selectedFormId ?? "Select Form")
                            .font(.subheadline)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            // Time range selector
            HStack {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button(action: { selectedTimeRange = range }) {
                        Text(range.displayName)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedTimeRange == range ? Color.accentColor : Color.secondaryBackground)
                            .foregroundColor(selectedTimeRange == range ? .white : .primary)
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.primaryBackground)
        .sheet(isPresented: $showingFormSelector) {
            FormSelectorView(selectedFormId: $selectedFormId)
        }
    }
    
    // MARK: - Overview Cards
    
    private func overviewCards(formId: String) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            OverviewCard(
                title: "Completion Rate",
                value: analyticsManager.getAnalytics(for: formId)?.calculateCompletionRate().formatted(.percent.precision(.fractionLength(1))) ?? "0%",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            OverviewCard(
                title: "Avg. Time",
                value: formatTime(analyticsManager.getAnalytics(for: formId)?.calculateAverageCompletionTime() ?? 0),
                icon: "clock.fill",
                color: .blue
            )
            
            OverviewCard(
                title: "Total Views",
                value: "\(analyticsManager.getAnalytics(for: formId)?.events.filter { $0.eventType == .view }.count ?? 0)",
                icon: "eye.fill",
                color: .orange
            )
            
            OverviewCard(
                title: "Submissions",
                value: "\(analyticsManager.getAnalytics(for: formId)?.events.filter { $0.eventType == .submission }.count ?? 0)",
                icon: "paperplane.fill",
                color: .purple
            )
        }
    }
    
    // MARK: - Performance Section
    
    private func performanceSection(formId: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Performance Metrics", icon: "speedometer")
            
            if let metrics = analyticsManager.getPerformanceMetrics(for: formId) {
                VStack(spacing: 12) {
                    PerformanceMetricRow(
                        label: "Render Time",
                        value: "\(Int(metrics.averageRenderTime))ms",
                        status: metrics.averageRenderTime < 1000 ? .good : .warning
                    )
                    
                    PerformanceMetricRow(
                        label: "Validation Time",
                        value: "\(Int(metrics.averageValidationTime))ms",
                        status: metrics.averageValidationTime < 500 ? .good : .warning
                    )
                    
                    PerformanceMetricRow(
                        label: "Memory Usage",
                        value: ByteCountFormatter.string(fromByteCount: metrics.memoryUsage, countStyle: .memory),
                        status: metrics.memoryUsage < 50 * 1024 * 1024 ? .good : .warning
                    )
                    
                    PerformanceMetricRow(
                        label: "CPU Usage",
                        value: "\(Int(metrics.cpuUsage * 100))%",
                        status: metrics.cpuUsage < 0.5 ? .good : .warning
                    )
                }
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(12)
            } else {
                Text("No performance data available")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    // MARK: - Analytics Section
    
    private func analyticsSection(formId: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Analytics", icon: "chart.bar.fill")
            
            if let analytics = analyticsManager.getAnalytics(for: formId) {
                VStack(spacing: 20) {
                    // Completion rate over time
                    ChartCard(
                        title: "Completion Rate Trend",
                        chart: CompletionRateChart(analytics: analytics, timeRange: selectedTimeRange)
                    )
                    
                    // Field interaction heatmap
                    ChartCard(
                        title: "Field Interaction Heatmap",
                        chart: FieldInteractionChart(analytics: analytics)
                    )
                }
            } else {
                Text("No analytics data available")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    // MARK: - Error Section
    
    private func errorSection(formId: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Error Tracking", icon: "exclamationmark.triangle.fill")
            
            let formErrors = analyticsManager.errorLogs.filter { $0.formId == formId }
            
            if !formErrors.isEmpty {
                VStack(spacing: 12) {
                    ForEach(formErrors.prefix(5)) { error in
                        ErrorRow(error: error)
                    }
                    
                    if formErrors.count > 5 {
                        Button("View All \(formErrors.count) Errors") {
                            // Show all errors
                        }
                        .font(.caption)
                        .foregroundColor(.accentColor)
                    }
                }
            } else {
                Text("No errors reported")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    // MARK: - A/B Testing Section
    
    private func abTestingSection(formId: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "A/B Testing", icon: "testtube.2")
            
            let formTests = analyticsManager.abTestResults.filter { result in
                // Filter by form ID (would need to extend ABTestResult to include formId)
                true
            }
            
            if !formTests.isEmpty {
                VStack(spacing: 12) {
                    ForEach(formTests.prefix(3)) { result in
                        ABTestResultRow(result: result)
                    }
                }
            } else {
                Text("No A/B tests running")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    // MARK: - Recommendations Section
    
    private func recommendationsSection(formId: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Recommendations", icon: "lightbulb.fill")
            
            let insights = analyticsManager.getFormInsights(formId: formId)
            
            if !insights.recommendations.isEmpty {
                VStack(spacing: 12) {
                    ForEach(insights.recommendations) { recommendation in
                        RecommendationRow(recommendation: recommendation)
                    }
                }
            } else {
                Text("No recommendations at this time")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    // MARK: - No Form Selected View
    
    private var noFormSelectedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Form Selected")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Select a form from the dropdown above to view its analytics and insights.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        if timeInterval < 60 {
            return "\(Int(timeInterval))s"
        } else if timeInterval < 3600 {
            return "\(Int(timeInterval / 60))m"
        } else {
            return "\(Int(timeInterval / 3600))h"
        }
    }
}

// MARK: - Supporting Views

/// Overview card for key metrics
public struct OverviewCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }
}

/// Section header with icon
public struct SectionHeader: View {
    let title: String
    let icon: String
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

/// Performance metric row
public struct PerformanceMetricRow: View {
    let label: String
    let value: String
    let status: PerformanceStatus
    
    public var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(status.color)
        }
    }
}

/// Performance status
public enum PerformanceStatus {
    case good, warning, critical
    
    var color: Color {
        switch self {
        case .good: return .green
        case .warning: return .orange
        case .critical: return .red
        }
    }
}

/// Chart card wrapper
public struct ChartCard<Chart: View>: View {
    let title: String
    let chart: Chart
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            chart
                .frame(height: 200)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }
}

/// Error row
public struct ErrorRow: View {
    let error: FormError
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(error.message)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text(error.type.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(error.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.tertiaryBackground)
        .cornerRadius(8)
    }
}

/// A/B test result row
public struct ABTestResultRow: View {
    let result: ABTestResult
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(result.metric.name): \(result.metric.value, specifier: "%.2f") \(result.metric.unit)")
                    .font(.subheadline)
                
                Text("Variant: \(result.variant)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(result.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.tertiaryBackground)
        .cornerRadius(8)
    }
}

/// Recommendation row
public struct RecommendationRow: View {
    let recommendation: FormRecommendation
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                PriorityBadge(priority: recommendation.priority)
            }
            
            Text(recommendation.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color.tertiaryBackground)
        .cornerRadius(8)
    }
}

/// Priority badge
public struct PriorityBadge: View {
    let priority: FormRecommendationPriority
    
    public var body: some View {
        Text(priority.rawValue.capitalized)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priority.color.opacity(0.2))
            .foregroundColor(priority.color)
            .cornerRadius(4)
    }
}

extension FormRecommendationPriority {
    var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

// MARK: - Chart Views

/// Completion rate chart
public struct CompletionRateChart: View {
    let analytics: FormAnalytics
    let timeRange: TimeRange
    
    public var body: some View {
        Chart {
            // Simplified chart - would implement actual data visualization
            BarMark(
                x: .value("Day", "Mon"),
                y: .value("Rate", 0.75)
            )
            BarMark(
                x: .value("Day", "Tue"),
                y: .value("Rate", 0.82)
            )
            BarMark(
                x: .value("Day", "Wed"),
                y: .value("Rate", 0.68)
            )
        }
        .chartYScale(domain: 0...1)
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text("\(Int(doubleValue * 100))%")
                    }
                }
            }
        }
    }
}

/// Field interaction chart
public struct FieldInteractionChart: View {
    let analytics: FormAnalytics
    
    public var body: some View {
        Chart {
            // Simplified chart - would implement actual data visualization
            BarMark(
                x: .value("Field", "Name"),
                y: .value("Interactions", 45)
            )
            BarMark(
                x: .value("Field", "Email"),
                y: .value("Interactions", 38)
            )
            BarMark(
                x: .value("Field", "Phone"),
                y: .value("Interactions", 22)
            )
        }
    }
}

// MARK: - Form Selector

/// Form selection view
public struct FormSelectorView: View {
    @Binding var selectedFormId: String?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var analyticsManager = FormAnalyticsManager.shared
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(Array(analyticsManager.analyticsData.keys), id: \.self) { formId in
                    Button(action: {
                        selectedFormId = formId
                        dismiss()
                    }) {
                        HStack {
                            Text(formId)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedFormId == formId {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Form")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Time Range

/// Time range for analytics
public enum TimeRange: CaseIterable {
    case day, week, month, quarter, year
    
    var displayName: String {
        switch self {
        case .day: return "24h"
        case .week: return "7d"
        case .month: return "30d"
        case .quarter: return "90d"
        case .year: return "1y"
        }
    }
}

// MARK: - Preview

#Preview {
    FormInsightsDashboard()
}
