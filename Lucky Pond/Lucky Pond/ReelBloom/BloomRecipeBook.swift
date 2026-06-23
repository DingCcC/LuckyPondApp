import Foundation

enum BloomRecipeBook {
    static func resolveBloom(for emblems: [LPEmblem], chainDepth: Int) -> BloomChain {
        let normalizedEmblems = emblems.sorted { $0.rawValue < $1.rawValue }
        let signature = normalizedEmblems.map(\.rawValue).joined(separator: "|")
        let recipe = recipeMap[signature] ?? fallbackBloom(for: emblems)
        var bloomYield = recipe.bloomYield
        let chainBonus = max(0, chainDepth - 1)
        bloomYield.coins += chainBonus * 120
        bloomYield.pearls += chainBonus * 3
        return BloomChain(title: recipe.title, emblems: emblems, bloomYield: bloomYield, chainDepth: chainDepth, tip: recipe.tip)
    }

    private static func key(_ emblems: [LPEmblem]) -> String {
        emblems.sorted { $0.rawValue < $1.rawValue }.map(\.rawValue).joined(separator: "|")
    }

    private static let recipeMap: [String: (title: String, bloomYield: BloomYield, tip: String)] = {
        var bloomMap: [String: (String, BloomYield, String)] = [:]
        bloomMap[key([.lotus, .lotus, .lotus])] = ("Lotus Bloom", BloomYield(pearls: 24, harmony: 8), "Three Lotus emblems deepen Pond Harmony.")
        bloomMap[key([.tidehook, .tidehook, .tidehook])] = ("Tidehook Bearing", BloomYield(coins: 420, pearls: 18, buffTitle: "Rare Fish Rate Up", buffMinutes: 15), "Tidehook matches invite rare shadows to the pond.")
        bloomMap[key([.coin, .coin, .coin])] = ("Golden Current", BloomYield(coins: 1450), "Gold-marked fish leave a warm current behind.")
        bloomMap[key([.lantern, .lantern, .lantern])] = ("Lantern Parade", BloomYield(coins: 500, lanternTokens: 28, bait: [BaitKind.lotusBait.rawValue: 3]), "Festival lanterns add progress to local event goals.")
        bloomMap[key([.frog, .frog, .frog])] = ("Frog Rain", BloomYield(energy: 5, bait: [BaitKind.reedWorm.rawValue: 5]), "Soft rain brings extra bait and energy.")
        bloomMap[key([.pearl, .pearl, .pearl])] = ("Pearl Whisper", BloomYield(pearls: 45, materials: [ReedMaterial.pearlDust.rawValue: 3]), "Pearls gather where patient catches ripple.")
        bloomMap[key([.bridge, .bridge, .bridge])] = ("Old Crossing", BloomYield(coins: 380, materials: [ReedMaterial.bambooThread.rawValue: 4, ReedMaterial.willowFiber.rawValue: 2]), "Old bridge emblems reveal decor materials.")
        bloomMap[key([.rain, .rain, .rain])] = ("Cloudwake Drizzle", BloomYield(energy: 3, bait: [BaitKind.berryDew.rawValue: 2]), "Rain emblems refresh the pond's small currents.")
        bloomMap[key([.bell, .bell, .bell])] = ("Quiet Chime", BloomYield(pearls: 15, materials: [ReedMaterial.talismanCord.rawValue: 4]), "Bell tones are useful for talisman upgrades.")
        bloomMap[key([.shrine, .shrine, .shrine])] = ("Shrine Glow", BloomYield(pearls: 12, harmony: 14), "Shrine marks raise the calm of the whole pond.")
        bloomMap[key([.fireSeven, .fireSeven, .fireSeven])] = ("Blazing Seven", BloomYield(coins: 1777, energy: 7, buffTitle: "Hot Reel Streak", buffMinutes: 12), "Three Flame 7 marks ignite a quick jackpot run.")
        bloomMap[key([.crystalTripleSeven, .crystalTripleSeven, .crystalTripleSeven])] = ("Crystal 777", BloomYield(coins: 777, pearls: 77, harmony: 7, materials: [ReedMaterial.pearlDust.rawValue: 3]), "Triple crystal sevens bring a rare pearl payout.")
        bloomMap[key([.crownBar, .crownBar, .crownBar])] = ("Crown BAR", BloomYield(coins: 2400, pearls: 21, lanternTokens: 30), "Three crowned BAR marks turn a catch reel into a royal payout.")
        bloomMap[key([.lotus, .tidehook, .koiCrest])] = ("Quiet Fortune", BloomYield(coins: 700, pearls: 18, harmony: 4), "A balanced blessing from flower, tidehook, and crest.")
        bloomMap[key([.fireSeven, .crystalTripleSeven, .crownBar])] = ("Pond Jackpot", BloomYield(coins: 1700, pearls: 37, energy: 7, harmony: 7), "A full jackpot trio blooms from the pond's luckiest catch.")
        bloomMap[key([.coin, .lantern, .bridge])] = ("Market Path", BloomYield(coins: 880, lanternTokens: 12, materials: [ReedMaterial.bambooThread.rawValue: 2]), "A safe trade path through the festival stalls.")
        bloomMap[key([.rain, .reed, .frog])] = ("Spring Chorus", BloomYield(energy: 4, bait: [BaitKind.reedWorm.rawValue: 4], buffTitle: "Rare Pond Spawn", buffMinutes: 10), "Reeds and rain call livelier fish.")
        bloomMap[key([.bell, .shrine, .tidehook])] = ("Tidehook Prayer", BloomYield(pearls: 20, materials: [ReedMaterial.talismanCord.rawValue: 3, ReedMaterial.tideglassShard.rawValue: 1]), "Chimes on the current guide careful upgrades.")
        bloomMap[key([.pearl, .lotus, .rain])] = ("Petalveil Wake", BloomYield(pearls: 18, harmony: 10), "A clean petal wake spreads across the water.")
        bloomMap[key([.bridge, .koiCrest, .lantern])] = ("Festival Crossing", BloomYield(coins: 520, lanternTokens: 25, materials: [ReedMaterial.lanternWick.rawValue: 2]), "A festival path opens for local milestones.")
        bloomMap[key([.tidehook, .pearl, .bell])] = ("Silver Chime", BloomYield(pearls: 34, materials: [ReedMaterial.pearlDust.rawValue: 2]), "A silver chime brings a clean pearl bonus.")
        bloomMap[key([.reed, .frog, .rain])] = ("Marsh Song", BloomYield(energy: 4, bait: [BaitKind.berryDew.rawValue: 3, BaitKind.reedWorm.rawValue: 2]), "A marsh tune refills fishing supplies.")
        bloomMap[key([.coin, .koiCrest, .shrine])] = ("Golden Offering", BloomYield(coins: 950, harmony: 6), "A golden crest near the shrine strengthens the pond.")
        bloomMap[key([.lantern, .tidehook, .pearl])] = ("Night Lantern", BloomYield(pearls: 22, lanternTokens: 16, buffTitle: "Rare Fish Rate Up", buffMinutes: 15), "A lantern on tidehook water invites rarer catches.")
        return bloomMap
    }()

    private static func fallbackBloom(for emblems: [LPEmblem]) -> (title: String, bloomYield: BloomYield, tip: String) {
        let titlePool = ["Lucky Current", "Reedwake Thread", "Quiet Fortune", "Petalveil Wake", "Hidden Pondsign"]
        let seed = emblems.map(\.rawValue).joined().unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let title = titlePool[seed % titlePool.count]
        return (title, BloomYield(coins: 260, pearls: 5, bait: [BaitKind.reedWorm.rawValue: 1]), "Any three emblem fish still bring a modest local reward.")
    }
}
