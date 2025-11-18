# Archived Fix Scripts

This directory contains one-time migration scripts that were used to fix specific issues in the codebase. These scripts are kept for historical reference but are no longer needed for ongoing development.

## Script Categories

### Compilation/Test Fixes
- `fix_compilation_errors.py` / `.sh` - Fixed BaseTestClass changes and compilation errors
- `fix_compilation_systematic.py` - Systematic compilation fixes
- `fix_test_classes.py` - Fixed test class issues
- `fix_test_function_signatures.py` - Fixed function signatures
- `fix_test_isolation.py` / `.sh` - Fixed test isolation
- `fix_testconfig_unwrapping.py` - Fixed test config issues
- `fix_all_tests.sh` - Comprehensive test fixes

### MainActor/Actor Isolation
- `fix_mainactor_tests.py` - Fixed MainActor test issues
- `fix_mainactor_wrappers.py` - Fixed MainActor wrappers
- `fix_mainactor_timeouts.py` - Fixed MainActor timeouts
- `fix_remaining_mainactor_wrappers.py` - Remaining MainActor fixes
- `fix_actor_isolation.py` - Fixed actor isolation
- `fix_actor_isolation_tests.py` - Fixed actor isolation tests

### ViewInspector
- `fix_viewinspector_tests.py` - Fixed ViewInspector tests
- `fix_viewinspector_tests_v2.py` - Version 2 fixes
- `fix_viewinspector_tests_v3.py` - Version 3 fixes
- `fix_macos_viewinspector_tests.py` - macOS ViewInspector fixes
- `fix_viewinspector_conditionals.sh` - ViewInspector conditionals

### Suite Annotations (Development/scripts)
- `fix_duplicate_suite_annotations.py` - Fixed duplicate suite annotations
- `fix_all_suite_placements.py` - Fixed suite placements
- `fix_suite_on_imports.py` - Fixed suite on imports
- `fix_suite_between_imports.py` - Fixed suite between imports

### Other One-Time Fixes
- `fix_shared_test_data.py` - Fixed shared test data
- `fix_expected_pattern.py` - Fixed expected patterns
- `fix_duplicate_let.py` - Fixed duplicate let declarations
- `fix_missing_braces.py` - Fixed missing braces
- `fix_super_class_issues.py` - Fixed super class issues
- `fix_brace_balance.py` - Fixed brace balance
- `fix_compiler_warnings.py` - Fixed compiler warnings
- `fix_dynamic_form_fields.sh` - Fixed dynamic form fields
- `fix_missing_hints.sh` - Fixed missing hints
- `fix_nil_comparisons.sh` - Fixed nil comparisons
- `fix_test_issues.sh` - Fixed test issues
- `fix_visionos_switches.sh` - Fixed visionOS switches

## Active Scripts

Scripts that are still useful for ongoing maintenance are kept in the parent `scripts/` directory:
- `scripts/fix_accessibility_tests.py` - Has documentation, may be useful for future fixes
- `scripts/fix_component_label_text_tests.py` - May be useful for similar fixes
- `scripts/fix_crossplatform_accessibility_tests.py` - May be useful for cross-platform fixes
- `scripts/fix_multiline_expects.py` - May be useful for test formatting
- `scripts/fix_remaining_accessibility_tests.py` - May be useful for remaining fixes

## Archive Date
November 18, 2025

## Rationale
These scripts fixed specific issues that are now resolved. The test suite is passing (2692 tests), and these one-time migration scripts are no longer needed for ongoing development. They are kept for historical reference only.

