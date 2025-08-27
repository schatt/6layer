import SwiftUI

@MainActor
@ViewBuilder
func platformSidebarPullIndicator(isVisible: Bool) -> some View {
    #if os(macOS)
    if isVisible {
        HStack {
            HStack(spacing: 2) {
                ForEach(0..<2, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 3, height: 22)
                        .cornerRadius(1)
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    #else
    EmptyView()
    #endif
}


@MainActor
@ViewBuilder
func platformSettingsContainer<Sidebar: View, Detail: View>(
    columnVisibility: Binding<NavigationSplitViewVisibility>,
    @ViewBuilder sidebar: @escaping () -> Sidebar,
    @ViewBuilder detail: @escaping () -> Detail
) -> some View {
    #if os(iOS)
    sidebar()
    #else
    NavigationSplitView(columnVisibility: columnVisibility) {
        sidebar()
            .frame(minWidth: 250, idealWidth: 280, maxWidth: 350)
    } detail: {
        detail()
            .frame(minWidth: 400, idealWidth: 500, maxWidth: 600)
    }
    .navigationSplitViewStyle(.balanced)
    .frame(minWidth: 700, idealWidth: 900, maxWidth: 1200, minHeight: 500, idealHeight: 600, maxHeight: 800)
    #endif
}

@MainActor
@ViewBuilder
func platformSidebarToggleButton(columnVisibility: Binding<NavigationSplitViewVisibility>) -> some View {
    #if os(macOS)
    Button(action: {
        switch columnVisibility.wrappedValue {
        case .all:
            columnVisibility.wrappedValue = .detailOnly
        case .doubleColumn:
            columnVisibility.wrappedValue = .detailOnly
        case .detailOnly:
            columnVisibility.wrappedValue = .automatic
        case .automatic:
            columnVisibility.wrappedValue = .all
        default:
            columnVisibility.wrappedValue = .automatic
        }
    }) {
        Image(systemName: "sidebar.leading")
    }
    #else
    EmptyView()
    #endif
}


