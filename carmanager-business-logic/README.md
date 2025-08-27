# CarManager Business Logic

This directory contains the CarManager-specific business logic that has been extracted from the main framework. These files are preserved for reference and to understand the original implementation, but they are **NOT** part of the core SixLayer framework.

## 📁 Directory Structure

### Vehicles/
- **Vehicle.swift** - Core Vehicle model definition
- **Vehicle+Extensions.swift** - Vehicle functionality extensions
- **Vehicle+ComparisonExtensions.swift** - Vehicle comparison logic
- **VehicleSelectionManager.swift** - Vehicle selection management
- **TireChange+Extensions.swift** - Tire change tracking
- **TireSet+Extensions.swift** - Tire set management

### Maintenance/
- Maintenance record models and management
- Service history tracking
- Maintenance scheduling

### Expenses/
- Expense tracking models
- Cost categorization
- Financial reporting

### Fuel/
- Fuel consumption tracking
- Mileage calculations
- Efficiency metrics

### Locations/
- Location management
- Address handling
- Geographic data

### Insurance/
- Insurance policy management
- Coverage tracking
- Claim handling

### Core Files/
- **PaymentTypes.swift** - Payment and financial types
- **SharedTypes.swift** - Common business logic types

## 🔄 Migration Status

These files are **preserved for reference only**. The core SixLayer framework should:

1. **Remove all references** to these business logic types
2. **Replace with generic types** where needed
3. **Maintain only the 6-layer architecture** without business logic
4. **Use the extracted types** as a reference for creating generic replacements

## 🎯 Next Steps

1. **Identify all references** to CarManager types in the framework
2. **Create generic replacements** for business logic types
3. **Clean up imports** and dependencies
4. **Test framework compilation** without business logic
5. **Document the clean architecture** for future use

## ⚠️ Important Notes

- **DO NOT** import these files into the main framework
- **DO NOT** reference these types in framework code
- **USE** these files to understand what needs to be replaced
- **MAINTAIN** the separation between framework and business logic
