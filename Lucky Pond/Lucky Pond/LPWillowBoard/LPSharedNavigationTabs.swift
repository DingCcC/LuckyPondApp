import SwiftUI

struct RewardRows: View {
    var bloomYield: BloomYield

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            if bloomYield.coins > 0 { RewardChip(assetName: "lp_hud_coins", text: "\(bloomYield.coins) Coins") }
            if bloomYield.pearls > 0 { RewardChip(assetName: "lp_hud_pearls", text: "\(bloomYield.pearls) Pearls") }
            if bloomYield.energy > 0 { RewardChip(assetName: "lp_hud_energy", text: "\(bloomYield.energy) Energy") }
            if bloomYield.harmony > 0 { RewardChip(icon: "leaf.fill", text: "\(bloomYield.harmony) Harmony", tint: PondInk.reed) }
            if bloomYield.lanternTokens > 0 { RewardChip(icon: "lightbulb.max.fill", text: "\(bloomYield.lanternTokens) Lanterns", tint: .orange) }
            ForEach(bloomYield.bait.sorted(by: { $0.key < $1.key }), id: \.key) { baitName, baitCount in
                RewardChip(icon: "shippingbox.fill", text: "\(baitName) x\(baitCount)", tint: PondInk.moss)
            }
            ForEach(bloomYield.materials.sorted(by: { $0.key < $1.key }), id: \.key) { materialName, materialCount in
                RewardChip(icon: "square.stack.3d.up.fill", text: "\(materialName) x\(materialCount)", tint: .brown)
            }
            if let buffTitle = bloomYield.buffTitle {
                RewardChip(icon: "sparkles", text: "\(buffTitle) \(bloomYield.buffMinutes)m", tint: .purple)
            }
        }
    }
}

struct RewardChip: View {
    var assetName: String?
    var icon: String?
    var text: String
    var tint: Color = PondInk.gold

    init(assetName: String, text: String) {
        self.assetName = assetName
        self.icon = nil
        self.text = text
    }

    init(icon: String, text: String, tint: Color) {
        self.assetName = nil
        self.icon = icon
        self.text = text
        self.tint = tint
    }

    var body: some View {
        HStack(spacing: 6) {
            if let assetName {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.14), radius: 1, x: 0, y: 1)
            } else if let icon {
                Image(systemName: icon).foregroundStyle(tint)
            }
            Text(text)
                .font(.caption.weight(.bold))
                .lineLimit(2)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8).fill(PondInk.parchment.opacity(0.56)))
    }
}

struct HeaderRow: View {
    var title: String
    var subtitle: String
    var rightSystemImage: String = "line.3.horizontal"
    var rightDock: PondDock = .settings
    var openDock: (PondDock) -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                RoundPondButton(systemImage: "chevron.left") { openDock(.home) }
                WoodenTitle(title: title, subtitle: subtitle)
                RoundPondButton(systemImage: rightSystemImage) { openDock(rightDock) }
            }
        }
        .padding(.top, 8)
    }
}

struct TutorialPondOverlay: View {
    @EnvironmentObject private var ledger: RippleLedger
    var activeDock: PondDock
    var openDock: (PondDock) -> Void

    var body: some View {
        if shouldShowTutorial {
            VStack {
                if activeDock == .gameplay {
                    tutorialCard
                        .padding(.top, 112)
                    Spacer()
                } else {
                    Spacer()
                    tutorialCard
                        .padding(.bottom, 86)
                }
            }
            .padding(.horizontal, 18)
            .transition(.move(edge: activeDock == .gameplay ? .top : .bottom).combined(with: .opacity))
        }
    }

    private var shouldShowTutorial: Bool {
        guard !ledger.waterline.quietSwitchboard.hasCompletedTutorial else { return false }
        switch activeDock {
        case .home:
            return tutorialStep == 0 || tutorialStep == 5
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

    private var tutorialCard: some View {
        ParchmentPanel(inset: 12) {
            HStack(spacing: 12) {
                LPEmblemSealView(emblem: tutorialEmblem, size: 46)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pond Guide")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PondInk.moss)
                    Text(tutorialText)
                        .font(.system(.subheadline, design: .serif).weight(.bold))
                        .foregroundStyle(PondInk.inkText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                }
                Spacer()
                Button(primaryTitle) {
                    primaryAction()
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(PondInk.creamText)
                .padding(.vertical, 9)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 8).fill(PondInk.moss))
                Button {
                    ledger.completeTutorial()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PondInk.inkText.opacity(0.65))
                }
                .buttonStyle(PondPressButtonStyle())
            }
        }
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

    private var primaryTitle: String {
        switch tutorialStep {
        case 0: return "Play"
        case 4: return "Claim"
        case 5: return "Pond"
        default: return "OK"
        }
    }

    private func primaryAction() {
        switch tutorialStep {
        case 0:
            ledger.advanceTutorial(to: 1)
            openDock(.gameplay)
        case 2:
            ledger.advanceTutorial(to: 3)
        case 4:
            ledger.advanceTutorial(to: 5)
            openDock(.home)
        case 5:
            ledger.completeTutorial()
            openDock(.pondGarden)
        default:
            break
        }
    }
}

struct SectionTitle: View {
    private var title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.system(.headline, design: .serif).weight(.heavy))
                .foregroundStyle(PondInk.creamText)
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
    }
}

enum ArchiveTab: String, CaseIterable, Identifiable, TabLabel {
    case fish = "Fish Album"
    case decor = "Pondworks"
    case rods = "Tackle"
    case talismans = "Talismans"
    var id: String { rawValue }
    var label: String { rawValue }
    var emblem: LPEmblem {
        switch self {
        case .fish: return .koiCrest
        case .decor: return .bridge
        case .rods: return .tidehook
        case .talismans: return .lotus
        }
    }
    var summaryTitle: String { rawValue }
    var summaryLine: String {
        switch self {
        case .fish: return "Caught and locked fish are recorded here."
        case .decor: return "Placed pond pieces raise Harmony and open water zones."
        case .rods: return "Tackle tuning changes cast power, precision, and luck."
        case .talismans: return "Talismans add local bonuses earned through casts."
        }
    }
    var actionTitle: String {
        switch self {
        case .fish: return "View Fish"
        case .decor: return "Open Pond"
        case .rods: return "Open Gear"
        case .talismans: return "Open Talismans"
        }
    }
    var actionIcon: String { "arrow.right.circle.fill" }
    var destination: PondDock {
        switch self {
        case .fish: return .fishAlbum
        case .decor: return .pondGarden
        case .rods, .talismans: return .gear
        }
    }
}

enum GearTab: String, CaseIterable, Identifiable, TabLabel {
    case rods = "Rods"
    case lines = "Traces"
    case floats = "Floats"
    case talismans = "Talismans"
    var id: String { rawValue }
    var label: String { rawValue }
}

enum FestivalTab: String, CaseIterable, Identifiable, TabLabel {
    case missions = "Missions"
    case rewards = "Rewards"
    case records = "Records"
    var id: String { rawValue }
    var label: String { rawValue }
}

enum SupplyTab: String, CaseIterable, Identifiable, TabLabel {
    case baits = "Baits"
    case materials = "Parts"
    case talismans = "Talismans"
    case decor = "Pondworks"
    case trade = "Trade"
    var id: String { rawValue }
    var label: String { rawValue }
}

protocol TabLabel: Hashable {
    var label: String { get }
}
