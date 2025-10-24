import SwiftUI

// MARK: - Layer 4: Component Implementation for Intelligent Card Expansion

/// Expandable card collection view
public struct ExpandableCardCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    @State private var expandedItem: Item.ID?
    @State private var hoveredItem: Item.ID?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
            .automaticAccessibilityIdentifiers()
        } else {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                
                // Get layout decision from Layer 2
                let layoutDecision = determineIntelligentCardLayout_L2(
                    contentCount: items.count,
                    screenWidth: screenWidth,
                    deviceType: SixLayerPlatform.deviceType,
                    contentComplexity: hints.complexity
                )
                
                // Get strategy from Layer 3
                let strategy = selectCardExpansionStrategy_L3(
                    contentCount: items.count,
                    screenWidth: screenWidth,
                    deviceType: SixLayerPlatform.deviceType,
                    interactionStyle: .expandable,
                    contentDensity: .balanced
                )
                
                // Render the appropriate layout
                renderCardLayout(
                    layoutDecision: layoutDecision,
                    strategy: strategy
                )
            }
        }
    }
    
    @ViewBuilder
    private func renderCardLayout(
        layoutDecision: IntelligentCardLayoutDecision,
        strategy: CardExpansionStrategy
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: layoutDecision.spacing), count: layoutDecision.columns),
            spacing: layoutDecision.spacing
        ) {
            ForEach(items) { item in
                ExpandableCardComponent(
                    item: item,
                    layoutDecision: layoutDecision,
                    strategy: strategy,
                    isExpanded: expandedItem == item.id,
                    isHovered: hoveredItem == item.id,
                    onExpand: { expandedItem = item.id },
                    onCollapse: { expandedItem = nil },
                    onHover: { isHovering in
                        hoveredItem = isHovering ? item.id : nil
                    },
                    onItemSelected: onItemSelected,
                    onItemDeleted: onItemDeleted,
                    onItemEdited: onItemEdited
                )
            }
            .padding(layoutDecision.padding)
            .automaticAccessibility()
        }
    }
}

/// Individual expandable card component
public struct ExpandableCardComponent<Item: Identifiable>: View {
    let item: Item
    let layoutDecision: IntelligentCardLayoutDecision
    let strategy: CardExpansionStrategy
    let isExpanded: Bool
    let isHovered: Bool
    let onExpand: () -> Void
    let onCollapse: () -> Void
    let onHover: (Bool) -> Void
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public var body: some View {
        let scale = calculateScale()
        let animation = Animation.easeInOut(duration: strategy.animationDuration)
        
        VStack(alignment: .leading, spacing: 12) {
            // Card content
            cardContent
            
            // Expanded content (if applicable)
            if isExpanded && strategy.primaryStrategy == .contentReveal {
                expandedContent
            }
        }
        .frame(width: layoutDecision.cardWidth, height: layoutDecision.cardHeight)
        .background(cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: isExpanded ? 8 : 4, x: 0, y: 2)
        .scaleEffect(scale)
        .animation(animation, value: scale)
        .animation(animation, value: isExpanded)
        .onTapGesture {
            handleTap()
            onItemSelected?(item)
        }
        .onHover { isHovering in
            onHover(isHovering)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isExpanded ? .isSelected : [])
        .accessibilityAction(named: "Activate") {
            handleTap()
        }
    }
    
