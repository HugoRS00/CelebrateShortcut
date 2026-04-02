import SwiftUI

@main
struct CelebrateShortcutApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(appDelegate.settingsManager)
                .environmentObject(appDelegate.celebrationController)
        } label: {
            Image(systemName: "party.popper")
        }
    }
}
