//
//  LuckyPondTool.swift
//  Lucky Pond
//

import AdjustSdk
import Foundation

final class LuckyPondTool {
    static let shared = LuckyPondTool()

    enum BridgeEvent {
        case grove
        case halo
        case tide

        init?(bridgeName: String) {
            switch bridgeName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            case "register":
                self = .grove
            case "firstpurchase":
                self = .halo
            case "purchase":
                self = .tide
            default:
                return nil
            }
        }
    }

    private struct Configuration {
        let mainKey: String
        let codeA: String
        let codeB: String
        let codeC: String

        func eventToken(for event: BridgeEvent) -> String {
            switch event {
            case .grove:
                return codeC
            case .halo:
                return codeA
            case .tide:
                return codeB
            }
        }
    }

    private var configuration: Configuration?
    private var hasStarted = false

    private init() {}

    func configure(mainKey: String, codeA: String, codeB: String, codeC: String) {
        let newConfiguration = Configuration(
            mainKey: mainKey.trimmed,
            codeA: codeA.trimmed,
            codeB: codeB.trimmed,
            codeC: codeC.trimmed
        )

        guard !newConfiguration.mainKey.isEmpty else { return }

        if hasStarted, configuration?.mainKey != newConfiguration.mainKey {
            return
        }
        configuration = newConfiguration
    }

    func startIfNeeded() {
        guard !hasStarted, let configuration else { return }
        guard let adjustConfiguration = ADJConfig(
            appToken: configuration.mainKey,
            environment: adjustEnvironment
        ) else {
            return
        }

        Adjust.initSdk(adjustConfiguration)
        hasStarted = true
    }

    func track(_ event: BridgeEvent, amount: Double? = nil, currency: String = "USD") {
        guard hasStarted, let configuration else { return }

        let eventToken = configuration.eventToken(for: event)
        guard !eventToken.isEmpty, let adjustEvent = ADJEvent(eventToken: eventToken) else { return }

        if event != .grove, let amount, amount >= 0 {
            adjustEvent.setRevenue(amount, currency: currency.normalizedCurrencyCode)
        }

        Adjust.trackEvent(adjustEvent)
    }

    private var adjustEnvironment: String {
        #if DEBUG
        ADJEnvironmentSandbox
        #else
        ADJEnvironmentProduction
        #endif
    }
}

struct LuckyPondModel: Decodable {
    let isLucky: Int
    let region: String?
    let bundleIdentifier: String?
    let luckyLink: String?
    let adjustConfiguration: LuckyPondAdjustConfiguration?

    var isEnabled: Bool { isLucky == 1 }

    var resolvedAddress: URL? {
        guard let luckyLink, let url = URL(string: luckyLink) else { return nil }
        guard let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme), url.host != nil else {
            return nil
        }
        return url
    }

    private enum CodingKeys: String, CodingKey {
        case isLucky
        case region = "reg"
        case bundleIdentifier = "bun"
        case luckyLink = "luckyLin"
        case adjustConfiguration = "lblike"
    }
}

struct LuckyPondAdjustConfiguration: Decodable {
    let mainKey: String
    let codeA: String
    let codeB: String
    let codeC: String

    private enum CodingKeys: String, CodingKey {
        case mainKey = "luckyken"
        case codeA = "fpCode"
        case codeB = "pCode"
        case codeC = "regCode"
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedCurrencyCode: String {
        let normalized = trimmed.uppercased()
        return normalized.count == 3 ? normalized : "USD"
    }
}
