import Foundation
import SwiftUI

// MARK: - Performance Benchmark Result Types

/// Result of a performance benchmark
public struct PerformanceBenchmarkResult {
    public let name: String
    public let timestamp: Date
    public let metrics: PerformanceMetrics
    public let recommendations: [String]
    
    public init(name: String, timestamp: Date = Date(), metrics: PerformanceMetrics, recommendations: [String] = []) {
        self.name = name
        self.timestamp = timestamp
        self.metrics = metrics
        self.recommendations = recommendations
    }
}

/// Benchmark result for view rendering performance
public struct ViewRenderingBenchmark {
    public let averageRenderTime: TimeInterval
    public let totalTime: TimeInterval
    public let iterations: Int
    public let performanceScore: Double
    public let timestamp: Date
    
    public init(averageRenderTime: TimeInterval, totalTime: TimeInterval, iterations: Int, performanceScore: Double, timestamp: Date) {
        self.averageRenderTime = averageRenderTime
        self.totalTime = totalTime
        self.iterations = iterations
        self.performanceScore = performanceScore
        self.timestamp = timestamp
    }
}

/// Benchmark result for memory usage
public struct MemoryUsageBenchmark {
    public let peakMemoryUsage: Double
    public let averageMemoryUsage: Double
    public let memoryDelta: Double
    public let duration: TimeInterval
    public let timestamp: Date
    
    public init(peakMemoryUsage: Double, averageMemoryUsage: Double, memoryDelta: Double, duration: TimeInterval, timestamp: Date) {
        self.peakMemoryUsage = peakMemoryUsage
        self.averageMemoryUsage = averageMemoryUsage
        self.memoryDelta = memoryDelta
        self.duration = duration
        self.timestamp = timestamp
    }
}

/// Cross-platform performance comparison results
public struct CrossPlatformPerformanceComparison {
    public let platformResults: [Platform: ViewRenderingBenchmark]
    public let timestamp: Date
    
    public init(platformResults: [Platform: ViewRenderingBenchmark], timestamp: Date) {
        self.platformResults = platformResults
        self.timestamp = timestamp
    }
}

// MARK: - Performance Recommendation Types

/// Performance optimization recommendation
public struct PerformanceRecommendation {
    public let title: String
    public let description: String
    public let impact: PerformanceImpact
    public let implementation: String
    
    public init(title: String, description: String, impact: PerformanceImpact, implementation: String) {
        self.title = title
        self.description = description
        self.impact = impact
        self.implementation = implementation
    }
}

/// Performance impact level
public enum PerformanceImpact: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
}

// MARK: - Memory Management Types

// MemoryMetrics is already defined in CrossPlatformOptimizationLayer6.swift

/// Memory alert for monitoring
public struct MemoryAlert {
    public let level: MemoryAlertLevel
    public let message: String
    public let timestamp: Date
    public let recommendations: [String]
    
    public init(level: MemoryAlertLevel, message: String, timestamp: Date = Date(), recommendations: [String] = []) {
        self.level = level
        self.message = message
        self.timestamp = timestamp
        self.recommendations = recommendations
    }
}

/// Memory alert level
public enum MemoryAlertLevel: String, CaseIterable {
    case warning = "warning"
    case critical = "critical"
    case emergency = "emergency"
}

/// Memory recommendation for optimization
public struct MemoryRecommendation {
    public let title: String
    public let description: String
    public let priority: MemoryPriority
    public let estimatedSavings: Double
    
    public init(title: String, description: String, priority: MemoryPriority, estimatedSavings: Double) {
        self.title = title
        self.description = description
        self.priority = priority
        self.estimatedSavings = estimatedSavings
    }
}

/// Memory optimization priority
public enum MemoryPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
}

// MARK: - Cache Metrics Types

/// Cache performance metrics
public struct CacheMetrics {
    public let hitRate: Double
    public let missRate: Double
    public let totalRequests: Int
    public let cacheSize: Int
    public let evictionCount: Int
    
    public init(hitRate: Double = 0.85, missRate: Double = 0.15, totalRequests: Int = 1000, cacheSize: Int = 100, evictionCount: Int = 0) {
        self.hitRate = hitRate
        self.missRate = missRate
        self.totalRequests = totalRequests
        self.cacheSize = cacheSize
        self.evictionCount = evictionCount
    }
}

// MARK: - Helper Functions

/// Calculate performance score based on render time
public func calculatePerformanceScore(_ renderTime: TimeInterval) -> Double {
    // Lower render time = higher score
    let baseScore = 100.0
    let timePenalty = renderTime * 1000 // Convert to milliseconds
    return max(0, baseScore - timePenalty)
}
