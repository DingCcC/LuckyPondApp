import Combine
import Foundation
import SwiftUI

enum PondProgressMark: String, Codable {
    case catches
    case lotusFish
    case tidehookFish
    case rareFish
    case elderFish
    case combos
    case coinsEarned
    case decorUpgrades
    case rodUpgrades
    case recipes
    case harmony
    case lanterns
    case loginDays
    case bestCombo
    case unlockedFish
}

struct WillowMilestone: Identifiable, Hashable {
    var id: String
    var title: String
    var mark: PondProgressMark
    var goal: Int
    var bloomYield: BloomYield
}

struct SupplyFold: Identifiable, Hashable {
    var id: String
    var title: String
    var note: String
    var emblem: LPEmblem
    var coinCost: Int
    var pearlCost: Int
    var lanternCost: Int
    var bloomYield: BloomYield
}

enum RippleCache {
    static let saveName = "lucky_pond_waterline.json"

    static func loadWaterline() -> WaterlineState? {
        guard let saveURL = waterlineURL(), FileManager.default.fileExists(atPath: saveURL.path) else { return nil }
        do {
            let pondBytes = try Data(contentsOf: saveURL)
            return try JSONDecoder().decode(WaterlineState.self, from: pondBytes)
        } catch {
            return nil
        }
    }

    static func storeWaterline(_ waterline: WaterlineState) {
        guard let saveURL = waterlineURL() else { return }
        do {
            let folderURL = saveURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            let pondBytes = try JSONEncoder().encode(waterline)
            try pondBytes.write(to: saveURL, options: .atomic)
        } catch {
            assertionFailure("Lucky Pond save failed: \(error)")
        }
    }

    private static func waterlineURL() -> URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("LuckyPond", isDirectory: true)
            .appendingPathComponent(saveName)
    }
}

@MainActor
final class RippleLedger: ObservableObject {
    @Published var waterline: WaterlineState

    let dailyMilestones: [WillowMilestone] = [
        WillowMilestone(id: "daily_catch_10", title: "Land 10 pond catches", mark: .catches, goal: 10, bloomYield: BloomYield(coins: 500, pearls: 20)),
        WillowMilestone(id: "daily_lotus_3", title: "Hook 3 petal-emblem fish", mark: .lotusFish, goal: 3, bloomYield: BloomYield(pearls: 18, harmony: 2)),
        WillowMilestone(id: "daily_combo_2", title: "Complete 2 Catch Reel combinations", mark: .combos, goal: 2, bloomYield: BloomYield(coins: 450, materials: [ReedMaterial.talismanCord.rawValue: 1])),
        WillowMilestone(id: "daily_coins_500", title: "Earn 500 Coins", mark: .coinsEarned, goal: 500, bloomYield: BloomYield(pearls: 12)),
        WillowMilestone(id: "daily_decor_1", title: "Improve 1 pond piece", mark: .decorUpgrades, goal: 1, bloomYield: BloomYield(harmony: 6, materials: [ReedMaterial.softClay.rawValue: 2]))
    ]

