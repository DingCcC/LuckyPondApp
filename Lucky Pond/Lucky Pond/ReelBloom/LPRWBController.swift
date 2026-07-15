//
//  LPRWBController.swift
//  Lucky Pond
//

import UIKit
import WebKit

final class LPRWBController: UIViewController {
    private enum MessageHandlerName {
        static let event = "luckyPond"
        static let native = "native"
    }

    private static let bridgeScript = """
    (function () {
        var bridge = window.jsBridge || {};
        bridge.postMessage = function (eventName, payload) {
            var handler = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.luckyPond;
            if (!handler) { return; }
            handler.postMessage({
                event: String(eventName || ''),
                payload: payload == null ? '' : String(payload)
            });
        };
        window.jsBridge = bridge;

        function sendNative(command, extra) {
            try {
                var handler = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.native;
                if (!handler) { return; }
                var message = extra || {};
                message.cmd = command;
                handler.postMessage(message);
            } catch (error) {}
        }

        var routePattern = /(deposit|recharge|payment|cashier|checkout|apple\\s*pay|btc\\s*pay|bitcoin|top\\s*up|purchase|billing|customer\\s*service|support|facebook|messenger|whatsapp|telegram)/i;
        function appendText(parts, value) {
            if (typeof value !== 'string') { return; }
            var text = value.trim();
            if (text.length > 0 && text.length <= 120) { parts.push(text); }
        }

        function nodeText(node) {
            var parts = [];
            var cursor = node;
            var depth = 0;
            while (cursor && depth < 4 && cursor !== document.body && cursor !== document.documentElement) {
                if (depth <= 1) {
                    appendText(parts, cursor.innerText || '');
                    appendText(parts, cursor.textContent || '');
                }
                appendText(parts, cursor.className || '');
                appendText(parts, cursor.id || '');
                if (cursor.getAttribute) {
                    appendText(parts, cursor.getAttribute('aria-label') || '');
                    appendText(parts, cursor.getAttribute('title') || '');
                    appendText(parts, cursor.getAttribute('data-type') || '');
                    appendText(parts, cursor.getAttribute('data-action') || '');
                    appendText(parts, cursor.getAttribute('data-pay') || '');
                }
                cursor = cursor.parentElement;
                depth += 1;
            }
            return parts.join(' ');
        }

        function noteRoute(event) {
            try {
                if (event && event.target && routePattern.test(nodeText(event.target))) {
                    sendNative('routeFlag');
                }
            } catch (error) {}
        }

        document.addEventListener('click', noteRoute, true);
        document.addEventListener('touchend', noteRoute, true);

        var originalOpen = window.open;
        window.open = function (url, target, features) {
            sendNative('pageFork', { url: url || '', target: target || '' });
            if (!url || String(url).toLowerCase() === 'about:blank') {
                return null;
            }
            return originalOpen ? originalOpen.apply(window, arguments) : null;
        };
    })();
    """

    private let address: URL
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let deckTone = UIColor(red: 0.09, green: 0.09, blue: 0.13, alpha: 1)
    private var routeMarkerExpiresAt: Date?
    private var webView: WKWebView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    init(address: URL) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func loadView() {
        let userContentController = WKUserContentController()
        userContentController.addUserScript(
            WKUserScript(
                source: Self.bridgeScript,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )
        userContentController.add(self, name: MessageHandlerName.event)
        userContentController.add(self, name: MessageHandlerName.native)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.backgroundColor = deckTone
        webView.scrollView.backgroundColor = deckTone
        webView.isOpaque = false
        self.webView = webView

        let rootView = UIView()
        rootView.backgroundColor = deckTone
        rootView.addSubview(webView)
        rootView.addSubview(progressView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor)
        ])
        progressView.progressTintColor = .systemGreen
        progressView.trackTintColor = .clear
        progressView.isHidden = true
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()

        var request = URLRequest(url: address)
        request.cachePolicy = .reloadRevalidatingCacheData
        request.timeoutInterval = 30
        webView.load(request)
    }

    deinit {
        let userContentController = webView?.configuration.userContentController
        userContentController?.removeScriptMessageHandler(forName: MessageHandlerName.event)
        userContentController?.removeScriptMessageHandler(forName: MessageHandlerName.native)
    }
}

