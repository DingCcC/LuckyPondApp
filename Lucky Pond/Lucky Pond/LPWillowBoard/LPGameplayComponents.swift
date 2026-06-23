import SwiftUI

struct ReelOrnament: View {
    var emblems: [LPEmblem]

    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 8,
                bottomTrailingRadius: 24,
                topTrailingRadius: 8,
                style: .continuous
            )
            .fill(LinearGradient(colors: [PondInk.woodDeep.opacity(0.98), PondInk.wood.opacity(0.96)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    bottomLeadingRadius: 8,
                    bottomTrailingRadius: 24,
                    topTrailingRadius: 8,
                    style: .continuous
                )
                .stroke(PondInk.gold.opacity(0.56), lineWidth: 1.2)
            )
            HStack(spacing: 14) {
                ForEach(Array(emblems.enumerated()), id: \.offset) { _, emblem in
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(PondInk.parchment.opacity(0.18))
                            .frame(width: 64, height: 76)
                            .rotationEffect(.degrees(emblem == .coin ? 2 : -3))
                        LPEmblemSealView(emblem: emblem, size: 56)
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 22)
        }
        .padding(.horizontal, 54)
    }
}

struct StartCatchShowcase: View {
    private let emblems: [LPEmblem] = [.lotus, .coin, .koiCrest]

    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 28,
                bottomTrailingRadius: 12,
                topTrailingRadius: 28,
                style: .continuous
            )
            .fill(LinearGradient(colors: [PondInk.wood.opacity(0.96), PondInk.woodDeep.opacity(0.98)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 28,
                    bottomTrailingRadius: 12,
                    topTrailingRadius: 28,
                    style: .continuous
                )
                .stroke(PondInk.gold.opacity(0.52), lineWidth: 1.2)
            )
            HStack(spacing: 14) {
                ForEach(emblems, id: \.self) { emblem in
                    LPEmblemSealView(emblem: emblem, size: 58)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }
}

struct DailyQuestCard: View {
    @EnvironmentObject private var ledger: RippleLedger
    var openDock: (PondDock) -> Void

    var body: some View {
        ParchmentPanel(inset: 12) {
            let milestone = ledger.dailyMilestones[0]
            VStack(alignment: .leading, spacing: 8) {
                Text("Pond Task")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PondInk.moss)
                Text("Land 10 catches")
                    .font(.system(.headline, design: .serif).weight(.bold))
                    .foregroundStyle(PondInk.inkText)
                ProgressWood(current: ledger.progress(for: milestone.mark), total: milestone.goal)
                Text("Reward 500 Coins • 20 Pearls")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(PondInk.inkText.opacity(0.82))
            }
        }
        .onTapGesture { openDock(.achievements) }
    }
}

struct EventHomeCard: View {
    var openDock: (PondDock) -> Void

    var body: some View {
        WoodPanel {
            VStack(alignment: .leading, spacing: 8) {
                Text("Lantern Run")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(red: 0.95, green: 0.52, blue: 0.55))
                Text("Bloomtide")
                    .font(.system(.headline, design: .serif).weight(.heavy))
                    .foregroundStyle(PondInk.creamText)
                Text("6d 12h")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PondInk.gold)
                Text("Gather lights along the reed path.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(PondInk.creamText.opacity(0.82))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture { openDock(.festival) }
    }
}

struct HomeTile: View {
    var title: String
    var emblem: LPEmblem
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                PondMenuGlyphBadge(emblem: emblem)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(.headline, design: .serif).weight(.heavy))
                        .foregroundStyle(PondInk.inkText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)
                    Text(tileSubtitle)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(PondInk.wood.opacity(0.68))
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 112)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 7,
                    bottomLeadingRadius: 18,
                    bottomTrailingRadius: 7,
                    topTrailingRadius: 18,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.96, green: 0.82, blue: 0.55), PondInk.parchment],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 7,
                        bottomLeadingRadius: 18,
                        bottomTrailingRadius: 7,
                        topTrailingRadius: 18,
                        style: .continuous
                    )
                    .stroke(PondInk.gold.opacity(0.70), lineWidth: 1.4)
                )
                .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PondPressButtonStyle())
    }

    private var tileSubtitle: String {
        switch emblem {
        case .koiCrest: return "species"
        case .bridge: return "layout"
        case .lantern: return "run"
        case .tidehook: return "gear"
        case .bell: return "feats"
        case .reed: return "trade"
        default: return "pond"
        }
    }
}

