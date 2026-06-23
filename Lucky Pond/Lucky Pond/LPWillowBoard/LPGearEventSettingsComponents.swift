import SwiftUI

struct RodRow: View {
    @EnvironmentObject private var ledger: RippleLedger
    var rod: TackleRod
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                TackleInsignia(emblem: rod.emblem, selected: selected)
                VStack(alignment: .leading, spacing: 5) {
                    Text(rod.name)
                        .font(.system(.headline, design: .serif).weight(.heavy))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text("Lv. \(ledger.waterline.rodLevels[rod.id, default: 1]) • \(rod.rarity.rawValue)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PondInk.creamText.opacity(0.78))
                }
                Spacer()
                if selected {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(PondInk.gold)
                }
            }
            .foregroundStyle(PondInk.creamText)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
            .background(TacklePlaqueBackground(selected: selected))
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(PondPressButtonStyle())
    }
}

struct RodDetail: View {
    @EnvironmentObject private var ledger: RippleLedger
    var rod: TackleRod

    var body: some View {
        ParchmentPanel {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rod.name)
                            .font(.system(.title2, design: .serif).weight(.heavy))
                        Text("Lv. \(ledger.waterline.rodLevels[rod.id, default: 1])/10")
                            .font(.headline)
                    }
                    Spacer()
                    LPEmblemSealView(emblem: rod.emblem, size: 70)
                }
                StatBar(title: "Cast Power", amount: rod.castPower, total: 220)
                StatBar(title: "Precision", amount: rod.precision, total: 220)
                StatBar(title: "Reel Luck", amount: rod.reelLuck, total: 220)
                StatBar(title: "Rare Chance", amount: Int(rod.rareChance * 1000), total: 220)
                HStack {
                    ForEach(rod.materialNeed.sorted(by: { $0.key < $1.key }), id: \.key) { materialName, materialCount in
                        VStack(spacing: 3) {
                            Image(systemName: "square.stack.3d.up.fill")
                            Text("\(ledger.waterline.reedVault.materials[materialName, default: 0])/\(materialCount)")
                                .font(.caption2.weight(.bold))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                PondButton(title: "Upgrade \(rod.upgradeCoins) Coins", systemImage: "arrow.up.circle.fill", isPrimary: true, isDisabled: ledger.waterline.reedVault.coins < rod.upgradeCoins || !ledger.hasMaterials(rod.materialNeed)) {
                    ledger.upgradeRod(rod)
                }
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct StatBar: View {
    var title: String
    var amount: Int
    var total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).font(.caption.weight(.bold))
                Spacer()
                Text("\(amount)").font(.caption.weight(.bold))
            }
            ProgressWood(current: amount, total: total)
        }
    }
}

struct TackleAccessoryRow: View {
    var name: String
    var level: Int
    var rarity: KoiRarity
    var emblem: LPEmblem
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                TackleInsignia(emblem: emblem, selected: selected)
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.system(.headline, design: .serif).weight(.heavy))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text("Lv. \(level) • \(rarity.rawValue)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PondInk.creamText.opacity(0.78))
                }
                Spacer()
                if selected {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(PondInk.gold)
                }
            }
            .foregroundStyle(PondInk.creamText)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
            .background(TacklePlaqueBackground(selected: selected))
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(PondPressButtonStyle())
    }
}

struct LineDetail: View {
    @EnvironmentObject private var ledger: RippleLedger
    var reedLine: ReedLine

