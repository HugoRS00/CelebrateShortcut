import AppKit
import Carbon
import ServiceManagement

class SettingsManager: ObservableObject {
    @Published var hotkeyKeyCode: UInt32 {
        didSet { UserDefaults.standard.set(hotkeyKeyCode, forKey: "hotkeyKeyCode") }
    }

    @Published var hotkeyModifiers: UInt {
        didSet { UserDefaults.standard.set(hotkeyModifiers, forKey: "hotkeyModifiers") }
    }

    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled") }
    }

    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            updateLoginItem()
        }
    }

    @Published var autoUpdateEnabled: Bool {
        didSet { UserDefaults.standard.set(autoUpdateEnabled, forKey: "autoUpdateEnabled") }
    }

    init() {
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "hotkeyKeyCode") == nil {
            defaults.set(UInt32(kVK_ANSI_C), forKey: "hotkeyKeyCode")
            defaults.set(UInt(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue), forKey: "hotkeyModifiers")
            defaults.set(true, forKey: "soundEnabled")
            defaults.set(false, forKey: "launchAtLogin")
            defaults.set(true, forKey: "autoUpdateEnabled")
        }

        self.hotkeyKeyCode = UInt32(defaults.integer(forKey: "hotkeyKeyCode"))
        self.hotkeyModifiers = UInt(defaults.integer(forKey: "hotkeyModifiers"))
        self.soundEnabled = defaults.bool(forKey: "soundEnabled")
        self.launchAtLogin = defaults.bool(forKey: "launchAtLogin")
        self.autoUpdateEnabled = defaults.object(forKey: "autoUpdateEnabled") == nil ? true : defaults.bool(forKey: "autoUpdateEnabled")
    }

    var modifierFlagsValue: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: hotkeyModifiers)
    }

    private func updateLoginItem() {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            do {
                if launchAtLogin {
                    try service.register()
                } else {
                    try service.unregister()
                }
            } catch {
                print("Login item error: \(error)")
            }
        }
    }
}