struct PondMenuGlyphBadge: View {
    var emblem: LPEmblem

    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 8,
                bottomLeadingRadius: 18,
                bottomTrailingRadius: 8,
                topTrailingRadius: 18,
                style: .continuous
            )
            .fill(LinearGradient(colors: [PondInk.woodDeep, PondInk.wood.opacity(0.92)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 8,
                    bottomLeadingRadius: 18,
                    bottomTrailingRadius: 8,
                    topTrailingRadius: 18,
                    style: .continuous
                )
                .stroke(PondInk.gold.opacity(0.48), lineWidth: 1.1)
            )
            Image(emblem.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .shadow(color: .black.opacity(0.18), radius: 1, x: 0, y: 1)
        }
        .frame(width: 58, height: 68)
    }
}

struct PondRoleGlyph: View {
    var emblem: LPEmblem

    var body: some View {
        switch emblem {
        case .koiCrest:
            PondKoiGlyph()
        case .bridge:
            PondBridgeGlyph()
        case .lantern:
            PondLanternGlyph()
        case .tidehook:
            PondReedGlyph()
        case .bell:
            PondBellGlyph()
        case .reed:
            PondLeafGlyph()
        default:
            PondPearlGlyph()
        }
    }
}

struct LuckMeter: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Luck Meter")
                .font(.caption2.weight(.bold))
            ProgressWood(current: min(100, ledger.waterline.reedVault.harmony), total: 100, height: 7)
            Text("\(max(1, ledger.waterline.comboChain + 1))x")
                .font(.system(.headline, design: .serif).weight(.heavy))
        }
        .foregroundStyle(PondInk.inkText)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(width: 110, height: 62, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(PondInk.parchmentLight.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.wood.opacity(0.58), lineWidth: 1.2))
        )
        .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 2)
    }
}

struct GameplayResourceBar: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        HStack(spacing: 8) {
            ResourcePill(assetName: "lp_hud_coins", text: ledger.waterline.reedVault.coins.formatted())
            ResourcePill(assetName: "lp_hud_pearls", text: ledger.waterline.reedVault.pearls.formatted())
            ResourcePill(assetName: "lp_hud_energy", text: "\(ledger.waterline.reedVault.energy)/\(ledger.waterline.reedVault.maxEnergy)")
        }
    }
}

struct GameplayWaterStage: View {
    var latestCatch: HookTally?

    var body: some View {
        ZStack {
            Image("premium_pond_day")
                .resizable()
                .scaledToFill()

            LinearGradient(
                colors: [Color.clear, PondInk.pond.opacity(0.10), PondInk.pondDeep.opacity(0.18)],
                startPoint: .top,
                endPoint: .bottom
            )

            WaterLines()
                .stroke(Color.white.opacity(0.13), style: StrokeStyle(lineWidth: 1.1, lineCap: .round))
                .padding(.horizontal, 18)
                .padding(.vertical, 34)
                .allowsHitTesting(false)

            GameplayFishLayer(latestCatch: latestCatch)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(PondInk.gold.opacity(0.76), lineWidth: 1.8)
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(LinearGradient(colors: [.clear, PondInk.woodDeep.opacity(0.55)], startPoint: .top, endPoint: .bottom))
                .frame(height: 64)
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.24), radius: 8, x: 0, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct GameplayFishLayer: View {
    @EnvironmentObject private var ledger: RippleLedger
    var latestCatch: HookTally?

    var body: some View {
        if ledger.waterline.quietSwitchboard.lowMotionEnabled {
            GeometryReader { proxy in
                fishField(in: proxy, time: 0, animated: false)
            }
            .allowsHitTesting(false)
        } else {
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                GeometryReader { proxy in
                    fishField(in: proxy, time: time, animated: true)
                }
            }
            .allowsHitTesting(false)
        }
    }

    @ViewBuilder
    private func fishField(in proxy: GeometryProxy, time: TimeInterval, animated: Bool) -> some View {
        ZStack {
            PondFishSprite(emblem: .coin, bodyColor: Color(red: 0.92, green: 0.64, blue: 0.24), width: 96, angle: -12, phase: time * 0.85)
                .position(x: proxy.size.width * (0.25 + 0.035 * sin(time * 0.65)), y: proxy.size.height * (0.47 + 0.035 * cos(time * 0.72)))
            PondFishSprite(emblem: .tidehook, bodyColor: Color(red: 0.86, green: 0.84, blue: 0.68), width: 88, angle: 9, phase: time * 0.9 + 1.7)
                .position(x: proxy.size.width * (0.72 + 0.04 * sin(time * 0.58 + 1.4)), y: proxy.size.height * (0.38 + 0.03 * cos(time * 0.62)))
            PondFishSprite(emblem: .frog, bodyColor: Color(red: 0.58, green: 0.72, blue: 0.42), width: 82, angle: -6, phase: time * 1.05 + 2.4)
                .position(x: proxy.size.width * (0.66 + 0.03 * sin(time * 0.74 + 2.2)), y: proxy.size.height * (0.63 + 0.028 * cos(time * 0.8)))
            PondFishSprite(emblem: .lantern, bodyColor: Color(red: 0.94, green: 0.78, blue: 0.48), width: 84, angle: 16, phase: time * 0.82 + 3.0)
                .position(x: proxy.size.width * (0.50 + 0.035 * sin(time * 0.68 + 3.1)), y: proxy.size.height * (0.76 + 0.026 * cos(time * 0.88)))
            PondFishSprite(emblem: .lotus, bodyColor: Color(red: 0.93, green: 0.50, blue: 0.48), width: latestCatch == nil ? 108 : 124, angle: latestCatch == nil ? -18 : -26, phase: time * 1.12)
                .position(x: proxy.size.width * (0.37 + 0.018 * sin(time)), y: proxy.size.height * (latestCatch == nil ? 0.58 : 0.52))
                .scaleEffect(latestCatch == nil ? 1 : 1.08)
                .animation(animated ? .spring(response: 0.32, dampingFraction: 0.72) : nil, value: latestCatch?.id)
        }
    }
}

struct PondFishSprite: View {
    var emblem: LPEmblem
    var bodyColor: Color
    var width: CGFloat
    var angle: Double
    var phase: Double

