import AVFoundation
import UIKit

enum HapticRipple {
    static func light(_ ledger: RippleLedger) {
        guard ledger.waterline.quietSwitchboard.hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func bloom(_ ledger: RippleLedger) {
        guard ledger.waterline.quietSwitchboard.hapticsEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

enum SoundRipple {
    private static let engine = AVAudioEngine()
    private static let player = AVAudioPlayerNode()
    private static var isPrepared = false

    static func tap(_ ledger: RippleLedger) {
        play(ledger, frequency: 560, duration: 0.045)
    }

    static func bloom(_ ledger: RippleLedger) {
        play(ledger, frequency: 820, duration: 0.075)
    }

    private static func play(_ ledger: RippleLedger, frequency: Double, duration: Double) {
        let volume = Float(ledger.waterline.quietSwitchboard.effectsVolume)
        guard volume > 0.02 else { return }
        prepareIfNeeded()

        let sampleRate = 44_100.0
        let frameCount = AVAudioFrameCount(duration * sampleRate)
        guard
            let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
            let channel = buffer.floatChannelData?[0]
        else { return }

        buffer.frameLength = frameCount
        for frame in 0..<Int(frameCount) {
            let t = Double(frame) / sampleRate
            let progress = Double(frame) / Double(max(frameCount, 1))
            let envelope = Float(sin(progress * Double.pi))
            let wave = Float(sin(2 * Double.pi * frequency * t))
            let gain = min(volume, 1) * 0.18
            channel[frame] = wave * envelope * gain
        }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        if !engine.isRunning {
            try? engine.start()
        }
        if !player.isPlaying {
            player.play()
        }
    }

    private static func prepareIfNeeded() {
        guard !isPrepared else { return }
        engine.attach(player)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        isPrepared = true
    }
}
