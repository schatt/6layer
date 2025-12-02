# GitHub Issues Recommendations

**Generated**: December 2, 2025  
**Purpose**: Identify which TODO items should be converted to GitHub issues for better tracking

## ✅ **Recommendation: YES - Create GitHub Issues For These**

### **High Priority Issues (Should Create)**

#### **1. Accessibility Test Fixes** 
**From**: `todos.md` - Accessibility Test Fixes section

**Issue Title**: "Fix remaining accessibility test failures (~150+ components)"

**Why**: 
- Large, actionable work item with clear scope
- Has dependencies (macOS ViewInspector limitation)
- Benefits from tracking progress
- Can be broken into sub-issues if needed

**Details**:
- 72 tests already fixed
- ~150+ components still need `.automaticCompliance()` modifiers
- Many failures are macOS ViewInspector limitations (tests pass on iOS simulator)
- Should include note about ViewInspector limitation

**Labels**: `bug`, `testing`, `accessibility`, `in-progress`

---

#### **2. PlatformImage Standardization Phase 2**
**From**: `todos.md` - PlatformImage Standardization Plan

**Issue Title**: "Complete PlatformImage standardization (Phase 2)"

**Why**:
- Clear architectural improvement
- Has defined success criteria
- Part of larger standardization effort

**Details**:
- Phase 1 complete (implicit conversions implemented)
- Need to update remaining framework code to use `PlatformImage` variables consistently
- Replace explicit conversions with inline implicit conversions
- Ensure all system API calls use `PlatformImage()` wrapper

**Labels**: `enhancement`, `architecture`, `refactoring`

---

#### **3. PlatformImage Standardization Phase 3**
**From**: `todos.md` - PlatformImage Standardization Plan

**Issue Title**: "Add PlatformImage export and processing methods (Phase 3)"

**Why**:
- Future enhancement with clear scope
- Can be tracked separately from Phase 2
- Has specific deliverables

**Details**:
- Add export methods (PNG, JPEG, bitmap)
- Add image processing methods
- Add metadata extraction

**Labels**: `enhancement`, `feature`, `future`

---

#### **4. API Testing Strategy - Comprehensive Coverage**
**From**: `todos.md` - API Testing Strategy Phase 3

**Issue Title**: "Implement comprehensive API testing coverage"

**Why**:
- Critical for preventing breaking changes
- Has clear requirements and methodology
- Addresses identified testing gap

**Details**:
- API signature tests for all public APIs
- Integration tests for all callback functions
- Breaking change detection for all critical patterns
- Backward compatibility tests for all deprecated APIs

**Labels**: `testing`, `enhancement`, `quality`

---

#### **5. HIG Compliance - Automatic Styling**
**From**: `Development/todo.md` - Section 10.1

**Issue Title**: "Implement automatic HIG-compliant styling for all components"

**Why**:
- High priority feature
- Clear scope and benefits
- Part of larger HIG compliance effort

**Details**:
- Ensure all components automatically apply HIG-compliant styling
- Visual design, spacing, typography
- Automatic platform-specific HIG patterns (iOS vs macOS)

**Labels**: `enhancement`, `accessibility`, `design`, `high-priority`

---

#### **6. HIG Compliance - Automatic Features**
**From**: `Development/todo.md` - Section 10.6

**Issue Title**: "Implement automatic HIG compliance features (touch targets, contrast, typography, etc.)"

**Why**:
- Multiple related features that work together
- High impact for accessibility
- Clear deliverables

**Details**:
- Automatic touch target sizing (44pt minimum on iOS)
- Automatic color contrast (WCAG-compliant)
- Automatic typography scaling (Dynamic Type support)
- Automatic focus indicators
- Automatic motion preferences (reduced motion)
- Automatic tab order

**Labels**: `enhancement`, `accessibility`, `high-priority`

---

### **Medium Priority Issues (Consider Creating)**

#### **7. HIG Compliance - Visual Design Categories**
**From**: `Development/todo.md` - Section 10.2

**Issue Title**: "Implement HIG-compliant visual design category system"

**Why**:
- Well-defined feature set
- Can be implemented incrementally
- Benefits from tracking

**Details**:
- Animation categories (EaseInOut, spring, custom timing)
- Shadow categories (Elevated, floating, custom)
- Corner radius categories
- Border width categories
- Opacity categories
- Blur categories

**Labels**: `enhancement`, `design`, `medium-priority`

