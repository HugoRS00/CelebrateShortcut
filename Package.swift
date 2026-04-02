// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "CelebrateShortcut",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.2.1")
    ],
    targets: [
        .executableTarget(
            name: "CelebrateShortcut",
            dependencies: ["HotKey"],
            path: "CelebrateShortcut",
            exclude: ["Resources/Info.plist"],
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        )
    ]
)
