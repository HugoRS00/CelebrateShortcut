import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var celebrationController: CelebrationController
    @State private var showingPreferences = false

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
                HStack(spacing: 6) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 14))
                    Text("by HUGO")
                        .font(.system(size: 12, weight: .semibold))
                }
            }

            // tradingwizard.ai ad spot
            Button {
                if let url = URL(string: "https://tradingwizard.ai") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                HStack(spacing: 4) {
                    Text("⚡")
                    Text("Supercharge your trading")
                        .font(.system(size: 11))
                    Text("— tradingwizard.ai")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
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
