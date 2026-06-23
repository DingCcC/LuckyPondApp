import Foundation

struct ReedVault: Codable, Hashable {
    var coins: Int = 12450
    var pearls: Int = 385
    var energy: Int = 30
    var maxEnergy: Int = 30
    var harmony: Int = 42
    var lanternTokens: Int = 0
    var lastEnergyRestoreAt: Date = Date()
    var bait: [String: Int] = [
        BaitKind.reedWorm.rawValue: 12,
        BaitKind.lotusBait.rawValue: 18,
        BaitKind.tideKernel.rawValue: 8,
        BaitKind.berryDew.rawValue: 5
    ]
    var materials: [String: Int] = [
        ReedMaterial.bambooThread.rawValue: 18,
        ReedMaterial.pearlDust.rawValue: 7,
        ReedMaterial.reedBundle.rawValue: 12,
        ReedMaterial.lanternWick.rawValue: 6,
        ReedMaterial.tideglassShard.rawValue: 4,
        ReedMaterial.koiToken.rawValue: 3,
        ReedMaterial.stoneChip.rawValue: 2,
        ReedMaterial.talismanCord.rawValue: 6,
        ReedMaterial.softClay.rawValue: 5,
        ReedMaterial.willowFiber.rawValue: 4
    ]
}

struct TackleRod: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var rarity: KoiRarity
    var emblem: LPEmblem
    var unlockStars: Int
    var castPower: Int
    var precision: Int
    var reelLuck: Int
    var rareChance: Double
    var upgradeCoins: Int
    var materialNeed: [String: Int]
}

struct ReedLine: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var rarity: KoiRarity
    var emblem: LPEmblem
    var precision: Int
    var energyEase: Int
    var upgradeCoins: Int
    var materialNeed: [String: Int]
}

struct PondFloat: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var rarity: KoiRarity
    var emblem: LPEmblem
    var reelLuck: Int
    var rareChance: Double
    var upgradeCoins: Int
    var materialNeed: [String: Int]
}

struct TalismanNest: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var emblem: LPEmblem
    var effectLine: String
    var upgradePearls: Int
}

struct DecorNest: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var category: DecorCategory
    var emblem: LPEmblem
    var harmony: Int
    var upgradeCoins: Int
    var materialNeed: [String: Int]
    var unlockHarmony: Int
    var description: String
}

enum DecorCategory: String, Codable, CaseIterable, Identifiable {
    case plants = "Plants"
    case lanterns = "Lanterns"
    case bridges = "Bridges"
    case stones = "Stones"
    case ornaments = "Ornaments"

    var id: String { rawValue }
}

struct LanternFold: Codable, Identifiable, Hashable {
    var id = UUID()
    var decorID: String
    var x: Double
    var y: Double
    var rotation: Double
}

enum TackleNest {
    static let rods: [TackleRod] = [
        TackleRod(id: "mistwake_reedcaster", name: "Giltwake Arc Rod", rarity: .rare, emblem: .tidehook, unlockStars: 0, castPower: 145, precision: 128, reelLuck: 162, rareChance: 0.115, upgradeCoins: 3500, materialNeed: [ReedMaterial.bambooThread.rawValue: 12, ReedMaterial.pearlDust.rawValue: 6, ReedMaterial.koiToken.rawValue: 3]),
        TackleRod(id: "bloomcurrent_skimmer", name: "Petalrun Skimmer", rarity: .uncommon, emblem: .lotus, unlockStars: 0, castPower: 118, precision: 132, reelLuck: 120, rareChance: 0.092, upgradeCoins: 2200, materialNeed: [ReedMaterial.bambooThread.rawValue: 8, ReedMaterial.reedBundle.rawValue: 8]),
        TackleRod(id: "obsidian_gatepole", name: "Blackstone Gate Rod", rarity: .mystic, emblem: .shrine, unlockStars: 12, castPower: 174, precision: 98, reelLuck: 142, rareChance: 0.13, upgradeCoins: 5000, materialNeed: [ReedMaterial.stoneChip.rawValue: 5, ReedMaterial.tideglassShard.rawValue: 5]),
        TackleRod(id: "suncoin_tidelance", name: "Sunseal Tidelance", rarity: .rare, emblem: .koiCrest, unlockStars: 6, castPower: 136, precision: 118, reelLuck: 148, rareChance: 0.105, upgradeCoins: 3200, materialNeed: [ReedMaterial.koiToken.rawValue: 4, ReedMaterial.pearlDust.rawValue: 4]),
        TackleRod(id: "willowglass_threadrod", name: "Greenveil Threadrod", rarity: .uncommon, emblem: .reed, unlockStars: 0, castPower: 106, precision: 145, reelLuck: 112, rareChance: 0.085, upgradeCoins: 1800, materialNeed: [ReedMaterial.reedBundle.rawValue: 9, ReedMaterial.willowFiber.rawValue: 4])
    ]

