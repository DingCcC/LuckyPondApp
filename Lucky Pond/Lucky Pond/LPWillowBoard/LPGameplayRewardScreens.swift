import SwiftUI

struct GameplayPondView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedBait: BaitKind = .lotusBait
    @State private var latestCatch: HookTally?
    @State private var noEnergyPulse = false
    @State private var skillNotice = "Catch 3 emblems to bloom rewards."
    @State private var scentCharges = 3
    @State private var currentCharges = 3
    @State private var gleamCharges = 2
    @State private var isCastingRod = false
    @State private var isResolvingBloom = false
    @State private var nextEmblemBias: LPEmblem?
    @State private var nextRareLift: Double = 0
    @State private var nextWeightBoost: Double = 0
    var presentBloom: (BloomChain) -> Void
    var openDock: (PondDock) -> Void

    var body: some View {
        ZStack {
            PondBackdrop(mood: .day)

            GeometryReader { proxy in
                let usesSidePanel = proxy.size.width >= 760 && proxy.size.width > proxy.size.height * 0.82

                if usesSidePanel {
                    sidePanelGameplay(in: proxy)
                } else {
                    stackedGameplay(in: proxy)
                }
            }
        }
        .onAppear {
            isResolvingBloom = false
        }
    }

    @ViewBuilder
    private func stackedGameplay(in proxy: GeometryProxy) -> some View {
        let usesPadChrome = PondChromeSafeArea.usesPadChrome(in: proxy)
        let compactHeight = proxy.size.height < 900 || usesPadChrome
        let horizontalInset = min(28, max(16, proxy.size.width * 0.04))
        let topInset = PondChromeSafeArea.top(in: proxy) + (compactHeight ? 24 : 18)
        let bottomInset = PondChromeSafeArea.bottom(in: proxy) + (compactHeight ? 16 : 12)
        let resourceWidth = min(proxy.size.width - horizontalInset * 2.6, usesPadChrome ? 560 : 620)
        let hudY = topInset + 24
        let waterTop = topInset + (compactHeight ? 76 : 82)
        let noticeHeight: CGFloat = compactHeight ? 31 : 34
        let baitHeight: CGFloat = compactHeight ? 96 : 108
        let actionHeight: CGFloat = compactHeight ? 76 : 88
        let controlGap: CGFloat = compactHeight ? 8 : 10
        let controlsHeight = noticeHeight + baitHeight + actionHeight + controlGap * 2
        let controlsTop = proxy.size.height - bottomInset - controlsHeight
        let stageHeight = max(compactHeight ? 220 : 280, controlsTop - waterTop - controlGap)
        let stageCenterY = waterTop + stageHeight / 2
        let topHudRowY = waterTop + min(compactHeight ? 44 : 54, stageHeight * 0.17)
        let reelY = waterTop + min(compactHeight ? 144 : 164, stageHeight * 0.34)
        let jackpotY = reelY + (compactHeight ? 68 : 76)
        let noticeY = controlsTop + noticeHeight / 2
        let baitY = noticeY + noticeHeight / 2 + controlGap + baitHeight / 2
        let actionY = baitY + baitHeight / 2 + controlGap + actionHeight / 2
        let todayBestY = min(noticeY - (compactHeight ? 50 : 66), waterTop + stageHeight - (compactHeight ? 58 : 74))

        ZStack {
            GameplayResourceBar()
                .frame(width: resourceWidth)
                .position(x: proxy.size.width / 2, y: hudY)

            gameplayStage(width: proxy.size.width - horizontalInset * 1.5, height: stageHeight)
                .position(x: proxy.size.width / 2, y: stageCenterY)

            RoundPondButton(systemImage: "house.fill", size: compactHeight ? 36 : 40) { openDock(.home) }
                .position(x: horizontalInset + 28, y: topHudRowY)

            LuckMeter(compact: compactHeight)
                .position(x: horizontalInset + (compactHeight ? 116 : 126), y: topHudRowY)

            ReelPanel(compact: compactHeight)
                .frame(width: min(compactHeight ? 184 : 214, proxy.size.width * 0.50))
                .position(x: proxy.size.width / 2, y: reelY)

            JackpotForecastPill(compact: compactHeight)
                .frame(width: min(compactHeight ? 206 : 232, proxy.size.width * 0.56))
                .position(x: proxy.size.width / 2, y: jackpotY)

            ComboSign(compact: compactHeight)
                .position(x: proxy.size.width - horizontalInset - (compactHeight ? 39 : 42), y: topHudRowY)

            if stageHeight > 300 {
                TodayBestSign(compact: compactHeight)
                    .position(x: horizontalInset + (compactHeight ? 62 : 68), y: todayBestY)
            }

            noticeCapsule(width: proxy.size.width - horizontalInset * 2.5, compact: compactHeight)
                .frame(height: noticeHeight)
                .position(x: proxy.size.width / 2, y: noticeY)

            BaitStrip(selectedBait: $selectedBait, compact: compactHeight)
                .frame(width: proxy.size.width - horizontalInset * 2, height: baitHeight)
                .clipped()
                .position(x: proxy.size.width / 2, y: baitY)

            actionControls(compact: compactHeight)
                .frame(width: proxy.size.width - horizontalInset * 2, height: actionHeight)
                .clipped()
                .position(x: proxy.size.width / 2, y: actionY)
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
    }

    @ViewBuilder
    private func sidePanelGameplay(in proxy: GeometryProxy) -> some View {
        let compactHeight = proxy.size.height < 900 || PondChromeSafeArea.usesPadChrome(in: proxy)
        let outerInset = min(28, max(16, proxy.size.width * 0.025))
        let topInset = PondChromeSafeArea.top(in: proxy) + (compactHeight ? 20 : 16)
        let bottomInset = PondChromeSafeArea.bottom(in: proxy) + (compactHeight ? 14 : 12)
        let hudY = topInset + 24
        let contentTop = topInset + (compactHeight ? 62 : 66)
        let contentHeight = max(420, proxy.size.height - contentTop - bottomInset)
        let sideWidth = min(compactHeight ? 340 : 380, max(318, proxy.size.width * 0.32))
        let columnGap: CGFloat = compactHeight ? 12 : 16
        let stageWidth = max(360, proxy.size.width - sideWidth - columnGap - outerInset * 2)
        let stageCenterX = outerInset + stageWidth / 2
        let sideCenterX = outerInset + stageWidth + columnGap + sideWidth / 2
        let contentCenterY = contentTop + contentHeight / 2

        ZStack {
            GameplayResourceBar()
                .frame(width: min(proxy.size.width - outerInset * 2, 660))
                .position(x: proxy.size.width / 2, y: hudY)

            gameplayStage(width: stageWidth, height: contentHeight)
                .position(x: stageCenterX, y: contentCenterY)

            VStack(spacing: compactHeight ? 8 : 10) {
                HStack(spacing: 8) {
                    RoundPondButton(systemImage: "house.fill", size: compactHeight ? 36 : 40) { openDock(.home) }
                    LuckMeter(compact: true)
                    Spacer(minLength: 0)
                    ComboSign(compact: true)
                }

                ReelPanel(compact: true)
                    .frame(maxWidth: .infinity)

                JackpotForecastPill(compact: true)

                if !compactHeight {
                    TodayBestSign(compact: true)
                }

                noticeCapsule(width: sideWidth, compact: true)
                    .frame(height: compactHeight ? 42 : 46)

                BaitStrip(selectedBait: $selectedBait, compact: true)
                    .frame(height: compactHeight ? 96 : 102)
                    .clipped()

                actionControls(compact: true)
                    .frame(height: compactHeight ? 76 : 82)
                    .clipped()
            }
            .frame(width: sideWidth, height: contentHeight, alignment: .top)
            .position(x: sideCenterX, y: contentCenterY)
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
    }

    private func gameplayStage(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            GameplayWaterStage(latestCatch: latestCatch)
            CastRodOverlay(latestCatch: latestCatch, selectedBait: selectedBait, isCasting: isCastingRod)
        }
        .frame(width: width)
        .frame(height: height)
        .clipped()
    }

    private func noticeCapsule(width: CGFloat, compact: Bool) -> some View {
        Text(noEnergyPulse ? "Energy is restoring locally. Complete rewards can also restore it." : skillNotice)
            .font(.system(compact ? .caption : .footnote, design: .serif).weight(.semibold))
            .foregroundStyle(PondInk.creamText)
            .lineLimit(compact ? 2 : 1)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.72)
            .padding(.vertical, compact ? 6 : 7)
            .padding(.horizontal, compact ? 12 : 14)
            .frame(width: width)
            .background(Capsule().fill(PondInk.woodDeep.opacity(0.72)))
    }

    private func actionControls(compact: Bool) -> some View {
        HStack(alignment: .center, spacing: compact ? 6 : 8) {
            SkillButton(title: "Scent", emblem: .koiCrest, count: scentCharges, isDisabled: scentCharges <= 0, compact: compact, action: useScent)
            SkillButton(title: "Current", emblem: .rain, count: currentCharges, isDisabled: currentCharges <= 0, compact: compact, action: useCurrent)
            SkillButton(title: "Gleam", emblem: .lotus, count: gleamCharges, isDisabled: gleamCharges <= 0, compact: compact, action: useGleam)
            castButton(compact: compact)
        }
    }

    private func castButton(compact: Bool) -> some View {
        Button(action: castNow) {
            VStack(spacing: compact ? 1 : 2) {
                Text(isResolvingBloom ? "SETTLING" : "CAST")
                    .font(.system(compact ? .headline : .title2, design: .serif).weight(.heavy))
                Text(selectedBait.pondName)
                    .font(.caption2.weight(.bold))
            }
            .foregroundStyle(PondInk.creamText)
            .lineLimit(1)
            .minimumScaleFactor(0.70)
            .frame(width: compact ? 84 : 96, height: compact ? 68 : 76)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: compact ? 18 : 22,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: compact ? 18 : 22,
                    topTrailingRadius: 10,
                    style: .continuous
                )
                .fill(LinearGradient(colors: [PondInk.wood, PondInk.woodDeep], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: compact ? 18 : 22,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: compact ? 18 : 22,
                    topTrailingRadius: 10,
                    style: .continuous
                )
                .stroke(PondInk.gold.opacity(0.86), lineWidth: compact ? 2 : 2.4)
            )
            .shadow(color: PondInk.gold.opacity(0.22), radius: compact ? 5 : 7, x: 0, y: 2)
        }
        .buttonStyle(PondPressButtonStyle())
        .contentShape(Rectangle())
        .disabled(isResolvingBloom)
        .opacity(isResolvingBloom ? 0.62 : 1)
    }

    private func useScent() {
        guard scentCharges > 0 else { return }
        scentCharges -= 1
        selectedBait = .lotusBait
        nextEmblemBias = .lotus
        nextRareLift = max(nextRareLift, 0.035)
        skillNotice = "Scent trail ready: next cast favors petal emblems."
        HapticRipple.light(ledger)
        SoundRipple.tap(ledger)
    }

    private func useCurrent() {
        guard currentCharges > 0 else { return }
        currentCharges -= 1
        if ledger.waterline.reedVault.energy < ledger.waterline.reedVault.maxEnergy {
            ledger.applyBloomYield(BloomYield(energy: 1))
            ledger.saveRipple()
        }
        nextWeightBoost = max(nextWeightBoost, 0.12)
        skillNotice = "Current sent: next catch has stronger weight pull."
        HapticRipple.light(ledger)
        SoundRipple.tap(ledger)
    }

    private func useGleam() {
        guard gleamCharges > 0 else { return }
        gleamCharges -= 1
        ledger.applyBloomYield(BloomYield(harmony: 1))
        ledger.saveRipple()
        nextRareLift = max(nextRareLift, 0.07)
        skillNotice = "Gleam set: rare wake chance rises next cast."
        HapticRipple.bloom(ledger)
        SoundRipple.bloom(ledger)
    }

    private func castNow() {
        guard !isResolvingBloom else { return }
        HapticRipple.light(ledger)
        SoundRipple.tap(ledger)
        guard let hookTally = ledger.castThread(using: selectedBait, emblemBias: nextEmblemBias, rareLift: nextRareLift, weightBoost: nextWeightBoost) else {
            noEnergyPulse = true
            return
        }
        triggerCastRodAnimation()
        nextEmblemBias = nil
        nextRareLift = 0
        nextWeightBoost = 0
        if ledger.waterline.quietSwitchboard.tutorialStep <= 1 {
            ledger.advanceTutorial(to: 2)
        } else if ledger.waterline.quietSwitchboard.tutorialStep == 2 {
            ledger.advanceTutorial(to: 3)
        }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            latestCatch = hookTally
            noEnergyPulse = false
            if hookTally.emblem.isJackpot {
                skillNotice = "Lucky mark hit: \(hookTally.emblem.rawValue)"
            } else {
                skillNotice = "Caught \(hookTally.koi.name) • \(String(format: "%.1f kg", hookTally.koiWeight))"
            }
        }
        if let bloomChain = hookTally.bloomChain {
            isResolvingBloom = true
            ledger.advanceTutorial(to: 4)
            HapticRipple.bloom(ledger)
            SoundRipple.bloom(ledger)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                presentBloom(bloomChain)
            }
        }
    }

    private func triggerCastRodAnimation() {
        withAnimation(.easeIn(duration: 0.12)) {
            isCastingRod = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 14)) {
                isCastingRod = false
            }
        }
    }
}

