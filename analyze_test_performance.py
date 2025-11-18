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

def has_compilation_errors(output):
    """Check if output contains compilation errors"""
    # Look for common compilation error patterns
    error_patterns = [
        r'error:',
        r'BUILD FAILED',
        r'CompileSwiftSources failed',
        r'xcodebuild: error:',
    ]
    for pattern in error_patterns:
        if re.search(pattern, output, re.IGNORECASE):
            return True
    return False

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
    
    results = []
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
    
    # Return non-zero exit code if there are any failures
    has_failures = (len(fatal_error_suites) > 0 or 
                   len(compilation_error_suites) > 0 or 
                   len(failed_suites) > 0 or 
                   len(timeout_suites) > 0)
    
    return 0 if not has_failures else 1

if __name__ == "__main__":
    sys.exit(main())

