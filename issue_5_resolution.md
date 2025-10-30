# Issue 5 Resolution: Deterministic Field Ordering for IntelligentFormView

Implemented and integrated deterministic field ordering to allow explicit, stable display order:

- API: `FieldOrderRules` (explicit lists, per-field weights, `FieldGroup`s, trait overrides), `FieldTrait`, `FieldGroup`, and `FieldOrderResolver`.
- Integration: `IntelligentFormView` consumes rules via `orderRulesProvider`, using `TaskLocal` for `DataAnalysisResult`. Default fallback prioritizes `title`/`name` first (not alphabetic-by-type).
- Debug/Docs: `inspectEffectiveOrder` helper; example usage; docs updated. Added docs warning: mixing manual `.accessibilityIdentifier(...)` with `.named`/`.exactNamed` has undefined priority—avoid mixing.
- Tests: Resolver unit tests added; removed undefined-behavior tests that expected overriding manual IDs.

This addresses the request for explicit field order, including trait-aware overrides, and restores `platformIntelligentForm` usage.
