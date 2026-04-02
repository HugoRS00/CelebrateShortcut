import AppKit
import Carbon

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

    init() {
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "hotkeyKeyCode") == nil {
            // Default: Cmd+Shift+C (keyCode 8 = 'C')
            defaults.set(UInt32(kVK_ANSI_C), forKey: "hotkeyKeyCode")
            defaults.set(UInt(NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue), forKey: "hotkeyModifiers")
            defaults.set(true, forKey: "soundEnabled")
        }

        self.hotkeyKeyCode = UInt32(defaults.integer(forKey: "hotkeyKeyCode"))
        self.hotkeyModifiers = UInt(defaults.integer(forKey: "hotkeyModifiers"))
        self.soundEnabled = defaults.bool(forKey: "soundEnabled")
    }

    var modifierFlagsValue: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: hotkeyModifiers)
    }
}
