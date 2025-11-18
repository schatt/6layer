#!/usr/bin/env python3
"""
Script to analyze test suite performance using xcodebuild.
Identifies test suites that take longer than 1 second and helps fix them.
Also detects compilation errors and fatal errors to prevent false success reports.
"""

import subprocess
import re
import time
import json
import sys
from pathlib import Path
from datetime import datetime

def has_compilation_errors(output):
    """Check if output contains compilation errors (excluding warnings)"""
    # First, check for explicit error patterns that indicate actual compilation failures
    # These patterns indicate real errors, not warnings
    error_patterns = [
        r'BUILD FAILED',
        r'CompileSwiftSources failed',
        r'xcodebuild: error:',
        r'error:.*cannot find',
        r'error:.*has no member',
        r'error:.*is not a member type',
        r'error:.*expected',
        r'error:.*missing',
        r'error:.*invalid',
        r'error:.*type.*has no member',
        r'error:.*value of type.*has no member',
        r'error:.*cannot infer',
        r'error:.*ambiguous',
        r'error:.*conformance',
        r'error:.*protocol',
        r'error:.*syntax',
        r'error:.*compilation',
    ]
    
    # Check if build actually failed - if "Build complete!" appears, it succeeded
    if re.search(r'Build complete!', output, re.IGNORECASE):
        return False
    
    # Check for error: but exclude deprecation-related messages and warnings
    # Warnings are NOT errors - only actual compilation errors should block
    lines = output.split('\n')
    has_real_error = False
    
    for line in lines:
        # Skip all warnings - warnings don't prevent compilation
        if re.search(r'warning:', line, re.IGNORECASE):
            continue
        # Skip deprecation notes
        if re.search(r'note:.*deprecated', line, re.IGNORECASE):
            continue
        if re.search(r'note:.*obsoleted', line, re.IGNORECASE):
            continue
        if re.search(r'\[#DeprecatedDeclaration\]', line, re.IGNORECASE):
            continue
        
        # Check for actual error patterns (not warnings)
        if re.search(r'error:', line, re.IGNORECASE):
            # Make sure it's not a deprecation-related error
            if not re.search(r'deprecated|obsoleted', line, re.IGNORECASE):
                has_real_error = True
                break
        
        # Check for other error patterns
        for pattern in error_patterns:
            if re.search(pattern, line, re.IGNORECASE):
                has_real_error = True
                break
        if has_real_error:
            break
    
    return has_real_error

def has_fatal_errors(output):
    """Check if output contains fatal errors"""
    # Look for fatal error patterns
    fatal_patterns = [
        r'Fatal error:',
        r'fatal error:',
        r'\bfatalError\b',  # Swift fatalError() calls
        r'EXC_BAD_ACCESS',
        r'EXC_CRASH',
        r'terminated by signal',
    ]
    for pattern in fatal_patterns:
        if re.search(pattern, output, re.IGNORECASE):
            return True
    return False

def get_test_suites():
    """Get all test suite names from swift test --list-tests"""
    print("📋 Listing all test suites...")
    result = subprocess.run(
        ["swift", "test", "--list-tests"],
        cwd="/Users/schatt/code/github/6layer",
        capture_output=True,
        text=True
    )
    
    # Combine stdout and stderr for error detection
    full_output = result.stdout + result.stderr
    
    # Check for compilation errors and fatal errors
    compilation_error = has_compilation_errors(full_output)
    fatal_error = has_fatal_errors(full_output)
    
    # If there are errors, return None to indicate failure
    if compilation_error or fatal_error or result.returncode != 0:
        if fatal_error:
            print(f"💥 Fatal error detected while listing tests!")
        elif compilation_error:
            print(f"🔨 Compilation errors detected while listing tests!")
        else:
            print(f"❌ Error listing tests (returncode: {result.returncode})")
        
        # Print relevant error output (last 50 lines to avoid overwhelming output)
        error_lines = full_output.split('\n')
        if len(error_lines) > 50:
            print("\n... (showing last 50 lines of output) ...")
            error_lines = error_lines[-50:]
        print("\n".join(error_lines))
        return None  # Return None to indicate failure
    
    # Extract unique test suite names (format: TestTarget.TestSuite)
    suites = set()
    for line in result.stdout.split('\n'):
        if '.' in line and '/' in line:
            suite = line.split('/')[0].strip()
            if suite.startswith('SixLayerFrameworkTests.') or suite.startswith('SixLayerFrameworkExternalIntegrationTests.'):
                suites.add(suite)
    
    return sorted(suites)

