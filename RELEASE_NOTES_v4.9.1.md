# SixLayer v4.9.1 Release Notes

## Highlights
- Deterministic field ordering for `IntelligentFormView` using `FieldOrderRules`:
  - Explicit order lists, per-field weights, `FieldGroup`s, and trait-specific overrides (`.compact`/`.regular`).
  - App-wide runtime provider via `IntelligentFormView.orderRulesProvider` and/or per-hints `fieldOrderRules`.
  - Default fallback prioritizes `title`/`name` first (not alphabetic-by-type).

## Developer Experience
- Debug helper: `IntelligentFormView.inspectEffectiveOrder(analysis:)`.
- Example: `Framework/Examples/FieldOrderingExample.swift`.

## Accessibility
- Disabled mode: test helper and regex handling corrected; stable identifier generation in UI-test mode.
- Documentation clarifies: mixing manual `.accessibilityIdentifier(...)` with `.named`/`.exactNamed` on the same view has undefined priority; avoid mixing.

## Platform Optimization (L5)
- macOS configuration now uses a positive default for `minTouchTarget`.

## Tests
- New: `FieldOrderResolver` unit tests for explicit lists, weights, groups, and trait overrides.
- Removed tests asserting override of manually-set accessibility identifiers (undefined behavior).

## Migration Notes
- For deterministic ordering: install an app-level `orderRulesProvider`, or attach `fieldOrderRules` via hints.
- Prefer not to mix `.named` with manual `.accessibilityIdentifier(...)` on the same element.

## Issue
- Resolves Issue #5: Enable explicit field display order for `IntelligentFormView` with trait-aware overrides.
