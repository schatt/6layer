import SwiftUI

// MARK: - Responsive Cards View - 6-Layer Architecture Demo
/// This view demonstrates the complete 6-layer architecture flow for responsive cards
/// Shows how each layer contributes to the final responsive card layout

struct ResponsiveCardsView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // Sample card data
    private let cards = [
        ResponsiveCardData(
            title: "Dashboard",
            subtitle: "Overview & statistics",
            icon: "gauge.with.dots.needle.67percent",
            color: Color.blue,
            complexity: .moderate
        ),
        ResponsiveCardData(
            title: "Vehicles",
            subtitle: "Manage your cars",
            icon: "car.fill",
            color: Color.green,
            complexity: .simple
        ),
        ResponsiveCardData(
            title: "Expenses",
            subtitle: "Track spending & costs",
            icon: "dollarsign.circle.fill",
            color: Color.orange,
            complexity: .complex
        ),
        ResponsiveCardData(
            title: "Maintenance",
            subtitle: "Service records & schedules",
            icon: "wrench.fill",
            color: Color.red,
            complexity: .moderate
        ),
        ResponsiveCardData(
            title: "Fuel",
            subtitle: "Monitor fuel consumption",
            icon: "fuelpump.fill",
            color: Color.purple,
            complexity: .simple
        ),
        ResponsiveCardData(
            title: "Reports",
            subtitle: "Analytics & insights",
            icon: "chart.bar.fill",
            color: Color.teal,
            complexity: .veryComplex
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            // Layer 1: Express semantic intent (simplified for demo)
            responsiveCardGrid(for: cards, in: geometry)
        }
        .navigationTitle("Responsive Cards Demo")
        // Layer 6: Platform-specific navigation optimizations
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
    
    // MARK: - Responsive Card Grid Implementation
    
    @ViewBuilder
    private func responsiveCardGrid(for cards: [ResponsiveCardData], in geometry: GeometryProxy) -> some View {
        let screenWidth = geometry.size.width
        let _ = geometry.size.height // Unused but kept for future use
        
        // Layer 2: Layout Decision Engine - Use existing platform function
        let layoutDecision = determineOptimalCardLayout_L2(
            contentCount: cards.count,
            screenWidth: screenWidth,
            deviceType: DeviceType.current,
            contentComplexity: .moderate
        )
        
        // Layer 3: Strategy Selection - Use existing platform function
        let strategy = selectCardLayoutStrategy_L3(
            contentCount: cards.count,
            screenWidth: screenWidth,
            deviceType: DeviceType.current,
            contentComplexity: .moderate
        )
        
        // Layer 4: Component Implementation
        switch strategy.approach {
        case .grid:
            responsiveCardGridLayout(cards: cards, layout: layoutDecision)
        case .masonry:
            responsiveCardMasonryLayout(cards: cards, layout: layoutDecision)
        case .list:
            responsiveCardListLayout(cards: cards, layout: layoutDecision)
        case .adaptive:
            responsiveCardAdaptiveLayout(cards: cards, layout: layoutDecision, screenWidth: screenWidth)
        case .custom:
            responsiveCardCustomLayout(cards: cards, layout: layoutDecision)
        case .compact:
            responsiveCardCompactLayout(cards: cards, layout: layoutDecision)
        case .spacious:
            responsiveCardSpaciousLayout(cards: cards, layout: layoutDecision)
        case .uniform:
            responsiveCardUniformLayout(cards: cards, layout: layoutDecision)
        case .responsive:
            responsiveCardResponsiveLayout(cards: cards, layout: layoutDecision)
        case .dynamic:
            responsiveCardDynamicLayout(cards: cards, layout: layoutDecision)
        }
    }
    
    // MARK: - Layer 4: Component Implementation
    
    @ViewBuilder
    private func responsiveCardGridLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: layout.spacing), count: layout.columns),
            spacing: layout.spacing
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardMasonryLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVStack(spacing: layout.spacing) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardListLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVStack(spacing: layout.spacing) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardAdaptiveLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision,
        screenWidth: CGFloat
    ) -> some View {
        let minWidth: CGFloat = 200
        let maxWidth: CGFloat = screenWidth * 0.8
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: minWidth, maximum: maxWidth))],
            spacing: layout.spacing
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardCustomLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: layout.columns),
            spacing: layout.spacing
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardCompactLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: max(1, layout.columns - 1)),
            spacing: 8
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(8)
    }
    
    @ViewBuilder
    private func responsiveCardSpaciousLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 24), count: max(1, layout.columns - 1)),
            spacing: 24
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
    }
    
    @ViewBuilder
    private func responsiveCardUniformLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: layout.spacing), count: layout.columns),
            spacing: layout.spacing
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private func responsiveCardResponsiveLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / 300)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: layout.spacing), count: max(1, columns)),
                spacing: layout.spacing
            ) {
                ForEach(cards) { card in
                    ResponsiveCardView(data: card)
                }
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    private func responsiveCardDynamicLayout(
        cards: [ResponsiveCardData],
        layout: CardLayoutDecision
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: layout.spacing), count: layout.columns),
            spacing: layout.spacing
        ) {
            ForEach(cards) { card in
                ResponsiveCardView(data: card)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
    }
}

// MARK: - Individual Card View

struct ResponsiveCardView: View {
    let data: ResponsiveCardData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Card header
            HStack {
                Image(systemName: data.icon)
                    .foregroundColor(data.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(data.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Complexity indicator
                complexityIndicator(for: data.complexity)
            }
            
            Spacer()
            
            // Card footer with complexity-based actions
            HStack {
                Spacer()
                
                Button("View Details") {
                    // Layer 5: Performance optimization would handle this
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(12)
        .shadow(radius: 2)
        .frame(height: 120)
    }
    
    @ViewBuilder
    private func complexityIndicator(for complexity: ContentComplexity) -> some View {
        switch complexity {
        case .simple:
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
                .font(.caption)
        case .moderate:
            Image(systemName: "circle.fill")
                .foregroundColor(.yellow)
                .font(.caption)
        case .complex:
            Image(systemName: "circle.fill")
                .foregroundColor(.orange)
                .font(.caption)
        case .veryComplex:
            Image(systemName: "circle.fill")
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

// MARK: - Data Models

struct ResponsiveCardData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let complexity: ContentComplexity
}

// MARK: - Preview

#Preview {
    NavigationView {
        ResponsiveCardsView()
    }
}