    let achievementMilestones: [WillowMilestone] = [
        WillowMilestone(id: "first_cast", title: "First Ripple Cast", mark: .catches, goal: 1, bloomYield: BloomYield(coins: 120)),
        WillowMilestone(id: "three_emblems", title: "Triple Emblem Reel", mark: .combos, goal: 1, bloomYield: BloomYield(pearls: 10)),
        WillowMilestone(id: "lotus_collector", title: "Petal Emblem Run", mark: .lotusFish, goal: 12, bloomYield: BloomYield(pearls: 30, harmony: 5)),
        WillowMilestone(id: "tidehook_catch", title: "Tidehook Catch", mark: .tidehookFish, goal: 8, bloomYield: BloomYield(materials: [ReedMaterial.tideglassShard.rawValue: 3])),
        WillowMilestone(id: "rare_fisher", title: "Rare Water Sign", mark: .rareFish, goal: 15, bloomYield: BloomYield(coins: 1000, pearls: 35)),
        WillowMilestone(id: "pond_keeper", title: "Ledger Keeper", mark: .unlockedFish, goal: 12, bloomYield: BloomYield(harmony: 12)),
        WillowMilestone(id: "harmony_builder", title: "Pond Accord", mark: .harmony, goal: 100, bloomYield: BloomYield(pearls: 60)),
        WillowMilestone(id: "gear_tinkerer", title: "Tackle Tuning", mark: .rodUpgrades, goal: 5, bloomYield: BloomYield(materials: [ReedMaterial.bambooThread.rawValue: 8, ReedMaterial.koiToken.rawValue: 2])),
        WillowMilestone(id: "golden_current", title: "Suncoin Wake", mark: .coinsEarned, goal: 5000, bloomYield: BloomYield(pearls: 45)),
        WillowMilestone(id: "combo_10", title: "Ten Reel Chain", mark: .combos, goal: 10, bloomYield: BloomYield(coins: 1600, pearls: 50)),
        WillowMilestone(id: "catch_100", title: "Hundred Wake Ledger", mark: .catches, goal: 100, bloomYield: BloomYield(pearls: 60, harmony: 20)),
        WillowMilestone(id: "decor_10", title: "Ten Pond Pieces", mark: .decorUpgrades, goal: 10, bloomYield: BloomYield(harmony: 25)),
        WillowMilestone(id: "recipes_20", title: "Twenty Reel Recipes", mark: .recipes, goal: 20, bloomYield: BloomYield(pearls: 90)),
        WillowMilestone(id: "elder_catch", title: "Elder Wake Hook", mark: .elderFish, goal: 1, bloomYield: BloomYield(pearls: 100, harmony: 40))
    ]

    let festivalMilestones: [WillowMilestone] = [
        WillowMilestone(id: "festival_lanterns_50", title: "Gather 50 reedlights", mark: .lanterns, goal: 50, bloomYield: BloomYield(lanternTokens: 20)),
        WillowMilestone(id: "festival_rare_15", title: "Catch 15 Rare or higher fish", mark: .rareFish, goal: 15, bloomYield: BloomYield(pearls: 10)),
        WillowMilestone(id: "festival_decor_2", title: "Improve pond pieces twice", mark: .decorUpgrades, goal: 2, bloomYield: BloomYield(lanternTokens: 25)),
        WillowMilestone(id: "festival_login_3", title: "Visit the pond for 3 days", mark: .loginDays, goal: 3, bloomYield: BloomYield(pearls: 15)),
        WillowMilestone(id: "festival_tidehook_3", title: "Hook 3 tidehook-emblem fish", mark: .tidehookFish, goal: 3, bloomYield: BloomYield(lanternTokens: 18)),
        WillowMilestone(id: "festival_combo_5", title: "Complete 5 Catch Reel combinations", mark: .combos, goal: 5, bloomYield: BloomYield(coins: 700)),
        WillowMilestone(id: "festival_elder_1", title: "Catch 1 Elder fish", mark: .elderFish, goal: 1, bloomYield: BloomYield(pearls: 25, harmony: 18))
    ]