    var body: some View {
        ZStack {
            Ellipse()
                .fill(
                    LinearGradient(colors: [bodyColor.opacity(0.96), PondInk.creamText.opacity(0.78), bodyColor.opacity(0.82)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: width * 0.72, height: width * 0.34)
                .overlay(Ellipse().stroke(Color.white.opacity(0.32), lineWidth: 1))
                .shadow(color: .black.opacity(0.20), radius: 5, x: 0, y: 3)

            TailShape()
                .fill(bodyColor.opacity(0.82))
                .frame(width: width * 0.26, height: width * 0.34)
                .offset(x: width * 0.39)
                .rotationEffect(.degrees(sin(phase * 4) * 7))

            Ellipse()
                .fill(bodyColor.opacity(0.65))
                .frame(width: width * 0.22, height: width * 0.10)
                .offset(x: -width * 0.02, y: -width * 0.18)
                .rotationEffect(.degrees(-16))

            Ellipse()
                .fill(bodyColor.opacity(0.55))
                .frame(width: width * 0.24, height: width * 0.10)
                .offset(x: width * 0.02, y: width * 0.18)
                .rotationEffect(.degrees(18))

            Circle()
                .fill(PondInk.woodDeep)
                .frame(width: width * 0.045, height: width * 0.045)
                .offset(x: -width * 0.25, y: -width * 0.04)

            LPEmblemSealView(emblem: emblem, size: width * 0.22)
                .offset(x: width * 0.06)
                .opacity(0.88)
        }
            .frame(width: width, height: width * 0.46)
            .rotationEffect(.degrees(angle))
            .opacity(0.88)
    }
}

struct TailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.82, y: rect.midY), control: CGPoint(x: rect.maxX * 0.95, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CastRodOverlay: View {
    var latestCatch: HookTally?
    var selectedBait: BaitKind
    var isCasting: Bool

    var body: some View {
        GeometryReader { proxy in
            let hookPoint = CGPoint(
                x: proxy.size.width * (isCasting ? 0.46 : 0.48),
                y: proxy.size.height * (isCasting ? 0.66 : 0.70)
            )
            let rodTip = CGPoint(
                x: proxy.size.width * (isCasting ? 0.78 : 0.83),
                y: proxy.size.height * (isCasting ? 0.22 : 0.18)
            )
            ZStack {
                Image("lp_gameplay_cast_rod")
                    .resizable()
                    .scaledToFit()
                    .frame(height: proxy.size.height * 1.16)
                    .rotationEffect(.degrees(isCasting ? -10 : 0), anchor: .bottomTrailing)
                    .offset(x: isCasting ? -20 : 0, y: isCasting ? -18 : 0)
                    .position(x: proxy.size.width * 0.90, y: proxy.size.height * 0.58)
                    .shadow(color: .black.opacity(0.24), radius: 5, x: 0, y: 3)
                    .animation(.interpolatingSpring(stiffness: 150, damping: 14), value: isCasting)

                Path { path in
                    path.move(to: rodTip)
                    path.addQuadCurve(
                        to: CGPoint(x: hookPoint.x + 2, y: hookPoint.y - 18),
                        control: CGPoint(
                            x: proxy.size.width * (isCasting ? 0.48 : 0.52),
                            y: proxy.size.height * (isCasting ? 0.33 : 0.36)
                        )
                    )
                }
                .stroke(
                    PondInk.creamText.opacity(isCasting ? 0.58 : latestCatch == nil ? 0.28 : 0.46),
                    style: StrokeStyle(lineWidth: isCasting ? 1.7 : 1.2, lineCap: .round, dash: latestCatch == nil ? [] : [4, 5])
                )
                .animation(.interpolatingSpring(stiffness: 150, damping: 14), value: isCasting)

                Circle()
                    .stroke(PondInk.creamText.opacity(isCasting ? 0.78 : 0.55), lineWidth: isCasting ? 2.8 : 2)
                    .frame(width: isCasting ? 72 : latestCatch == nil ? 42 : 66, height: isCasting ? 72 : latestCatch == nil ? 42 : 66)
                    .position(x: hookPoint.x, y: hookPoint.y + 18)
                    .scaleEffect(isCasting ? 1.08 : 1)
                    .animation(.easeOut(duration: 0.24), value: isCasting)
                    .animation(.easeOut(duration: 0.35), value: latestCatch?.id)

                BaitOnHookView(baitKind: selectedBait, isCasting: isCasting)
                    .frame(width: isCasting ? 58 : 52, height: isCasting ? 58 : 52)
                    .position(x: hookPoint.x + (isCasting ? 4 : 0), y: hookPoint.y)
                    .animation(.interpolatingSpring(stiffness: 150, damping: 15), value: isCasting)
                    .animation(.easeOut(duration: 0.22), value: selectedBait)
            }
            .allowsHitTesting(false)
        }
    }
}

struct BaitOnHookView: View {
    var baitKind: BaitKind
    var isCasting: Bool

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 28, y: 1))
                path.addLine(to: CGPoint(x: 28, y: 16))
                path.addQuadCurve(to: CGPoint(x: 20, y: 35), control: CGPoint(x: 13, y: 22))
                path.addQuadCurve(to: CGPoint(x: 37, y: 38), control: CGPoint(x: 23, y: 49))
            }
            .stroke(PondInk.creamText.opacity(0.78), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))

            Image(baitKind.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: isCasting ? 36 : 32, height: isCasting ? 36 : 32)
                .rotationEffect(.degrees(isCasting ? -8 : 3))
                .shadow(color: .black.opacity(0.20), radius: 3, x: 0, y: 2)
                .offset(x: -5, y: 15)
        }
        .accessibilityHidden(true)
    }
}

