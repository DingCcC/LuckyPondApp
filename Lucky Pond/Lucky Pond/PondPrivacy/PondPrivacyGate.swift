import AppTrackingTransparency

enum LanternConsent {
    @MainActor
    static func requestMistSignalAccess() async -> LanternConsentStatus {
        guard #available(iOS 14, *) else { return .unavailable }
        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status.lanternStatus)
            }
        }
    }

    static func readMistSignalStatus() -> LanternConsentStatus {
        guard #available(iOS 14, *) else { return .unavailable }
        return ATTrackingManager.trackingAuthorizationStatus.lanternStatus
    }
}

@available(iOS 14, *)
private extension ATTrackingManager.AuthorizationStatus {
    var lanternStatus: LanternConsentStatus {
        switch self {
        case .authorized: return .allowed
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        @unknown default: return .unavailable
        }
    }
}
