import AVFoundation
import AppKit

class SoundPlayer {
    private var players: [AVAudioPlayer] = []
    private let maxPlayers = 6

    init() {
        // Use the macOS "Bottle" sound — a clean, satisfying cork pop
        let path = "/System/Library/Sounds/Bottle.aiff"
        if let player = createPlayer(path: path) {
            players.append(player)
        }
    }

    func play() {
        // Find a player that's not currently playing
        if let available = players.first(where: { !$0.isPlaying }) {
            available.currentTime = 0
            available.volume = 0.5
            available.play()
        } else if players.count < maxPlayers, let source = players.first?.url {
            // Clone for overlapping playback when spamming
            if let clone = createPlayer(url: source) {
                clone.volume = 0.5
                clone.play()
                players.append(clone)
            }
        } else if let first = players.first {
            first.currentTime = 0
            first.volume = 0.5
            first.play()
        }
    }

    private func createPlayer(path: String) -> AVAudioPlayer? {
        guard FileManager.default.fileExists(atPath: path) else { return nil }
        return createPlayer(url: URL(fileURLWithPath: path))
    }

    private func createPlayer(url: URL) -> AVAudioPlayer? {
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return nil }
        player.prepareToPlay()
        return player
    }
}