def write_log_file(log_file, timestamp, suites, results, slow_suites, timeout_suites, 
                   compilation_error_suites, fatal_error_suites, failed_suites, completed=False):
    """Write or update the log file with current results"""
    # Create summary results
    summary_results = []
    for result in results:
        summary = {
            'suite': result['suite'],
            'time': result['time'],
            'passed': result.get('passed', False),
            'timeout': result.get('timeout', False),
            'compilation_error': result.get('compilation_error', False),
            'fatal_error': result.get('fatal_error', False),
            'returncode': result.get('returncode')
        }
        # Only include output if there was an error (to keep file size reasonable)
        if not result.get('passed', False):
            summary['output'] = result.get('output', '')[:1000]  # First 1000 chars of output
        summary_results.append(summary)
    
    log_data = {
        'timestamp': timestamp,
        'total_suites': len(suites),
        'completed': completed,
        'progress': f"{len(results)}/{len(suites)}" if suites else "0/0",
        'passed': len([r for r in results if r.get('passed', False)]),
        'failed': len(failed_suites),
        'compilation_errors': len(compilation_error_suites),
        'fatal_errors': len(fatal_error_suites),
        'timeouts': len(timeout_suites),
        'slow_suites': len(slow_suites),
        'note': 'Times include ~3s overhead per suite (xcodebuild startup/workspace loading). Actual test execution is typically much faster.',
        'results': summary_results
    }
    
    with open(log_file, 'w') as f:
        json.dump(log_data, f, indent=2)

def run_test_suite(suite_name, timeout=30):
    """Run a single test suite using xcodebuild and measure execution time"""
    print(f"  ⏱️  Running {suite_name}...", end=' ', flush=True)
    
    start_time = time.time()
    
    # Run the test suite using xcodebuild
    # Format: -only-testing:TestTarget/TestSuite
    test_identifier = suite_name.replace('.', '/')
    
    try:
        result = subprocess.run(
            [
                "xcodebuild", "test",
                "-workspace", ".swiftpm/xcode/package.xcworkspace",
                "-scheme", "SixLayerFramework",
                "-destination", "platform=macOS",
                "-only-testing", test_identifier,
                "-quiet"
            ],
            cwd="/Users/schatt/code/github/6layer",
            capture_output=True,
            text=True,
            timeout=timeout
        )
        
        end_time = time.time()
        execution_time = end_time - start_time
        
        # Combine stdout and stderr for analysis
        full_output = result.stdout + result.stderr
        
        # Check for compilation errors and fatal errors
        compilation_error = has_compilation_errors(full_output)
        fatal_error = has_fatal_errors(full_output)
        
        # Tests pass only if return code is 0 AND no compilation/fatal errors
        passed = (result.returncode == 0 and 
                 not compilation_error and 
                 not fatal_error)
        
        # Determine status indicator
        if fatal_error:
            status = "💥"  # Fatal error
        elif compilation_error:
            status = "🔨"  # Compilation error
        elif result.returncode != 0:
            status = "❌"  # Test failure
        else:
            status = "✅"  # Success
        
        print(f"{status} {execution_time:.3f}s")
        
        return {
            'suite': suite_name,
            'time': execution_time,
            'passed': passed,
            'timeout': False,
            'compilation_error': compilation_error,
            'fatal_error': fatal_error,
            'returncode': result.returncode,
            'output': full_output
        }
    except subprocess.TimeoutExpired:
        end_time = time.time()
        execution_time = end_time - start_time
        
        print(f"⏱️  TIMEOUT ({execution_time:.3f}s)")
        
        return {
            'suite': suite_name,
            'time': execution_time,
            'passed': False,
            'timeout': True,
            'compilation_error': False,
            'fatal_error': False,
            'returncode': None,
            'output': f"Test suite timed out after {timeout} seconds"
        }

