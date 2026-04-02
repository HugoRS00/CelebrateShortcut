import AppKit
import Combine

class CelebrationController: ObservableObject {
    var settingsManager: SettingsManager?
    private var soundPlayer: SoundPlayer?
    private var overlayController: OverlayWindowController?

    init() {
        soundPlayer = SoundPlayer()
        overlayController = OverlayWindowController()
    }

    func celebrate() {
        // Reuse a single overlay — spamming adds emitters to the same scene
        overlayController?.showCelebration()

        if settingsManager?.soundEnabled ?? true {
            soundPlayer?.play()
        }
    }
}
