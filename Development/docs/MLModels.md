# Core ML Models (Compilation & Bundling)

This app can load Core ML models from two locations at runtime (bundle-first, then override by Documents):

- App bundle: `.mlmodelc` (preferred) or `.mlmodel` (compiled at launch)
- Documents directory: `.mlmodelc` or `.mlmodel` (compiled at launch). Documents overrides bundle on matching key.

## Compile `.mlmodel` to `.mlmodelc`

Use the provided script:

```bash
./Scripts/compile_mlmodels.sh -i Shared/Models/Prediction/MLModels -o Build/CompiledMLModels -r -v
```

- `-i/--input`: directory containing `.mlmodel` files (default: `MLModels`)
- `-o/--output`: target directory for compiled bundles (default: `Build/CompiledMLModels`)
- `-r/--recursive`: search subdirectories under input
- `-c/--clean`: remove output dir before compiling
- `-v/--verbose`: verbose logging

Output bundles are created as `<output>/<ModelName>.mlmodelc`.

## Bundling compiled models

Add the compiled `.mlmodelc` directories to `project.yml` under the app target `resources`. Example:

```yaml
# project.yml (excerpt)
# targets:
#   "FrameworkML iOS":
#     resources:
#       - path: Build/CompiledMLModels
#         optional: true
```

Regenerate the Xcode project with XcodeGen:

```bash
./Scripts/build.pl --target mac # or run xcodegen as per project conventions
```

## Runtime loading order

The app loads models in this order (per model key, first wins until Documents override):

1. Bundle `.mlmodelc`
2. Bundle `.mlmodel` (compiled at launch)
3. Documents `.mlmodelc`
4. Documents `.mlmodel` (compiled at launch)
5. If none present or loading fails: fallback to statistical predictions

See `Shared/Models/Prediction/BasePredictionManager.swift` for details.

## Notes

- Training with CreateML is macOS-only. Ship pre-trained models or let users drop models in the app’s Documents folder.
- Keep model names stable to allow overrides by placing a same-named model in Documents.
- Ensure models do not contain PII; models should be trained on sanitized data.


