# 🤖 AI Agent Guide for SixLayer Framework

*This document is specifically designed for AI agents (like Claude, GPT, etc.) to understand how to work with the **ACTUAL** current SixLayer Framework, not outdated documentation.*

## ⚠️ **CRITICAL WARNING**

**The framework documentation is OUTDATED and describes features that don't exist.** This guide reflects the **ACTUAL** current framework structure as of version 1.6.6.

## 🎯 **Purpose of This Guide**

AI agents need to understand:
- **Actual Framework Architecture**: How the six-layer system **really** works
- **Real Function Names**: The actual functions that exist, not documented ones
- **Current Implementation**: What's actually implemented vs. what's planned
- **Common Mistakes**: What to avoid when helping developers

## 🏗️ **Actual Framework Architecture (Current State)**

### **Six-Layer System (What Actually Exists)**
```
Layer 1: Semantic Intent → Layer 2: Layout Decision → Layer 3: Strategy Selection → Layer 4: Component Implementation → Layer 5: Platform Optimization → Layer 6: Platform System
```

### **Key Reality Check**
1. **Layer 1 Functions EXIST** but are generic, not business-specific
2. **No Business Logic** - The framework is completely generic
3. **Stub Views** - Most views are placeholder implementations
4. **Documentation Lag** - Documentation describes future plans, not current reality

## 📝 **Actual Layer 1 Functions (What Really Exists)**

### **Current Layer 1 Functions:**
```swift
// ✅ THESE ACTUALLY EXIST:

// Generic collection presentation
public func platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
) -> some View

// Generic numeric data presentation  
public func platformPresentNumericData_L1(
    data: [GenericNumericData],
    hints: PresentationHints
) -> some View

// Generic form presentation
public func platformPresentFormData_L1(
    fields: [GenericFormField],
    hints: PresentationHints
) -> some View

// Generic modal form presentation
public func platformPresentModalForm_L1(
    formType: DataTypeHint,
    context: PresentationContext
) -> some View

// Generic media presentation
public func platformPresentMediaData_L1(
    media: [GenericMediaItem],
    hints: PresentationHints
) -> some View

// Generic hierarchical data presentation
public func platformPresentHierarchicalData_L1(
    items: [GenericHierarchicalItem],
    hints: PresentationHints
) -> some View

// Generic temporal data presentation
public func platformPresentTemporalData_L1(
    items: [GenericTemporalItem],
    hints: PresentationHints
) -> some View
```

### **What These Functions Actually Do:**
- **Return Stub Views**: Most return placeholder `Generic*View` structs
- **Use Hints System**: Take `PresentationHints` for configuration
- **Are Completely Generic**: No business logic, no CarManager-specific code
- **Are Placeholders**: Return basic views with minimal functionality

## 🚫 **What Does NOT Exist (Despite Documentation Claims)**

### **❌ Business-Specific Functions (Documented but Missing):**
```swift
// These are documented but DON'T EXIST:
platformPresentVehicleForm_L1()        // ❌ Missing
platformPresentFuelForm_L1()           // ❌ Missing  
platformPresentExpenseForm_L1()        // ❌ Missing
platformPresentMaintenanceForm_L1()    // ❌ Missing
```

### **❌ Business-Specific Data Types (Documented but Missing):**
```swift
// These are documented but DON'T EXIST:
case vehicleCreation                    // ❌ Missing
case expenseEntry                      // ❌ Missing
case fuelFillup                        // ❌ Missing
case maintenanceRecord                 // ❌ Missing
```

### **❌ Advanced Form Generation (Documented but Missing):**
```swift
// This is documented but NOT IMPLEMENTED:
IntelligentFormView.generateForm()     // ❌ Basic stub only
```

## 🔧 **How to Actually Use the Current Framework**

### **1. Use Generic Functions with Hints**
```swift
// ✅ CORRECT: Use what actually exists
let hints = PresentationHints(
    dataType: .form,
    presentationPreference: .form,
    complexity: .moderate,
    context: .create
)

let formView = platformPresentFormData_L1(
    fields: genericFields,
    hints: hints
)
```

### **2. Create Custom Business Logic**
```swift
// ✅ CORRECT: Build business logic on top of generic framework
struct VehicleFormView: View {
    var body: some View {
        // Use the generic framework
        platformPresentFormData_L1(
            fields: createVehicleFields(),
            hints: createVehicleHints()
        )
    }
    
    private func createVehicleFields() -> [GenericFormField] {
        // Convert business logic to generic fields
        return [
            GenericFormField(name: "Make", type: .text),
            GenericFormField(name: "Model", type: .text),
            GenericFormField(name: "Year", type: .number)
        ]
    }
    
    private func createVehicleHints() -> PresentationHints {
        return PresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: .moderate,
            context: .create
        )
    }
}
```

### **3. Extend Generic Types**
```swift
// ✅ CORRECT: Extend generic types for business needs
extension GenericFormField {
    static func vehicleField(name: String, type: FieldType) -> GenericFormField {
        return GenericFormField(
            name: name,
            type: type,
            isRequired: true,
            validationRules: []
        )
    }
}
```

