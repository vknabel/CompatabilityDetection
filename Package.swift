// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "CompatabilityDetection",
    products: [
        .library(name: "CompatabilityDetection", targets: ["CompatabilityDetection"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.2.0"),
        .package(url: "https://github.com/vknabel/PromptLine", from: "0.6.2"),
    ],
    targets: [
        .target(name: "CompatabilityDetection", dependencies: ["Overture", "PromptLine"]),
        .testTarget(name: "CompatabilityDetectionTests", dependencies: ["CompatabilityDetection"]),
    ]
)
