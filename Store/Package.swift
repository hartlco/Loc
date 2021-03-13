// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Store",
            targets: ["Store"])
    ],
    dependencies: [
        .package(path: "../Model")
    ],
    targets: [
        .target(
            name: "Store",
            dependencies: ["Model"]),
        .testTarget(
            name: "StoreTests",
            dependencies: ["Store"])
    ]
)
