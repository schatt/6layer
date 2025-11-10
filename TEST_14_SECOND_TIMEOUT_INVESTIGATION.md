# 14-Second Test Timeout Investigation

## Problem
Many tests are taking exactly **14.000 seconds**, suggesting a timeout rather than actual work.

## Observations
- Tests are running via `xcodebuild test` (not `swift test`)
- Many tests consistently show **14.000 seconds** execution time
- This is suspiciously uniform - suggests a timeout mechanism
- Previously fixed 4-second and 11-second timeouts, now seeing 14 seconds

## Potential Causes

### 1. Swift Testing Default Timeout (Most Likely)
When run via `xcodebuild`, Swift Testing may have a different default timeout than when run via `swift test`. The 14-second timeout could be:
- A default timeout in Swift Testing for xcodebuild execution
- A timeout that's applied when tests don't complete quickly
- A timeout related to async operations not being properly awaited

### 2. MainActor Blocking
Tests using `@MainActor` or `await MainActor.run` might be blocking if:
- The main actor is busy with other operations
- There's a deadlock or contention on the main actor
- Async operations aren't being properly awaited

### 3. ViewInspector Blocking
Tests using ViewInspector might be blocking if:
- ViewInspector operations are taking too long
- There's a timeout in ViewInspector itself
- View inspection is waiting for view updates that never complete

### 4. CoreData Semaphore Timeout
The `CoreDataTestUtilities.swift` has a 5-second semaphore timeout, but this shouldn't cause 14-second timeouts unless there are multiple such operations.

## Investigation Steps

### Immediate Actions
1. **Check Swift Testing timeout configuration** - Look for default timeout settings
2. **Profile a specific 14-second test** - Use Instruments to see what's blocking
3. **Check if tests are actually completing** - Or if they're timing out and being marked as passed

### Code Patterns to Investigate
1. **Async tests without proper awaiting**:
   ```swift
   @Test func testSomething() async {
       await MainActor.run {
           // Is this actually completing?
       }
   }
   ```

2. **MainActor isolation issues**:
   ```swift
   @MainActor
   class SomeTest {
       // Are these tests blocking on main actor?
   }
   ```

3. **ViewInspector operations**:
   ```swift
   let inspected = view.tryInspect()
   // Are ViewInspector operations timing out?
   ```

## Next Steps

1. **Run a single test with verbose logging** to see what's happening
2. **Check Swift Testing source** for default timeout values
3. **Profile a 14-second test** with Instruments to identify the bottleneck
4. **Compare xcodebuild vs swift test** execution times for the same test
5. **Check if tests are actually completing** or if they're being killed by timeout

## Related Issues
- Previously fixed 4-second timeouts (DispatchQueue.main.async issue)
- Previously fixed 11-second timeouts (similar async issue)
- Now seeing 14-second timeouts (possibly related to Swift Testing default timeout)

## Hypothesis
The 14-second timeout is likely Swift Testing's default timeout when tests are run via `xcodebuild`. Tests that don't complete quickly enough are being killed at 14 seconds, but the test framework might be reporting this as "passed" with a 14-second duration rather than as a timeout failure.