struct RewardPondView: View {
    @EnvironmentObject private var ledger: RippleLedger
    var bloomChain: BloomChain
    var castAgain: () -> Void
    var claimAndHome: () -> Void

    var body: some View {
        GeometryReader { proxy in
            let usesPadChrome = PondChromeSafeArea.usesPadChrome(in: proxy)
            let compactReward = usesPadChrome || proxy.size.height < 980
            let rewardTopInset = usesPadChrome
                ? min(max(proxy.safeAreaInsets.top, 24), 42)
                : max(proxy.safeAreaInsets.top, 38)
            let topPadding = rewardTopInset + (compactReward ? 4 : 8)
            let bottomPadding = PondChromeSafeArea.bottom(in: proxy) + (compactReward ? 28 : 20)
            let contentWidth = min(proxy.size.width - (compactReward ? 70 : 36), compactReward ? 620 : 700)
            let emblemSize: CGFloat = compactReward ? 68 : 82
            let contentSpacing: CGFloat = compactReward ? 12 : 18

            ZStack {
                PondBackdrop(mood: .night)

                VStack(spacing: compactReward ? 6 : 12) {
                    ResourceBar()
                        .frame(width: min(proxy.size.width - 72, compactReward ? 560 : 640))
                        .padding(.top, topPadding)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: contentSpacing) {
                            WoodenTitle(title: bloomChain.title, subtitle: "3 fish caught")

                            WoodPanel {
                                HStack(spacing: compactReward ? 18 : 12) {
                                    ForEach(Array(bloomChain.emblems.enumerated()), id: \.offset) { _, emblem in
                                        LPEmblemSealView(emblem: emblem, size: emblemSize)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }

                            ParchmentPanel {
                                VStack(spacing: compactReward ? 10 : 12) {
                                    Text("Your Rewards")
                                        .font(.system(compactReward ? .headline : .title3, design: .serif).weight(.bold))
                                    RewardRows(bloomYield: bloomChain.bloomYield)
                                    HStack {
                                        Text("Combo Chain")
                                            .font(compactReward ? .subheadline.weight(.bold) : .headline)
                                        Spacer()
                                        Text("x\(max(1, bloomChain.chainDepth))")
                                            .font((compactReward ? Font.title3 : Font.title2).weight(.heavy))
                                    }
                                    ProgressWood(current: min(5, bloomChain.chainDepth), total: 5, height: compactReward ? 12 : 14)
                                }
                                .foregroundStyle(PondInk.inkText)
                            }

                            HStack(spacing: 12) {
                                RewardActionButton(title: "CAST AGAIN", systemImage: "bolt.fill", isDisabled: ledger.waterline.reedVault.energy <= 0, action: castAgain)
                                RewardActionButton(title: "CLAIM", systemImage: "checkmark.seal.fill", isPrimary: true, action: claimAndHome)
                            }

                            Text(bloomChain.tip)
                                .font(.system(.footnote, design: .serif).weight(.semibold))
                                .foregroundStyle(PondInk.creamText.opacity(0.86))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.78)
                                .padding(.horizontal, 18)
                        }
                        .frame(width: contentWidth)
                        .frame(maxWidth: .infinity)
                        .padding(.top, compactReward ? 2 : 12)
                        .padding(.bottom, bottomPadding)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
            }
        }
    }
}

struct RewardActionButton: View {
    var title: String
    var systemImage: String
    var isPrimary: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .heavy))
                Text(title)
                    .font(.system(.headline, design: .serif).weight(.heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(isDisabled ? PondInk.creamText.opacity(0.48) : PondInk.creamText)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isPrimary
                                ? [Color(red: 0.42, green: 0.56, blue: 0.14), Color(red: 0.18, green: 0.32, blue: 0.08)]
                                : [PondInk.wood, PondInk.woodDeep],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(PondInk.gold.opacity(0.78), lineWidth: 1.5))
                    .shadow(color: .black.opacity(0.20), radius: 4, x: 0, y: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(PondPressButtonStyle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.62 : 1)
    }
}
