import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var celebrationController: CelebrationController

    var body: some View {
        VStack(spacing: 4) {
            Button {
                celebrationController.celebrate()
            } label: {
                Label("Celebrate!", systemImage: "party.popper")
            }
            .keyboardShortcut("c", modifiers: [.command])

            Divider()

            Button("Preferences...") {
                PreferencesWindowController.shared.showWindow(settingsManager: settingsManager)
            }
            .keyboardShortcut(",", modifiers: [.command])

            Divider()

            // Made by Hugo
            Button {
                if let url = URL(string: "https://www.linkedin.com/in/hugo-rosensk%C3%B6ld-stengert-4b236a19a/") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Label("by HUGO", systemImage: "person.circle.fill")
            }

            // tradingwizard.ai ad spot
            Button {
                if let url = URL(string: "https://tradingwizard.ai") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Label("Supercharge your trading — tradingwizard.ai", systemImage: "bolt.fill")
            }

            Divider()

            Button("Quit Celebrate Shortcut") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: [.command])
        }
        .padding(.vertical, 4)
    }
}