    let supplyFolds: [SupplyFold] = [
        SupplyFold(id: "lotus_bait_pack", title: "Petal Bait Satchel", note: "20 petal baits", emblem: .lotus, coinCost: 150, pearlCost: 0, lanternCost: 0, bloomYield: BloomYield(bait: [BaitKind.lotusBait.rawValue: 20])),
        SupplyFold(id: "reed_bait_pack", title: "Fen Worm Bundle", note: "24 reed worms", emblem: .reed, coinCost: 120, pearlCost: 0, lanternCost: 0, bloomYield: BloomYield(bait: [BaitKind.reedWorm.rawValue: 24])),
        SupplyFold(id: "tideglass_wrap", title: "Tideglass Wrap", note: "Tideglass shard x3", emblem: .tidehook, coinCost: 0, pearlCost: 40, lanternCost: 0, bloomYield: BloomYield(materials: [ReedMaterial.tideglassShard.rawValue: 3])),
        SupplyFold(id: "stone_lantern_fragment", title: "Gate Stone Crate", note: "Stone chip x4", emblem: .lantern, coinCost: 300, pearlCost: 0, lanternCost: 6, bloomYield: BloomYield(materials: [ReedMaterial.stoneChip.rawValue: 4])),
        SupplyFold(id: "pearl_dust", title: "Shell Dust Pouch", note: "Pearl dust x5", emblem: .pearl, coinCost: 0, pearlCost: 35, lanternCost: 0, bloomYield: BloomYield(materials: [ReedMaterial.pearlDust.rawValue: 5])),
        SupplyFold(id: "bamboo_thread", title: "Bamboo Lash Coil", note: "Bamboo thread x10", emblem: .bridge, coinCost: 220, pearlCost: 0, lanternCost: 0, bloomYield: BloomYield(materials: [ReedMaterial.bambooThread.rawValue: 10])),
        SupplyFold(id: "bellcord_spool", title: "Bellcord Spool", note: "Talisman cord x6", emblem: .bell, coinCost: 0, pearlCost: 30, lanternCost: 0, bloomYield: BloomYield(materials: [ReedMaterial.talismanCord.rawValue: 6])),
        SupplyFold(id: "harmony_seed", title: "Accord Seed", note: "Harmony +8", emblem: .shrine, coinCost: 500, pearlCost: 10, lanternCost: 0, bloomYield: BloomYield(harmony: 8))
    ]

    init() {
        var loadedWaterline = RippleCache.loadWaterline() ?? LocalPondSeed.freshWaterline()
        Self.ensureCurrentTackleDefaults(&loadedWaterline)
        waterline = loadedWaterline
        restoreEnergy()
        refreshLocalDay()
        loadedWaterline = waterline
        RippleCache.storeWaterline(loadedWaterline)
    }

    var selectedRod: TackleRod {
        TackleNest.rods.first { $0.id == waterline.selectedRodID } ?? TackleNest.rods[0]
    }

    var selectedLine: ReedLine {
        TackleNest.lines.first { $0.id == (waterline.selectedLineID ?? "reedglass_trace") } ?? TackleNest.lines[0]
    }

    var selectedFloat: PondFloat {
        TackleNest.floats.first { $0.id == (waterline.selectedFloatID ?? "bloomcap_bobber") } ?? TackleNest.floats[0]
    }

    var collectionProgress: (caught: Int, total: Int) {
        let caught = KoiArchiveBook.patterns.filter { (waterline.koiArchive[$0.id]?.caughtCount ?? 0) > 0 }.count
        return (caught, KoiArchiveBook.patterns.count)
    }

    var harmonyGoal: Int {
        max(100, ((waterline.reedVault.harmony / 25) + 1) * 25)
    }

    var castsUntilRareMark: Int {
        let nextCatch = waterline.progressRipple.totalCatches + 1
        let remainder = nextCatch % 5
        return remainder == 0 ? 1 : 5 - remainder + 1
    }

    var nextRareMarkEmblem: LPEmblem {
        scheduledRareMarkEmblem(forCatchNumber: waterline.progressRipple.totalCatches + castsUntilRareMark) ?? .firefly
    }

    func saveRipple() {
        RippleCache.storeWaterline(waterline)
    }

