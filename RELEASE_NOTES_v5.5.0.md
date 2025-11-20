# SixLayer Framework v5.5.0 Release Notes

## 🎉 Major Features

### SwiftUI Map Support (Issue #25)

**NEW**: Cross-platform SwiftUI Map components with modern API support!

The framework now provides unified map functionality across iOS and macOS using the modern SwiftUI Map API with `Annotation` and `MapContentBuilder` (iOS 17+, macOS 14+).

#### Key Features

- **Modern API**: Uses `Annotation` with `MapContentBuilder` (not deprecated `MapAnnotation`)
- **Cross-Platform**: Unified API works identically on iOS and macOS
- **LocationService Integration**: Built-in integration with existing `LocationService` for current location
- **Automatic Compliance**: All map components include accessibility support via `automaticCompliance()`
- **Platform Fallbacks**: Graceful fallback UI for unsupported platforms (tvOS, watchOS)

#### Basic Usage

```swift
import SixLayerFramework
import MapKit

struct MyMapView: View {
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        platformMapView_L4(position: $position) {
            Annotation("Location", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) {
                Image(systemName: "mappin.circle.fill")
            }
        }
    }
}
```

#### With Annotations Array

```swift
let annotations = [
    MapAnnotationData(
        title: "Point 1",
        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        content: Image(systemName: "mappin")
    )
]

platformMapView_L4(position: $position, annotations: annotations)
```

#### With Current Location

```swift
@StateObject private var locationService = LocationService()

platformMapViewWithCurrentLocation_L4(
    locationService: locationService,
    showCurrentLocation: true
)
```

### API Reference

#### Layer 4 Component

```swift
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public enum PlatformMapComponentsLayer4 {
    /// Basic map view with MapContentBuilder
    public static func platformMapView_L4(
        position: Binding<MapCameraPosition>,
        @MapContentBuilder content: () -> some MapContent
    ) -> some View
    
    /// Map view with annotations array
    public static func platformMapView_L4(
        position: Binding<MapCameraPosition>,
        annotations: [MapAnnotationData],
        onAnnotationTapped: ((MapAnnotationData) -> Void)? = nil
    ) -> some View
    
    /// Map view with LocationService integration
    public static func platformMapViewWithCurrentLocation_L4(
        locationService: LocationService,
        showCurrentLocation: Bool = true,
        additionalAnnotations: [MapAnnotationData] = [],
        onAnnotationTapped: ((MapAnnotationData) -> Void)? = nil
    ) -> some View
}
```

#### Supporting Types

```swift
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct MapAnnotationData: Identifiable {
    public let id: UUID
    public let title: String
    public let coordinate: CLLocationCoordinate2D
    public let content: AnyView
    
    public init(title: String, coordinate: CLLocationCoordinate2D, content: some View)
}
```

### Platform Support

- **iOS**: 17.0+ ✅ Full support with modern Map API
- **macOS**: 14.0+ ✅ Full support with modern Map API
- **tvOS**: 17.0+ ⚠️ Limited support (fallback UI provided)
- **watchOS**: 10.0+ ⚠️ Limited support (fallback UI provided)

### LocationService Integration

The map component integrates seamlessly with the existing `LocationService`:

- Automatic location authorization requests
- Current location annotation with blue pin
- Automatic camera positioning to current location
- Error handling for permission denial
- Loading states during location fetch

### Examples

See `Framework/Examples/MapUsageExample.swift` for complete examples including:
- Basic map view
- Multiple annotations
- Current location integration
- Custom annotation views

## 🔧 API Changes

### New Components

- `PlatformMapComponentsLayer4` - Layer 4 map component enum
- `MapAnnotationData` - Cross-platform annotation data type
- `platformMapView_L4()` - Convenience functions for map views
- `platformMapViewWithCurrentLocation_L4()` - LocationService-integrated map view

### No Breaking Changes

- All new APIs are additive
- Existing code continues to work unchanged
- Map support is opt-in

## 📚 Documentation

### New Documentation

- **[Map API Usage Guide](Framework/docs/MapAPIUsage.md)** - Complete guide to using the modern SwiftUI Map API
  - Migration from deprecated `MapAnnotation` to `Annotation`
  - Cross-platform considerations
  - Framework integration examples

### Updated Documentation

- **[Deprecated APIs Audit](Framework/docs/DeprecatedAPIsAudit.md)** - Updated with Map API migration status

## 🧪 Testing

- **12 comprehensive tests** covering all map functionality
- **TDD approach**: Tests written first, then implementation
- **All tests passing**: 100% test success rate
- **Cross-platform testing**: Tests verify iOS and macOS implementations
- **LocationService integration tests**: Verify location functionality
- **Error handling tests**: Verify graceful error handling
- **Accessibility tests**: Verify accessibility support

## ✅ Backward Compatibility

- **100% backward compatible**: No breaking changes
- **Opt-in feature**: Map support is new functionality
- **Existing code**: Continues to work unchanged

## 🔄 Migration

No migration required - this is a new feature. To use maps in your app:

1. Import `MapKit` and `SixLayerFramework`
2. Use `platformMapView_L4()` or `platformMapViewWithCurrentLocation_L4()`
3. Ensure your app targets iOS 17+ or macOS 14+

## 📦 Dependencies

- **MapKit**: Required for map functionality (available on all platforms)
- **CoreLocation**: Already used by `LocationService`
- **SwiftUI**: Required (iOS 17+, macOS 14+)

## 🎯 Implementation Details

### Architecture

- **Layer 4 Component**: Follows framework's 6-layer architecture
- **Cross-Platform Abstraction**: Unified API across platforms
- **Modern API Only**: Uses `Annotation` with `MapContentBuilder`, avoids deprecated `MapAnnotation`
- **Accessibility**: Automatic compliance via `automaticCompliance()` modifier

### Error Handling

- Location permission denial handled gracefully
- Location service unavailability shows user-friendly error
- Network issues (map tiles) handled by MapKit
- Loading states during location fetch

### Performance

- Efficient map rendering
- Annotation updates don't cause performance issues
- Proper memory management for location updates

### Privacy & Security

- Location permissions requested before showing user location
- Platform-specific permission patterns (iOS vs macOS)
- Permission denial handled gracefully
- Privacy implications documented

## 🐛 Bug Fixes

None in this release (new feature addition).

## 📝 Notes

- **Do NOT use deprecated `MapAnnotation`** - Always use `Annotation` with `MapContentBuilder`
- Map components require iOS 17+ / macOS 14+ for full functionality
- Unsupported platforms (tvOS, watchOS) show fallback UI
- LocationService integration requires location permissions

---

**Version**: 5.5.0  
**Release Date**: November 20, 2025  
**Previous Version**: 5.4.0  
**Issue**: #25

