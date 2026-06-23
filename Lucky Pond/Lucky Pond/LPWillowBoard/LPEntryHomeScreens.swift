import SpriteKit
import SwiftUI

enum PondDock: Hashable {
    case start
    case home
    case gameplay
    case reward
    case fishAlbum
    case pondGarden
    case gear
    case festival
    case achievements
    case supplies
    case settings
}

struct StartPondView: View {
    var enterPond: () -> Void

    var body: some View {
        ZStack {
            PondBackdrop(mood: .dawn)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    Spacer(minLength: 36)
                    LuckyPondLogo()

                    StartCatchShowcase()
                        .padding(.horizontal, 24)

                    ParchmentPanel {
                        VStack(spacing: 10) {
                            Text("Cast • Match • Collect")
                                .font(.system(.title3, design: .serif).weight(.bold))
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(PondInk.moss)
                                Text("Pond Ready")
                                    .font(.system(.headline, design: .serif).weight(.bold))
                            }
                            Text("Tip: Matching 3 rare emblem fish increases your combo rewards.")
                                .font(.system(.subheadline, design: .serif))
                                .multilineTextAlignment(.center)
                            Text("No login is required. Your pond is saved locally.")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(PondInk.inkText.opacity(0.72))
                        }
                        .foregroundStyle(PondInk.inkText)
                    }
                    .padding(.horizontal, 24)

                    PondButton(title: "TAP TO START", systemImage: "hand.tap.fill", isPrimary: true, action: enterPond)
                        .padding(.horizontal, 34)
                    PondButton(title: "PLAY AS GUEST", systemImage: "person.fill", action: enterPond)
                        .padding(.horizontal, 70)

                    Text("v\(Bundle.main.pondVersionText)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PondInk.creamText.opacity(0.7))
                    Spacer(minLength: 34)
                }
                .padding(.vertical, 18)
            }
        }
    }
}

extension Bundle {
    var pondVersionText: String {
        let shortVersion = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return shortVersion?.isEmpty == false ? shortVersion! : "1.0.0"
    }
}

struct HomePondView: View {
    @EnvironmentObject private var ledger: RippleLedger
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .day, active: .home, openDock: openDock, horizontalPadding: 0, contentBottomPadding: 220) {
            VStack(spacing: 14) {
                LuckyPondLogo(compact: true)
                    .padding(.top, 6)

                ReelOrnament(emblems: [.lotus, .coin, .koiCrest])

                PondButton(title: "PLAY", systemImage: "figure.fishing", isPrimary: true) {
                    openDock(.gameplay)
                }
                .font(.title)
                .padding(.horizontal, 36)

                HStack(spacing: 12) {
                    DailyQuestCard(openDock: openDock)
                    EventHomeCard(openDock: openDock)
                }
                .padding(.horizontal, 14)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    HomeTile(title: "Fish", emblem: .koiCrest) { openDock(.fishAlbum) }
                    HomeTile(title: "Pond", emblem: .bridge) { openDock(.pondGarden) }
                    HomeTile(title: "Lantern", emblem: .lantern) { openDock(.festival) }
                    HomeTile(title: "Tackle", emblem: .tidehook) { openDock(.gear) }
                    HomeTile(title: "Marks", emblem: .bell) { openDock(.achievements) }
                    HomeTile(title: "Stores", emblem: .reed) { openDock(.supplies) }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 8)
            }
        }
    }
}
