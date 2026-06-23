import Foundation

enum LanternConsentStatus: String, Codable {
    case allowed = "Allowed"
    case denied = "Denied"
    case notDetermined = "Not Determined"
    case restricted = "Restricted"
    case unavailable = "Unavailable"
}

struct QuietSwitchboard: Codable, Hashable {
    var musicVolume: Double = 0.65
    var effectsVolume: Double = 0.75
    var hapticsEnabled: Bool = true
    var lowMotionEnabled: Bool = false
    var hasSeenStartPrelude: Bool = false
    var hasShownLanternConsentPrelude: Bool = false
    var lanternConsentStatus: LanternConsentStatus = .notDetermined
    var tutorialStep: Int = 0
    var hasCompletedTutorial: Bool = false

    init() {}

    init(from decoder: Decoder) throws {
        let pondKeys = try decoder.container(keyedBy: CodingKeys.self)
        musicVolume = try pondKeys.decodeIfPresent(Double.self, forKey: .musicVolume) ?? 0.65
        effectsVolume = try pondKeys.decodeIfPresent(Double.self, forKey: .effectsVolume) ?? 0.75
        hapticsEnabled = try pondKeys.decodeIfPresent(Bool.self, forKey: .hapticsEnabled) ?? true
        lowMotionEnabled = try pondKeys.decodeIfPresent(Bool.self, forKey: .lowMotionEnabled) ?? false
        hasSeenStartPrelude = try pondKeys.decodeIfPresent(Bool.self, forKey: .hasSeenStartPrelude) ?? false
        hasShownLanternConsentPrelude = try pondKeys.decodeIfPresent(Bool.self, forKey: .hasShownLanternConsentPrelude) ?? false
        lanternConsentStatus = try pondKeys.decodeIfPresent(LanternConsentStatus.self, forKey: .lanternConsentStatus) ?? .notDetermined
        tutorialStep = try pondKeys.decodeIfPresent(Int.self, forKey: .tutorialStep) ?? 0
        hasCompletedTutorial = try pondKeys.decodeIfPresent(Bool.self, forKey: .hasCompletedTutorial) ?? false
    }
}

struct ProgressRipple: Codable, Hashable {
    var totalCatches: Int = 0
    var rareOrHigherCatches: Int = 0
    var elderCatches: Int = 0
    var comboCount: Int = 0
    var coinFlowEarned: Int = 0
    var decorUpgradeCount: Int = 0
    var rodUpgradeCount: Int = 0
    var lotusFestivalLoginDays: Int = 1
    var bestComboChain: Int = 0
    var bestCatchWeight: Double = 0
    var emblemCounts: [String: Int] = [:]
}

struct LanternPath: Codable, Hashable {
    var lanternsCollected: Int = 0
    var claimedMilestones: Set<Int> = []
    var claimedMissionMarks: Set<String> = []
    var localRecordScore: Int = 0

    init() {}

    init(from decoder: Decoder) throws {
        let pondKeys = try decoder.container(keyedBy: CodingKeys.self)
        lanternsCollected = try pondKeys.decodeIfPresent(Int.self, forKey: .lanternsCollected) ?? 0
        claimedMilestones = try pondKeys.decodeIfPresent(Set<Int>.self, forKey: .claimedMilestones) ?? []
        claimedMissionMarks = try pondKeys.decodeIfPresent(Set<String>.self, forKey: .claimedMissionMarks) ?? []
        localRecordScore = try pondKeys.decodeIfPresent(Int.self, forKey: .localRecordScore) ?? 0
    }
}

struct WaterlineState: Codable, Hashable {
    var reedVault = ReedVault()
    var catchReel: [LPEmblem] = []
    var comboChain: Int = 0
    var koiArchive: [String: KoiTrace] = [:]
    var rodLevels: [String: Int] = ["mistwake_reedcaster": 3, "bloomcurrent_skimmer": 2, "obsidian_gatepole": 1, "suncoin_tidelance": 2, "willowglass_threadrod": 1]
    var selectedRodID: String = "mistwake_reedcaster"
    var lineLevels: [String: Int]? = ["reedglass_trace": 1, "nightwell_filament": 1, "pearlspin_trace": 1, "bridgewake_cord": 1]
    var selectedLineID: String? = "reedglass_trace"
    var floatLevels: [String: Int]? = ["bloomcap_bobber": 1, "bellwake_drifter": 1, "lanterncap_waker": 1, "rainpearl_buoy": 1]
    var selectedFloatID: String? = "bloomcap_bobber"
    var talismanLevels: [String: Int] = ["bloomwake_token": 2, "tidewell_sigil": 3, "coinstream_knot": 1]
    var equippedTalismanIDs: [String] = ["bloomwake_token", "tidewell_sigil", "coinstream_knot"]
    var decorInventory: [String: Int] = ["lotus_cluster": 2, "lotus_bud": 4, "reed_patch": 2, "water_grass": 3, "stone_lantern": 1, "moss_rock": 2, "festival_lantern": 1, "wooden_dock_tile": 2]
    var decorLevels: [String: Int] = ["lotus_cluster": 2, "stone_lantern": 2, "red_bridge": 3, "shrine_ornament": 1]
    var pondLayout: [LanternFold] = [
        LanternFold(decorID: "lotus_cluster", x: 0.24, y: 0.36, rotation: -8),
        LanternFold(decorID: "stone_lantern", x: 0.56, y: 0.48, rotation: 0),
        LanternFold(decorID: "moss_rock", x: 0.76, y: 0.33, rotation: 6)
    ]
    var progressRipple = ProgressRipple()
    var lotusFestival = LanternPath()
    var discoveredRecipes: Set<String> = []
    var claimedDailyMarks: Set<String> = []
    var claimedAchievementMarks: Set<String> = []
    var quietSwitchboard = QuietSwitchboard()
    var lastLocalDayKey: String = ""
}

enum LocalPondSeed {
    static func freshWaterline() -> WaterlineState {
        var waterline = WaterlineState()
        for koi in KoiArchiveBook.patterns where koi.unlockCatchCount == 0 {
            waterline.koiArchive[koi.id] = KoiTrace()
        }
        waterline.lastLocalDayKey = dayKey(for: Date())
        return waterline
    }

    static func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
