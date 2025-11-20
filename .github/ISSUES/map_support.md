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
- **iOS**: 17.0+ ✅ (full support with modern API)
- **macOS**: 14.0+ ✅ (full support)
- **tvOS**: 17.0+ ⚠️ (limited support)
- **watchOS**: 10.0+ ⚠️ (limited support - consider WatchKit fallback)

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

## Acceptance Criteria

- [ ] Map component compiles and runs on iOS 17+ and macOS 14+
- [ ] Proper fallbacks for unsupported platforms (tvOS, watchOS)
- [ ] Integration with `LocationService` for current location
- [ ] All tests pass (TDD approach)
- [ ] Documentation updated with examples
- [ ] No deprecated APIs used (`MapAnnotation` is avoided)
- [ ] Follows framework's 6-layer architecture patterns
- [ ] Proper error handling for location permissions
- [ ] Accessibility support (VoiceOver, etc.)

## Example Usage

```swift
// Basic map with current location
struct LocationMapView: View {
    @StateObject private var locationService = LocationService()
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        platformMapView_L4(position: $position) {
            if let location = locationService.currentLocation {
                Annotation("Current Location", coordinate: location.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            Task {
                try? await locationService.requestAuthorization()
                try? await locationService.getCurrentLocation()
            }
        }
    }
}
```

## Testing Requirements

Following TDD principles:
- [ ] Test map component creation on iOS
- [ ] Test map component creation on macOS
- [ ] Test fallback behavior on unsupported platforms
- [ ] Test annotation display
- [ ] Test location integration
- [ ] Test error handling (permissions denied, etc.)
- [ ] Test accessibility features
- [ ] Cross-platform consistency tests

## Privacy & Security

- Location permissions must be requested before showing user location
- Follow platform-specific permission patterns (iOS vs macOS)
- Handle permission denial gracefully
- Consider privacy implications of location data
- Document location data usage in framework documentation

## Dependencies

- **MapKit**: Required for map functionality (available on all platforms)
- **CoreLocation**: Already used by `LocationService`
- **SwiftUI**: Required (iOS 17+, macOS 14+)

## Performance Considerations

- Map rendering should be efficient
- Annotation updates should not cause performance issues
- Consider lazy loading for large annotation sets
- Memory management for location updates

## Accessibility

- Map annotations must be accessible to VoiceOver
- Provide accessibility labels for annotations
- Support Dynamic Type where applicable
- Ensure keyboard navigation support (macOS)

## Error Handling

- Handle location permission denial
- Handle location service unavailability
- Handle network issues (map tiles)
- Provide user-friendly error messages

## Notes

- **Do NOT use deprecated `MapAnnotation`** - Always use `Annotation` with `MapContentBuilder`
- Follow the same cross-platform patterns used in other Layer 4 components
- Ensure proper availability checks for all platforms
- Consider privacy implications (location permissions)
- Follow framework's TDD, DTRT, DRY principles

## Related Issues/PRs

- None currently

## Labels

`enhancement`, `feature`, `cross-platform`, `layer-4`, `maps`

