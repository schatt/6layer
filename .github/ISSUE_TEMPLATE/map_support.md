# Add SwiftUI Map Support

## Overview

Add cross-platform SwiftUI Map support to the SixLayer Framework, following the modern Map API with `Annotation` and `MapContentBuilder` (iOS 17+).

## Motivation

Currently, the framework does not provide map functionality. Adding Map support would enable:
- Location-based features
- Geographic data visualization
- Integration with location services
- Cross-platform map components

## Requirements

### Platform Support
- **iOS**: 17.0+ (full support with modern API)
- **macOS**: 14.0+ (full support)
- **tvOS**: 17.0+ (limited support)
- **watchOS**: 10.0+ (limited support - consider WatchKit fallback)

### API Design

Follow the modern SwiftUI Map API:
- Use `Map(position:)` with `MapCameraPosition` (not deprecated `Map(coordinateRegion:)`)
- Use `Annotation` with `MapContentBuilder` (not deprecated `MapAnnotation`)
- Provide cross-platform abstraction similar to other framework components

### Implementation Approach

1. **Layer 4 Component**: Create `PlatformMapComponentsLayer4` for map UI components
2. **Cross-Platform Abstraction**: Provide unified API that works on all supported platforms
3. **Availability Checks**: Proper fallbacks for older iOS versions and unsupported platforms
4. **Integration**: Work with existing `LocationService` for location data

## Proposed API

```swift
// Layer 4: Component Implementation
@ViewBuilder
public static func platformMapView_L4(
    position: Binding<MapCameraPosition>,
    annotations: [MapAnnotation],
    onAnnotationTapped: ((MapAnnotation) -> Void)? = nil
) -> some View

// Or more flexible with MapContentBuilder
@ViewBuilder
public static func platformMapView_L4<Content: MapContent>(
    position: Binding<MapCameraPosition>,
    @MapContentBuilder content: () -> Content
) -> some View
```

## Cross-Platform Considerations

### iOS
- Full support with modern `Map` API
- Use `Annotation` with `MapContentBuilder`

### macOS
- Full support on macOS 14.0+
- Same API as iOS

### tvOS
- Limited support
- May need fallback UI

### watchOS
- Limited SwiftUI Map support
- Consider `WKInterfaceMap` from WatchKit as fallback

## Implementation Checklist

- [ ] Create `PlatformMapComponentsLayer4.swift`
- [ ] Implement iOS map component with modern API
- [ ] Implement macOS map component
- [ ] Add availability checks for iOS 17+ / macOS 14+
- [ ] Add fallback for older versions
- [ ] Add tvOS/watchOS fallbacks or alternatives
- [ ] Create cross-platform `MapAnnotation` type
- [ ] Integrate with `LocationService`
- [ ] Write tests following TDD
- [ ] Update documentation
- [ ] Add examples

## Documentation

Reference documentation already created:
- `Framework/docs/MapAPIUsage.md` - Modern Map API guide
- Includes migration from deprecated `MapAnnotation` to `Annotation`

## Related

- `LocationService.swift` - Existing location service that can provide coordinates
- `Framework/docs/DeprecatedAPIsAudit.md` - Documents Map API deprecations

## Notes

- **Do NOT use deprecated `MapAnnotation`** - Always use `Annotation` with `MapContentBuilder`
- Follow the same cross-platform patterns used in other Layer 4 components
- Ensure proper availability checks for all platforms
- Consider privacy implications (location permissions)


