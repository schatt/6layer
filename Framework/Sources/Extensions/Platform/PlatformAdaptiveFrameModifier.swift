import SwiftUI

// MARK: - Adaptive Frame ViewModifier

/// ViewModifier for platform-adaptive frame sizing
/// Analyzes form content and applies appropriate dimensions
public struct AdaptiveFrameModifier: ViewModifier {
    @State private var calculatedWidth: CGFloat = 600
    @State private var calculatedHeight: CGFloat = 700
    
        public func body(content: Content) -> some View {
        content
            .frame(minWidth: calculatedWidth, minHeight: calculatedHeight)
            .onPreferenceChange(FormContentKey.self) { metrics in
                let (width, height) = analyzeFormContent(metrics)
                calculatedWidth = width
                calculatedHeight = height
            }
    }
    
    /// Analyze form content and calculate appropriate dimensions
    /// Uses intelligent algorithms to determine sizing based on content complexity
    /// - Parameter metrics: Form content metrics from preference keys
    /// - Returns: Tuple of (minWidth, minHeight) with safe bounds
    private func analyzeFormContent(_ metrics: FormContentMetrics) -> (minWidth: CGFloat, minHeight: CGFloat) {
        // Base dimensions for simple forms
        let baseWidth: CGFloat = 500
        let baseHeight: CGFloat = 400
        
        // Calculate width based on field count
        let fieldWidthContribution: CGFloat = 25
        let calculatedWidth = baseWidth + (CGFloat(metrics.fieldCount) * fieldWidthContribution)
        
        // Calculate height based on section count and content complexity
        let sectionHeightContribution: CGFloat = 100
        let complexContentBonus: CGFloat = metrics.hasComplexContent ? 200 : 0
        let calculatedHeight = baseHeight + (CGFloat(metrics.sectionCount) * sectionHeightContribution) + complexContentBonus
        
        // Apply safe bounds
        let minWidth = max(500, min(900, calculatedWidth))
        let minHeight = max(400, min(1000, calculatedHeight))
        
        // Debug logging (can be removed in production)
        #if DEBUG
        print("Form Content Analysis - Fields: \(metrics.fieldCount), Sections: \(metrics.sectionCount), Complex: \(metrics.hasComplexContent)")
        print("Calculated Dimensions - Width: \(minWidth), Height: \(minHeight)")
        #endif
        
        return (minWidth: minWidth, minHeight: minHeight)
    }
    
    /// Test function to validate content analysis with different form configurations
    /// This helps verify the adaptive sizing system during development
    #if DEBUG
    static func testContentAnalysis() {
        let testCases = [
            FormContentMetrics(fieldCount: 3, estimatedComplexity: .simple, preferredLayout: .compact, sectionCount: 2, hasComplexContent: false),  // Simple form
            FormContentMetrics(fieldCount: 8, estimatedComplexity: .moderate, preferredLayout: .adaptive, sectionCount: 4, hasComplexContent: false),  // Medium form
            FormContentMetrics(fieldCount: 12, estimatedComplexity: .complex, preferredLayout: .spacious, sectionCount: 6, hasComplexContent: true),  // Complex form
            FormContentMetrics(fieldCount: 1, estimatedComplexity: .simple, preferredLayout: .compact, sectionCount: 1, hasComplexContent: false),  // Minimal form
            FormContentMetrics(fieldCount: 20, estimatedComplexity: .veryComplex, preferredLayout: .custom, sectionCount: 8, hasComplexContent: true)   // Very complex form
        ]
        
        print("=== Adaptive Sizing System Test ===")
        for (index, metrics) in testCases.enumerated() {
            let modifier = AdaptiveFrameModifier()
            let (width, height) = modifier.analyzeFormContent(metrics)
            print("Test \(index + 1): Fields=\(metrics.fieldCount), Sections=\(metrics.sectionCount), Complex=\(metrics.hasComplexContent)")
            print("  Result: Width=\(width), Height=\(height)")
        }
        print("=== Test Complete ===")
    }
    #endif
}