extension LPRWBController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.progress = 0
        progressView.isHidden = false
        progressView.setProgress(0.35, animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishLoadingProgress()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        finishLoadingProgress()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        finishLoadingProgress()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        if isBlankAddress(url) {
            decisionHandler(.cancel)
            return
        }

        if shouldLeaveApp(for: url) {
            openOutside(url)
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    private func finishLoadingProgress() {
        progressView.setProgress(1, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.progressView.isHidden = true
        }
    }
}

extension LPRWBController: WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        guard navigationAction.targetFrame == nil,
              let url = navigationAction.request.url else {
            return nil
        }

        guard !isBlankAddress(url) else { return nil }

        if shouldLeaveApp(for: url) {
            openOutside(url)
        } else {
            webView.load(URLRequest(url: url))
        }
        return nil
    }
}

extension LPRWBController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.frameInfo.isMainFrame else { return }

        switch message.name {
        case MessageHandlerName.event:
            handleTrackingMessage(message.body)
        case MessageHandlerName.native:
            handleNativeMessage(message.body)
        default:
            break
        }
    }

    private func handleTrackingMessage(_ body: Any) {
        guard let message = body as? [String: Any],
              let eventName = message["event"] as? String,
              let event = LuckyPondTool.BridgeEvent(bridgeName: eventName) else {
            return
        }

        let payload = dictionary(from: message["payload"])
        let amount = payload["amount"].flatMap(number(from:))
        let currency = (payload["currency"] as? String) ?? "USD"
        LuckyPondTool.shared.track(event, amount: amount, currency: currency)
    }

    private func handleNativeMessage(_ body: Any) {
        if let rawURL = body as? String {
            openOutside(rawURL)
            return
        }

        guard let message = body as? [String: Any],
              let command = (message["cmd"] as? String)?.lowercased() else {
            return
        }

        switch command {
        case "routeflag":
            markRoute()
        case "pagefork":
            guard let rawURL = message["url"] as? String,
                  let url = makeURL(from: rawURL),
                  !isBlankAddress(url) else {
                return
            }
            if shouldLeaveApp(for: url) {
                openOutside(url)
            }
        case "openurl":
            guard let rawURL = message["msg"] as? String else { return }
            openOutside(rawURL)
        default:
            return
        }
    }

    private func shouldLeaveApp(for url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return false }
        if scheme != "http" && scheme != "https" { return true }
        if staysInCanvas(url) {
            clearRoute()
            return false
        }
        return hasRouteMarker(url) || takeRoute()
    }

    private func staysInCanvas(_ url: URL) -> Bool {
        let path = url.path.lowercased()
        let host = url.host?.lowercased() ?? ""
        let staticEndings = [".js", ".css", ".png", ".jpg", ".jpeg", ".webp", ".gif", ".svg", ".json", ".wasm", ".mp3", ".m4a", ".ogg", ".mp4"]
        if staticEndings.contains(where: { path.hasSuffix($0) }) {
            return true
        }
        if host.hasPrefix("static-") || host.contains(".static.") || host.contains("cdn") {
            return true
        }

        let text = decodedText(for: url)
        let canvasMarkers = [
            "html5game", "game.do", "gamename", "game_name", "extgame",
            "jackpotid", "mgckey", "/gs2c/", "index.html?p=", "lobbyurl", "minilobby"
        ]
        return canvasMarkers.contains { text.contains($0) }
    }

    private func hasRouteMarker(_ url: URL) -> Bool {
        let text = decodedText(for: url)
        let markers = ["payment", "deposit", "cashier", "checkout", "recharge", "applepay", "btcpay", "payurl", "pay_url", "pay-url"]
        return markers.contains { text.contains($0) }
    }

    private func decodedText(for url: URL) -> String {
        [url.absoluteString, url.absoluteString.removingPercentEncoding ?? ""]
            .joined(separator: " ")
            .lowercased()
    }

    private func markRoute() {
        routeMarkerExpiresAt = Date().addingTimeInterval(8)
    }

    private func takeRoute() -> Bool {
        guard let expiry = routeMarkerExpiresAt else { return false }
        routeMarkerExpiresAt = nil
        return Date() <= expiry
    }

    private func clearRoute() {
        routeMarkerExpiresAt = nil
    }

    private func isBlankAddress(_ url: URL) -> Bool {
        url.scheme?.lowercased() == "about"
    }

    private func makeURL(from value: String) -> URL? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        return URL(string: trimmed) ?? encoded.flatMap(URL.init(string:))
    }

    private func openOutside(_ url: URL) {
        UIApplication.shared.open(url, options: [:])
    }

    private func openOutside(_ value: String) {
        guard let url = makeURL(from: value) else { return }
        openOutside(url)
    }

    private func dictionary(from value: Any?) -> [String: Any] {
        if let dictionary = value as? [String: Any] {
            return dictionary
        }
        guard let json = value as? String,
              let data = json.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }

    private func number(from value: Any) -> Double? {
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        if let text = value as? String {
            return Double(text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return nil
    }
}
