import SwiftUI

struct PondRootShell: View {
    @StateObject private var ledger = RippleLedger()
    @State private var activeDock: PondDock = .start
    @State private var latestBloom: BloomChain?

    var body: some View {
        ZStack {
            switch activeDock {
            case .start:
                StartPondView(enterPond: enterHome)
            case .home:
                HomePondView(openDock: openDock)
            case .gameplay:
                GameplayPondView(presentBloom: { bloomChain in
                    latestBloom = bloomChain
                    activeDock = .reward
                }, openDock: openDock)
            case .reward:
                if let latestBloom {
                    RewardPondView(bloomChain: latestBloom, castAgain: {
                        activeDock = .gameplay
                    }, claimAndHome: {
                        ledger.advanceTutorial(to: 5)
                        activeDock = .home
                    })
                } else {
                    HomePondView(openDock: openDock)
                }
            case .fishAlbum:
                FishAlbumView(openDock: openDock)
            case .pondGarden:
                PondDecorationView(openDock: openDock)
            case .gear:
                LPTackleLoftView(openDock: openDock)
            case .festival:
                LotusFestivalView(openDock: openDock)
            case .achievements:
                LPPondMarksView(openDock: openDock)
            case .supplies:
                LPReedStoresView(openDock: openDock)
            case .settings:
                SettingsPondView(openDock: openDock)
            }

            PassiveTutorialPondOverlay(activeDock: activeDock)
        }
        .environmentObject(ledger)
        .preferredColorScheme(.dark)
        .onAppear {
            ledger.syncLanternConsent(LanternConsent.readMistSignalStatus())
            Task {
                try? await Task.sleep(nanoseconds: 350_000_000)
                let consentRipple = await LanternConsent.requestMistSignalAccess()
                ledger.storeLanternConsent(consentRipple)
            }
        }
    }

    private func enterHome() {
        activeDock = .home
    }

    private func openDock(_ dock: PondDock) {
        if dock == .gameplay {
            ledger.advanceTutorial(to: 1)
        }
        if dock == .gear || dock == .pondGarden {
            ledger.completeTutorial()
        }
        activeDock = dock
    }
}