    @ViewBuilder
    private var cardContent: some View {
        // Icon or image
        Image(systemName: cardIcon)
            .font(.title2)
            .foregroundColor(cardColor)
        
        // Title
        Text(cardTitle)
            .font(.headline)
            .lineLimit(2)
            .foregroundColor(isPlaceholderTitle ? .blue.opacity(0.6) : .primary)
        
        // Subtitle or description
        if let subtitle = cardSubtitle {
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        } else if let description = cardDescription {
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
    }
    
    @ViewBuilder
    private var expandedContent: some View {
        Divider()
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Additional Details")
                .font(.subheadline)
                .fontWeight(.medium)
            
            if let description = cardDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("This content is revealed when the card is expanded. It can contain additional information, actions, or interactive elements.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if let onItemEdited = onItemEdited {
                    Button("Edit") { 
                        onItemEdited(item)
                    }
                    .buttonStyle(.bordered)
                }
                
                if let onItemDeleted = onItemDeleted {
                    Button("Delete") { 
                        onItemDeleted(item)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isExpanded ? .blue : .clear, lineWidth: 2)
            )
    }
    
    private func calculateScale() -> CGFloat {
        if isExpanded {
            return CGFloat(strategy.expansionScale)
        } else if isHovered && strategy.primaryStrategy == .hoverExpand {
            return CGFloat(strategy.expansionScale * 0.5) // Partial expansion on hover
        } else {
            return 1.0
        }
    }
    
    private func handleTap() {
        if isExpanded {
            onCollapse()
        } else {
            onExpand()
        }
        
        // Haptic feedback if supported
        if strategy.hapticFeedback {
            #if os(iOS)
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            #endif
        }
    }
    
    // MARK: - Card Displayable Support
    
    private var cardTitle: String {
        CardDisplayHelper.extractTitle(from: item) ?? "Title"
    }
    
    private var isPlaceholderTitle: Bool {
        CardDisplayHelper.extractTitle(from: item) == nil
    }
    
    private var cardSubtitle: String? {
        CardDisplayHelper.extractSubtitle(from: item)
    }
    
    private var cardDescription: String? {
        if let displayable = item as? CardDisplayable {
            return displayable.cardDescription
        }
        return nil
    }
    
    private var cardIcon: String {
        CardDisplayHelper.extractIcon(from: item) ?? "star.fill"
    }
    
    private var cardColor: Color {
        CardDisplayHelper.extractColor(from: item) ?? .blue
    }
}

/// Cover flow collection view for visionOS
public struct CoverFlowCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
            .automaticAccessibilityIdentifiers()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items) { item in
                        CoverFlowCardComponent(
                            item: item,
                            onItemSelected: onItemSelected,
                            onItemDeleted: onItemDeleted,
                            onItemEdited: onItemEdited
                        )
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

/// Cover flow card component
public struct CoverFlowCardComponent<Item: Identifiable>: View {
    let item: Item
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public var body: some View {
        VStack {
            Image(systemName: cardIcon)
                .font(.largeTitle)
                .foregroundColor(cardColor)
            
            Text(cardTitle)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(isPlaceholderTitle ? .blue.opacity(0.6) : .primary)
            
            if let subtitle = cardSubtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 200, height: 300)
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 8)
        .onTapGesture {
            onItemSelected?(item)
        }
    }
    
    // MARK: - Card Displayable Support
    
    private var cardTitle: String {
        CardDisplayHelper.extractTitle(from: item) ?? "Title"
    }
    
    private var isPlaceholderTitle: Bool {
        CardDisplayHelper.extractTitle(from: item) == nil
    }
    
    private var cardSubtitle: String? {
        CardDisplayHelper.extractSubtitle(from: item)
    }
    
    private var cardIcon: String {
        CardDisplayHelper.extractIcon(from: item) ?? "star.fill"
    }
    
    private var cardColor: Color {
        CardDisplayHelper.extractColor(from: item) ?? .blue
    }
}

/// Grid collection view
public struct GridCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
        } else {
            GeometryReader { geometry in
                let layoutDecision = determineIntelligentCardLayout_L2(
                    contentCount: items.count,
                    screenWidth: geometry.size.width,
                    deviceType: SixLayerPlatform.deviceType,
                    contentComplexity: hints.complexity
                )
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: layoutDecision.spacing), count: layoutDecision.columns),
                    spacing: layoutDecision.spacing
                ) {
                    ForEach(items) { item in
                        SimpleCardComponent(
                            item: item, 
                            layoutDecision: layoutDecision,
                            hints: hints,
                            onItemSelected: onItemSelected,
                            onItemDeleted: onItemDeleted,
                            onItemEdited: onItemEdited
                        )
                    }
                }
                .padding(layoutDecision.padding)
            }
        }
    }
}

/// List collection view
public struct ListCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
            .automaticAccessibilityIdentifiers()
        } else {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    ListCardComponent(item: item, hints: hints)
                }
            }
            .padding(16)
        }
    }
}

/// Masonry collection view
public struct MasonryCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
            .automaticAccessibilityIdentifiers()
        } else {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 3),
                spacing: 16
            ) {
                ForEach(items) { item in
                    MasonryCardComponent(item: item, hints: hints)
                }
            }
            .padding(16)
        }
    }
}

/// Adaptive collection view that chooses the best layout
public struct AdaptiveCollectionView<Item: Identifiable>: View {
    let items: [Item]
    let hints: PresentationHints
    let onCreateItem: (() -> Void)?
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        items: [Item], 
        hints: PresentationHints, 
        onCreateItem: (() -> Void)? = nil,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.items = items
        self.hints = hints
        self.onCreateItem = onCreateItem
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        if items.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "tray")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No items available")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let onCreateItem = onCreateItem {
                    Button("Add Item") {
                        onCreateItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.platformBackground)
            .automaticAccessibilityIdentifiers()
        } else {
            // Choose the best layout based on content and device
            if items.count <= 2 {
                ListCollectionView(items: items, hints: hints, onCreateItem: onCreateItem)
            } else if SixLayerPlatform.deviceType == .phone {
                ListCollectionView(items: items, hints: hints, onCreateItem: onCreateItem)
            } else {
                GridCollectionView(items: items, hints: hints, onCreateItem: onCreateItem)
            }
        }
    }
}

