# Fix Scripts Cleanup Plan

## Overview
This document categorizes fix scripts to determine which should be kept, archived, or removed.

## Scripts to KEEP (in `scripts/` directory)
These have documentation and may be useful for ongoing maintenance:

- `scripts/fix_accessibility_tests.py` - Has README, may be useful for future accessibility test fixes
- `scripts/fix_component_label_text_tests.py` - May be useful for similar fixes
- `scripts/fix_crossplatform_accessibility_tests.py` - May be useful for cross-platform fixes
- `scripts/fix_multiline_expects.py` - May be useful for test formatting
- `scripts/fix_remaining_accessibility_tests.py` - May be useful for remaining fixes

## Scripts to ARCHIVE (one-time migration scripts)
These fixed specific issues that are now resolved. Archive to `scripts/archive/`:

### Compilation/Test Fixes (already applied):
- `fix_compilation_errors.py` - Fixed BaseTestClass changes
- `fix_compilation_errors.sh` - Fixed compilation errors
- `fix_compilation_systematic.py` - Systematic compilation fixes
- `fix_test_classes.py` - Fixed test class issues
- `fix_test_function_signatures.py` - Fixed function signatures
- `fix_test_isolation.py` / `.sh` - Fixed test isolation
- `fix_testconfig_unwrapping.py` - Fixed test config issues
- `fix_all_tests.sh` - Comprehensive test fixes

### MainActor/Actor Isolation (already applied):
- `fix_mainactor_tests.py` - Fixed MainActor test issues
- `fix_mainactor_wrappers.py` - Fixed MainActor wrappers
- `fix_mainactor_timeouts.py` - Fixed MainActor timeouts
- `fix_remaining_mainactor_wrappers.py` - Remaining MainActor fixes
- `fix_actor_isolation.py` - Fixed actor isolation
- `fix_actor_isolation_tests.py` - Fixed actor isolation tests

### ViewInspector (already applied):
- `fix_viewinspector_tests.py` - Fixed ViewInspector tests
- `fix_viewinspector_tests_v2.py` - Version 2 fixes
- `fix_viewinspector_tests_v3.py` - Version 3 fixes
- `fix_macos_viewinspector_tests.py` - macOS ViewInspector fixes
- `fix_viewinspector_conditionals.sh` - ViewInspector conditionals

### Other One-Time Fixes:
- `fix_shared_test_data.py` - Fixed shared test data
- `fix_expected_pattern.py` - Fixed expected patterns
- `fix_duplicate_let.py` - Fixed duplicate let declarations
- `fix_missing_braces.py` - Fixed missing braces
- `fix_super_class_issues.py` - Fixed super class issues
- `fix_brace_balance.py` - Fixed brace balance
- `fix_compiler_warnings.py` - Fixed compiler warnings

### Shell Scripts (already applied):
- `fix_dynamic_form_fields.sh` - Fixed dynamic form fields
- `fix_missing_hints.sh` - Fixed missing hints
- `fix_nil_comparisons.sh` - Fixed nil comparisons
- `fix_test_issues.sh` - Fixed test issues
- `fix_visionos_switches.sh` - Fixed visionOS switches

## Scripts to REMOVE (empty or obsolete):
- `fix_macos_tests.sh` - Empty file

## Recommendation

1. **Move scripts to archive**: Create `scripts/archive/` and move one-time migration scripts there
2. **Keep documented scripts**: Keep scripts in `scripts/` directory that have documentation
3. **Remove empty scripts**: Delete empty or clearly obsolete scripts
4. **Update .gitignore**: Consider ignoring archived scripts if desired

## Action Plan

```bash
# Create archive directory
mkdir -p scripts/archive

# Move one-time migration scripts to archive
mv fix_*.py scripts/archive/ 2>/dev/null
mv fix_*.sh scripts/archive/ 2>/dev/null

# Keep scripts/ directory scripts (they have documentation)
# (No action needed - they're already in scripts/)

# Remove empty scripts
rm fix_macos_tests.sh  # Empty file
```

## Rationale

- **Tests are passing**: The fixes have been applied and are working
- **Not in build process**: Scripts aren't referenced in Makefile or buildconfig.yml
- **One-time migrations**: Most scripts fixed specific issues that are now resolved
- **Keep useful tools**: Scripts with documentation may be useful for similar future issues
- **Clean repository**: Removing obsolete scripts improves maintainability

