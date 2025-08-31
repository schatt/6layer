import SwiftUI

extension TextField {
public func platformTextFieldStyle() -> some View {
        #if os(iOS)
        return self.textFieldStyle(.roundedBorder)
        #elseif os(macOS)
        return self.textFieldStyle(.roundedBorder)
        #else
        return self.textFieldStyle(.roundedBorder)
        #endif
    }
}


