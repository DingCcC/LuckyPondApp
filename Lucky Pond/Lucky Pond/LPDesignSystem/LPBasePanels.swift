import SwiftUI

struct PondBackdrop: View {
    var mood: PondMood = .dawn

    var body: some View {
        ZStack {
            Image(mood.assetName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(colors: [Color.black.opacity(0.00), Color.black.opacity(0.14)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            LinearGradient(colors: skyColors, startPoint: .top, endPoint: .bottom)
                .opacity(mood == .night ? 0.07 : 0.02)
                .ignoresSafeArea()

            LinearGradient(colors: [.clear, PondInk.pondDeep.opacity(0.10)], startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }

    private var skyColors: [Color] {
        switch mood {
        case .dawn:
            return [Color(red: 0.96, green: 0.67, blue: 0.34), Color(red: 0.43, green: 0.63, blue: 0.57), PondInk.pondDeep]
        case .day:
            return [Color(red: 0.72, green: 0.82, blue: 0.70), Color(red: 0.36, green: 0.58, blue: 0.52), PondInk.pondDeep]
        case .night:
            return [Color(red: 0.07, green: 0.10, blue: 0.24), Color(red: 0.06, green: 0.22, blue: 0.30), PondInk.pondDeep]
        case .festival:
            return [Color(red: 0.08, green: 0.09, blue: 0.25), Color(red: 0.19, green: 0.30, blue: 0.34), PondInk.pondDeep]
        }
    }
}

struct ParchmentPanel<PanelContent: View>: View {
    var inset: CGFloat = 14
    @ViewBuilder var panelContent: PanelContent

    var body: some View {
        panelContent
            .padding(.horizontal, inset + 14)
            .padding(.vertical, inset + 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: [PondInk.parchmentLight, PondInk.parchment], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white.opacity(0.22), lineWidth: 1)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(PondInk.wood.opacity(0.72), lineWidth: 1.5))
                    .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 2)
            )
    }
}

struct WoodPanel<PanelContent: View>: View {
    var corner: CGFloat = 8
    @ViewBuilder var panelContent: PanelContent

    var body: some View {
        panelContent
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(LinearGradient(colors: [Color(red: 0.43, green: 0.24, blue: 0.10), PondInk.woodDeep], startPoint: .top, endPoint: .bottom))
                    .overlay(
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .overlay(RoundedRectangle(cornerRadius: corner).stroke(PondInk.gold.opacity(0.58), lineWidth: 1.6))
                    .shadow(color: .black.opacity(0.20), radius: 5, x: 0, y: 3)
            )
    }
}

struct PondButton: View {
    var title: String
    var systemImage: String?
    var isPrimary: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.system(.headline, design: .serif).weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.74)
            }
            .foregroundStyle(isDisabled ? Color.white.opacity(0.48) : PondInk.creamText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, isPrimary ? 16 : 13)
            .padding(.horizontal, 12)
            .background(
                ZStack {
                    if isPrimary {
                        Image("premium_green_button")
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(LinearGradient(colors: [Color(red: 0.50, green: 0.29, blue: 0.12), PondInk.woodDeep], startPoint: .top, endPoint: .bottom))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(PondInk.gold.opacity(0.72), lineWidth: 1.4))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(PondPressButtonStyle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.62 : 1)
    }
}

struct RoundPondButton: View {
    var systemImage: String
    var size: CGFloat = 46
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(PondInk.creamText)
                .frame(width: size, height: size)
                .background(Circle().fill(LinearGradient(colors: [Color(red: 0.45, green: 0.25, blue: 0.09), PondInk.woodDeep], startPoint: .top, endPoint: .bottom)))
                .overlay(Circle().stroke(PondInk.gold.opacity(0.6), lineWidth: 1.5))
                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PondPressButtonStyle())
    }
}