struct CatchSplashCard: View {
    var catchTally: HookTally

    var body: some View {
        HStack(spacing: 10) {
            LPEmblemSealView(emblem: catchTally.emblem, size: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(catchTally.firstCatch ? "New Catch" : "Caught")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PondInk.moss)
                Text("\(catchTally.koi.name) • \(String(format: "%.1f kg", catchTally.koiWeight))")
                    .font(.system(.subheadline, design: .serif).weight(.heavy))
                    .foregroundStyle(PondInk.inkText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(PondInk.parchmentLight.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(PondInk.wood.opacity(0.52), lineWidth: 1.2))
        )
        .shadow(color: .black.opacity(0.20), radius: 6, x: 0, y: 3)
    }
}

struct PassiveTutorialPondOverlay: View {
    @EnvironmentObject private var ledger: RippleLedger
    var activeDock: PondDock

    var body: some View {
        if shouldShowTutorial {
            VStack {
                if activeDock == .gameplay {
                    hintCard
                        .padding(.top, 112)
                    Spacer()
                } else {
                    Spacer()
                    hintCard
                        .padding(.bottom, 86)
                }
            }
            .padding(.horizontal, 18)
            .allowsHitTesting(false)
            .transition(.opacity)
        }
    }

    private var shouldShowTutorial: Bool {
        guard !ledger.waterline.quietSwitchboard.hasCompletedTutorial else { return false }
        switch activeDock {
        case .home:
            return false
        case .gameplay:
            return tutorialStep >= 1 && tutorialStep <= 3
        case .reward:
            return tutorialStep == 4
        default:
            return false
        }
    }