    static let talismans: [TalismanNest] = [
        TalismanNest(id: "bloomwake_token", name: "Petalcrest Token", emblem: .lotus, effectLine: "+8 Reel Luck", upgradePearls: 40),
        TalismanNest(id: "tidewell_sigil", name: "Tidepool Sigil", emblem: .tidehook, effectLine: "+12% Current Bonus", upgradePearls: 50),
        TalismanNest(id: "coinstream_knot", name: "Sunseed Knot", emblem: .coin, effectLine: "+5% Coin Bonus", upgradePearls: 35),
        TalismanNest(id: "lanternpath_bead", name: "Gleamtrail Bead", emblem: .lantern, effectLine: "+2 Reedlights", upgradePearls: 45),
        TalismanNest(id: "reedhopper_talisman", name: "Fenstep Talisman", emblem: .frog, effectLine: "+3 Bait Finds", upgradePearls: 30),
        TalismanNest(id: "pearlveil_relic", name: "Shellglow Relic", emblem: .pearl, effectLine: "+4 Pearl Chance", upgradePearls: 55)
    ]

    static let lines: [ReedLine] = [
        ReedLine(id: "reedglass_trace", name: "Fenlace Trace", rarity: .common, emblem: .reed, precision: 82, energyEase: 4, upgradeCoins: 700, materialNeed: [ReedMaterial.reedBundle.rawValue: 5]),
        ReedLine(id: "nightwell_filament", name: "Currentlace Filament", rarity: .rare, emblem: .tidehook, precision: 124, energyEase: 8, upgradeCoins: 1800, materialNeed: [ReedMaterial.tideglassShard.rawValue: 2, ReedMaterial.bambooThread.rawValue: 5]),
        ReedLine(id: "pearlspin_trace", name: "Shelltwist Trace", rarity: .rare, emblem: .pearl, precision: 116, energyEase: 10, upgradeCoins: 1600, materialNeed: [ReedMaterial.pearlDust.rawValue: 4, ReedMaterial.talismanCord.rawValue: 2]),
        ReedLine(id: "bridgewake_cord", name: "Bridgecurl Cord", rarity: .uncommon, emblem: .bridge, precision: 96, energyEase: 6, upgradeCoins: 1100, materialNeed: [ReedMaterial.bambooThread.rawValue: 6, ReedMaterial.willowFiber.rawValue: 2])
    ]

    static let floats: [PondFloat] = [
        PondFloat(id: "bloomcap_bobber", name: "Petalcap Waker", rarity: .common, emblem: .lotus, reelLuck: 70, rareChance: 0.015, upgradeCoins: 650, materialNeed: [ReedMaterial.softClay.rawValue: 3]),
        PondFloat(id: "bellwake_drifter", name: "Bellshade Drifter", rarity: .rare, emblem: .bell, reelLuck: 122, rareChance: 0.035, upgradeCoins: 1900, materialNeed: [ReedMaterial.tideglassShard.rawValue: 2, ReedMaterial.talismanCord.rawValue: 3]),
        PondFloat(id: "lanterncap_waker", name: "Glowcap Float", rarity: .uncommon, emblem: .lantern, reelLuck: 94, rareChance: 0.025, upgradeCoins: 1250, materialNeed: [ReedMaterial.lanternWick.rawValue: 3, ReedMaterial.reedBundle.rawValue: 3]),
        PondFloat(id: "rainpearl_buoy", name: "Rainbell Buoy", rarity: .mystic, emblem: .rain, reelLuck: 142, rareChance: 0.046, upgradeCoins: 2600, materialNeed: [ReedMaterial.pearlDust.rawValue: 5, ReedMaterial.tideglassShard.rawValue: 3])
    ]
}

