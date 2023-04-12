// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProcuretAPI",
    platforms: [
        .macOS(.v12),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ProcuretAPI",
            targets: ["ProcuretAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ProcuretAPI",
            dependencies: []),
        .testTarget(
            name: "ProcuretAPITests",
            dependencies: ["ProcuretAPI"]),
    ]
)