    private var tutorialStep: Int {
        ledger.waterline.quietSwitchboard.tutorialStep
    }

    private var hintCard: some View {
        HStack(spacing: 10) {
            LPEmblemSealView(emblem: tutorialEmblem, size: 34)
            Text(tutorialText)
                .font(.system(.footnote, design: .serif).weight(.bold))
                .foregroundStyle(PondInk.creamText)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(PondInk.woodDeep.opacity(0.88))
                .overlay(Capsule().stroke(PondInk.gold.opacity(0.55), lineWidth: 1))
                .shadow(color: .black.opacity(0.22), radius: 5, x: 0, y: 2)
        )
    }

    private var tutorialText: String {
        switch tutorialStep {
        case 0: return "Tap Play to cast into the pond."
        case 1: return "Cast into the pond."
        case 2: return "Each fish carries an emblem."
        case 3: return "Catch three fish to form a Catch Reel."
        case 4: return "Good matches bring better rewards."
        default: return "Decorate your pond or upgrade a rod to attract rarer fish."
        }
    }

    private var tutorialEmblem: LPEmblem {
        switch tutorialStep {
        case 0: return .koiCrest
        case 1: return .rain
        case 2: return .lotus
        case 3: return .bell
        case 4: return .pearl
        default: return .bridge
        }
    }
}

struct ReelPanel: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        VStack(spacing: 6) {
            Text("Catch Reel")
                .font(.system(.subheadline, design: .serif).weight(.heavy))
                .foregroundStyle(PondInk.creamText)
                .shadow(color: .black.opacity(0.38), radius: 2, x: 0, y: 1)
            HStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { slotIndex in
                    LPEmblemSealView(emblem: slotIndex < ledger.waterline.catchReel.count ? ledger.waterline.catchReel[slotIndex] : nil, size: 48)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: [Color(red: 0.43, green: 0.24, blue: 0.10), PondInk.woodDeep], startPoint: .top, endPoint: .bottom))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.gold.opacity(0.58), lineWidth: 1.4))
                .shadow(color: .black.opacity(0.20), radius: 5, x: 0, y: 3)
        )
    }
}

struct JackpotForecastPill: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        HStack(spacing: 8) {
            LPEmblemSealView(emblem: ledger.nextJackpotEmblem, size: 28)
            VStack(alignment: .leading, spacing: 1) {
                Text("Lucky Mark")
                    .font(.caption2.weight(.heavy))
                Text(ledger.castsUntilJackpot <= 1 ? "next cast" : "in \(ledger.castsUntilJackpot) casts")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(PondInk.gold)
            }
            Spacer(minLength: 0)
            HStack(spacing: 3) {
                ForEach([LPEmblem.fireSeven, .crystalTripleSeven, .crownBar], id: \.self) { emblem in
                    Image(emblem.assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .opacity(emblem == ledger.nextJackpotEmblem ? 1 : 0.42)
                }
            }
        }
        .foregroundStyle(PondInk.creamText)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            Capsule()
                .fill(PondInk.woodDeep.opacity(0.78))
                .overlay(Capsule().stroke(PondInk.gold.opacity(0.48), lineWidth: 1))
                .shadow(color: .black.opacity(0.20), radius: 4, x: 0, y: 2)
        )
        .allowsHitTesting(false)
    }
}

struct TodayBestSign: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        ParchmentPanel(inset: 8) {
            VStack(spacing: 3) {
                Text("Today's Best")
                    .font(.caption.weight(.bold))
                Text(String(format: "%.1f kg", ledger.waterline.progressRipple.bestCatchWeight))
                    .font(.system(.title3, design: .serif).weight(.heavy))
                Text("Record: 18.4 kg")
                    .font(.caption2)
            }
            .foregroundStyle(PondInk.inkText)
            .frame(width: 104)
        }
    }
}

struct ComboSign: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        VStack(spacing: 2) {
            Text("Combo")
                .font(.caption2.weight(.bold))
            Text("x\(max(1, ledger.waterline.comboChain))")
                .font(.system(.headline, design: .serif).weight(.heavy))
            Text("+\(ledger.waterline.comboChain * 10)%")
                .font(.caption2.weight(.bold))
        }
        .foregroundStyle(PondInk.creamText)
        .frame(width: 76, height: 64)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: [Color(red: 0.44, green: 0.24, blue: 0.10).opacity(0.94), PondInk.woodDeep.opacity(0.94)], startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.gold.opacity(0.58), lineWidth: 1.2))
        )
        .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)
    }
}