    private static func ensureCurrentTackleDefaults(_ waterline: inout WaterlineState) {
        let defaults = WaterlineState()
        let rodIDs = Set(TackleNest.rods.map(\.id))
        let lineIDs = Set(TackleNest.lines.map(\.id))
        let floatIDs = Set(TackleNest.floats.map(\.id))
        let talismanIDs = Set(TackleNest.talismans.map(\.id))

        if !rodIDs.contains(waterline.selectedRodID) || waterline.rodLevels.keys.allSatisfy({ !rodIDs.contains($0) }) {
            waterline.rodLevels = defaults.rodLevels
            waterline.selectedRodID = defaults.selectedRodID
        }
        if let selectedLineID = waterline.selectedLineID, !lineIDs.contains(selectedLineID) {
            waterline.lineLevels = defaults.lineLevels
            waterline.selectedLineID = defaults.selectedLineID
        }
        if let lineLevels = waterline.lineLevels, lineLevels.keys.allSatisfy({ !lineIDs.contains($0) }) {
            waterline.lineLevels = defaults.lineLevels
            waterline.selectedLineID = defaults.selectedLineID
        }
        if let selectedFloatID = waterline.selectedFloatID, !floatIDs.contains(selectedFloatID) {
            waterline.floatLevels = defaults.floatLevels
            waterline.selectedFloatID = defaults.selectedFloatID
        }
        if let floatLevels = waterline.floatLevels, floatLevels.keys.allSatisfy({ !floatIDs.contains($0) }) {
            waterline.floatLevels = defaults.floatLevels
            waterline.selectedFloatID = defaults.selectedFloatID
        }
        if waterline.equippedTalismanIDs.contains(where: { !talismanIDs.contains($0) }) || waterline.talismanLevels.keys.allSatisfy({ !talismanIDs.contains($0) }) {
            waterline.talismanLevels = defaults.talismanLevels
            waterline.equippedTalismanIDs = defaults.equippedTalismanIDs
        }
    }

    func resetPond() {
        waterline = LocalPondSeed.freshWaterline()
        saveRipple()
    }

    func refreshLocalDay() {
        let todayKey = LocalPondSeed.dayKey(for: Date())
        guard waterline.lastLocalDayKey != todayKey else { return }
        waterline.lastLocalDayKey = todayKey
        waterline.claimedDailyMarks.removeAll()
        waterline.progressRipple.lotusFestivalLoginDays += 1
        waterline.reedVault.energy = waterline.reedVault.maxEnergy
        saveRipple()
    }

    func restoreEnergy() {
        let elapsed = Date().timeIntervalSince(waterline.reedVault.lastEnergyRestoreAt)
        let restoredEnergy = Int(elapsed / 240)
        guard restoredEnergy > 0 else { return }
        waterline.reedVault.energy = min(waterline.reedVault.maxEnergy, waterline.reedVault.energy + restoredEnergy)
        waterline.reedVault.lastEnergyRestoreAt = Date()
    }

    func castThread(
        using baitKind: BaitKind,
        emblemBias: LPEmblem? = nil,
        rareLift: Double = 0,
        weightBoost: Double = 0
    ) -> HookTally? {
        restoreEnergy()
        guard waterline.reedVault.energy > 0 else { return nil }
        waterline.reedVault.energy -= 1
        let baitIsAvailable = waterline.reedVault.bait[baitKind.rawValue, default: 0] > 0
        if let baitCount = waterline.reedVault.bait[baitKind.rawValue], baitCount > 0 {
            waterline.reedVault.bait[baitKind.rawValue] = baitCount - 1
        }

        let koi = chooseKoi(using: baitKind, baitIsAvailable: baitIsAvailable, emblemBias: emblemBias, rareLift: rareLift)
        let linePower = Double(selectedLine.precision + lineLevel(selectedLine.id) * 6) / 2400.0
        let rawWeight = Double.random(in: koi.minWeight...koi.maxWeight)
        let koiWeight = min(koi.maxWeight * 1.18, rawWeight * (1 + linePower + weightBoost))
        let firstCatch = (waterline.koiArchive[koi.id]?.caughtCount ?? 0) == 0
        var trace = waterline.koiArchive[koi.id] ?? KoiTrace()
        trace.caughtCount += 1
        trace.bestWeight = max(trace.bestWeight, koiWeight)
        if trace.firstCaughtAt == nil { trace.firstCaughtAt = Date() }
        waterline.koiArchive[koi.id] = trace

        waterline.progressRipple.totalCatches += 1
        waterline.progressRipple.bestCatchWeight = max(waterline.progressRipple.bestCatchWeight, koiWeight)
        let reelEmblem = chooseReelEmblem(for: koi, baitKind: baitKind, baitIsAvailable: baitIsAvailable)
        waterline.progressRipple.emblemCounts[reelEmblem.rawValue, default: 0] += 1
        if koi.rarity >= .rare { waterline.progressRipple.rareOrHigherCatches += 1 }
        if koi.rarity == .elder { waterline.progressRipple.elderCatches += 1 }
        if koi.emblem == .lantern {
            waterline.lotusFestival.lanternsCollected += 1
            waterline.reedVault.lanternTokens += 1
        }

        unlockNewKoiIfNeeded()

        waterline.catchReel.append(reelEmblem)
        var bloomChain: BloomChain?
        if waterline.catchReel.count >= 3 {
            let reelEmblems = Array(waterline.catchReel.prefix(3))
            waterline.catchReel.removeFirst(3)
            let matched = BloomRecipeBook.resolveBloom(for: reelEmblems, chainDepth: waterline.comboChain + 1)
            waterline.comboChain = matched.title == "Lucky Current" || matched.title == "Reedwake Thread" || matched.title == "Hidden Pondsign" ? 0 : matched.chainDepth
            waterline.progressRipple.bestComboChain = max(waterline.progressRipple.bestComboChain, waterline.comboChain)
            waterline.progressRipple.comboCount += 1
            waterline.discoveredRecipes.insert(matched.title)
            applyBloomYield(matched.bloomYield)
            bloomChain = matched
        }

        saveRipple()
        return HookTally(koi: koi, koiWeight: koiWeight, emblem: reelEmblem, firstCatch: firstCatch, bloomChain: bloomChain)
    }

