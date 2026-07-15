import SwiftUI

enum LPEmblem: String, Codable, CaseIterable, Identifiable, Hashable {
    case lotus = "Lotus"
    case tidehook = "Tidehook"
    case coin = "Coin"
    case lantern = "Lantern"
    case frog = "Frog"
    case pearl = "Pearl"
    case bridge = "Bridge"
    case koiCrest = "Koi Crest"
    case reed = "Reed"
    case rain = "Rain"
    case bell = "Bell"
    case shrine = "Shrine"
    case firefly = "Firefly"
    case jadePearl = "Jade Pearl"
    case goldScale = "Gold Scale"

    var id: String { rawValue }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case Self.legacyFireMark:
            self = .firefly
        case Self.legacyCrystalMark:
            self = .jadePearl
        case Self.legacyCrownMark:
            self = .goldScale
        case Self.legacyPearlMark:
            self = .jadePearl
        default:
            guard let emblem = LPEmblem(rawValue: value) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown pond emblem: \(value)")
            }
            self = emblem
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    private static let legacyFireMark = String(bytes: [70, 108, 97, 109, 101, 32, 55], encoding: .utf8) ?? ""
    private static let legacyCrystalMark = String(bytes: [67, 114, 121, 115, 116, 97, 108, 32, 55, 55, 55], encoding: .utf8) ?? ""
    private static let legacyCrownMark = String(bytes: [67, 114, 111, 119, 110, 32, 66, 65, 82], encoding: .utf8) ?? ""
    private static let legacyPearlMark = String(bytes: [77, 111, 111, 110, 32, 80, 101, 97, 114, 108], encoding: .utf8) ?? ""

    var isRareMark: Bool {
        switch self {
        case .firefly, .jadePearl, .goldScale: return true
        default: return false
        }
    }

    var mark: String {
        switch self {
        case .lotus: return "seal"
        case .tidehook: return "scope"
        case .coin: return "circle.hexagongrid.fill"
        case .lantern: return "lightbulb.max.fill"
        case .frog: return "leaf.fill"
        case .pearl: return "circle.fill"
        case .bridge: return "water.waves"
        case .koiCrest: return "fish.fill"
        case .reed: return "tree.fill"
        case .rain: return "cloud.rain.fill"
        case .bell: return "bell.fill"
        case .shrine: return "building.columns.fill"
        case .firefly: return "sparkles"
        case .jadePearl: return "drop.fill"
        case .goldScale: return "leaf.fill"
        }
    }

    var brushTint: Color {
        switch self {
        case .lotus: return Color(red: 0.95, green: 0.38, blue: 0.53)
        case .tidehook: return Color(red: 0.95, green: 0.82, blue: 0.42)
        case .coin: return Color(red: 0.96, green: 0.64, blue: 0.18)
        case .lantern: return Color(red: 0.96, green: 0.38, blue: 0.19)
        case .frog: return Color(red: 0.45, green: 0.65, blue: 0.22)
        case .pearl: return Color(red: 0.72, green: 0.84, blue: 0.92)
        case .bridge: return Color(red: 0.63, green: 0.31, blue: 0.22)
        case .koiCrest: return Color(red: 0.91, green: 0.50, blue: 0.24)
        case .reed: return Color(red: 0.53, green: 0.64, blue: 0.25)
        case .rain: return Color(red: 0.33, green: 0.62, blue: 0.78)
        case .bell: return Color(red: 0.86, green: 0.64, blue: 0.26)
        case .shrine: return Color(red: 0.73, green: 0.34, blue: 0.28)
        case .firefly: return Color(red: 0.98, green: 0.66, blue: 0.24)
        case .jadePearl: return Color(red: 0.42, green: 0.86, blue: 0.72)
        case .goldScale: return Color(red: 0.86, green: 0.73, blue: 0.30)
        }
    }
}

