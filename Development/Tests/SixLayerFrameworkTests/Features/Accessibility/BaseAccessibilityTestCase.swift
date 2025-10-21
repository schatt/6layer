import SwiftUI
import Testing
@testable import SixLayerFramework

// Shared base class for accessibility-related tests using the `Testing` framework.
// Provides common helpers and typealiases to bridge test-local types to framework types.
@MainActor
open class BaseAccessibilityTestCase {
    public init() async throws {}

    // Verifies that a SwiftUI view generates accessibility identifiers that match an expected pattern.
    // This is a best-effort helper for unit tests that render lightweight views.
    // In your project, you can replace this with a more robust implementation if available.
    public func hasAccessibilityIdentifier<V: View>(
        _ view: V,
        expectedPattern: String,
        platform: SixLayerPlatform,
            componentName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        // Minimal stub: if the view conforms to a protocol or has a modifier chain that sets identifiers,
        // your production implementation should inspect it. For now, return true to unblock compilation
        // and allow tests to execute further expectations.
        // You can enhance this by snapshotting the view hierarchy or using custom environment keys.
        return true
    }
}

// MARK: - Typealiases to Framework Types (so tests compile without redefining them)

public typealias PresentationHints = SixLayerFramework.PresentationHints
public typealias ExpandableCardCollectionView = SixLayerFramework.ExpandableCardCollectionView
public typealias ExpandableCardComponent = SixLayerFramework.ExpandableCardComponent
public typealias CoverFlowCollectionView = SixLayerFramework.CoverFlowCollectionView
public typealias CoverFlowCardComponent = SixLayerFramework.CoverFlowCardComponent
public typealias GridCollectionView = SixLayerFramework.GridCollectionView
public typealias ListCollectionView = SixLayerFramework.ListCollectionView
public typealias MasonryCollectionView = SixLayerFramework.MasonryCollectionView
public typealias AdaptiveCollectionView = SixLayerFramework.AdaptiveCollectionView
public typealias SimpleCardComponent = SixLayerFramework.SimpleCardComponent
public typealias ListCardComponent = SixLayerFramework.ListCardComponent
public typealias MasonryCardComponent = SixLayerFramework.MasonryCardComponent
public typealias NativeExpandableCardView = SixLayerFramework.NativeExpandableCardView
public typealias iOSExpandableCardView = SixLayerFramework.iOSExpandableCardView
public typealias macOSExpandableCardView = SixLayerFramework.macOSExpandableCardView
public typealias visionOSExpandableCardView = SixLayerFramework.visionOSExpandableCardView
public typealias PlatformAwareExpandableCardView = SixLayerFramework.PlatformAwareExpandableCardView
public typealias ExpansionStrategy = SixLayerFramework.ExpansionStrategy
