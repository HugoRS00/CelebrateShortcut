import SwiftUI

struct PreferencesView: View {
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Celebrate Shortcut")
                .font(.title2.bold())

            // Hotkey section
            VStack(alignment: .leading, spacing: 8) {
                Text("Global Shortcut")
                    .font(.headline)
                Text("Click below and press your desired key combination")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                KeyRecorderView(
                    keyCode: $settingsManager.hotkeyKeyCode,
                    modifiers: $settingsManager.hotkeyModifiers
                )
                .frame(width: 200)
            }

            // Sound section
            VStack(alignment: .leading, spacing: 8) {
                Text("Sound")
                    .font(.headline)
                Toggle("Play celebration sound", isOn: $settingsManager.soundEnabled)
            }

            Spacer()

            HStack {
                Spacer()
                Text("by Hugo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .frame(width: 350, height: 280)
    }
}

// Window controller for preferences
class PreferencesWindowController {
    static let shared = PreferencesWindowController()
    private var window: NSWindow?

    func showWindow(settingsManager: SettingsManager) {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let prefsView = PreferencesView(settingsManager: settingsManager)
        let hostingView = NSHostingView(rootView: prefsView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 350, height: 280),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Preferences"
        window.contentView = hostingView
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = window
    }
}