    func progress(for mark: PondProgressMark) -> Int {
        switch mark {
        case .catches: return waterline.progressRipple.totalCatches
        case .lotusFish: return waterline.progressRipple.emblemCounts[LPEmblem.lotus.rawValue, default: 0]
        case .tidehookFish: return waterline.progressRipple.emblemCounts[LPEmblem.tidehook.rawValue, default: 0]
        case .rareFish: return waterline.progressRipple.rareOrHigherCatches
        case .elderFish: return waterline.progressRipple.elderCatches
        case .combos: return waterline.progressRipple.comboCount
        case .coinsEarned: return waterline.progressRipple.coinFlowEarned
        case .decorUpgrades: return waterline.progressRipple.decorUpgradeCount
        case .rodUpgrades: return waterline.progressRipple.rodUpgradeCount
        case .recipes: return waterline.discoveredRecipes.count
        case .harmony: return waterline.reedVault.harmony
        case .lanterns: return waterline.lotusFestival.lanternsCollected
        case .loginDays: return waterline.progressRipple.lotusFestivalLoginDays
        case .bestCombo: return waterline.progressRipple.bestComboChain
        case .unlockedFish:
            return KoiArchiveBook.patterns.filter { (waterline.koiArchive[$0.id]?.caughtCount ?? 0) > 0 }.count
        }
    }

    func claimDaily(_ milestone: WillowMilestone) {
        guard progress(for: milestone.mark) >= milestone.goal, !waterline.claimedDailyMarks.contains(milestone.id) else { return }
        waterline.claimedDailyMarks.insert(milestone.id)
        applyBloomYield(milestone.bloomYield)
        saveRipple()
    }

    func claimAchievement(_ milestone: WillowMilestone) {
        guard progress(for: milestone.mark) >= milestone.goal, !waterline.claimedAchievementMarks.contains(milestone.id) else { return }
        waterline.claimedAchievementMarks.insert(milestone.id)
        applyBloomYield(milestone.bloomYield)
        saveRipple()
    }

    func claimFestivalStep(_ step: Int) {
        guard waterline.lotusFestival.lanternsCollected >= step, !waterline.lotusFestival.claimedMilestones.contains(step) else { return }
        waterline.lotusFestival.claimedMilestones.insert(step)
        switch step {
        case 10: applyBloomYield(BloomYield(lanternTokens: 25))
        case 25: applyBloomYield(BloomYield(pearls: 15))
        case 50:
            waterline.decorInventory["red_bridge", default: 0] += 1
            waterline.reedVault.harmony += 8
        case 75: applyBloomYield(BloomYield(lanternTokens: 50, bait: [BaitKind.lotusBait.rawValue: 5]))
        default:
            waterline.decorInventory["stone_lantern", default: 0] += 1
            waterline.reedVault.harmony += 10
        }
        saveRipple()
    }

