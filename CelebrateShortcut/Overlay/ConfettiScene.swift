import SpriteKit

class ConfettiScene: SKScene {
    private let emojis = ["🎉", "🎊", "✨", "🥳"]
    private let confettiColors: [NSColor] = [
        .systemRed, .systemBlue, .systemGreen,
        .systemYellow, .systemPink, .systemOrange,
        .systemPurple, .systemTeal
    ]

    // Pre-rendered textures — created once, reused every burst
    private var emojiTextures: [SKTexture] = []
    private var confettiTextures: [SKTexture] = []

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Pre-render all textures once
        emojiTextures = emojis.map { emojiTexture($0, size: 44) }
        confettiTextures = confettiColors.map { rectangleTexture(size: CGSize(width: 12, height: 8), color: $0) }
    }

    func addBurst() {
        let emitX = size.width / 2
        let emitY: CGFloat = 0

        // Emoji emitters — tight upward column, then gravity fans them out
        for texture in emojiTextures {
            let emitter = createEmitter(
                texture: texture,
                birthRate: 40,
                totalParticles: 10,
                speed: 1200,
                speedRange: 300,
                scale: 0.65,
                scaleRange: 0.25,
                lifetime: 2.0
            )
            emitter.position = CGPoint(x: emitX, y: emitY)
            // Narrow initial angle — shoots up centered
            emitter.emissionAngle = .pi / 2
            emitter.emissionAngleRange = .pi / 5  // ~36 degrees
            // Horizontal drift spreads them to the sides as they fall
            emitter.xAcceleration = 0
            addChild(emitter)

            // Auto-remove this emitter node after it's done
            emitter.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(emitter.particleLifetime + emitter.particleLifetimeRange + 0.5)),
                SKAction.removeFromParent()
            ]))
        }

        // Paper confetti — same tight column, fans out on descent
        for texture in confettiTextures {
            let emitter = createEmitter(
                texture: texture,
                birthRate: 50,
                totalParticles: 15,
                speed: 1100,
                speedRange: 400,
                scale: 0.9,
                scaleRange: 0.4,
                lifetime: 1.8
            )
            emitter.position = CGPoint(x: emitX, y: emitY)
            emitter.emissionAngle = .pi / 2
            emitter.emissionAngleRange = .pi / 4  // ~45 degrees
            emitter.particleColorBlendFactor = 0.3
            emitter.particleColorSequence = nil
            addChild(emitter)

            emitter.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(emitter.particleLifetime + emitter.particleLifetimeRange + 0.5)),
                SKAction.removeFromParent()
            ]))
        }
    }

    private func createEmitter(
        texture: SKTexture,
        birthRate: CGFloat,
        totalParticles: Int,
        speed: CGFloat,
        speedRange: CGFloat,
        scale: CGFloat,
        scaleRange: CGFloat,
        lifetime: CGFloat
    ) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        emitter.particleTexture = texture

        emitter.particleSpeed = speed
        emitter.particleSpeedRange = speedRange

        // Strong gravity — shoots high then pulls down hard
        emitter.yAcceleration = -800

        // Horizontal randomness makes them fan out as they fall
        emitter.xAcceleration = CGFloat.random(in: -80...80)

        // Particle count — finite burst
        emitter.particleBirthRate = birthRate
        emitter.numParticlesToEmit = totalParticles

        emitter.particleLifetime = lifetime
        emitter.particleLifetimeRange = 0.3

        // Tumbling
        emitter.particleRotation = 0
        emitter.particleRotationRange = .pi * 2
        emitter.particleRotationSpeed = CGFloat.random(in: -4...4)

        // Scale
        emitter.particleScale = scale
        emitter.particleScaleRange = scaleRange

        // Fade out toward end
        emitter.particleAlpha = 1.0
        emitter.particleAlphaSpeed = -0.4

        // Tight emission point
        emitter.particlePositionRange = CGVector(dx: 20, dy: 0)

        return emitter
    }

    private func emojiTexture(_ emoji: String, size: CGFloat) -> SKTexture {
        let imageSize = NSSize(width: size, height: size)
        let image = NSImage(size: imageSize)
        image.lockFocus()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: size * 0.8)
        ]
        let string = emoji as NSString
        let stringSize = string.size(withAttributes: attributes)
        let origin = NSPoint(
            x: (imageSize.width - stringSize.width) / 2,
            y: (imageSize.height - stringSize.height) / 2
        )
        string.draw(at: origin, withAttributes: attributes)
        image.unlockFocus()
        return SKTexture(image: image)
    }

    private func rectangleTexture(size: CGSize, color: NSColor) -> SKTexture {
        let image = NSImage(size: size)
        image.lockFocus()
        color.setFill()
        NSBezierPath(roundedRect: NSRect(origin: .zero, size: size), xRadius: 1, yRadius: 1).fill()
        image.unlockFocus()
        return SKTexture(image: image)
    }
}
