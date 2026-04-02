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

        popBuffer = generatePop(sampleRate: sampleRate)

        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 0.3
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

    private func generatePop(sampleRate: Double) -> AVAudioPCMBuffer? {
        // A real pop/click is a short filtered impulse — like snapping a bubble
        // Not a sine wave. It's a brief burst of shaped noise with resonance.
        let duration = 0.06
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        buffer.frameLength = frameCount
        guard let samples = buffer.floatChannelData?[0] else { return nil }

        // Step 1: Generate the raw pop — a single-cycle impulse with resonant ring
        var phase = 0.0
        let twoPi = 2.0 * Double.pi

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate
            let progress = t / duration

            // The "click" — a very fast attack impulse (first 1ms)
            let clickDuration = 0.001
            let click: Double
            if t < clickDuration {
                let p = t / clickDuration
                click = sin(p * .pi) * 0.7  // half-sine impulse
            } else {
                click = 0
            }

            // The "body" — resonant ring at ~200Hz, decays fast
            let bodyFreq = 200.0
            phase += twoPi * bodyFreq / sampleRate
            if phase > twoPi { phase -= twoPi }

            let bodyAttack = min(t / 0.001, 1.0)
            let bodyDecay = exp(-progress * 8.0)
            let body = sin(phase) * bodyAttack * bodyDecay * 0.4

            // The "air" — very soft high-frequency shimmer, gone in 10ms
            let airDecay = exp(-progress * 20.0)
            let air = sin(phase * 3.7) * airDecay * 0.08

            // Combine
            let sample = click + body + air

            samples[i] = Float(sample)
        }

        // Step 2: Smooth the edges — gentle fade on last 5ms to prevent any click at the end
        let fadeSamples = Int(0.005 * sampleRate)
        let startFade = Int(frameCount) - fadeSamples
        for i in startFade..<Int(frameCount) {
            let fade = Float(Int(frameCount) - 1 - i) / Float(fadeSamples)
            samples[i] *= fade
        }

        return buffer
    }
}
