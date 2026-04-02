# 🎉 Celebrate Shortcut

A tiny Mac menu bar app that shoots confetti across your entire screen with a keyboard shortcut.

Press **⌘⇧C** → emoji confetti (🎉🎊✨🥳) explodes from the bottom of your screen → disappears after 3 seconds. That's it.

Works on top of every app, even fullscreen ones. No dock icon, no clutter — just a small 🎉 in your menu bar.

---

## Quick Install

**Requirements:** macOS 14+ and [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) (`xcode-select --install`)

```bash
git clone https://github.com/HugoRS00/CelebrateShortcut.git
cd CelebrateShortcut
chmod +x scripts/build.sh
./scripts/build.sh
```

That's it. The script builds the app, installs it to `~/Applications`, and asks if you want to launch it.

---

## How to Use

| | |
|---|---|
| **🎉 Trigger confetti** | Press **⌘⇧C** anywhere on your Mac |
| **🖱️ Trigger from menu** | Click the 🎉 in your menu bar → **Celebrate!** |
| **⌨️ Change shortcut** | Menu bar 🎉 → **Preferences** → click the shortcut box → press your new combo |
| **🔇 Toggle sound** | Menu bar 🎉 → **Preferences** → toggle **Play celebration sound** |
| **🔄 Auto-update** | Checks GitHub for new releases on launch. Toggle in Preferences |
| **🚀 Launch at login** | Menu bar 🎉 → **Preferences** → toggle **Launch at login** |

---

## Start / Stop

**Start the app:**
```bash
open -a "Celebrate Shortcut"
```
Or double-click `Celebrate Shortcut.app` in `~/Applications`.

**Stop the app:**

Click the 🎉 in your menu bar → **Quit**

```bash
# Or from terminal:
pkill -f CelebrateShortcut
```

---

## Uninstall

```bash
chmod +x scripts/uninstall.sh
./scripts/uninstall.sh
```

Stops the app, deletes it, and clears preferences. Clean.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| No 🎉 in menu bar | App isn't running — `open -a "Celebrate Shortcut"` |
| Shortcut doesn't work | Open Preferences, re-record it. Must include ⌘, ⌥, ⌃, or ⇧ |
| Build fails | Run `xcode-select --install` first |

---

## Contributing

PRs welcome! This is a simple SwiftUI + SpriteKit app — easy to hack on.

```
CelebrateShortcut/
├── App/           → App entry point, menu bar setup
├── MenuBar/       → Menu dropdown UI
├── Overlay/       → Transparent fullscreen window + confetti particles
├── Hotkey/        → Global keyboard shortcut
├── Preferences/   → Settings window + key recorder
├── Audio/         → Sound player
└── Settings/      → UserDefaults persistence
```

To build from source: `swift build` (or open in Xcode).

---

## License

MIT — do whatever you want with it.

---

Made by [**Hugo**](https://www.linkedin.com/in/hugo-rosensk%C3%B6ld-stengert-4b236a19a/)

⚡ [tradingwizard.ai](https://tradingwizard.ai) — Supercharge your trading
