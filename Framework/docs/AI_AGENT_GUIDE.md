# 🤖 AI Agent Guide for SixLayer Framework

*This document is specifically designed for AI agents (like Claude, GPT, etc.) to understand how to work with the SixLayer Framework, create stubs, and provide accurate assistance to developers.*

## 🎯 **Purpose of This Guide**

AI agents need to understand:
- **Framework Architecture**: How the six-layer system works
- **Stub System**: How to create and use stubs correctly
- **Usage Patterns**: Common patterns and best practices
- **Common Mistakes**: What to avoid when helping developers

## 🏗️ **Framework Architecture Overview**

### **Six-Layer System**
```
Layer 1: Semantic Intent → Layer 2: Layout Decision → Layer 3: Strategy Selection → Layer 4: Component Implementation → Layer 5: Platform Optimization → Layer 6: Platform System
```

### **Key Principles**
1. **Semantic Intent First**: Always start with WHAT the developer wants to achieve
2. **Progressive Delegation**: Each layer delegates to the next for implementation
3. **Platform Independence**: Layer 4+ handles platform-specific details
4. **Stub-First Development**: Use stubs to establish the architecture before implementation

## 📝 **Stub System Understanding**

### **What Are Stubs?**
Stubs are placeholder implementations that establish the architectural structure without full implementation. They're located in `Framework/Stubs/` and serve as:
- **Architecture Templates**: Show the intended structure
- **Development Guides**: Provide patterns for implementation
- **Testing Scaffolds**: Enable testing before full implementation

### **Stub Creation Rules**

#### **1. Naming Convention**
```swift
// ✅ CORRECT: Layer-numbered naming
func platformPresentForm_L1(data: FormData, hints: PresentationHints) -> some View
func determineOptimalLayout_L2(hints: PresentationHints) -> LayoutDecision
func selectLayoutStrategy_L3(decision: LayoutDecision) -> LayoutStrategy

// ❌ WRONG: Generic names without layer context
func presentForm(data: FormData) -> some View
func getLayout(hints: PresentationHints) -> LayoutDecision
```

#### **2. Function Signatures**
```swift
// ✅ CORRECT: Full type information
@MainActor
public func platformPresentForm_L1(
    data: FormData,
    hints: PresentationHints,
    context: PresentationContext
) -> some View {
    // Stub implementation
    return FormStubView(data: data, hints: hints, context: context)
}

// ❌ WRONG: Missing types or access modifiers
func platformPresentForm_L1(data, hints, context) {
    // Missing types make it hard to understand
}
```

#### **3. Stub Implementation Pattern**
```swift
// ✅ CORRECT: Clear stub with delegation
@MainActor
public func platformPresentForm_L1(
    data: FormData,
    hints: PresentationHints
) -> some View {
    // Layer 1: Semantic intent
    let layout = determineOptimalFormLayout_L2(hints: hints)
    let strategy = selectFormStrategy_L3(layout: layout)
    return platformFormContainer_L4(strategy: strategy) {
        FormContentStub(data: data)
    }
}

// ❌ WRONG: Direct implementation without delegation
@MainActor
public func platformPresentForm_L1(
    data: FormData,
    hints: PresentationHints
) -> some View {
    // Don't implement directly in Layer 1
    return Form {
        // Direct implementation breaks the architecture
    }
}
```

## 🔧 **Common Usage Patterns**

### **1. Form Presentation Pattern**
```swift
// ✅ CORRECT: Full semantic pattern
platformPresentForm_L1(
    data: formData,
    hints: PresentationHints(
        dataType: .form,
        presentationPreference: .automatic,
        complexity: .complex,
        context: .modal
    )
)

// ❌ WRONG: Missing hints or using wrong layer
platformPresentForm_L4(data: formData) // Wrong layer
platformPresentForm_L1(data: formData) // Missing hints
```

