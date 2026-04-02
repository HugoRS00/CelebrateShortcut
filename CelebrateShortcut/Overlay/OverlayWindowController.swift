import AppKit
import SpriteKit

class OverlayWindowController {
    private var window: NSWindow?
    private var skView: SKView?
    private var scene: ConfettiScene?
    private var hideTimer: DispatchWorkItem?

    func showCelebration() {
        // Cancel any pending hide — we're adding more confetti
        hideTimer?.cancel()

        if window == nil {
            setupWindow()
        }

        window?.orderFrontRegardless()
        scene?.addBurst()

        // Schedule hide after particles are done
        let work = DispatchWorkItem { [weak self] in
            self?.hide()
        }
        hideTimer = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: work)
    }

    private func setupWindow() {
        let screenFrame = unionOfAllScreens()

        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.level = NSWindow.Level(rawValue: NSWindow.Level.screenSaver.rawValue + 1)
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.ignoresMouseEvents = true

        let skView = SKView(frame: NSRect(origin: .zero, size: screenFrame.size))
        skView.preferredFramesPerSecond = 120
        skView.allowsTransparency = true
        skView.wantsLayer = true
        skView.layer?.backgroundColor = NSColor.clear.cgColor

        let scene = ConfettiScene(size: screenFrame.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear

        skView.presentScene(scene)
        window.contentView = skView

        self.window = window
        self.skView = skView
        self.scene = scene
    }

    private func hide() {
        window?.orderOut(nil)
        // Clean up all emitter nodes so they don't pile up
        scene?.removeAllChildren()
        scene?.removeAllActions()
    }

    private func unionOfAllScreens() -> NSRect {
        guard let screens = NSScreen.screens as [NSScreen]?, !screens.isEmpty else {
            return NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
        }
        var unionRect = screens[0].frame
        for screen in screens.dropFirst() {
            unionRect = unionRect.union(screen.frame)
        }
        return unionRect
    }
}