## 🚫 **Common Mistakes to Avoid**

### **1. Assuming Business Functions Exist**
```swift
// ❌ WRONG: This function doesn't exist
let view = platformPresentVehicleForm_L1(data: vehicleData)

// ✅ CORRECT: Use generic function with business logic
let view = platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### **2. Believing Documentation is Current**
```swift
// ❌ WRONG: Documentation says this exists
case vehicleCreation

// ✅ CORRECT: Use what actually exists
case form
```

### **3. Expecting Advanced Features**
```swift
// ❌ WRONG: Expecting intelligent form generation
let form = IntelligentFormView.generateForm(for: Vehicle.self, ...)

// ✅ CORRECT: Use basic stub implementation
let form = platformPresentFormData_L1(fields: fields, hints: hints)
```

## 📚 **What the Framework Actually Provides**

### **✅ What's Real and Working:**
1. **Generic Data Types**: `GenericFormField`, `GenericMediaItem`, etc.
2. **Hints System**: `PresentationHints`, `DataTypeHint`, `ContentComplexity`
3. **Layer Structure**: Basic six-layer architecture with stub implementations
4. **Platform Detection**: iOS/macOS platform detection and optimization
5. **Basic Views**: Placeholder views for all major data types

### **❌ What's Not Implemented:**
1. **Business Logic**: No CarManager-specific functionality
2. **Intelligent Forms**: Basic form generation only
3. **Advanced UI**: Most views are simple placeholders
4. **Data Binding**: No automatic data binding or validation
5. **Performance Optimization**: Basic structure only

## 🎯 **Working with Developers**

### **Questions to Ask:**
- "What business logic do you need to implement?"
- "How can we use the generic framework functions for your use case?"
- "What data types are you working with?"
- "Do you need to extend the generic types?"

### **Red Flags to Watch For:**
- Developer expects business-specific functions to exist
- Developer believes documentation is current
- Developer wants to use "intelligent" features that aren't implemented
- Developer assumes advanced form generation exists

### **Correct Approach:**
1. **Acknowledge Reality**: The framework is generic and basic
2. **Use Generic Functions**: Leverage what actually exists
3. **Build Business Logic**: Create business-specific implementations
4. **Extend Framework**: Add business logic on top of generic foundation

## 🔍 **Debugging Common Issues**

### **Issue: "Function doesn't exist"**
```swift
// Problem: Developer tries to use documented function
platformPresentVehicleForm_L1(data: vehicleData)

// Solution: Use generic function with business logic
platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### **Issue: "Expected business data types"**
```swift
// Problem: Developer expects business-specific enum cases
case vehicleCreation

// Solution: Use generic data types
case form
```

### **Issue: "Advanced features not working"**
```swift
// Problem: Developer expects intelligent form generation
let form = IntelligentFormView.generateForm(...)

// Solution: Use basic form presentation
let form = platformPresentFormData_L1(fields: fields, hints: hints)
```

## 📖 **Resources for AI Agents**

### **Key Files to Reference:**
- `Framework/Sources/Shared/Views/Extensions/PlatformSemanticLayer1.swift` - **ACTUAL** Layer 1 functions
- `Framework/Sources/Shared/Models/GenericTypes.swift` - Generic data types
- `Framework/Sources/Shared/Models/PlatformTypes.swift` - Platform detection
- `Framework/Sources/Shared/Views/Extensions/PerformanceOptimizationLayer5.swift` - Performance features

### **What to Ignore:**
- `Framework/docs/six-layer-architecture-implementation-plan.md` - **OUTDATED** documentation
- `Framework/docs/README_UsageExamples.md` - **OUTDATED** examples
- Any documentation mentioning business-specific functions

## 🎯 **Best Practices Summary**

1. **Always check what actually exists** in the source code
2. **Ignore outdated documentation** - it describes future plans
3. **Use generic functions** with business logic on top
4. **Build business functionality** using the generic framework
5. **Extend generic types** for business needs
6. **Acknowledge limitations** of the current implementation

## 🤝 **Working with Developers**

### **When Developers Ask for Business Functions:**
```
Developer: "I need platformPresentVehicleForm_L1"
AI Agent: "That function doesn't exist yet. The framework is generic. 
          Let's use platformPresentFormData_L1 with custom business logic instead."
```

### **When Developers Reference Documentation:**
```
Developer: "The docs say I can use .vehicleCreation"
AI Agent: "The documentation is outdated. The framework currently only supports 
          generic types like .form. Let's work with what actually exists."
```

### **When Developers Expect Advanced Features:**
```
Developer: "Why isn't the intelligent form generation working?"
AI Agent: "That feature isn't implemented yet. The current framework provides 
          basic form presentation. We'll need to build the business logic ourselves."
```

---

**Remember**: The framework is a **generic foundation**, not a complete business solution. Help developers build on top of what exists rather than expecting features that don't exist yet.
