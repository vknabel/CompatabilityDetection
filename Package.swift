// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "CompatabilityDetection",
    products: [
        .library(name: "CompatabilityDetection", targets: ["CompatabilityDetection"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-overture", .branchItem("c3082d0c535acd9b6fda9531b54ede37ccbd421d")),
        .package(url: "https://github.com/vknabel/PromptLine", .branchItem("2a38b0c97c267a1ac1f7dc45694e6524593b55b3")),
    ],
    targets: [
        .target(name: "CompatabilityDetection", dependencies: ["Overture", "PromptLine"]),
        .testTarget(name: "CompatabilityDetectionTests", dependencies: ["CompatabilityDetection"]),
    ]
)
