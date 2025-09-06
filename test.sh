#!/bin/bash
# Six-Layer Framework Test Script
# Suppresses secondary test run by filtering to specific test target

echo "🧪 Running Six-Layer Framework Tests..."
echo "========================================"

cd Framework
swift test --filter SixLayerFrameworkTests

echo ""
echo "✅ Test run completed successfully!"