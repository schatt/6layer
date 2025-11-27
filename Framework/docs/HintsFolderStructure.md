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

## XcodeGen Configuration for .hints Files

### Problem

XcodeGen doesn't automatically recognize `.hints` files as resources that should be copied to the app bundle. Files listed in the `resources` section with `.hints` extension were not being included in the built app bundle.

### Solution

To ensure `.hints` files are properly copied to the app bundle, two steps are required:

#### 1. Add the Hints Directory to Sources

Add the hints directory to the `sources` section so XcodeGen can discover and reference the files:

```yaml
sources:
  - path: Shared/Resources/Hints
```

#### 2. Configure Each Hints File with copyFiles Build Phase

For each `.hints` file in the `resources` section, specify `buildPhase: copyFiles` with the appropriate destination:

```yaml
resources:
  - path: Shared/Resources/Hints/FuelPurchaseDTO.hints
    buildPhase: copyFiles
    destination: resources
    subpath: ""
  - path: Shared/Resources/Hints/ExpenseDTO.hints
    buildPhase: copyFiles
    destination: resources
    subpath: ""
  # ... repeat for each hints file
```

### Why This Works

- Adding the directory to `sources` allows XcodeGen to find and reference the files in the Xcode project
- Using `buildPhase: copyFiles` with `destination: resources` creates a "Copy Files" build phase that explicitly copies these files to the app bundle's Resources folder
- The `subpath: ""` ensures files are copied directly to the Resources folder without a subdirectory

### Result

After this configuration, all `.hints` files are properly included in the app bundle and accessible at runtime via `Bundle.main.url(forResource:withExtension:)` or the `FileBasedDataHintsLoader` from SixLayerFramework.

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