    var body: some View {
        ParchmentPanel {
            VStack(alignment: .leading, spacing: 12) {
                TackleDetailHeader(title: reedLine.name, subtitle: "Line Lv. \(ledger.lineLevel(reedLine.id))/10", emblem: reedLine.emblem)
                StatBar(title: "Precision", amount: reedLine.precision + ledger.lineLevel(reedLine.id) * 6, total: 200)
                StatBar(title: "Energy Ease", amount: reedLine.energyEase * 10, total: 140)
                MaterialNeedStrip(materialNeed: reedLine.materialNeed)
                PondButton(title: "Upgrade \(reedLine.upgradeCoins) Coins", systemImage: "arrow.up.circle.fill", isPrimary: true, isDisabled: ledger.waterline.reedVault.coins < reedLine.upgradeCoins || !ledger.hasMaterials(reedLine.materialNeed)) {
                    ledger.upgradeLine(reedLine)
                }
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct FloatDetail: View {
    @EnvironmentObject private var ledger: RippleLedger
    var pondFloat: PondFloat

    var body: some View {
        ParchmentPanel {
            VStack(alignment: .leading, spacing: 12) {
                TackleDetailHeader(title: pondFloat.name, subtitle: "Float Lv. \(ledger.floatLevel(pondFloat.id))/10", emblem: pondFloat.emblem)
                StatBar(title: "Reel Luck", amount: pondFloat.reelLuck + ledger.floatLevel(pondFloat.id) * 7, total: 220)
                StatBar(title: "Rare Chance", amount: Int((pondFloat.rareChance + Double(ledger.floatLevel(pondFloat.id)) * 0.002) * 1000), total: 90)
                MaterialNeedStrip(materialNeed: pondFloat.materialNeed)
                PondButton(title: "Upgrade \(pondFloat.upgradeCoins) Coins", systemImage: "arrow.up.circle.fill", isPrimary: true, isDisabled: ledger.waterline.reedVault.coins < pondFloat.upgradeCoins || !ledger.hasMaterials(pondFloat.materialNeed)) {
                    ledger.upgradeFloat(pondFloat)
                }
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct TackleDetailHeader: View {
    var title: String
    var subtitle: String
    var emblem: LPEmblem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title2, design: .serif).weight(.heavy))
                Text(subtitle)
                    .font(.headline)
            }
            Spacer()
            LPEmblemSealView(emblem: emblem, size: 70)
        }
    }
}

struct MaterialNeedStrip: View {
    @EnvironmentObject private var ledger: RippleLedger
    var materialNeed: [String: Int]

    var body: some View {
        HStack {
            ForEach(materialNeed.sorted(by: { $0.key < $1.key }), id: \.key) { materialName, materialCount in
                VStack(spacing: 3) {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("\(ledger.waterline.reedVault.materials[materialName, default: 0])/\(materialCount)")
                        .font(.caption2.weight(.bold))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct TalismanCard: View {
    @EnvironmentObject private var ledger: RippleLedger
    var talisman: TalismanNest

    var body: some View {
        Button {
            ledger.upgradeTalisman(talisman)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    TackleInsignia(emblem: talisman.emblem, selected: false)
                        .frame(width: 56, height: 56)
                    Spacer()
                    Text("Lv. \(ledger.waterline.talismanLevels[talisman.id, default: 0])")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(PondInk.gold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(PondInk.woodDeep.opacity(0.72)))
                }
                Text(talisman.name)
                    .font(.system(.headline, design: .serif).weight(.heavy))
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                Text(talisman.effectLine)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(PondInk.creamText.opacity(0.78))
                Spacer(minLength: 0)
                HStack(spacing: 6) {
                    Image(systemName: "diamond.circle.fill")
                    Text("\(talisman.upgradePearls) Pearls")
                }
                .font(.caption.weight(.heavy))
                .foregroundStyle(canUpgrade ? PondInk.gold : PondInk.creamText.opacity(0.42))
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(PondInk.woodDeep.opacity(canUpgrade ? 0.82 : 0.45)))
            }
            .foregroundStyle(PondInk.creamText)
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 188, alignment: .leading)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 8,
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 8,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: [PondInk.wood.opacity(0.96), PondInk.woodDeep.opacity(0.98)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 8,
                        style: .continuous
                    )
                    .stroke(PondInk.gold.opacity(0.62), lineWidth: 1.4)
                )
                .shadow(color: .black.opacity(0.22), radius: 5, x: 0, y: 3)
            )
            .contentShape(Rectangle())
        }
        .disabled(!canUpgrade)
        .buttonStyle(PondPressButtonStyle())
    }

    private var canUpgrade: Bool {
        ledger.waterline.reedVault.pearls >= talisman.upgradePearls
    }
}

struct TackleInsignia: View {
    var emblem: LPEmblem
    var selected: Bool

    var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 5,
                bottomTrailingRadius: 16,
                topTrailingRadius: 5,
                style: .continuous
            )
            .fill(selected ? PondInk.moss.opacity(0.94) : PondInk.parchment.opacity(0.88))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 5,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 5,
                    style: .continuous
                )
                .stroke(selected ? PondInk.gold : PondInk.wood.opacity(0.38), lineWidth: selected ? 2 : 1)
            )
            LPEmblemSealView(emblem: emblem, size: 40)
        }
        .frame(width: 62, height: 62)
    }
}

