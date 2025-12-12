# Performance Service: Battery & Thermal Optimization

**Parent Issue**: #107  
**Depends On**: #107a (Performance Service Core)

## Overview

Add battery and thermal optimization capabilities to the Performance Service, building on the core memory and cache management infrastructure.

This extends the core Performance Service with:
- Battery level monitoring
- Thermal state monitoring
- Adaptive optimization strategies based on battery/thermal conditions
- Frame rate adjustment for battery conservation
- CPU throttling for thermal management

## Motivation

Battery and thermal optimization are critical for mobile devices:
- Low battery requires aggressive optimization
- Thermal throttling requires performance reduction
- Adaptive strategies improve user experience
- Frame rate adjustment saves battery

**Solution**: Extend `PerformanceService` with battery and thermal monitoring and optimization methods.

## Architecture Pattern

This extends the core `PerformanceService` from issue #107a:
- **Builds on core**: Uses existing metrics and optimization infrastructure
- **Service extension**: Adds methods to existing service
- **Adaptive**: Automatically adjusts based on conditions

## Proposed API Design

### Extensions to PerformanceMetrics

```swift
extension PerformanceMetrics {
    public let batteryLevel: Double? // percentage (if available)
    public let thermalState: ThermalState
    
    // Updated initializer includes battery and thermal
    public init(
        memoryUsage: Int64,
        memoryLimit: Int64,
        cacheSize: Int64,
        cacheLimit: Int64,
        cpuUsage: Double,
        frameRate: Double,
        batteryLevel: Double? = nil,
        thermalState: ThermalState = .nominal
    ) {
        // ... existing initialization
        self.batteryLevel = batteryLevel
        self.thermalState = thermalState
    }
}

public enum ThermalState {
    case nominal
    case fair
    case serious
    case critical
    
    public var displayName: String {
        switch self {
        case .nominal: return "Normal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        }
    }
    
    public var requiresOptimization: Bool {
        return self == .serious || self == .critical
    }
}
```

### Extensions to PerformanceService

