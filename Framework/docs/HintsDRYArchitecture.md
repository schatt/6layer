# Hints Architecture: DRY (Don't Repeat Yourself)

## Core Principle

**Define hints ONCE, use EVERYWHERE.**

Hints describe your data models and are automatically applied wherever that data is presented.

## Architecture

```
Your App:
├── Models/
│   └── User.swift          # Your data model
├── Hints/                   # Hints folder (organized!)
│   ├── User.hints          # Define display hints ONCE ←
│   └── Product.hints       # Other model hints
├── Views/
│   ├── CreateUserView.swift  # Uses hints
│   ├── EditUserView.swift    # Uses hints
│   ├── UserDetailView.swift  # Uses hints
│   └── UserListView.swift    # Uses hints
```

## How It Works

### 1. Define Hints Once

Create `User.hints`:

```json
{
  "username": {
    "displayWidth": "medium",
    "expectedLength": 20
  },
  "email": {
    "displayWidth": "wide"
  }
}
```

### 2. Use Everywhere

Any view presenting User data automatically uses these hints:

```swift
// CreateUserView
platformPresentFormData_L1(
    fields: userFields,
    hints: EnhancedPresentationHints(...),
    modelName: "User"  // Hints loaded from User.hints
)

// EditUserView - SAME hints used!
platformPresentFormData_L1(
    fields: userFields,
    hints: EnhancedPresentationHints(...),
    modelName: "User"  // SAME User.hints file!
)

// UserDetailView - SAME hints used!
platformPresentDetail_L1(
    item: user,
    modelName: "User"  // SAME User.hints file!
)
```

### 3. Caching (Performance)

Hints are loaded ONCE and cached:

```swift
// First call: loads from file
let hints = loadHintsFromFile(for: "User")  // Reads User.hints

// Second call: uses cache
let hints = loadHintsFromFile(for: "User")  // Returns cached hints

// Third call: uses cache
let hints = loadHintsFromFile(for: "User")  // Returns cached hints
```

## Benefits

1. **DRY**: Define hints once, use everywhere
2. **Consistent**: Same hints applied to all views of that data model
3. **Efficient**: Cached - loaded once, reused everywhere
4. **Maintainable**: Change hints in one place, affects all views
5. **Declarative**: Hints describe the data, not the view

## Example: Complete App

```swift
// Models/User.swift
struct User {
    let username: String
    let email: String
    let bio: String
}

// Models/User.hints  ← Define once
{
  "username": { "displayWidth": "medium" },
  "email": { "displayWidth": "wide" },
  "bio": { "displayWidth": "wide", "showCharacterCounter": "true" }
}

// Views/CreateUserView.swift  ← Use everywhere
platformPresentFormData_L1(
    fields: createUserFields(),
    hints: EnhancedPresentationHints(...),
    modelName: "User"
)

// Views/EditUserView.swift  ← Use everywhere
platformPresentFormData_L1(
    fields: createUserFields(),
    hints: EnhancedPresentationHints(...),
    modelName: "User"
)

// Views/UserListView.swift  ← Use everywhere
platformPresentItemCollection_L1(
    items: users,
    hints: EnhancedPresentationHints(...),
    modelName: "User"
)
```

All these views automatically use `User.hints` to present the data consistently!

