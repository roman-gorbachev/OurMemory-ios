import SwiftUI

extension View {
    func appStyle(_ typography: Typography, weight: Font.Weight? = nil) -> some View {
        return font(typography.font(weight: weight))
    }
}