```swift
extension PerformanceService {
    // MARK: - Battery Optimization
    
    /// Optimize for battery life
    public func optimizeForBattery() async throws {
        // Reduce CPU usage
        try await optimizeCPUUsage()
        
        // Reduce frame rate
        try await optimizeFrameRate(targetFPS: 30)
        
        // Clear non-essential cache
        try await clearNonEssentialCache()
        
        // Reduce background processing
        await reduceBackgroundProcessing()
    }
    
    /// Check if battery optimization should be enabled
    public func shouldOptimizeForBattery() -> Bool {
        guard let batteryLevel = metrics.batteryLevel else { return false }
        return batteryLevel < 20.0 || 
               metrics.thermalState == .serious || 
               metrics.thermalState == .critical
    }
    
    /// Get recommended optimization strategy based on battery/thermal state
    public func recommendedStrategy() -> OptimizationStrategy {
        if shouldOptimizeForBattery() {
            return .conservative
        } else if metrics.thermalState == .fair {
            return .balanced
        } else {
            return strategy // Use configured strategy
        }
    }
    
    // MARK: - Thermal Management
    
    /// Optimize for thermal conditions
    public func optimizeForThermal() async throws {
        guard metrics.thermalState.requiresOptimization else { return }
        
        // Reduce CPU usage aggressively
        try await optimizeCPUUsage(aggressive: true)
        
        // Reduce frame rate
        try await optimizeFrameRate(targetFPS: 30)
        
        // Clear cache to reduce heat
        try await clearUnusedCache()
        
        // Pause non-essential operations
        await pauseNonEssentialOperations()
    }
    
    /// Check if thermal optimization is needed
    public func shouldOptimizeForThermal() -> Bool {
        return metrics.thermalState.requiresOptimization
    }
    
    // MARK: - Frame Rate Optimization
    
    /// Optimize frame rate for battery/thermal conditions
    /// - Parameter targetFPS: Target frames per second
    public func optimizeFrameRate(targetFPS: Double? = nil) async throws {
        let target = targetFPS ?? recommendedFrameRate()
        
        // Adjust frame rate based on conditions
        if shouldOptimizeForBattery() {
            // Lower frame rate for battery
            await setFrameRateLimit(30.0)
        } else if shouldOptimizeForThermal() {
            // Lower frame rate for thermal
            await setFrameRateLimit(30.0)
        } else {
            // Normal frame rate
            await setFrameRateLimit(60.0)
        }
    }
    
    /// Get recommended frame rate based on conditions
    private func recommendedFrameRate() -> Double {
        if shouldOptimizeForBattery() || shouldOptimizeForThermal() {
            return 30.0
        }
        return 60.0
    }
    
    /// Set frame rate limit (platform-specific)
    private func setFrameRateLimit(_ fps: Double) async {
        #if os(iOS)
        await setIOSFrameRateLimit(fps)
        #elseif os(macOS)
        await setMacOSFrameRateLimit(fps)
        #endif
    }
    
    // MARK: - CPU Optimization
    
    /// Optimize CPU usage
    /// - Parameter aggressive: Whether to use aggressive optimization
    public func optimizeCPUUsage(aggressive: Bool = false) async throws {
        if aggressive {
            // Aggressive CPU reduction
            await reduceCPUIntensiveOperations()
            await deferNonCriticalOperations()
        } else {
            // Normal CPU optimization
            await optimizeCPUIntensiveOperations()
        }
    }
    
    // MARK: - Background Processing
    
    /// Reduce background processing
    private func reduceBackgroundProcessing() async {
        // Pause non-essential background tasks
        // Reduce network activity
        // Defer cache updates
    }
    
    /// Clear non-essential cache
    private func clearNonEssentialCache() async throws {
        // Clear cache entries that aren't critical
        // Keep only essential cached items
    }
    
    /// Pause non-essential operations
    private func pauseNonEssentialOperations() async {
        // Pause background sync
        // Pause preloading
        // Pause non-critical updates
    }
    
    // MARK: - Battery & Thermal Monitoring
    
    /// Update battery level (called by monitoring)
    private func updateBatteryLevel() async {
        #if os(iOS)
        let level = await getIOSBatteryLevel()
        metrics = PerformanceMetrics(
            memoryUsage: metrics.memoryUsage,
            memoryLimit: metrics.memoryLimit,
            cacheSize: metrics.cacheSize,
            cacheLimit: metrics.cacheLimit,
            cpuUsage: metrics.cpuUsage,
            frameRate: metrics.frameRate,
            batteryLevel: level,
            thermalState: metrics.thermalState
        )
        #endif
    }
    
    /// Update thermal state (called by monitoring)
    private func updateThermalState() async {
        #if os(iOS)
        let state = await getIOSThermalState()
        metrics = PerformanceMetrics(
            memoryUsage: metrics.memoryUsage,
            memoryLimit: metrics.memoryLimit,
            cacheSize: metrics.cacheSize,
            cacheLimit: metrics.cacheLimit,
            cpuUsage: metrics.cpuUsage,
            frameRate: metrics.frameRate,
            batteryLevel: metrics.batteryLevel,
            thermalState: state
        )
        #endif
    }
    
    // MARK: - Platform-Specific Helpers
    
    #if os(iOS)
    private func getIOSBatteryLevel() async -> Double? {
        UIDevice.current.isBatteryMonitoringEnabled = true
        guard UIDevice.current.batteryState != .unknown else { return nil }
        return Double(UIDevice.current.batteryLevel * 100)
    }
    
    private func getIOSThermalState() async -> ThermalState {
        let state = ProcessInfo.processInfo.thermalState
        switch state {
        case .nominal:
            return .nominal
        case .fair:
            return .fair
        case .serious:
            return .serious
        case .critical:
            return .critical
        @unknown default:
            return .nominal
        }
    }
    
    private func setIOSFrameRateLimit(_ fps: Double) async {
        // iOS doesn't have direct frame rate control
        // But we can recommend to the system
        // This would be handled by the app's rendering pipeline
    }
    #endif
    
    #if os(macOS)
    private func getMacOSBatteryLevel() async -> Double? {
        // macOS doesn't expose battery level easily
        // Would need IOKit or similar
        return nil
    }
    
    private func getMacOSThermalState() async -> ThermalState {
        // macOS thermal state detection
        return .nominal
    }
    
    private func setMacOSFrameRateLimit(_ fps: Double) async {
        // macOS frame rate control
    }
    #endif
}
```

### Layer 1 Semantic Functions

```swift
/// Optimize performance for current conditions (including battery/thermal)
@MainActor
public func platformOptimizePerformance_L1(
    target: OptimizationTarget = .all,
    hints: PerformanceHints = PerformanceHints()
) async throws {
    let performance = PerformanceService(
        memoryLimit: hints.memoryLimit,
        cacheLimit: hints.cacheLimit
    )
    performance.strategy = hints.strategy
    
    // Automatically optimize for battery/thermal if needed
    if performance.shouldOptimizeForBattery() {
        try await performance.optimizeForBattery()
    } else if performance.shouldOptimizeForThermal() {
        try await performance.optimizeForThermal()
    } else {
        try await performance.optimizeMemory(target: target)
    }
}

/// Get current battery and thermal status
@MainActor
public func platformGetBatteryThermalStatus_L1(
    hints: PerformanceHints = PerformanceHints()
) -> (batteryLevel: Double?, thermalState: ThermalState) {
    let performance = PerformanceService()
    return (performance.metrics.batteryLevel, performance.metrics.thermalState)
}
```