    func claimFestivalMission(_ milestone: WillowMilestone) {
        guard progress(for: milestone.mark) >= milestone.goal,
              !waterline.lotusFestival.claimedMissionMarks.contains(milestone.id) else { return }
        waterline.lotusFestival.claimedMissionMarks.insert(milestone.id)
        applyBloomYield(milestone.bloomYield)
        saveRipple()
    }

    func exchangeSupply(_ fold: SupplyFold) {
        guard waterline.reedVault.coins >= fold.coinCost,
              waterline.reedVault.pearls >= fold.pearlCost,
              waterline.reedVault.lanternTokens >= fold.lanternCost else { return }
        waterline.reedVault.coins -= fold.coinCost
        waterline.reedVault.pearls -= fold.pearlCost
        waterline.reedVault.lanternTokens -= fold.lanternCost
        applyBloomYield(fold.bloomYield)
        saveRipple()
    }

    func canExchange(_ fold: SupplyFold) -> Bool {
        waterline.reedVault.coins >= fold.coinCost &&
        waterline.reedVault.pearls >= fold.pearlCost &&
        waterline.reedVault.lanternTokens >= fold.lanternCost
    }

    func equipRod(_ rodID: String) {
        guard waterline.rodLevels[rodID] != nil else { return }
        waterline.selectedRodID = rodID
        saveRipple()
    }

    func lineLevel(_ lineID: String) -> Int {
        waterline.lineLevels?[lineID] ?? 0
    }

    func floatLevel(_ floatID: String) -> Int {
        waterline.floatLevels?[floatID] ?? 0
    }

    func equipLine(_ lineID: String) {
        if waterline.lineLevels == nil {
            waterline.lineLevels = Dictionary(uniqueKeysWithValues: TackleNest.lines.map { ($0.id, 1) })
        }
        guard waterline.lineLevels?[lineID] != nil else { return }
        waterline.selectedLineID = lineID
        saveRipple()
    }

    func equipFloat(_ floatID: String) {
        if waterline.floatLevels == nil {
            waterline.floatLevels = Dictionary(uniqueKeysWithValues: TackleNest.floats.map { ($0.id, 1) })
        }
        guard waterline.floatLevels?[floatID] != nil else { return }
        waterline.selectedFloatID = floatID
        saveRipple()
    }

    func upgradeRod(_ rod: TackleRod) {
        guard waterline.reedVault.coins >= rod.upgradeCoins, hasMaterials(rod.materialNeed) else { return }
        waterline.reedVault.coins -= rod.upgradeCoins
        consumeMaterials(rod.materialNeed)
        waterline.rodLevels[rod.id, default: 1] += 1
        waterline.progressRipple.rodUpgradeCount += 1
        saveRipple()
    }

    func upgradeLine(_ line: ReedLine) {
        if waterline.lineLevels == nil {
            waterline.lineLevels = Dictionary(uniqueKeysWithValues: TackleNest.lines.map { ($0.id, 1) })
        }
        guard waterline.reedVault.coins >= line.upgradeCoins, hasMaterials(line.materialNeed) else { return }
        waterline.reedVault.coins -= line.upgradeCoins
        consumeMaterials(line.materialNeed)
        waterline.lineLevels?[line.id, default: 1] += 1
        saveRipple()
    }

    func upgradeFloat(_ pondFloat: PondFloat) {
        if waterline.floatLevels == nil {
            waterline.floatLevels = Dictionary(uniqueKeysWithValues: TackleNest.floats.map { ($0.id, 1) })
        }
        guard waterline.reedVault.coins >= pondFloat.upgradeCoins, hasMaterials(pondFloat.materialNeed) else { return }
        waterline.reedVault.coins -= pondFloat.upgradeCoins
        consumeMaterials(pondFloat.materialNeed)
        waterline.floatLevels?[pondFloat.id, default: 1] += 1
        saveRipple()
    }

