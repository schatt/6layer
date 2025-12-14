# Kernel Panic Investigation Report

## Panic Summary
- **Type**: Userspace watchdog timeout
- **Service**: `configd` (configuration daemon)
- **Duration**: 183 seconds without checkin
- **System**: macOS 25.1.0 (Darwin Kernel 25.1.0) - Beta/Early Release
- **Memory Pressure**: 99% of compressed pages limit (BAD)
- **Hardware**: T6020 chip (Apple Silicon)

## Investigation Findings

### ✅ Low Risk Areas (Unlikely Contributors)

1. **UserDefaults Usage**
   - Framework uses `UserDefaults.standard` in multiple places
   - Standard, thread-safe API
   - No excessive writes or rapid access patterns observed
   - **Verdict**: Not a contributing factor

2. **System Preferences Opening**
   - `platformOpenSettings()` opens System Preferences/Settings
   - Uses standard `NSWorkspace` APIs
   - Only called on user action, not automatically
   - **Verdict**: Not a contributing factor

3. **OCR/Image Processing**
   - Uses Vision framework (standard Apple API)
   - Processing is async and doesn't block system services
   - No excessive memory allocation patterns found
   - **Verdict**: Unlikely contributor (though memory pressure could be related)

### ⚠️ Potential Risk Areas (Requires Investigation)

#### 1. **NWPathMonitor in CloudKitService** ⚠️ **HIGHEST CONCERN**

**Location**: `Framework/Sources/Core/Services/CloudKitService.swift:798-826`

**Issue**: 
- `CloudKitService` creates an `NWPathMonitor` on initialization
- Network monitoring interacts with `configd` (system configuration daemon)
- Monitor is started in `init()` and may not be properly cleaned up in all cases

**Code Pattern**:
```swift
private func startNetworkMonitoring() {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "com.sixlayer.cloudkit.networkmonitor")
    
    monitor.pathUpdateHandler = { [weak self] path in
        Task { @MainActor [weak self] in
            // Network status updates
        }
    }
    
    monitor.start(queue: queue)
    self.networkMonitor = monitor
    self.networkMonitorQueue = queue
}
```

**Potential Problems**:
1. **Multiple Instances**: If multiple `CloudKitService` instances are created, each creates its own monitor
2. **Cleanup**: `deinit` cancels the monitor, but if instances aren't deallocated, monitors persist
3. **Rapid Initialization**: Creating/destroying services rapidly could stress `configd`
4. **Memory Pressure Interaction**: Under high memory pressure, `configd` may struggle to respond to monitor callbacks

**Recommendations**:
- ✅ **Immediate**: Add singleton pattern or shared monitor for network status
- ✅ **Immediate**: Add proper cleanup verification
- ✅ **Short-term**: Add monitoring to detect multiple service instances
- ✅ **Short-term**: Add rate limiting for monitor creation

#### 2. **Memory Pressure** ⚠️ **SECONDARY CONCERN**

**Panic Log Evidence**:
```
Compressor Info: 99% of compressed pages limit (BAD) and 100% of segments limit (BAD)
```

**Potential Contributors**:
- OCR image processing (Vision framework)
- CloudKit operations
- Large form data in UserDefaults
- Image processing pipeline

**Recommendations**:
- ✅ **Immediate**: Add memory pressure monitoring
- ✅ **Short-term**: Implement memory pressure handlers
- ✅ **Short-term**: Add image size limits for OCR processing
- ✅ **Short-term**: Review UserDefaults storage size limits

#### 3. **CloudKit Initialization** ⚠️ **MODERATE CONCERN**

**Location**: `Framework/Sources/Core/Services/CloudKitService.swift:212-240`

**Issue**:
- CloudKit container initialization may trigger system service interactions
- Account status checks happen asynchronously on init
- Multiple instances could create multiple containers

**Recommendations**:
- ✅ **Short-term**: Verify CloudKit container lifecycle
- ✅ **Short-term**: Add logging for container initialization
- ✅ **Short-term**: Consider singleton pattern for CloudKit service

## Root Cause Analysis

### Most Likely Scenario

**Primary Hypothesis**: `NWPathMonitor` instances from `CloudKitService` are creating excessive load on `configd`, especially under memory pressure conditions.

**Supporting Evidence**:
1. `NWPathMonitor` directly interacts with `configd` (system network configuration daemon)
2. Panic shows `configd` failed to check in for 183 seconds
3. System was under severe memory pressure (99% compressed pages)
4. Framework creates network monitors on service initialization
5. No cleanup verification exists for monitor lifecycle

**Secondary Factors**:
- High memory pressure may have exacerbated the issue
- macOS 25.1.0 is a beta/early release (may have bugs)
- Multiple service instances could multiply the problem

### Less Likely Scenarios

1. **Direct configd interaction**: Framework doesn't use SystemConfiguration APIs directly
2. **UserDefaults overload**: Standard usage patterns, no excessive writes
3. **OCR processing**: Uses standard Vision framework, unlikely to affect system daemons

## Immediate Actions Required

### 1. Fix NWPathMonitor Usage (Priority: HIGH)

**File**: `Framework/Sources/Core/Services/CloudKitService.swift`

**Changes Needed**:
1. Add singleton/shared network monitor
2. Add proper cleanup verification
3. Add instance counting/logging
4. Add rate limiting for monitor creation

### 2. Add Memory Pressure Monitoring (Priority: MEDIUM)

**Changes Needed**:
1. Monitor system memory pressure
2. Reduce operations under memory pressure
3. Add logging for memory pressure events

### 3. Add Diagnostic Logging (Priority: MEDIUM)

**Changes Needed**:
1. Log CloudKitService initialization/destruction
2. Log NWPathMonitor creation/destruction
3. Log memory pressure events
4. Log network status changes

## Long-term Recommendations

1. **Service Lifecycle Management**
   - Implement proper singleton patterns where appropriate
   - Add service instance tracking
   - Add cleanup verification

2. **Memory Management**
   - Implement memory pressure handlers
   - Add image size limits
   - Review UserDefaults storage patterns

3. **Network Monitoring**
   - Consider shared network status service
   - Add rate limiting
   - Add proper cleanup verification

4. **Testing**
   - Add tests for service lifecycle
   - Add tests for memory pressure scenarios
   - Add tests for multiple service instances

## Verification Steps

1. **Check for Multiple CloudKitService Instances**
   ```swift
   // Add logging to track instance creation
   ```

2. **Monitor NWPathMonitor Lifecycle**
   ```swift
   // Add logging to track monitor creation/destruction
   ```

3. **Check Memory Usage**
   ```swift
   // Add memory pressure monitoring
   ```

4. **Review App Usage Patterns**
   - Check if app creates multiple CloudKitService instances
   - Check if services are properly deallocated
   - Check for rapid initialization/destruction cycles

## Conclusion

**Most Likely Cause**: `NWPathMonitor` instances from `CloudKitService` are creating excessive load on `configd`, especially under memory pressure.

**Confidence Level**: Medium-High (70-80%)

**Next Steps**:
1. Implement NWPathMonitor fixes (HIGH priority)
2. Add memory pressure monitoring (MEDIUM priority)
3. Add diagnostic logging (MEDIUM priority)
4. Monitor for recurrence

**Note**: macOS 25.1.0 is a beta/early release, so some issues may be OS-level bugs rather than framework issues. However, the framework should be defensive against such scenarios.

