import SwiftUI

public struct ResponsiveContainer<Content: View>: View {
    let content: (_ isHorizontal: Bool, _ isVertical: Bool) -> Content
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass

    public var body: some View {
        content(hSizeClass == .regular, vSizeClass == .regular)
    }
}

#if DEBUG
public struct ResponsiveContainer_Previews: PreviewProvider {
    public static var previews: some View {
        ResponsiveContainer { horizontal, vertical in
            VStack {
                Text(horizontal ? "Horizontal: Yes" : "Horizontal: No")
                Text(vertical ? "Vertical: Yes" : "Vertical: No")
            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