    func upgradeTalisman(_ talisman: TalismanNest) {
        guard waterline.reedVault.pearls >= talisman.upgradePearls else { return }
        waterline.reedVault.pearls -= talisman.upgradePearls
        waterline.talismanLevels[talisman.id, default: 1] += 1
        saveRipple()
    }

    func placeDecor(_ decor: DecorNest) {
        let usedCount = waterline.pondLayout.filter { $0.decorID == decor.id }.count
        let ownedCount = waterline.decorInventory[decor.id, default: 0]
        guard ownedCount > usedCount else { return }
        let offset = Double(waterline.pondLayout.count % 5) * 0.1
        waterline.pondLayout.append(LanternFold(decorID: decor.id, x: 0.30 + offset, y: 0.38 + offset / 2, rotation: Double.random(in: -12...12)))
        waterline.reedVault.harmony += max(1, decor.harmony / 3)
        saveRipple()
    }

    func rotateLastDecor() {
        guard let lastIndex = waterline.pondLayout.indices.last else { return }
        waterline.pondLayout[lastIndex].rotation += 45
        saveRipple()
    }

    func upgradeDecor(_ decor: DecorNest) {
        guard waterline.reedVault.coins >= decor.upgradeCoins, hasMaterials(decor.materialNeed) else { return }
        waterline.reedVault.coins -= decor.upgradeCoins
        consumeMaterials(decor.materialNeed)
        waterline.decorLevels[decor.id, default: 1] += 1
        waterline.reedVault.harmony += decor.harmony
        waterline.progressRipple.decorUpgradeCount += 1
        saveRipple()
    }

    func storeLanternConsentPrelude() {
        waterline.quietSwitchboard.hasShownLanternConsentPrelude = true
        saveRipple()
    }

    func storeLanternConsent(_ status: LanternConsentStatus) {
        waterline.quietSwitchboard.lanternConsentStatus = status
        waterline.quietSwitchboard.hasShownLanternConsentPrelude = true
        saveRipple()
    }

    func syncLanternConsent(_ status: LanternConsentStatus) {
        waterline.quietSwitchboard.lanternConsentStatus = status
        saveRipple()
    }

    func advanceTutorial(to nextStep: Int) {
        guard !waterline.quietSwitchboard.hasCompletedTutorial else { return }
        if waterline.quietSwitchboard.tutorialStep < nextStep {
            waterline.quietSwitchboard.tutorialStep = nextStep
            saveRipple()
        }
    }

    func completeTutorial() {
        waterline.quietSwitchboard.tutorialStep = 6
        waterline.quietSwitchboard.hasCompletedTutorial = true
        saveRipple()
    }

    func applyBloomYield(_ bloomYield: BloomYield) {
        waterline.reedVault.coins += bloomYield.coins
        waterline.reedVault.pearls += bloomYield.pearls
        waterline.reedVault.energy = min(waterline.reedVault.maxEnergy, waterline.reedVault.energy + bloomYield.energy)
        waterline.reedVault.harmony += bloomYield.harmony
        waterline.reedVault.lanternTokens += bloomYield.lanternTokens
        waterline.lotusFestival.lanternsCollected += bloomYield.lanternTokens
        waterline.progressRipple.coinFlowEarned += bloomYield.coins
        for (baitName, baitCount) in bloomYield.bait {
            waterline.reedVault.bait[baitName, default: 0] += baitCount
        }
        for (materialName, materialCount) in bloomYield.materials {
            waterline.reedVault.materials[materialName, default: 0] += materialCount
        }
    }

    func hasMaterials(_ materialNeed: [String: Int]) -> Bool {
        materialNeed.allSatisfy { materialName, materialCount in
            waterline.reedVault.materials[materialName, default: 0] >= materialCount
        }
    }

    private func consumeMaterials(_ materialNeed: [String: Int]) {
        for (materialName, materialCount) in materialNeed {
            waterline.reedVault.materials[materialName, default: 0] -= materialCount
        }
    }

