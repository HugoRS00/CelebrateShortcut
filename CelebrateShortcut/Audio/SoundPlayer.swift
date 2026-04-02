import AVFoundation
import AppKit

class SoundPlayer {
    private var popBuffer: AVAudioPCMBuffer?
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let format: AVAudioFormat

    init() {
        let sampleRate = 44100.0
        format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!

        popBuffer = generatePopSound(sampleRate: sampleRate)

        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.4
        try? engine.start()
    }

    func play() {
        guard let buffer = popBuffer else { return }

        guard let copy = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: buffer.frameLength) else { return }
        copy.frameLength = buffer.frameLength
        if let src = buffer.floatChannelData?[0], let dst = copy.floatChannelData?[0] {
            dst.update(from: src, count: Int(buffer.frameLength))
        }

        if !playerNode.isPlaying {
            playerNode.play()
        }
        playerNode.scheduleBuffer(copy, at: nil, options: [], completionHandler: nil)
    }

    private func generatePopSound(sampleRate: Double) -> AVAudioPCMBuffer? {
        // A satisfying pop is a damped resonant impulse — like tapping a hollow tube
        // Two layered resonances give it body and character
        let duration = 0.15
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        buffer.frameLength = frameCount
        guard let samples = buffer.floatChannelData?[0] else { return nil }

        var phase1 = 0.0
        var phase2 = 0.0
        let twoPi = 2.0 * Double.pi

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate
            let progress = t / duration

            // Layer 1: main body — warm resonance around 180Hz dropping to 120Hz
            let freq1 = 120.0 + 60.0 * exp(-progress * 4.0)
            phase1 += twoPi * freq1 / sampleRate
            if phase1 > twoPi { phase1 -= twoPi }

            // Layer 2: higher harmonic "tap" — 400Hz, decays much faster
            let freq2 = 400.0 * exp(-progress * 2.0)
            phase2 += twoPi * freq2 / sampleRate
            if phase2 > twoPi { phase2 -= twoPi }

            // Smooth attack (2ms raised cosine) — no click
            let attackTime = 0.002
            let attack = t < attackTime ? 0.5 * (1.0 - cos(Double.pi * t / attackTime)) : 1.0

            // Body: gentle decay
            let decay1 = exp(-progress * 3.5)
            // Tap: fast decay gives the initial "pop" transient
            let decay2 = exp(-progress * 12.0)

            // Smooth cosine tail — no abrupt cutoff at the end
            let tailStart = 0.7
            let tail = progress > tailStart ? 0.5 * (1.0 + cos(Double.pi * (progress - tailStart) / (1.0 - tailStart))) : 1.0

            let body = sin(phase1) * decay1 * 0.6
            let tap  = sin(phase2) * decay2 * 0.3

            let sample = (body + tap) * attack * tail

            samples[i] = Float(sample * 0.5)
        }

        return buffer
    }
}
