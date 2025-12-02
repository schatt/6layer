# AI Agent Guide for SixLayer Framework v5.7.0

This guide summarizes the version-specific context for v5.7.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v5.7.0** (see `Package.swift` comment or release tags).
2. Understand that **OCR structured extraction** now automatically consumes hints files when `OCRContext.entityName` is provided.
3. Respect the opt-in nature of hints: `entityName == nil` means “developer chose not to load hints”.
4. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v5.7.0

### Configurable OCR Entity Mapping
- `OCRContext` has `entityName: String?` so each project decides how document types map to Core Data entities/hints.
- No more framework-owned mappings—projects remain authoritative.

### Automatic Hints Loading & Regex Conversion
- `OCRService` loads `{entityName}.hints`, converts each field’s `ocrHints` array into regex patterns, and merges them with built-in/custom hints.
- Regex format: `(?i)(hint1|hint2|...)\\s*[:=]?\\s*([\\d.,]+)`

### Calculation Group Evaluation
- After extraction, `applyCalculationGroups` walks hint-defined `CalculationGroup`s (priority ordered) and uses `NSExpression` to derive missing values.
- Automatically skips groups if dependencies are missing or `entityName` is nil.

### Stability Fix
- `PlatformPhotoComponentsLayer4IntegrationTests` now create real image data for simulated captures/selections to ensure valid `PlatformImage` dimensions on macOS.

## 🧠 Guidance for v5.7.0 Work

### 1. Entity Mapping Strategy
- Encourage developers to maintain their own enum → entity mappings (e.g., `.fuelReceipt → "FuelPurchase"`).
- When adding new structured extraction features, prefer `entityName` over any hard-coded mapping logic.
- If `entityName` is absent, do **not** attempt to infer or auto-load hints—this is an intentional opt-out.

### 2. Automatic Hints Usage
- Hints loading is only available in `.automatic` or `.hybrid` extraction modes.
- Custom `extractionHints` still override everything; ensure precedence order remains: built-in → hints file → custom hints.
- Always keep locale-awareness in mind: `FileBasedDataHintsLoader` already supports `Locale`, so new hints features should respect localization.

### 3. Calculation Groups
- Ensure formulas reference field IDs exactly as they appear in hints.
- Avoid evaluating expressions when dependencies are missing or non-numeric—return `nil`.
- When extending calculation logic, continue using `NSExpression` for predictable parsing.

### 4. Testing Expectations
- Follow TDD: add/adjust tests in `OCRServiceAutomaticHintsTests.swift` before modifying implementation.
- Cover both sides of capability branches (entityName provided vs. nil, automatic vs. custom extraction modes).
- When touching photo integration tests, use `createRealImageData()` to avoid flaky zero-sized images.

## ✅ Best Practices

1. **Keep hints optional**: Never force `entityName` if the app does not need hints.
2. **Document both paths**: When writing docs/examples, show how to opt in (with entityName) and opt out (nil, custom hints).
3. **Preserve precedence**: Built-in → hints file → custom hints is intentional; maintain this order when expanding pattern logic.
4. **Respect locale loading**: Pass through `Locale(identifier: context.language.rawValue)` whenever hints are loaded.
5. **Use helper functions**: `createRealImageData()` and `simulatePhotoCaptureWithData` exist to keep tests deterministic—re-use them.
6. **Clean release process**: Before tagging releases, ensure docs (`RELEASES.md`, `README`, `PROJECT_STATUS.md`, etc.) mention v5.7.0 per release checklist.

## 🔗 Reference Documentation

- `Framework/Sources/Core/Services/OCRService.swift` – Hints loading and calculation group logic.
- `Framework/Sources/Core/Models/PlatformOCRTypes.swift` – `OCRContext` definition with `entityName`.
- `Development/Tests/SixLayerFrameworkUnitTests/Features/OCR/OCRServiceAutomaticHintsTests.swift` – Canonical tests for entityName behavior.
- `Development/RELEASE_v5.7.0.md` – Full release notes.
- `Development/AI_AGENT.md` – General AI assistant guidance.

Follow these guidelines to keep contributions aligned with the v5.7.0 architecture and release objectives.

