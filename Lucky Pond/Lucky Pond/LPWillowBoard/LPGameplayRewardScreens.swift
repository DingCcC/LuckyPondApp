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
                let topInset = max(proxy.safeAreaInsets.top, 58)
                let bottomInset = max(proxy.safeAreaInsets.bottom, 28)
                let hudY = topInset + 24
                let controlsHeight: CGFloat = 212
                let waterTop = topInset + 72
                let waterBottom = proxy.size.height - bottomInset - controlsHeight
                let stageHeight = max(360, waterBottom - waterTop)
                let stageCenterY = waterTop + stageHeight / 2
                let topHudRowY = waterTop + 42
                let noticeY = proxy.size.height - bottomInset - 235
                let baitY = proxy.size.height - bottomInset - 152
                let actionY = proxy.size.height - bottomInset - 52

                ZStack {
                    GameplayResourceBar()
                        .frame(width: proxy.size.width - 24)
                        .position(x: proxy.size.width / 2, y: hudY)

                    ZStack {
                        GameplayWaterStage(latestCatch: latestCatch)
                        CastRodOverlay(latestCatch: latestCatch, selectedBait: selectedBait, isCasting: isCastingRod)
                    }
                    .frame(width: proxy.size.width - 18)
                    .frame(height: stageHeight)
                    .clipped()
                    .position(x: proxy.size.width / 2, y: stageCenterY)

                    RoundPondButton(systemImage: "house.fill", size: 40) { openDock(.home) }
                        .position(x: 44, y: topHudRowY)

                    LuckMeter()
                        .position(x: 124, y: topHudRowY)

                    ReelPanel()
                        .frame(width: min(214, proxy.size.width * 0.54))
                        .position(x: proxy.size.width / 2, y: waterTop + 130)

                    JackpotForecastPill()
                        .frame(width: min(232, proxy.size.width * 0.58))
                        .position(x: proxy.size.width / 2, y: waterTop + 198)

                    ComboSign()
                        .position(x: proxy.size.width - 60, y: topHudRowY)

                    TodayBestSign()
                        .position(x: 74, y: noticeY - 66)

                    Text(noEnergyPulse ? "Energy is restoring locally. Complete rewards can also restore it." : skillNotice)
                        .font(.system(.footnote, design: .serif).weight(.semibold))
                        .foregroundStyle(PondInk.creamText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 14)
                        .background(Capsule().fill(PondInk.woodDeep.opacity(0.7)))
                        .frame(width: proxy.size.width - 50)
                        .position(x: proxy.size.width / 2, y: noticeY)

                    BaitStrip(selectedBait: $selectedBait)
                        .frame(width: proxy.size.width - 24, height: 108)
                        .clipped()
                        .position(x: proxy.size.width / 2, y: baitY)

                    HStack(alignment: .center, spacing: 8) {
                        SkillButton(title: "Scent", emblem: .koiCrest, count: scentCharges, isDisabled: scentCharges <= 0) {
                            guard scentCharges > 0 else { return }
                            scentCharges -= 1
                            selectedBait = .lotusBait
                            nextEmblemBias = .lotus
                            nextRareLift = max(nextRareLift, 0.035)
                            skillNotice = "Scent trail ready: next cast favors petal emblems."
                            HapticRipple.light(ledger)
                            SoundRipple.tap(ledger)
                        }
                        SkillButton(title: "Current", emblem: .rain, count: currentCharges, isDisabled: currentCharges <= 0) {
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
                        SkillButton(title: "Gleam", emblem: .lotus, count: gleamCharges, isDisabled: gleamCharges <= 0) {
                            guard gleamCharges > 0 else { return }
                            gleamCharges -= 1
                            ledger.applyBloomYield(BloomYield(harmony: 1))
                            ledger.saveRipple()
                            nextRareLift = max(nextRareLift, 0.07)
                            skillNotice = "Gleam set: rare wake chance rises next cast."
                            HapticRipple.bloom(ledger)
                            SoundRipple.bloom(ledger)
                        }
                        Button(action: castNow) {
                            VStack(spacing: 2) {
                                Text(isResolvingBloom ? "SETTLING" : "CAST")
                                    .font(.system(.title2, design: .serif).weight(.heavy))
                                Text(selectedBait.pondName)
                                    .font(.caption2.weight(.bold))
                            }
                            .foregroundStyle(PondInk.creamText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.70)
                            .frame(width: 96, height: 76)
                            .background(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 22,
                                    bottomLeadingRadius: 10,
                                    bottomTrailingRadius: 22,
                                    topTrailingRadius: 10,
                                    style: .continuous
                                )
                                .fill(LinearGradient(colors: [PondInk.wood, PondInk.woodDeep], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                            .overlay(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 22,
                                    bottomLeadingRadius: 10,
                                    bottomTrailingRadius: 22,
                                    topTrailingRadius: 10,
                                    style: .continuous
                                )
                                .stroke(PondInk.gold.opacity(0.86), lineWidth: 2.4)
                            )
                            .shadow(color: PondInk.gold.opacity(0.22), radius: 7, x: 0, y: 2)
                        }
                        .buttonStyle(PondPressButtonStyle())
                        .contentShape(Rectangle())
                        .disabled(isResolvingBloom)
                        .opacity(isResolvingBloom ? 0.62 : 1)
                    }
                    .frame(width: proxy.size.width - 24, height: 88)
                    .clipped()
                    .position(x: proxy.size.width / 2, y: actionY)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .onAppear {
            isResolvingBloom = false
        }
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
        ZStack {
            PondBackdrop(mood: .night)
            VStack(spacing: 0) {
                ResourceBar()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        WoodenTitle(title: bloomChain.title, subtitle: "3 fish caught")
                            .padding(.horizontal, 18)

                        WoodPanel {
                            HStack(spacing: 12) {
                                ForEach(Array(bloomChain.emblems.enumerated()), id: \.offset) { _, emblem in
                                    LPEmblemSealView(emblem: emblem, size: 82)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 22)

                        ParchmentPanel {
                            VStack(spacing: 12) {
                                Text("Your Rewards")
                                    .font(.system(.title3, design: .serif).weight(.bold))
                                RewardRows(bloomYield: bloomChain.bloomYield)
                                HStack {
                                    Text("Combo Chain")
                                        .font(.headline)
                                    Spacer()
                                    Text("x\(max(1, bloomChain.chainDepth))")
                                        .font(.title2.weight(.heavy))
                                }
                                ProgressWood(current: min(5, bloomChain.chainDepth), total: 5, height: 14)
                            }
                            .foregroundStyle(PondInk.inkText)
                        }
                        .padding(.horizontal, 18)

                        HStack(spacing: 12) {
                            PondButton(title: "CAST AGAIN", systemImage: "bolt.fill", isDisabled: ledger.waterline.reedVault.energy <= 0, action: castAgain)
                            PondButton(title: "CLAIM", systemImage: "checkmark.seal.fill", isPrimary: true, action: claimAndHome)
                        }
                        .padding(.horizontal, 18)

                        Text(bloomChain.tip)
                            .font(.system(.footnote, design: .serif).weight(.semibold))
                            .foregroundStyle(PondInk.creamText.opacity(0.86))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.vertical, 18)
            }
        }
    }
}
}
