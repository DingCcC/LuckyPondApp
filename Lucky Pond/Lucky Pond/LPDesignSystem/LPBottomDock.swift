import SwiftUI

struct BottomDock: View {
    var active: PondDock
    var openDock: (PondDock) -> Void
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 0 : 2) {
            DockButton(title: "Home", image: "house.fill", active: active == .home, compact: compact) { openDock(.home) }
            DockButton(title: "Play", image: "figure.fishing", active: active == .gameplay || active == .reward, compact: compact) { openDock(.gameplay) }
            DockButton(title: "Fish", image: "book.closed.fill", active: active == .fishAlbum, compact: compact) { openDock(.fishAlbum) }
            DockButton(title: "Pond", image: "square.grid.3x3.fill", active: active == .pondGarden, compact: compact) { openDock(.pondGarden) }
            DockButton(title: "Gear", image: "wrench.and.screwdriver.fill", active: active == .gear, compact: compact) { openDock(.gear) }
            DockButton(title: "Settings", image: "gearshape.fill", active: active == .settings, compact: compact) { openDock(.settings) }
        }
        .padding(.horizontal, compact ? 5 : 8)
        .frame(maxWidth: .infinity)
        .frame(height: compact ? 72 : 78)
        .background(
            Image("premium_bottom_dock_v2")
                .resizable(capInsets: EdgeInsets(top: 28, leading: 42, bottom: 28, trailing: 42), resizingMode: .stretch)
        )
        .clipped()
    }
}

struct DockButton: View {
    var title: String
    var image: String
    var active: Bool
    var compact: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: compact ? 1 : 3) {
                Image(systemName: image)
                    .font(.system(size: compact ? 15 : 17, weight: .bold))
                Text(title)
                    .font(.system(size: compact ? 9 : 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
            }
            .foregroundStyle(active ? PondInk.gold : PondInk.creamText.opacity(0.86))
            .frame(maxWidth: .infinity)
            .frame(height: compact ? 46 : 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(PondPressButtonStyle())
    }
}
