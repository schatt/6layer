//
//  FinancialDashboardHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a starting point for financial dashboard hints.
//

import Foundation
import SixLayerFramework

// MARK: - Financial Dashboard Hint

/// Custom hint for financial dashboards
/// Modify this class to match your financial application's requirements
class FinancialDashboardHint: CustomHint {
    
    // MARK: - Properties
    
    /// Time range for the dashboard
    let timeRange: String
    
    /// Whether to show charts
    let showCharts: Bool
    
    /// Refresh rate in seconds
    let refreshRate: Int
    
    /// Whether to enable real-time updates
    let realTimeUpdates: Bool
    
    /// Whether to enable data export
    let exportEnabled: Bool
    
    /// Whether to enable drill-down functionality
    let drillDownEnabled: Bool
    
    // MARK: - Initialization
    
    init(
        timeRange: String,
        showCharts: Bool = true,
        refreshRate: Int = 60,
        realTimeUpdates: Bool = true,
        exportEnabled: Bool = true,
        drillDownEnabled: Bool = true
    ) {
        self.timeRange = timeRange
        self.showCharts = showCharts
        self.refreshRate = refreshRate
        self.realTimeUpdates = realTimeUpdates
        self.exportEnabled = exportEnabled
        self.drillDownEnabled = drillDownEnabled
        
        super.init(
            hintType: "financial.dashboard.\(timeRange)",
            priority: .critical, // Financial data is critical
            overridesDefault: true, // Financial data needs real-time updates
            customData: [
                "timeRange": timeRange,
                "showCharts": showCharts,
                "refreshRate": refreshRate,
                "realTimeUpdates": realTimeUpdates,
                "exportEnabled": exportEnabled,
                "drillDownEnabled": drillDownEnabled,
                "showAlerts": true,
                "customizableWidgets": true,
                "dataRetention": calculateDataRetention(for: timeRange),
                "updateFrequency": calculateUpdateFrequency(for: timeRange),
                "showTrends": true,
                "showComparisons": true
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    /// Calculate optimal data retention period based on time range
    private func calculateDataRetention(for timeRange: String) -> String {
        switch timeRange.lowercased() {
        case "hourly":
            return "7 days"
        case "daily":
            return "1 year"
        case "weekly":
            return "5 years"
        case "monthly":
            return "10 years"
        case "quarterly":
            return "20 years"
        default:
            return "1 year"
        }
    }
    
    /// Calculate optimal update frequency based on time range
    private func calculateUpdateFrequency(for timeRange: String) -> String {
        switch timeRange.lowercased() {
        case "hourly":
            return "5 minutes"
        case "daily":
            return "1 hour"
        case "weekly":
            return "6 hours"
        case "monthly":
            return "1 day"
        case "quarterly":
            return "1 week"
        default:
            return "1 hour"
        }
    }
}

// MARK: - Enhanced Presentation Hints Extension

extension EnhancedPresentationHints {
    
    /// Create hints optimized for financial dashboards
    static func forFinancialDashboard(
        timeRange: String,
        showCharts: Bool = true,
        refreshRate: Int = 60,
        realTimeUpdates: Bool = true,
        exportEnabled: Bool = true
    ) -> EnhancedPresentationHints {
        let financialHint = FinancialDashboardHint(
            timeRange: timeRange,
            showCharts: showCharts,
            refreshRate: refreshRate,
            realTimeUpdates: realTimeUpdates,
            exportEnabled: exportEnabled
        )
        
        return EnhancedPresentationHints(
            dataType: .numeric,
            presentationPreference: .chart,
            complexity: .complex,
            context: .dashboard,
            extensibleHints: [financialHint]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your financial app, use it like this:
 
 struct FinancialDashboardView: View {
     let financialData: [FinancialData]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forFinancialDashboard(
             timeRange: "daily",
             showCharts: true,
             refreshRate: 30, // 30-second refresh for daily view
             realTimeUpdates: true,
             exportEnabled: true
         )
         
         return platformPresentNumericData_L1(
             data: financialData,
             hints: hints
         )
     }
 }
 
 // For different time ranges:
 
 struct QuarterlyReportView: View {
     let quarterlyData: [FinancialData]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forFinancialDashboard(
             timeRange: "quarterly",
             showCharts: true,
             refreshRate: 3600, // 1-hour refresh for quarterly data
             realTimeUpdates: false, // Quarterly data doesn't need real-time updates
             exportEnabled: true
         )
         
         return platformPresentNumericData_L1(
             data: quarterlyData,
             hints: hints
         )
     }
 }
 
 // Custom financial hint for specific use cases:
 
 struct TradingDashboardView: View {
     let tradingData: [TradingData]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .numeric,
             presentationPreference: .chart,
             complexity: .veryComplex,
             context: .dashboard,
             extensibleHints: [
                 FinancialDashboardHint(
                     timeRange: "hourly",
                     showCharts: true,
                     refreshRate: 5, // 5-second refresh for trading
                     realTimeUpdates: true,
                     exportEnabled: true,
                     drillDownEnabled: true
                 )
             ]
         )
         
         return platformPresentNumericData_L1(
             data: tradingData,
             hints: hints
         )
     }
 }
 
 */
