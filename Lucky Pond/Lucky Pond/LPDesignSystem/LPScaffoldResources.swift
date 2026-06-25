import SwiftUI

enum PondChromeSafeArea {
    private static var isRunningOnIPadHardware: Bool {
        let model = UIDevice.current.model.lowercased()
        let localizedModel = UIDevice.current.localizedModel.lowercased()
        return UIDevice.current.userInterfaceIdiom == .pad
            || model.contains("ipad")
            || localizedModel.contains("ipad")
    }

    static func usesPadChrome(in proxy: GeometryProxy) -> Bool {
        isRunningOnIPadHardware || proxy.size.width >= 700
    }

    static func usesCompactPhoneChrome(in proxy: GeometryProxy) -> Bool {
        !usesPadChrome(in: proxy) && proxy.size.width < 430
    }

    static func top(in proxy: GeometryProxy) -> CGFloat {
        let compatibilityTop: CGFloat = usesPadChrome(in: proxy) ? 86 : 58
        return max(proxy.safeAreaInsets.top, compatibilityTop)
    }

    static func bottom(in proxy: GeometryProxy) -> CGFloat {
        let compatibilityBottom: CGFloat = usesPadChrome(in: proxy) ? 72 : 18
        return max(proxy.safeAreaInsets.bottom, compatibilityBottom)
    }

    static func dockBottom(in proxy: GeometryProxy) -> CGFloat {
        let compatibilityBottom: CGFloat = usesPadChrome(in: proxy) ? 28 : 12
        return max(proxy.safeAreaInsets.bottom, compatibilityBottom)
    }

    static func dockHeight(in proxy: GeometryProxy) -> CGFloat {
        usesCompactPhoneChrome(in: proxy) ? 72 : 78
    }
}

struct ResourceBar: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        HStack(spacing: 8) {
            ResourcePill(assetName: "lp_hud_coins", text: ledger.waterline.reedVault.coins.formatted())
            ResourcePill(assetName: "lp_hud_pearls", text: ledger.waterline.reedVault.pearls.formatted())
            ResourcePill(assetName: "lp_hud_energy", text: "\(ledger.waterline.reedVault.energy)/\(ledger.waterline.reedVault.maxEnergy)")
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
    }
}

struct PondScreenScaffold<Content: View, BottomAccessory: View>: View {
    var mood: PondMood
    var active: PondDock
    var openDock: (PondDock) -> Void
    var horizontalPadding: CGFloat = 12
    var contentBottomPadding: CGFloat = 18
    @ViewBuilder var content: Content
    @ViewBuilder var bottomAccessory: BottomAccessory

    init(
        mood: PondMood,
        active: PondDock,
        openDock: @escaping (PondDock) -> Void,
        horizontalPadding: CGFloat = 12,
        contentBottomPadding: CGFloat = 18,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomAccessory: () -> BottomAccessory
    ) {
        self.mood = mood
        self.active = active
        self.openDock = openDock
        self.horizontalPadding = horizontalPadding
        self.contentBottomPadding = contentBottomPadding
        self.content = content()
        self.bottomAccessory = bottomAccessory()
    }

    var body: some View {
        GeometryReader { proxy in
            let topPadding = PondChromeSafeArea.top(in: proxy) + 28
            let dockBottomPadding = PondChromeSafeArea.dockBottom(in: proxy)
            let dockHeight = PondChromeSafeArea.dockHeight(in: proxy)
            let usesPadChrome = PondChromeSafeArea.usesPadChrome(in: proxy)
            let compactDock = PondChromeSafeArea.usesCompactPhoneChrome(in: proxy)
            let dockHorizontalPadding: CGFloat = usesPadChrome ? 32 : 20
            let chromeTopGap: CGFloat = compactDock ? 16 : 14

            ZStack {
                PondBackdrop(mood: mood)

                VStack(spacing: 0) {
                    ResourceBar()
                        .padding(.top, topPadding)
                        .padding(.bottom, 8)

                    ScrollView(showsIndicators: false) {
                        content
                            .padding(.horizontal, horizontalPadding)
                            .padding(.bottom, contentBottomPadding)
                    }
                    .clipped()
                    .padding(.bottom, chromeTopGap)

                    bottomAccessory
                    BottomDock(active: active, openDock: openDock, compact: compactDock)
                        .frame(height: dockHeight)
                        .padding(.horizontal, dockHorizontalPadding)
                        .padding(.bottom, dockBottomPadding)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

extension PondScreenScaffold where BottomAccessory == EmptyView {
    init(
        mood: PondMood,
        active: PondDock,
        openDock: @escaping (PondDock) -> Void,
        horizontalPadding: CGFloat = 12,
        contentBottomPadding: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
        self.mood = mood
        self.active = active
        self.openDock = openDock
        self.horizontalPadding = horizontalPadding
        self.contentBottomPadding = contentBottomPadding
        self.content = content()
        self.bottomAccessory = EmptyView()
    }
}

struct PondToast: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.system(.footnote, design: .serif).weight(.bold))
            .foregroundStyle(PondInk.creamText)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .background(Capsule().fill(PondInk.woodDeep.opacity(0.88)))
            .overlay(Capsule().stroke(PondInk.gold.opacity(0.58), lineWidth: 1))
            .shadow(color: .black.opacity(0.24), radius: 6, x: 0, y: 3)
            .allowsHitTesting(false)
    }
}

struct ResourcePill: View {
    var assetName: String
    var text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .shadow(color: .black.opacity(0.16), radius: 1, x: 0, y: 1)
            Text(text)
                .font(.system(.subheadline, design: .serif).weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .foregroundStyle(PondInk.creamText)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(PondInk.woodDeep.opacity(0.86))
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .overlay(Capsule().stroke(PondInk.gold.opacity(0.48), lineWidth: 1.2))
        )
    }
}