struct BaitStrip: View {
    @Binding var selectedBait: BaitKind
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 18,
                bottomLeadingRadius: 8,
                bottomTrailingRadius: 18,
                topTrailingRadius: 8,
                style: .continuous
            )
            .fill(LinearGradient(colors: [PondInk.wood.opacity(0.98), PondInk.woodDeep.opacity(0.98)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 18,
                    bottomLeadingRadius: 8,
                    bottomTrailingRadius: 18,
                    topTrailingRadius: 8,
                    style: .continuous
                )
                .stroke(PondInk.gold.opacity(0.56), lineWidth: 1.2)
            )
            VStack(spacing: 7) {
                Text("Bait Rack")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(PondInk.parchmentLight)
                HStack(spacing: 8) {
                    ForEach(BaitKind.allCases) { baitKind in
                        let isSelected = selectedBait == baitKind
                        let count = ledger.waterline.reedVault.bait[baitKind.rawValue, default: 0]
                        Button {
                            selectedBait = baitKind
                        } label: {
                            VStack(spacing: 2) {
                                ZStack {
                                    PondGlyphPlateShape()
                                        .fill(isSelected ? PondInk.gold.opacity(0.25) : PondInk.woodDeep.opacity(0.50))
                                        .overlay(
                                            PondGlyphPlateShape()
                                                .stroke(isSelected ? PondInk.gold : PondInk.parchmentLight.opacity(0.25), lineWidth: isSelected ? 1.8 : 1)
                                        )
                                    BaitGlyphView(baitKind: baitKind)
                                        .frame(width: isSelected ? 34 : 30, height: isSelected ? 34 : 30)
                                }
                                .frame(height: 34)
                                Text(baitKind.shortName)
                                    .font(.caption2.weight(.heavy))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.68)
                                Text("\(count)")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(count == 0 ? Color(red: 0.95, green: 0.45, blue: 0.35) : PondInk.parchmentLight.opacity(0.86))
                            }
                            .foregroundStyle(isSelected ? PondInk.gold : PondInk.creamText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 6,
                                    bottomLeadingRadius: 13,
                                    bottomTrailingRadius: 6,
                                    topTrailingRadius: 13,
                                    style: .continuous
                                )
                                .fill(isSelected ? PondInk.woodDeep.opacity(0.72) : PondInk.woodDeep.opacity(0.38))
                            )
                            .overlay(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 6,
                                    bottomLeadingRadius: 13,
                                    bottomTrailingRadius: 6,
                                    topTrailingRadius: 13,
                                    style: .continuous
                                )
                                .stroke(isSelected ? PondInk.gold : Color.clear, lineWidth: 1.6)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PondPressButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
    }
}

struct SkillButton: View {
    var title: String
    var emblem: LPEmblem
    var count: Int
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    LPEmblemSealView(emblem: emblem, size: 38)
                        .opacity(isDisabled ? 0.45 : 1)
                }
                .frame(width: 40, height: 34)
                Text(title)
                    .font(.caption.weight(.heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                Text("\(count) left")
                    .font(.caption2.weight(.bold))
            }
            .foregroundStyle(isDisabled ? PondInk.inkText.opacity(0.42) : PondInk.inkText)
            .frame(maxWidth: .infinity, minHeight: 76)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 6,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 6,
                    topTrailingRadius: 16,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: isDisabled
                            ? [PondInk.parchment.opacity(0.64), PondInk.wood.opacity(0.28)]
                            : [PondInk.parchmentLight, PondInk.parchment],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 6,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 6,
                        topTrailingRadius: 16,
                        style: .continuous
                    )
                    .stroke(PondInk.wood.opacity(isDisabled ? 0.26 : 0.62), lineWidth: 1.4)
                )
            )
            .contentShape(Rectangle())
        }
        .disabled(isDisabled)
        .buttonStyle(PondPressButtonStyle())
    }
}

struct BaitGlyphView: View {
    var baitKind: BaitKind

    var body: some View {
        Image(baitKind.assetName)
            .resizable()
            .scaledToFit()
            .shadow(color: .black.opacity(0.18), radius: 2, x: 0, y: 1)
    }
}