    private func unlockNewKoiIfNeeded() {
        for koi in KoiArchiveBook.patterns where waterline.progressRipple.totalCatches >= koi.unlockCatchCount {
            if waterline.koiArchive[koi.id] == nil {
                waterline.koiArchive[koi.id] = KoiTrace()
            }
        }
    }

    private func chooseKoi(using baitKind: BaitKind, baitIsAvailable: Bool, emblemBias: LPEmblem?, rareLift: Double) -> KoiPattern {
        let unlockedKoi = KoiArchiveBook.patterns.filter { waterline.progressRipple.totalCatches >= $0.unlockCatchCount }
        let harmonyBoost = min(0.24, Double(waterline.reedVault.harmony) / 700.0)
        let rodBoost = selectedRod.rareChance
        let lineBoost = Double(selectedLine.precision + lineLevel(selectedLine.id) * 6) / 3600.0
        let floatBoost = selectedFloat.rareChance + Double(floatLevel(selectedFloat.id)) * 0.002
        let weightedKoi: [(koi: KoiPattern, weight: Double)] = unlockedKoi.map { koi in
            var weight: Double
            switch koi.rarity {
            case .common: weight = 8.0
            case .uncommon: weight = 5.0
            case .rare: weight = 2.4 + harmonyBoost * 6 + (rodBoost + floatBoost + lineBoost + rareLift) * 8
            case .mystic: weight = 0.9 + harmonyBoost * 3 + (rodBoost + floatBoost + lineBoost + rareLift) * 4
            case .elder: weight = 0.2 + harmonyBoost + (rodBoost + floatBoost + lineBoost + rareLift) * 1.5
            }
            if baitIsAvailable && baitKind.emblemNudge == koi.emblem { weight *= 1.75 }
            if let emblemBias, emblemBias == koi.emblem { weight *= 2.35 }
            return (koi, weight)
        }
        let totalWeight = weightedKoi.reduce(0) { $0 + $1.weight }
        var currentRoll = Double.random(in: 0..<max(totalWeight, 0.1))
        for pondChoice in weightedKoi {
            currentRoll -= pondChoice.weight
            if currentRoll <= 0 { return pondChoice.koi }
        }
        return unlockedKoi.first ?? KoiArchiveBook.patterns[0]
    }

    private func chooseReelEmblem(for koi: KoiPattern, baitKind: BaitKind, baitIsAvailable: Bool) -> LPEmblem {
        if let scheduledRareMark = scheduledRareMarkEmblem(forCatchNumber: waterline.progressRipple.totalCatches) {
            return scheduledRareMark
        }

        let harmonyLift = min(0.026, Double(waterline.reedVault.harmony) / 4200.0)
        let rareLift: Double
        switch koi.rarity {
        case .common: rareLift = 0.0
        case .uncommon: rareLift = 0.004
        case .rare: rareLift = 0.010
        case .mystic: rareLift = 0.018
        case .elder: rareLift = 0.026
        }
        let baitLift = baitIsAvailable && baitKind == .lotusBait ? 0.006 : 0
        guard Double.random(in: 0..<1) < 0.045 + harmonyLift + rareLift + baitLift else {
            return koi.emblem
        }

        let rareMarkPool: [(emblem: LPEmblem, weight: Double)] = [
            (.firefly, 54),
            (.goldScale, 29),
            (.jadePearl, 17)
        ]
        let totalWeight = rareMarkPool.reduce(0) { $0 + $1.weight }
        var roll = Double.random(in: 0..<totalWeight)
        for option in rareMarkPool {
            roll -= option.weight
            if roll <= 0 { return option.emblem }
        }
        return .firefly
    }

    private func scheduledRareMarkEmblem(forCatchNumber catchNumber: Int) -> LPEmblem? {
        guard catchNumber > 0, catchNumber % 5 == 0 else { return nil }
        if catchNumber % 15 == 0 { return .jadePearl }
        if catchNumber % 10 == 0 { return .goldScale }
        return .firefly
    }
}
