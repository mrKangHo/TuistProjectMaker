// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TuistProjectMaker",
    defaultLocalization: "en",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "TuistProjectMaker",
            path: "Sources/TuistProjectMaker",
            resources: [.process("Resources")]
        )
    ]
)