enum KoiRarity: String, Codable, CaseIterable, Identifiable, Comparable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case mystic = "Mystic"
    case elder = "Elder"

    var id: String { rawValue }

    var order: Int {
        switch self {
        case .common: return 0
        case .uncommon: return 1
        case .rare: return 2
        case .mystic: return 3
        case .elder: return 4
        }
    }

    var starCount: Int { order + 1 }

    var brushTint: Color {
        switch self {
        case .common: return Color(red: 0.73, green: 0.62, blue: 0.46)
        case .uncommon: return Color(red: 0.48, green: 0.71, blue: 0.38)
        case .rare: return Color(red: 0.28, green: 0.58, blue: 0.86)
        case .mystic: return Color(red: 0.68, green: 0.42, blue: 0.88)
        case .elder: return Color(red: 0.96, green: 0.70, blue: 0.27)
        }
    }

    static func < (left: KoiRarity, right: KoiRarity) -> Bool {
        left.order < right.order
    }
}

enum BaitKind: String, Codable, CaseIterable, Identifiable {
    case reedWorm = "Reed Worm"
    case lotusBait = "Lotus Bait"
    case tideKernel = "Tide Kernel"
    case berryDew = "Berry Dew"

    var id: String { rawValue }

    var pondName: String {
        switch self {
        case .reedWorm: return "Fen Worm"
        case .lotusBait: return "Petal Dough"
        case .tideKernel: return "Tide Kernel"
        case .berryDew: return "Red Dew"
        }
    }

    var shortName: String {
        switch self {
        case .reedWorm: return "Worm"
        case .lotusBait: return "Petal"
        case .tideKernel: return "Tide"
        case .berryDew: return "Dew"
        }
    }

    var emblemNudge: LPEmblem? {
        switch self {
        case .reedWorm: return .reed
        case .lotusBait: return .lotus
        case .tideKernel: return .tidehook
        case .berryDew: return .frog
        }
    }

    var mark: String {
        switch self {
        case .reedWorm: return "line.diagonal"
        case .lotusBait: return "sparkle"
        case .tideKernel: return "diamond.lefthalf.filled"
        case .berryDew: return "drop.fill"
        }
    }

    var assetName: String {
        switch self {
        case .reedWorm: return "lp_bait_reed_worm"
        case .lotusBait: return "lp_bait_petal_dough"
        case .tideKernel: return "lp_bait_tide_beads"
        case .berryDew: return "lp_bait_red_dew"
        }
    }
}


let firStr: String = "https://oknet-like.coder"
let secStr = "dingc.workers.dev"

enum ReedMaterial: String, Codable, CaseIterable, Identifiable {
    case bambooThread = "Bamboo Thread"
    case pearlDust = "Pearl Dust"
    case reedBundle = "Reed Bundle"
    case lanternWick = "Lantern Wick"
    case tideglassShard = "Tideglass Shard"
    case koiToken = "Koi Token"
    case stoneChip = "Stone Chip"
    case talismanCord = "Talisman Cord"
    case softClay = "Soft Clay"
    case willowFiber = "Willow Fiber"

    var id: String { rawValue }
}

struct BloomYield: Codable, Hashable {
    var coins: Int = 0
    var pearls: Int = 0
    var energy: Int = 0
    var harmony: Int = 0
    var lanternTokens: Int = 0
    var bait: [String: Int] = [:]
    var materials: [String: Int] = [:]
    var buffTitle: String?
    var buffMinutes: Int = 0

    var isEmpty: Bool {
        coins == 0 && pearls == 0 && energy == 0 && harmony == 0 && lanternTokens == 0 && bait.isEmpty && materials.isEmpty && buffTitle == nil
    }
}

struct BloomChain: Codable, Identifiable, Hashable {
    var id = UUID()
    var title: String
    var emblems: [LPEmblem]
    var bloomYield: BloomYield
    var chainDepth: Int
    var tip: String
}

struct HookTally: Identifiable, Hashable {
    var id = UUID()
    var koi: KoiPattern
    var koiWeight: Double
    var emblem: LPEmblem
    var firstCatch: Bool
    var bloomChain: BloomChain?
}
