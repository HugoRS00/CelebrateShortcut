import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    let settingsManager = SettingsManager()
    let celebrationController = CelebrationController()
    private var hotkeyManager: HotkeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        celebrationController.settingsManager = settingsManager

        hotkeyManager = HotkeyManager(settingsManager: settingsManager) { [weak self] in
            self?.celebrationController.celebrate()
        }

        // Check for updates on launch (silently)
        UpdateChecker.checkForUpdates(settingsManager: settingsManager, silent: true)
    }
}