struct TacklePlaqueBackground: View {
    var selected: Bool

    var body: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 8,
            bottomLeadingRadius: 18,
            bottomTrailingRadius: 8,
            topTrailingRadius: 18,
            style: .continuous
        )
        .fill(
            LinearGradient(
                colors: selected
                    ? [PondInk.moss.opacity(0.96), PondInk.wood.opacity(0.98)]
                    : [PondInk.wood.opacity(0.96), PondInk.woodDeep.opacity(0.98)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: 8,
                bottomLeadingRadius: 18,
                bottomTrailingRadius: 8,
                topTrailingRadius: 18,
                style: .continuous
            )
            .stroke(selected ? PondInk.gold : PondInk.gold.opacity(0.36), lineWidth: selected ? 2.2 : 1.1)
        )
        .shadow(color: .black.opacity(0.22), radius: 5, x: 0, y: 3)
    }
}

enum ClaimKind {
    case daily
    case achievement
    case festival
}

struct MilestoneRow: View {
    @EnvironmentObject private var ledger: RippleLedger
    var milestone: WillowMilestone
    var claimed: Bool
    var claimKind: ClaimKind
    var goAction: ((WillowMilestone) -> Void)?

    var body: some View {
        ParchmentPanel(inset: 10) {
            HStack(spacing: 10) {
                LPEmblemSealView(emblem: emblemForMilestone, size: 48)
                VStack(alignment: .leading, spacing: 6) {
                    Text(milestone.title)
                        .font(.system(.subheadline, design: .serif).weight(.bold))
                    ProgressWood(current: ledger.progress(for: milestone.mark), total: milestone.goal, height: 12)
                }
                Button(claimTitle) {
                    if canClaim {
                        switch claimKind {
                        case .daily: ledger.claimDaily(milestone)
                        case .achievement: ledger.claimAchievement(milestone)
                        case .festival:
                            ledger.claimFestivalMission(milestone)
                        }
                    } else {
                        goAction?(milestone)
                    }
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(PondInk.creamText)
                .padding(.vertical, 9)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 8).fill(buttonFill))
                .disabled(claimed || (!canClaim && goAction == nil))
            }
            .foregroundStyle(PondInk.inkText)
        }
    }

    private var canClaim: Bool {
        if claimed { return false }
        return ledger.progress(for: milestone.mark) >= milestone.goal
    }

    private var claimTitle: String {
        if claimed { return "Claimed" }
        return canClaim ? "Claim" : "Go"
    }

    private var buttonFill: Color {
        if canClaim { return PondInk.moss }
        if goAction != nil { return PondInk.wood }
        return PondInk.wood.opacity(0.5)
    }

    private var emblemForMilestone: LPEmblem {
        switch milestone.mark {
        case .lotusFish: return .lotus
        case .tidehookFish: return .tidehook
        case .rareFish, .elderFish, .catches, .unlockedFish: return .koiCrest
        case .combos, .bestCombo, .recipes: return .bell
        case .coinsEarned: return .coin
        case .decorUpgrades, .harmony: return .bridge
        case .rodUpgrades: return .tidehook
        case .lanterns, .loginDays: return .lantern
        }
    }
}

