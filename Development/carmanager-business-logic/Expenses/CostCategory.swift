import Foundation
import SwiftUI

struct CostCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color

    init(name: String, amount: Double, color: Color = .accentColor) {
        self.name = name
        self.amount = amount
        self.color = color
    }
}