/// Simple card component for basic layouts
public struct SimpleCardComponent<Item: Identifiable>: View {
    let item: Item
    let layoutDecision: IntelligentCardLayoutDecision
    let hints: PresentationHints
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        item: Item,
        layoutDecision: IntelligentCardLayoutDecision,
        hints: PresentationHints,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.item = item
        self.layoutDecision = layoutDecision
        self.hints = hints
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        VStack {
            // Display item icon or fallback
            Image(systemName: cardIcon)
                .font(.title2)
                .foregroundColor(cardColor)
            
            // Display item title
            Text(cardTitle)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(isPlaceholderTitle ? .blue.opacity(0.6) : .primary)
        }
        .frame(width: layoutDecision.cardWidth, height: layoutDecision.cardHeight)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onItemSelected?(item)
        }
    }
    
    // MARK: - Card Displayable Support
    
    private var cardTitle: String {
        CardDisplayHelper.extractTitle(from: item, hints: hints) ?? "Title"
    }
    
    private var isPlaceholderTitle: Bool {
        CardDisplayHelper.extractTitle(from: item, hints: hints) == nil
    }
    
    private var cardIcon: String {
        CardDisplayHelper.extractIcon(from: item, hints: hints) ?? "star.fill"
    }
    
    private var cardColor: Color {
        CardDisplayHelper.extractColor(from: item, hints: hints) ?? .blue
    }
}

/// List card component
public struct ListCardComponent<Item: Identifiable>: View {
    let item: Item
    let hints: PresentationHints
    let onItemSelected: ((Item) -> Void)?
    let onItemDeleted: ((Item) -> Void)?
    let onItemEdited: ((Item) -> Void)?
    
    public init(
        item: Item,
        hints: PresentationHints,
        onItemSelected: ((Item) -> Void)? = nil,
        onItemDeleted: ((Item) -> Void)? = nil,
        onItemEdited: ((Item) -> Void)? = nil
    ) {
        self.item = item
        self.hints = hints
        self.onItemSelected = onItemSelected
        self.onItemDeleted = onItemDeleted
        self.onItemEdited = onItemEdited
    }
    
    public var body: some View {
        HStack {
            Image(systemName: cardIcon)
                .font(.title2)
                .foregroundColor(cardColor)
            
            VStack(alignment: .leading) {
                Text(cardTitle)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(isPlaceholderTitle ? .blue.opacity(0.6) : .primary)
                
                if let subtitle = cardSubtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
        .onTapGesture {
            onItemSelected?(item)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: "Activate") {
            onItemSelected?(item)
        }
    }
    
    // MARK: - Card Displayable Support
    
    private var cardTitle: String {
        CardDisplayHelper.extractTitle(from: item) ?? "Title"
    }
    
    private var isPlaceholderTitle: Bool {
        CardDisplayHelper.extractTitle(from: item) == nil
    }
    
    private var cardSubtitle: String? {
        CardDisplayHelper.extractSubtitle(from: item)
    }
    
    private var cardIcon: String {
        CardDisplayHelper.extractIcon(from: item) ?? "star.fill"
    }
    
    private var cardColor: Color {
        CardDisplayHelper.extractColor(from: item) ?? .blue
    }
}

/// Masonry card component
public struct MasonryCardComponent<Item: Identifiable>: View {
    let item: Item
    let hints: PresentationHints
    
    public init(item: Item, hints: PresentationHints) {
        self.item = item
        self.hints = hints
    }
    
    public var body: some View {
        VStack {
            Image(systemName: cardIcon)
                .font(.title)
                .foregroundColor(cardColor)
            
            Text(cardTitle)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(isPlaceholderTitle ? .blue.opacity(0.6) : .primary)
            
            if let description = cardDescription {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.random(in: 150...250))
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    // MARK: - Card Displayable Support
    
    private var cardTitle: String {
        CardDisplayHelper.extractTitle(from: item, hints: hints) ?? "Title"
    }
    
    private var isPlaceholderTitle: Bool {
        CardDisplayHelper.extractTitle(from: item, hints: hints) == nil
    }
    
    private var cardDescription: String? {
        CardDisplayHelper.extractSubtitle(from: item, hints: hints)
    }
    
    private var cardIcon: String {
        CardDisplayHelper.extractIcon(from: item, hints: hints) ?? "star.fill"
    }
    
    private var cardColor: Color {
        CardDisplayHelper.extractColor(from: item, hints: hints) ?? .blue
    }
}