---

#### **8. HIG Compliance - Platform-Specific Categories**
**From**: `Development/todo.md` - Section 10.4

**Issue Title**: "Implement platform-specific HIG compliance categories"

**Why**:
- Platform-specific features need separate tracking
- Can be broken into sub-issues per platform

**Details**:
- iOS-specific (haptics, gestures, touch targets, safe area)
- macOS-specific (window management, menu bar, keyboard shortcuts, mouse interactions)
- visionOS-specific (spatial audio, hand tracking, eye tracking, spatial UI)

**Labels**: `enhancement`, `platform-specific`, `medium-priority`

---

#### **9. Integration Testing Improvements**
**From**: `Development/todo.md` - Framework Integration Testing Strategy

**Issue Title**: "Implement comprehensive integration testing suite"

**Why**:
- Addresses identified testing gap (50% coverage)
- Has clear methodology and examples
- Multiple sub-tasks that benefit from tracking

**Details**:
- End-to-end workflow testing
- Performance integration testing
- Error propagation testing
- OCR + Accessibility integration
- Cross-component integration

**Labels**: `testing`, `enhancement`, `medium-priority`

---

## ❌ **Recommendation: NO - Don't Create Issues For These**

### **Completed Items**
- All items marked with ✅ in both files
- These are historical records, not actionable work

### **Documentation/Planning Items**
- Test audit documentation tasks
- Planning items without clear deliverables
- Items that are more "notes" than "work"

### **Too Granular**
- Individual test file documentation tasks
- Small refactoring tasks that are part of larger efforts
- Items that would be better as checklist items within a larger issue

### **Future/Backlog Items**
- Phase 6 advanced features (AI-powered UI, enterprise features)
- Items marked as "Future" or "Planned" without clear timeline
- These can be tracked in the roadmap document instead

---

## 📋 **Issue Template Recommendations**

### **For Accessibility Test Fixes Issue**:
```markdown
## Problem
~150+ framework components are missing `.automaticCompliance()` modifiers, causing accessibility test failures.

## Current Status
- 72 tests already fixed
- Infrastructure in place
- Known limitation: macOS ViewInspector doesn't propagate SwiftUI identifiers (tests pass on iOS simulator)

## Scope
- Add `.automaticCompliance()` to ~150+ components
- Verify tests pass (on iOS simulator where applicable)
- Document ViewInspector limitation

## Success Criteria
- All framework components have `.automaticCompliance()` modifiers
- All accessibility tests pass (accounting for macOS ViewInspector limitation)
```

### **For PlatformImage Standardization Issue**:
```markdown
## Problem
Framework still uses platform-specific image types (`UIImage`/`NSImage`) in some places instead of standardized `PlatformImage`.

## Current Status
- Phase 1 complete: Implicit conversions implemented
- Layer 4 callbacks use `PlatformImage`
- Remaining code needs standardization

## Scope
- Update all framework code to use `PlatformImage` variables
- Replace explicit conversions with implicit conversions
- Ensure all system API calls use `PlatformImage()` wrapper

## Success Criteria
- No `UIImage`/`NSImage` variables inside framework
- All conversions happen at system boundaries
- Comprehensive tests enforce architecture
```

---

## 🎯 **Action Plan**

1. **Create High Priority Issues First** (Items 1-6)
   - These have clear scope and high impact
   - Can be worked on immediately or soon

2. **Create Medium Priority Issues** (Items 7-9)
   - Create when ready to start work
   - Can be backlogged if needed

3. **Link Issues to TODOs**
   - Add issue numbers to relevant TODO items
   - Update TODOs when issues are closed

4. **Use Labels Effectively**
   - `bug`, `enhancement`, `feature`, `testing`, `accessibility`, `architecture`
   - Priority labels: `high-priority`, `medium-priority`, `low-priority`
   - Status labels: `in-progress`, `blocked`, `needs-discussion`

5. **Break Large Issues Into Sub-Tasks**
   - Use GitHub issue checklists
   - Or create separate issues linked with "blocks" relationship

---

## 📝 **Notes**

- **Don't duplicate**: If an issue already exists for a TODO item, link to it instead of creating a new one
- **Keep TODOs updated**: When issues are created, update the TODO files with issue numbers
- **Regular review**: Periodically review both TODOs and issues to ensure they stay in sync
- **Close completed**: When work is done, close the issue and mark the TODO as complete

