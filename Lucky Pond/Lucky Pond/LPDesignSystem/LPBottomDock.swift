import SwiftUI

struct BottomDock: View {
    var active: PondDock
    var openDock: (PondDock) -> Void

    var body: some View {
        HStack(spacing: 2) {
            DockButton(title: "Home", image: "house.fill", active: active == .home) { openDock(.home) }
            DockButton(title: "Play", image: "figure.fishing", active: active == .gameplay || active == .reward) { openDock(.gameplay) }
            DockButton(title: "Fish", image: "book.closed.fill", active: active == .fishAlbum) { openDock(.fishAlbum) }
            DockButton(title: "Pond", image: "square.grid.3x3.fill", active: active == .pondGarden) { openDock(.pondGarden) }
            DockButton(title: "Gear", image: "wrench.and.screwdriver.fill", active: active == .gear) { openDock(.gear) }
            DockButton(title: "Settings", image: "gearshape.fill", active: active == .settings) { openDock(.settings) }
        }
        .frame(height: 70)
        .padding(.horizontal, 8)
        .padding(.top, 7)
        .padding(.bottom, 10)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(PondInk.woodDeep)
                Image("premium_bottom_dock_v2")
                    .resizable(capInsets: EdgeInsets(top: 28, leading: 42, bottom: 28, trailing: 42), resizingMode: .stretch)
                    .overlay(Rectangle().fill(PondInk.woodDeep.opacity(0.06)))
            }
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct DockButton: View {
    var title: String
    var image: String
    var active: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: image)
                    .font(.system(size: 17, weight: .bold))
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
            }
            .foregroundStyle(active ? PondInk.gold : PondInk.creamText.opacity(0.86))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(PondPressButtonStyle())
    }
}
