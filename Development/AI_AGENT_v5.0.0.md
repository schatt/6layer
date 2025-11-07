# AI Agent Guide for SixLayer Framework v5.0.0

This document provides guidance for AI assistants working with the SixLayer Framework v5.0.0. **Always read this version-specific guide first** before attempting to help with this framework.

**Note**: This guide is for AI agents helping developers USE the framework, not for AI agents working ON the framework itself.

## 🎯 Quick Start

1. **Identify the current framework version** from the project's Package.swift or release tags
2. **Read this AI_AGENT_v5.0.0.md file** for version-specific guidance
3. **Follow the guidelines** for architecture, patterns, and best practices

## 🆕 What's New in v5.0.0

### Major Testing and Accessibility Release

v5.0.0 is a comprehensive release focusing on:
- **Complete TDD Implementation**: Framework now follows strict TDD principles throughout development
- **Advanced Accessibility Overhaul**: Complete accessibility system with automatic identifier generation
- **Testing Infrastructure Revolution**: Comprehensive testing with 800+ tests and full platform coverage

### Field-Level Display Hints System - Major Enhancement (v5.0.0)

The most significant improvement in v5.0.0 is the introduction of **field-level display hints** that allow apps to declaratively describe how their data should be presented.

#### Problem Solved

Previously, field display properties (widths, lengths, etc.) had to be configured manually in code for each view. This created duplication and made it difficult to maintain consistent presentation across the app.

#### Solution: Declarative .hints Files

Apps now create `.hints` files that describe their data models:

```
YourApp/
├── Models/
│   └── User.swift
├── Hints/
│   └── User.hints         ← 6Layer reads this automatically
└── Views/
    ├── CreateUserView.swift
    └── EditUserView.swift
```

**Data Persistence Support**: Field hints work seamlessly with both **CoreData AND/OR Swift Data**. The hints describe your data models, not the persistence layer.

**Xcode Project Integration**: Hints files should be added to your Xcode project target:
- **Via Xcode**: Drag `.hints` files into your project and ensure they're included in your app target
- **Via xcodegen**: Add hints files to your `project.yml` resources section
- **Via Package.swift**: For Swift Package projects, include hints in your package resources

### Layout Hints and Section Grouping (NEW in v5.0.0+)

Layout hints extend field-level hints to include **structural organization** - defining how groups of fields should be displayed together.

**Key principle**: Layout hints describe **data relationships** - which fields belong together and in what order. They're **hints, not commandments** - the framework adapts layouts responsively.

## 🏗️ Framework Architecture Overview

The SixLayer Framework follows a **layered architecture** where each layer builds upon the previous:

1. **Layer 1 (Semantic)**: Express WHAT you want to achieve, not how
2. **Layer 2 (Decision)**: Intelligent layout analysis and decision making
3. **Layer 3 (Strategy)**: Optimal layout strategy selection
4. **Layer 4 (Implementation)**: Platform-agnostic component implementation
5. **Layer 5 (Optimization)**: Platform-specific enhancements and optimizations
6. **Layer 6 (System)**: Direct platform system calls and native implementations

**📚 For complete architecture details, see [6-Layer Architecture Overview](../Framework/docs/README_6LayerArchitecture.md)**

## 🎯 Field Hints Usage Patterns

### Creating .hints Files

Apps create hint files that describe their data:

**Hints/User.hints**:
```json
{
  "username": {
    "displayWidth": "medium",
    "expectedLength": 20,
    "maxLength": 50,
    "minLength": 3
  },
  "email": {
    "displayWidth": "wide",
    "maxLength": 255
  },
  "bio": {
    "displayWidth": "wide",
    "showCharacterCounter": true,
    "maxLength": 1000
  },
  "_sections": [
    {
      "id": "account",
      "title": "Account Information",
      "fields": ["username", "email"],
      "layoutStyle": "vertical"
    },
    {
      "id": "profile",
      "title": "Profile",
      "fields": ["bio"],
      "layoutStyle": "horizontal"
    }
  ]
}
```

### Using Hints in Views

Hints are automatically loaded when presenting data:

```swift
platformPresentFormData_L1(
    fields: createUserFields(),
    hints: EnhancedPresentationHints(
        dataType: .form,
        context: .create
    ),
    modelName: "User"  // 6Layer reads User.hints automatically!
)
```

### DRY Principle

- **Define once**: Create `User.hints` file once
- **Use everywhere**: All User views automatically use same hints
- **Cached**: Hints loaded once per model, reused for performance
- **Consistent**: Same presentation rules across all views
- **Works with CoreData AND/OR Swift Data**: Hints describe your data models regardless of persistence layer

## 🔑 Key Principles

### Hints Describe the DATA

```swift
// ✅ CORRECT: Hints describe the data model
// User.hints describes how User data should be presented
// Works with CoreData User entity OR Swift Data User model

// ❌ WRONG: Hints don't describe specific views
// Don't create CreateUserView.hints or EditUserView.hints
```

### Layout Hints and Grouping

Layout hints allow you to define:
- **Field Grouping**: Which fields belong together in sections
- **Layout Styles**: How fields should be arranged (vertical, horizontal, grid, adaptive)
- **Field Ordering**: Explicit control over field display order

All layout hints are **hints, not commandments** - the framework adapts layouts responsively based on available space and platform capabilities.

## 📚 Documentation Links

- **[Field Hints Complete Guide](../Framework/docs/FieldHintsCompleteGuide.md)** - Comprehensive usage guide
- **[Field Hints Guide](../Framework/docs/FieldHintsGuide.md)** - Quick start and layout hints
- **[Hints DRY Architecture](../Framework/docs/HintsDRYArchitecture.md)** - DRY principles
- **[AI Agent Guide](AI_AGENT_GUIDE.md)** - General AI agent guidance

## 🎯 Key Takeaways for AI Agents

### When Developers Ask About Field Hints

```
Developer: "How do I configure field display properties?"
AI Agent: "Use the field hints system in v5.0.0! Create a .hints file 
          (e.g., User.hints) that describes your data model. The hints 
          work with both CoreData and Swift Data. Don't forget to add 
          the hints file to your Xcode project target."
```

### When Developers Ask About Layout

```
Developer: "How do I group fields into sections?"
AI Agent: "Use the layout hints feature! Add a _sections array to your 
          .hints file to define field groupings and layout styles. The 
          framework adapts layouts responsively based on available space."
```

### When Developers Ask About Data Persistence

```
Developer: "Do hints work with CoreData/Swift Data?"
AI Agent: "Yes! Field hints work seamlessly with both CoreData AND/OR 
          Swift Data. The hints describe your data models, not the 
          persistence layer, so you can use the same hints regardless 
          of which persistence framework you're using."
```

---

**Version**: SixLayer Framework v5.0.0  
**Last Updated**: January 2025  
**Related**: [AI Agent Guide](AI_AGENT_GUIDE.md), [Field Hints Complete Guide](FieldHintsCompleteGuide.md)

**Remember**: Field hints are a **major new capability** in v5.0.0 that provides developers with declarative data presentation. Help developers understand and use this powerful feature effectively.


