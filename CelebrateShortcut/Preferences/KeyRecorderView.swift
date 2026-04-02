import SwiftUI
import AppKit
import Carbon

struct KeyRecorderView: NSViewRepresentable {
    @Binding var keyCode: UInt32
    @Binding var modifiers: UInt

    func makeNSView(context: Context) -> KeyRecorderNSView {
        let view = KeyRecorderNSView()
        view.onKeyRecorded = { code, mods in
            keyCode = code
            modifiers = mods
        }
        view.updateDisplay(keyCode: keyCode, modifiers: modifiers)
        return view
    }

    func updateNSView(_ nsView: KeyRecorderNSView, context: Context) {
        nsView.updateDisplay(keyCode: keyCode, modifiers: modifiers)
    }
}

class KeyRecorderNSView: NSView {
    var onKeyRecorded: ((UInt32, UInt) -> Void)?
    private var isRecording = false
    private let textField = NSTextField()

    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = true
        textField.bezelStyle = .roundedBezel
        textField.alignment = .center
        textField.font = .systemFont(ofSize: 14, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 28)
        ])

        let click = NSClickGestureRecognizer(target: self, action: #selector(startRecording))
        addGestureRecognizer(click)
    }

    @objc private func startRecording() {
        isRecording = true
        textField.stringValue = "Press shortcut..."
        textField.textColor = .systemOrange
        window?.makeFirstResponder(self)
    }

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        guard isRecording else { return }

        let mods = event.modifierFlags.intersection([.command, .option, .control, .shift])

        // Require at least one modifier
        guard !mods.isEmpty else {
            textField.stringValue = "Add ⌘, ⌥, ⌃, or ⇧"
            return
        }

        let code = UInt32(event.keyCode)
        isRecording = false
        textField.textColor = .labelColor
        onKeyRecorded?(code, mods.rawValue)
    }

    override func flagsChanged(with event: NSEvent) {
        // Don't record modifier-only presses
    }

    func updateDisplay(keyCode: UInt32, modifiers: UInt) {
        guard !isRecording else { return }
        textField.textColor = .labelColor
        textField.stringValue = shortcutString(keyCode: keyCode, modifiers: modifiers)
    }

    private func shortcutString(keyCode: UInt32, modifiers: UInt) -> String {
        var parts: [String] = []
        let flags = NSEvent.ModifierFlags(rawValue: modifiers)

        if flags.contains(.control) { parts.append("⌃") }
        if flags.contains(.option) { parts.append("⌥") }
        if flags.contains(.shift) { parts.append("⇧") }
        if flags.contains(.command) { parts.append("⌘") }

        parts.append(keyName(for: keyCode))
        return parts.joined()
    }

    private func keyName(for keyCode: UInt32) -> String {
        let keyMap: [UInt32: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
            23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
            30: "]", 31: "O", 32: "U", 33: "[", 34: "I", 35: "P", 36: "↩",
            37: "L", 38: "J", 39: "'", 40: "K", 41: ";", 42: "\\", 43: ",",
            44: "/", 45: "N", 46: "M", 47: ".", 48: "⇥", 49: "Space",
            51: "⌫", 53: "⎋",
            96: "F5", 97: "F6", 98: "F7", 99: "F3", 100: "F8",
            101: "F9", 109: "F10", 111: "F12", 103: "F11",
            118: "F4", 120: "F2", 122: "F1",
        ]
        return keyMap[keyCode] ?? "Key\(keyCode)"
    }
}