def main():
    """Main function to analyze test performance"""
    print("🚀 Starting test performance analysis...\n")
    
    # Create timestamped log file at the start
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log_file = Path(f"/Users/schatt/code/github/6layer/test_performance_{timestamp}.json")
    
    suites = get_test_suites()
    
    # If get_test_suites returns None, there were compilation/fatal errors
    if suites is None:
        print("\n❌ Cannot proceed: compilation or fatal errors detected during test listing.")
        print("Please fix compilation errors before running test performance analysis.")
        return 1
    
    if len(suites) == 0:
        print("⚠️  Warning: No test suites found. This might indicate a problem.")
        print("Checking if this is due to compilation errors...")
        # Try to get more info by running a test command
        check_result = subprocess.run(
            ["swift", "test", "--list-tests"],
            cwd="/Users/schatt/code/github/6layer",
            capture_output=True,
            text=True
        )
        full_output = check_result.stdout + check_result.stderr
        if has_compilation_errors(full_output) or has_fatal_errors(full_output):
            print("❌ Compilation or fatal errors detected. Cannot analyze test performance.")
            return 1
        else:
            print("ℹ️  No compilation errors, but no test suites found. Proceeding with empty analysis.")
    
    print(f"Found {len(suites)} test suites\n")
    print(f"📝 Logging results to {log_file.name} (updating as tests complete)")
    print(f"ℹ️  Note: Times include ~3s overhead per suite (xcodebuild startup/workspace loading).")
    print(f"    Actual test execution is typically much faster.\n")
    
    # Initialize log file with empty results
    results = []
    write_log_file(log_file, timestamp, suites, results, [], [], [], [], [], completed=False)
    
    slow_suites = []
    timeout_suites = []
    compilation_error_suites = []
    fatal_error_suites = []
    failed_suites = []
    
    for i, suite in enumerate(suites, 1):
        print(f"[{i}/{len(suites)}] ", end='')
        result = run_test_suite(suite)
        results.append(result)
        
        if result.get('timeout', False):
            timeout_suites.append(result)
        elif result.get('fatal_error', False):
            fatal_error_suites.append(result)
        elif result.get('compilation_error', False):
            compilation_error_suites.append(result)
        elif not result.get('passed', False):
            failed_suites.append(result)
        elif result['time'] > 1.0:
            slow_suites.append(result)
        
        # Update log file after each test completes
        write_log_file(log_file, timestamp, suites, results, slow_suites, timeout_suites,
                      compilation_error_suites, fatal_error_suites, failed_suites, completed=False)
    
    # Summary
    print(f"\n📊 Performance Summary:")
    print(f"  Total suites: {len(suites)}")
    print(f"  ✅ Passed: {len([r for r in results if r.get('passed', False)])}")
    print(f"  💥 Fatal errors: {len(fatal_error_suites)}")
    print(f"  🔨 Compilation errors: {len(compilation_error_suites)}")
    print(f"  ❌ Test failures: {len(failed_suites)}")
    print(f"  🐌 Slow suites (>1s): {len(slow_suites)}")
    print(f"  ⏱️  Timeout suites (>30s): {len(timeout_suites)}")
    
    if fatal_error_suites:
        print(f"\n💥 Test Suites With Fatal Errors:")
        for result in fatal_error_suites:
            print(f"  {result['suite']}")
    
    if compilation_error_suites:
        print(f"\n🔨 Test Suites With Compilation Errors:")
        for result in compilation_error_suites:
            print(f"  {result['suite']}")
    
    if failed_suites:
        print(f"\n❌ Test Suites That Failed:")
        for result in failed_suites:
            print(f"  {result['suite']} (returncode: {result.get('returncode', 'unknown')})")
    
    if timeout_suites:
        print(f"\n⏱️  Test Suites That Timed Out (>30 seconds):")
        for result in timeout_suites:
            print(f"  {result['suite']}: TIMEOUT")
    
    if slow_suites:
        print(f"\n🐌 Slow Test Suites (>1 second):")
        for result in sorted(slow_suites, key=lambda x: x['time'], reverse=True):
            print(f"  {result['suite']}: {result['time']:.3f}s")
    
    # Save results if there are any issues
    issues = (slow_suites + timeout_suites + compilation_error_suites + 
              fatal_error_suites + failed_suites)
    
    if issues:
        output_file = Path("/Users/schatt/code/github/6layer/slow_test_suites.json")
        with open(output_file, 'w') as f:
            json.dump(issues, f, indent=2)
        print(f"\n💾 Results saved to {output_file}")
    else:
        print("\n✅ All test suites passed and run in under 1 second!")
    
    # Finalize log file with completed status
    write_log_file(log_file, timestamp, suites, results, slow_suites, timeout_suites,
                  compilation_error_suites, fatal_error_suites, failed_suites, completed=True)
    print(f"📝 Final results logged to {log_file.name}")
    
    # Return non-zero exit code if there are any failures
    has_failures = (len(fatal_error_suites) > 0 or 
                   len(compilation_error_suites) > 0 or 
                   len(failed_suites) > 0 or 
                   len(timeout_suites) > 0)
    
    return 0 if not has_failures else 1

if __name__ == "__main__":
    sys.exit(main())

