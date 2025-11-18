#!/usr/bin/env python3
"""
Script to analyze test suite performance using xcodebuild.
Identifies test suites that take longer than 1 second and helps fix them.
"""

import subprocess
import re
import time
import json
import sys
from pathlib import Path

def get_test_suites():
    """Get all test suite names from swift test --list-tests"""
    print("📋 Listing all test suites...")
    result = subprocess.run(
        ["swift", "test", "--list-tests"],
        cwd="/Users/schatt/code/github/6layer",
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"❌ Error listing tests: {result.stderr}")
        return []
    
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
        
        # Check if tests passed
        passed = result.returncode == 0
        
        status = "✅" if passed else "❌"
        print(f"{status} {execution_time:.3f}s")
        
        return {
            'suite': suite_name,
            'time': execution_time,
            'passed': passed,
            'timeout': False,
            'output': result.stdout + result.stderr
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
            'output': f"Test suite timed out after {timeout} seconds"
        }

def main():
    """Main function to analyze test performance"""
    print("🚀 Starting test performance analysis...\n")
    
    suites = get_test_suites()
    print(f"Found {len(suites)} test suites\n")
    
    results = []
    slow_suites = []
    timeout_suites = []
    
    for i, suite in enumerate(suites, 1):
        print(f"[{i}/{len(suites)}] ", end='')
        result = run_test_suite(suite)
        results.append(result)
        
        if result.get('timeout', False):
            timeout_suites.append(result)
        elif result['time'] > 1.0:
            slow_suites.append(result)
    
    # Summary
    print(f"\n📊 Performance Summary:")
    print(f"  Total suites: {len(suites)}")
    print(f"  Slow suites (>1s): {len(slow_suites)}")
    print(f"  Timeout suites (>30s): {len(timeout_suites)}")
    
    if timeout_suites:
        print(f"\n⏱️  Test Suites That Timed Out (>30 seconds):")
        for result in timeout_suites:
            print(f"  {result['suite']}: TIMEOUT")
    
    if slow_suites:
        print(f"\n🐌 Slow Test Suites (>1 second):")
        for result in sorted(slow_suites, key=lambda x: x['time'], reverse=True):
            print(f"  {result['suite']}: {result['time']:.3f}s")
    
    if slow_suites or timeout_suites:
        # Save results to file
        output_file = Path("/Users/schatt/code/github/6layer/slow_test_suites.json")
        all_slow = slow_suites + timeout_suites
        with open(output_file, 'w') as f:
            json.dump(all_slow, f, indent=2)
        print(f"\n💾 Results saved to {output_file}")
    else:
        print("\n✅ All test suites run in under 1 second!")
    
    return 0 if not slow_suites and not timeout_suites else 1

if __name__ == "__main__":
    sys.exit(main())

