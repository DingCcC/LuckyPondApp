import Foundation

struct KoiPattern: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var emblem: LPEmblem
    var rarity: KoiRarity
    var minWeight: Double
    var maxWeight: Double
    var habitat: String
    var timePreference: String
    var bonusEffect: String
    var pondLore: String
    var unlockCatchCount: Int
}

struct KoiTrace: Codable, Hashable {
    var caughtCount: Int = 0
    var bestWeight: Double = 0
    var firstCaughtAt: Date?
}

enum KoiArchiveBook {
    static let patterns: [KoiPattern] = [
        KoiPattern(id: "lotus_carp", name: "Lotus Carp", emblem: .lotus, rarity: .rare, minWeight: 2.8, maxWeight: 14.5, habitat: "Lotus Pond", timePreference: "Dawn", bonusEffect: "Adds +1 Reel Luck", pondLore: "A emblem of purity and renewal. Said to bring good fortune to those who care for the pond.", unlockCatchCount: 0),
        KoiPattern(id: "tidehook_carp", name: "Tidehook Carp", emblem: .tidehook, rarity: .rare, minWeight: 3.2, maxWeight: 13.2, habitat: "Tidehook Run", timePreference: "Night", bonusEffect: "Improves night catches", pondLore: "Its scales catch the lantern current and guide patient fishers.", unlockCatchCount: 0),
        KoiPattern(id: "coin_koi", name: "Coin Koi", emblem: .coin, rarity: .uncommon, minWeight: 1.8, maxWeight: 9.4, habitat: "Old Dock", timePreference: "Day", bonusEffect: "Adds extra Coins", pondLore: "A bright pond visitor that follows warm currents near the dock.", unlockCatchCount: 0),
        KoiPattern(id: "frogfish", name: "Frogfish", emblem: .frog, rarity: .uncommon, minWeight: 1.1, maxWeight: 6.5, habitat: "Reed Bank", timePreference: "Rain", bonusEffect: "Improves bait finds", pondLore: "A playful reed dweller that leaps at ripples after soft rain.", unlockCatchCount: 0),
        KoiPattern(id: "lanternfish", name: "Lanternfish", emblem: .lantern, rarity: .rare, minWeight: 2.2, maxWeight: 11.8, habitat: "Festival Pool", timePreference: "Evening", bonusEffect: "Adds Lantern Tokens", pondLore: "A glowing festival fish that follows paper lantern reflections.", unlockCatchCount: 3),
        KoiPattern(id: "pearl_eel", name: "Pearl Eel", emblem: .pearl, rarity: .rare, minWeight: 1.7, maxWeight: 8.9, habitat: "Pearl Basin", timePreference: "Dusk", bonusEffect: "Adds Pearl Dust", pondLore: "A silver ribbon in the water, often seen near polished stones.", unlockCatchCount: 6),
        KoiPattern(id: "shadow_koi", name: "Shadow Koi", emblem: .koiCrest, rarity: .mystic, minWeight: 6.0, maxWeight: 22.0, habitat: "Willow Shade", timePreference: "Night", bonusEffect: "Boosts rare fish chance", pondLore: "A deep-water wanderer whose crest glows only when the pond is calm.", unlockCatchCount: 12),
        KoiPattern(id: "bridge_minnow", name: "Bridge Minnow", emblem: .bridge, rarity: .common, minWeight: 0.6, maxWeight: 3.1, habitat: "Red Bridge", timePreference: "Day", bonusEffect: "Finds decor fragments", pondLore: "Tiny and quick, it threads through reflections under the old bridge.", unlockCatchCount: 0),
        KoiPattern(id: "reed_loach", name: "Reed Loach", emblem: .reed, rarity: .common, minWeight: 0.8, maxWeight: 4.2, habitat: "Reed Bank", timePreference: "Morning", bonusEffect: "Finds Reed Bundles", pondLore: "A humble fish that stirs the reeds and keeps the pond lively.", unlockCatchCount: 0),
        KoiPattern(id: "shrine_goldfish", name: "Shrine Goldfish", emblem: .shrine, rarity: .mystic, minWeight: 1.4, maxWeight: 7.6, habitat: "Stone Shrine", timePreference: "Festival Night", bonusEffect: "Raises Pond Harmony", pondLore: "It circles the shrine stones as if listening for old prayers.", unlockCatchCount: 18),
        KoiPattern(id: "rainscale_carp", name: "Rainscale Carp", emblem: .rain, rarity: .uncommon, minWeight: 2.4, maxWeight: 10.2, habitat: "Rain Pool", timePreference: "Rain", bonusEffect: "Refreshes pond spawns", pondLore: "Its soft scales shimmer when ripples overlap in the rain.", unlockCatchCount: 5),
        KoiPattern(id: "old_bell_koi", name: "Old Bell Koi", emblem: .bell, rarity: .rare, minWeight: 4.2, maxWeight: 16.0, habitat: "Bell Stone", timePreference: "Dawn", bonusEffect: "Finds Talisman Thread", pondLore: "A calm koi whose movement feels like the echo of a distant bell.", unlockCatchCount: 9),
        KoiPattern(id: "mist_arowana", name: "Mist Arowana", emblem: .tidehook, rarity: .mystic, minWeight: 5.8, maxWeight: 23.4, habitat: "Mist Pond", timePreference: "Dawn", bonusEffect: "Improves Mystic catches", pondLore: "This long silver fish appears when fog softens the bamboo path.", unlockCatchCount: 16),
        KoiPattern(id: "tea_garden_guppy", name: "Tea Garden Guppy", emblem: .coin, rarity: .common, minWeight: 0.4, maxWeight: 2.1, habitat: "Tea Garden", timePreference: "Afternoon", bonusEffect: "Adds small Coin finds", pondLore: "A tiny bright swimmer fond of warm stones and quiet tea steam.", unlockCatchCount: 0),
        KoiPattern(id: "willowfin", name: "Willowfin", emblem: .reed, rarity: .uncommon, minWeight: 1.6, maxWeight: 6.9, habitat: "Willow Shade", timePreference: "Dusk", bonusEffect: "Adds Willow Fiber", pondLore: "Its fins trail like willow leaves just beneath the surface.", unlockCatchCount: 10),
        KoiPattern(id: "dawnscale_koi", name: "Dawnscale Koi", emblem: .koiCrest, rarity: .rare, minWeight: 3.6, maxWeight: 15.5, habitat: "Dawn Pond", timePreference: "Dawn", bonusEffect: "Raises cast precision", pondLore: "A copper koi that glows when the first light reaches the bridge.", unlockCatchCount: 14),
        KoiPattern(id: "night_lotus_eel", name: "Night Lotus Eel", emblem: .lotus, rarity: .elder, minWeight: 8.0, maxWeight: 28.0, habitat: "Night Lotus", timePreference: "Night", bonusEffect: "Greatly raises Harmony", pondLore: "An elder pond spirit that curls between night-blooming lotus roots.", unlockCatchCount: 28),
        KoiPattern(id: "lanternback_carp", name: "Lanternback Carp", emblem: .lantern, rarity: .elder, minWeight: 9.5, maxWeight: 31.5, habitat: "Festival Pool", timePreference: "Festival Night", bonusEffect: "Adds major event progress", pondLore: "A rare elder fish whose back shines like warm paper lanterns.", unlockCatchCount: 34)
    ]
}