struct FestivalRewardTrack: View {
    @EnvironmentObject private var ledger: RippleLedger
    private let steps = [10, 25, 50, 75, 100]

    var body: some View {
        ParchmentPanel {
            VStack(alignment: .leading, spacing: 14) {
                Text("Lantern Milestone")
                    .font(.system(.title3, design: .serif).weight(.bold))
                ProgressWood(current: ledger.waterline.lotusFestival.lanternsCollected, total: 100, height: 16)
                HStack {
                    ForEach(steps, id: \.self) { step in
                        VStack(spacing: 6) {
                            LPEmblemSealView(emblem: step == 50 ? .bridge : .lantern, size: 46)
                            Text("\(step)")
                                .font(.caption.weight(.bold))
                            PondButton(title: ledger.waterline.lotusFestival.claimedMilestones.contains(step) ? "Done" : "Claim", systemImage: "checkmark", isDisabled: ledger.waterline.lotusFestival.lanternsCollected < step || ledger.waterline.lotusFestival.claimedMilestones.contains(step)) {
                                ledger.claimFestivalStep(step)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct LocalRecordPanel: View {
    @EnvironmentObject private var ledger: RippleLedger

    var body: some View {
        ParchmentPanel {
            VStack(spacing: 12) {
                Text("Local Record Board")
                    .font(.system(.title2, design: .serif).weight(.bold))
                DetailLine(title: "Best Catch", text: String(format: "%.1f kg", ledger.waterline.progressRipple.bestCatchWeight))
                DetailLine(title: "Best Combo Chain", text: "\(ledger.waterline.progressRipple.bestComboChain)")
                DetailLine(title: "Recipes Discovered", text: "\(ledger.waterline.discoveredRecipes.count)")
                Text("Records are stored only on this device.")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct SupplyCard: View {
    @EnvironmentObject private var ledger: RippleLedger
    var fold: SupplyFold

    var body: some View {
        Button {
            ledger.exchangeSupply(fold)
        } label: {
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    TackleInsignia(emblem: fold.emblem, selected: ledger.canExchange(fold))
                        .frame(width: 56, height: 56)
                    Spacer()
                    Image(systemName: ledger.canExchange(fold) ? "arrow.left.arrow.right.circle.fill" : "lock.circle.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(ledger.canExchange(fold) ? PondInk.gold : PondInk.creamText.opacity(0.4))
                }
                Text(fold.title)
                    .font(.system(.headline, design: .serif).weight(.heavy))
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                Text(fold.note)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(PondInk.creamText.opacity(0.78))
                    .lineLimit(2)
                Text(costLine)
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(PondInk.gold)
                    .padding(.top, 2)
            }
            .foregroundStyle(PondInk.creamText)
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 190, alignment: .topLeading)
            .background(TacklePlaqueBackground(selected: ledger.canExchange(fold)))
            .contentShape(Rectangle())
        }
        .buttonStyle(PondPressButtonStyle())
        .disabled(!ledger.canExchange(fold))
    }

    private var costLine: String {
        var parts: [String] = []
        if fold.coinCost > 0 { parts.append("\(fold.coinCost) Coins") }
        if fold.pearlCost > 0 { parts.append("\(fold.pearlCost) Pearls") }
        if fold.lanternCost > 0 { parts.append("\(fold.lanternCost) Lanterns") }
        return parts.joined(separator: " • ")
    }
}

struct SliderRow: View {
    @EnvironmentObject private var ledger: RippleLedger
    var title: String
    var systemImage: String
    @Binding var amount: Double
    var saveRipple: () -> Void
    var previewsSound: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            Slider(value: $amount, in: 0...1)
                .onChange(of: amount) { _, _ in
                    saveRipple()
                    if previewsSound {
                        SoundRipple.tap(ledger)
                    }
                }
        }
    }
}

extension Date {
    var pondDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: self)
    }
}
