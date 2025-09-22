# SixLayer Framework Makefile
# Includes build quality gates

.PHONY: build test quality-gate pre-release-check clean

# Default target
all: quality-gate

# Build the framework
build:
	swift build --package-path Framework

# Run tests
test:
	swift test --package-path Framework

# Quality gate: treats warnings as failures
quality-gate:
	@echo "🔍 Running Build Quality Gate..."
	@./scripts/build-quality-check.sh

# Clean build artifacts
clean:
	swift package --package-path Framework clean
	rm -rf .build

# Development workflow
dev: clean build test

# Pre-release check (mandatory before any release)
pre-release-check:
	@echo "🚀 Running Pre-Release Check..."
	@./scripts/pre-release-check.sh

# CI workflow
ci: quality-gate

# Release workflow (includes mandatory pre-release check)
release: pre-release-check
	@echo "✅ All release checks passed - ready for release"