enum DecorNestBook {
    static let decor: [DecorNest] = [
        DecorNest(id: "lotus_cluster", name: "Lotus Cluster", category: .plants, emblem: .lotus, harmony: 8, upgradeCoins: 900, materialNeed: [ReedMaterial.softClay.rawValue: 2], unlockHarmony: 0, description: "A bright lotus cluster that settles the surface."),
        DecorNest(id: "lotus_bud", name: "Lotus Bud", category: .plants, emblem: .lotus, harmony: 2, upgradeCoins: 350, materialNeed: [ReedMaterial.softClay.rawValue: 1], unlockHarmony: 0, description: "A small bud with a gentle morning glow."),
        DecorNest(id: "reed_patch", name: "Reed Patch", category: .plants, emblem: .reed, harmony: 2, upgradeCoins: 300, materialNeed: [ReedMaterial.reedBundle.rawValue: 2], unlockHarmony: 0, description: "Soft reeds that shelter small fish."),
        DecorNest(id: "water_grass", name: "Water Grass", category: .plants, emblem: .rain, harmony: 3, upgradeCoins: 420, materialNeed: [ReedMaterial.reedBundle.rawValue: 3], unlockHarmony: 0, description: "A quiet grass patch for ripples to cross."),
        DecorNest(id: "stone_lantern", name: "Stone Lantern", category: .lanterns, emblem: .lantern, harmony: 7, upgradeCoins: 1000, materialNeed: [ReedMaterial.stoneChip.rawValue: 2, ReedMaterial.lanternWick.rawValue: 1], unlockHarmony: 8, description: "A warm lantern that invites festival fish."),
        DecorNest(id: "red_bridge", name: "Red Bridge", category: .bridges, emblem: .bridge, harmony: 10, upgradeCoins: 1500, materialNeed: [ReedMaterial.bambooThread.rawValue: 4, ReedMaterial.willowFiber.rawValue: 2], unlockHarmony: 15, description: "An old red bridge that improves pond paths."),
        DecorNest(id: "bamboo_fountain", name: "Bamboo Fountain", category: .ornaments, emblem: .rain, harmony: 9, upgradeCoins: 1300, materialNeed: [ReedMaterial.bambooThread.rawValue: 3, ReedMaterial.reedBundle.rawValue: 4], unlockHarmony: 20, description: "A bamboo fountain with a clean water rhythm."),
        DecorNest(id: "shrine_ornament", name: "Shrine Ornament", category: .ornaments, emblem: .shrine, harmony: 12, upgradeCoins: 1800, materialNeed: [ReedMaterial.stoneChip.rawValue: 3, ReedMaterial.tideglassShard.rawValue: 2], unlockHarmony: 30, description: "A small shrine ornament for rare blessings."),
        DecorNest(id: "tidehook_lamp", name: "Tidehook Lamp", category: .lanterns, emblem: .tidehook, harmony: 8, upgradeCoins: 1200, materialNeed: [ReedMaterial.lanternWick.rawValue: 2, ReedMaterial.tideglassShard.rawValue: 1], unlockHarmony: 18, description: "A pale lantern that glows at night."),
        DecorNest(id: "pearl_basin", name: "Pearl Basin", category: .stones, emblem: .pearl, harmony: 9, upgradeCoins: 1400, materialNeed: [ReedMaterial.pearlDust.rawValue: 3, ReedMaterial.softClay.rawValue: 2], unlockHarmony: 24, description: "A basin where pearl dust gathers."),
        DecorNest(id: "moss_rock", name: "Moss Rock", category: .stones, emblem: .reed, harmony: 4, upgradeCoins: 500, materialNeed: [ReedMaterial.stoneChip.rawValue: 1], unlockHarmony: 0, description: "A mossy stone that calms shallow water."),
        DecorNest(id: "willow_shade", name: "Willow Shade", category: .plants, emblem: .reed, harmony: 11, upgradeCoins: 1600, materialNeed: [ReedMaterial.willowFiber.rawValue: 5], unlockHarmony: 32, description: "A willow shade for secret dusk fish."),
        DecorNest(id: "festival_lantern", name: "Reedlight Lantern", category: .lanterns, emblem: .lantern, harmony: 6, upgradeCoins: 850, materialNeed: [ReedMaterial.lanternWick.rawValue: 2], unlockHarmony: 0, description: "A warm pond lantern for Bloomtide nights."),
        DecorNest(id: "wooden_dock_tile", name: "Wooden Dock Tile", category: .bridges, emblem: .bridge, harmony: 5, upgradeCoins: 700, materialNeed: [ReedMaterial.bambooThread.rawValue: 3], unlockHarmony: 0, description: "A sturdy dock tile for pond building.")
    ]
}