### **2. Collection Presentation Pattern**
```swift
// ✅ CORRECT: Collection with layout hints
platformPresentCollection_L1(
    items: dataItems,
    hints: PresentationHints(
        dataType: .collection,
        presentationPreference: .cards,
        complexity: .moderate,
        context: .dashboard
    )
)

// ❌ WRONG: Direct collection without semantic layer
ForEach(items) { item in // Bypasses the framework
    ItemView(item: item)
}
```

### **3. Modal Presentation Pattern**
```swift
// ✅ CORRECT: Semantic modal presentation
platformPresentModal_L1(
    content: modalContent,
    hints: PresentationHints(
        dataType: .modal,
        presentationPreference: .sheet,
        complexity: .simple,
        context: .overlay
    )
)

// ❌ WRONG: Direct sheet presentation
.sheet(isPresented: $showingModal) { // Bypasses the framework
    ModalContent()
}
```

## 🚫 **Common Mistakes to Avoid**

### **1. Layer Violations**
```swift
// ❌ WRONG: Layer 1 calling Layer 6 directly
func platformPresentForm_L1(data: FormData) -> some View {
    return NavigationView { // Layer 6 component in Layer 1
        Form {
            // Direct implementation
        }
    }
}

// ✅ CORRECT: Proper delegation
func platformPresentForm_L1(data: FormData) -> some View {
    let layout = determineOptimalFormLayout_L2(hints: hints)
    let strategy = selectFormStrategy_L3(layout: layout)
    return platformFormContainer_L4(strategy: strategy) {
        FormContentStub(data: data)
    }
}
```

### **2. Missing Hints**
```swift
// ❌ WRONG: No hints for intelligent decisions
platformPresentForm_L1(data: formData)

// ✅ CORRECT: Comprehensive hints
platformPresentForm_L1(
    data: formData,
    hints: PresentationHints(
        dataType: .form,
        presentationPreference: .automatic,
        complexity: .complex,
        context: .modal,
        customPreferences: [
            "hasImagePicker": "true",
            "hasDatePickers": "true",
            "sectionCount": "4"
        ]
    )
)
```

### **3. Incorrect Access Levels**
```swift
// ❌ WRONG: Internal access prevents external use
func platformPresentForm_L1(data: FormData) -> some View

// ✅ CORRECT: Public access for external consumption
@MainActor
public func platformPresentForm_L1(data: FormData) -> some View
```

## 📚 **Stub Creation Workflow**

### **Step 1: Identify the Need**
- What semantic intent does the developer want to express?
- What layer should this function belong to?
- What hints are needed for intelligent decisions?

### **Step 2: Create the Stub**
```swift
// Example: Creating a new form presentation stub
@MainActor
public func platformPresentAdvancedForm_L1(
    data: AdvancedFormData,
    hints: PresentationHints
) -> some View {
    // Layer 1: Semantic intent
    let layout = determineAdvancedFormLayout_L2(hints: hints)
    let strategy = selectAdvancedFormStrategy_L3(layout: layout)
    return platformAdvancedFormContainer_L4(strategy: strategy) {
        AdvancedFormStubView(data: data)
    }
}
```

### **Step 3: Create Supporting Stubs**
```swift
// Layer 2: Layout decision
func determineAdvancedFormLayout_L2(hints: PresentationHints) -> AdvancedFormLayoutDecision {
    // Stub: Will analyze hints and determine optimal layout
    return AdvancedFormLayoutDecision.stub
}

// Layer 3: Strategy selection
func selectAdvancedFormStrategy_L3(layout: AdvancedFormLayoutDecision) -> AdvancedFormStrategy {
    // Stub: Will select optimal strategy based on layout
    return AdvancedFormStrategy.stub
}

// Layer 4: Component implementation
func platformAdvancedFormContainer_L4(strategy: AdvancedFormStrategy) -> some View {
    // Stub: Will implement the actual form container
    return AdvancedFormContainerStub(strategy: strategy)
}
```