## Platform-Specific Considerations

### iOS
- Battery level monitoring via `UIDevice.batteryLevel`
- Thermal state via `ProcessInfo.thermalState`
- Battery monitoring must be enabled
- Frame rate recommendations (no direct control)

### macOS
- Limited battery level access (requires IOKit)
- Thermal state detection
- Frame rate control via display link

### visionOS
- Battery optimization for spatial experiences
- Thermal management for immersive content
- Frame rate optimization for spatial rendering

## Adaptive Optimization Strategy

The service automatically adjusts optimization based on conditions:

1. **Normal Conditions**: Uses configured strategy (balanced, aggressive, etc.)
2. **Low Battery (< 20%)**: Automatically switches to conservative strategy
3. **Thermal Serious/Critical**: Automatically reduces performance
4. **Adaptive Strategy**: Automatically adjusts based on all conditions

## Testing

- Framework tests should use mocks for battery/thermal monitoring
- Battery level simulation should be testable
- Thermal state simulation should be testable
- Optimization strategies should be testable

## Implementation Checklist

### Phase 1: Battery Monitoring
- [ ] Extend `PerformanceMetrics` with battery level
- [ ] Implement battery level monitoring (iOS)
- [ ] Add battery level to metrics updates
- [ ] Add battery monitoring enable/disable

### Phase 2: Thermal Monitoring
- [ ] Define `ThermalState` enum
- [ ] Extend `PerformanceMetrics` with thermal state
- [ ] Implement thermal state monitoring (iOS)
- [ ] Add thermal state to metrics updates

### Phase 3: Battery Optimization
- [ ] Implement `optimizeForBattery()` method
- [ ] Implement `shouldOptimizeForBattery()` logic
- [ ] Add frame rate reduction for battery
- [ ] Add CPU usage reduction for battery
- [ ] Add cache clearing for battery

### Phase 4: Thermal Optimization
- [ ] Implement `optimizeForThermal()` method
- [ ] Implement `shouldOptimizeForThermal()` logic
- [ ] Add aggressive CPU reduction for thermal
- [ ] Add frame rate reduction for thermal
- [ ] Add operation pausing for thermal

### Phase 5: Adaptive Strategy
- [ ] Implement `recommendedStrategy()` method
- [ ] Add automatic strategy switching
- [ ] Integrate with existing optimization methods
- [ ] Add adaptive frame rate adjustment

### Phase 6: Layer 1 Functions
- [ ] Extend `PlatformPerformanceL1.swift`
- [ ] Implement `platformOptimizePerformance_L1()` with battery/thermal
- [ ] Implement `platformGetBatteryThermalStatus_L1()`
- [ ] Add battery/thermal status views

### Phase 7: Testing & Documentation
- [ ] Write comprehensive tests (using mocks)
- [ ] Create usage guide (`PerformanceBatteryOptimizationGuide.md`)
- [ ] Add examples
- [ ] Update framework documentation
- [ ] Document adaptive strategies

## Design Decisions

### Why Extend Core Service?
- **Reusability**: Uses existing metrics and optimization infrastructure
- **Consistency**: Single service for all performance features
- **Integration**: Battery/thermal affects all optimizations

### Why Adaptive Strategy?
- **User Experience**: Automatically optimizes without user intervention
- **Battery Life**: Extends battery life when needed
- **Thermal Safety**: Prevents device overheating

### Why Frame Rate Control?
- **Battery Impact**: Lower frame rate saves significant battery
- **Thermal Impact**: Lower frame rate reduces heat generation
- **User Experience**: 30fps is acceptable for most content

## Related

- Issue #107 - Parent issue for Performance Service
- Issue #107a - Performance Service Core (dependency)
- `InternationalizationService.swift` - Reference implementation pattern

## Acceptance Criteria

- [ ] Battery level monitoring works on iOS
- [ ] Thermal state monitoring works on iOS
- [ ] Battery optimization works correctly
- [ ] Thermal optimization works correctly
- [ ] Adaptive strategy switching works
- [ ] Frame rate adjustment works
- [ ] CPU optimization works
- [ ] Layer 1 semantic functions are implemented
- [ ] Comprehensive tests pass (20+ tests)
- [ ] Documentation is complete
- [ ] Examples are provided
- [ ] All platforms (iOS, macOS, visionOS) are supported
