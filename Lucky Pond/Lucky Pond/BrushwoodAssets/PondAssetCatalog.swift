import Foundation

enum PondAssetCatalog {
    static func imageName(from rawName: String, prefix: String) -> String {
        let foldedName = rawName
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
        return "\(prefix)_\(foldedName)"
    }
}

extension LPEmblem {
    var assetName: String {
        switch self {
        case .lotus: return "lp_crest_lotus"
        case .tidehook: return "lp_crest_tidehook"
        case .coin: return "lp_crest_coin"
        case .lantern: return "lp_crest_lantern"
        case .frog: return "lp_crest_frog"
        case .pearl: return "lp_crest_pearl"
        case .bridge: return "lp_crest_bridge"
        case .koiCrest: return "lp_crest_koi"
        case .reed: return "lp_crest_reed"
        case .rain: return "lp_crest_rain"
        case .bell: return "lp_crest_bell"
        case .shrine: return "lp_crest_shrine"
        case .firefly: return "lp_crest_firefly"
        case .jadePearl: return "lp_crest_jade_pearl"
        case .goldScale: return "lp_crest_gold_scale"
        }
    }
}

extension KoiPattern {
    var assetName: String {
        "fish_\(id)"
    }
}

extension DecorNest {
    var assetName: String {
        "decor_\(id)"
    }
}

extension PondMood {
    var assetName: String {
        switch self {
        case .dawn: return "premium_pond_day"
        case .day: return "premium_pond_day"
        case .night: return "pond_night"
        case .festival: return "premium_pond_day"
        }
    }
}