### **Step 4: Create Stub Views**
```swift
// Stub view for development and testing
struct AdvancedFormStubView: View {
    let data: AdvancedFormData
    
    var body: some View {
        VStack {
            Text("Advanced Form Stub")
                .font(.headline)
            Text("Data: \(data.description)")
                .font(.caption)
            Text("This is a placeholder for the actual form implementation")
                .padding()
        }
        .padding()
    }
}
```

## 🧪 **Testing Stubs**

### **Stub Validation**
```swift
// Test that stubs compile and provide expected structure
func testAdvancedFormStub() {
    let data = AdvancedFormData.stub
    let hints = PresentationHints.stub
    
    let view = platformPresentAdvancedForm_L1(data: data, hints: hints)
    
    // Verify the view compiles and has expected structure
    XCTAssertNotNil(view)
}
```

### **Integration Testing**
```swift
// Test that the delegation chain works
func testAdvancedFormDelegationChain() {
    let data = AdvancedFormData.stub
    let hints = PresentationHints.stub
    
    // This should compile and show the stub view
    let view = platformPresentAdvancedForm_L1(data: data, hints: hints)
    
    // In a real app, this would show the stub view
    // allowing developers to see the intended structure
}
```

## 🔍 **Debugging Stubs**

### **Common Issues**
1. **Compilation Errors**: Check function signatures and types
2. **Missing Delegation**: Ensure Layer 1 calls Layer 2, not Layer 6
3. **Access Level Issues**: Verify all functions are `public`
4. **Missing Hints**: Ensure comprehensive hint objects

### **Debugging Tools**
```swift
// Add debug logging to stubs
func platformPresentForm_L1(data: FormData, hints: PresentationHints) -> some View {
    print("🔍 Layer 1: Presenting form with hints: \(hints)")
    
    let layout = determineOptimalFormLayout_L2(hints: hints)
    print("🔍 Layer 2: Layout decision: \(layout)")
    
    let strategy = selectFormStrategy_L3(layout: layout)
    print("🔍 Layer 3: Strategy selection: \(strategy)")
    
    return platformFormContainer_L4(strategy: strategy) {
        FormContentStub(data: data)
    }
}
```

## 📖 **Resources for AI Agents**

### **Key Files to Reference**
- `Framework/docs/README_6LayerArchitecture.md` - Complete architecture overview
- `Framework/docs/README_UsageExamples.md` - Practical usage examples
- `Framework/docs/FunctionIndex.md` - Complete function reference
- `Framework/Stubs/` - Example stub implementations

### **When to Create Stubs**
- **New Features**: Always start with stubs to establish architecture
- **Missing Functions**: If a developer needs a function that doesn't exist
- **Architecture Changes**: When modifying the layer structure
- **Testing**: To validate architectural decisions before implementation

### **When NOT to Create Stubs**
- **Bug Fixes**: Fix the actual implementation, don't create stubs
- **Performance Issues**: Optimize existing code, don't stub it
- **Simple UI Changes**: Use existing functions, don't create new stubs

## 🎯 **Best Practices Summary**

1. **Always use layer-numbered naming** (`_L1`, `_L2`, etc.)
2. **Start with semantic intent** in Layer 1
3. **Delegate to lower layers** - never skip layers
4. **Provide comprehensive hints** for intelligent decisions
5. **Use public access** for all external functions
6. **Create stub views** for visual feedback during development
7. **Test the delegation chain** before implementation
8. **Document the intent** of each stub function

## 🤝 **Working with Developers**

### **Questions to Ask**
- "What are you trying to achieve semantically?"
- "What layer should this function belong to?"
- "What hints would help the framework make intelligent decisions?"
- "Are you looking for a stub or a full implementation?"

### **Red Flags to Watch For**
- Developer wants to bypass the framework layers
- Direct platform-specific code in semantic layers
- Missing or incomplete hint objects
- Functions without layer numbering
- Private or internal access levels

---

**Remember**: The goal is to help developers work WITH the framework architecture, not around it. Stubs are the bridge between intent and implementation, ensuring the six-layer system works as designed.
