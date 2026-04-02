import AppKit
import HotKey
import Combine

class HotkeyManager {
    private var hotKey: HotKey?
    private var settingsManager: SettingsManager
    private var onTrigger: () -> Void
    private var cancellables = Set<AnyCancellable>()

    init(settingsManager: SettingsManager, onTrigger: @escaping () -> Void) {
        self.settingsManager = settingsManager
        self.onTrigger = onTrigger

        registerHotkey()

        // Re-register when settings change
        settingsManager.$hotkeyKeyCode
            .combineLatest(settingsManager.$hotkeyModifiers)
            .dropFirst()
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.registerHotkey()
            }
            .store(in: &cancellables)
    }

    private func registerHotkey() {
        hotKey = nil

        guard let key = Key(carbonKeyCode: settingsManager.hotkeyKeyCode) else { return }
        let modifiers = carbonModifiers(from: settingsManager.hotkeyModifiers)

        hotKey = HotKey(key: key, modifiers: modifiers)
        hotKey?.keyDownHandler = { [weak self] in
            self?.onTrigger()
        }
    }

    private func carbonModifiers(from rawValue: UInt) -> NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: rawValue)
    }
}
