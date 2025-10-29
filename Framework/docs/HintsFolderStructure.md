# Hints Folder Structure

## Recommended Organization

Store hints files in a dedicated `Hints/` folder for better organization:

```
YourApp/
├── Models/
│   ├── User.swift
│   ├── Product.swift
│   └── Order.swift
├── Hints/                          ← All hints in one place
│   ├── User.hints
│   ├── Product.hints
│   └── Order.hints
└── Views/
    ├── CreateUserView.swift
    ├── EditUserView.swift
    └── ProductListView.swift
```

## Benefits

1. **Organization**: All hints in one place
2. **Easy to Find**: Know where to look for hints
3. **Clean**: Keeps root directory clean
4. **Standard**: Common practice for configuration files
5. **Version Control**: Easy to track changes to all hints

## How 6Layer Finds Hints

6Layer looks for hints in this order:

1. **Primary**: `Hints/User.hints` in app bundle
2. **Fallback 1**: `User.hints` at bundle root (backward compatibility)
3. **Fallback 2**: `Hints/User.hints` in documents directory (runtime)

## Setting Up in Xcode

### Step 1: Create Hints Folder

In Xcode, create a folder called `Hints` in your project.

### Step 2: Add .hints Files

Add your `.hints` files to the `Hints` folder and ensure they're included in your target.

### Step 3: Verify Bundle Resource

Ensure the `Hints` folder and its contents are added as bundle resources.

## Example Structure

```
YourApp.xcodeproj/
├── Hints/
│   ├── User.hints
│   ├── Product.hints
│   └── Order.hints
└── YourApp/
    ├── Models/
    │   ├── User.swift
    │   └── Product.swift
    ├── Hints/                     ← References the folder
    │   ├── User.hints            ← Physical files
    │   └── Product.hints
    └── Views/
        └── ...
```

The `Hints/` folder keeps your hints organized and easy to manage!


