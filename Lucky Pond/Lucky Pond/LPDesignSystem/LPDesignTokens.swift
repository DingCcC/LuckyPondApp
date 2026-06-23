import SwiftUI

enum PondMood {
    case dawn
    case day
    case night
    case festival
}

enum PondInk {
    static let wood = Color(red: 0.34, green: 0.18, blue: 0.08)
    static let woodDeep = Color(red: 0.18, green: 0.09, blue: 0.04)
    static let parchment = Color(red: 0.88, green: 0.74, blue: 0.52)
    static let parchmentLight = Color(red: 0.98, green: 0.88, blue: 0.68)
    static let moss = Color(red: 0.28, green: 0.42, blue: 0.17)
    static let reed = Color(red: 0.56, green: 0.67, blue: 0.32)
    static let gold = Color(red: 0.93, green: 0.68, blue: 0.26)
    static let pond = Color(red: 0.05, green: 0.27, blue: 0.30)
    static let pondDeep = Color(red: 0.02, green: 0.13, blue: 0.18)
    static let creamText = Color(red: 1.0, green: 0.91, blue: 0.72)
    static let inkText = Color(red: 0.20, green: 0.11, blue: 0.05)
}

struct PondPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.965 : 1)
            .opacity(configuration.isPressed ? 0.84 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
