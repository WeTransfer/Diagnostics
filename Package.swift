// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.

import PackageDescription

let package = Package(name: "Diagnostics",
                      platforms: [
                        .macOS(.v10_15),
                        .iOS(.v10),
                        .tvOS(.v12),
                        .watchOS(.v6)],
                      products: [
                        // dev .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]),
                        .library(name: "Diagnostics", targets: ["Diagnostics"])
                        ],
                      dependencies: [
                        // dev .package(url: "https://github.com/danger/swift", from: "3.0.0"),
                        // dev .package(path: "Submodules/WeTransfer-iOS-CI/Danger-Swift")
                        ],
                      targets: [
                        // dev .target(name: "DangerDependencies", dependencies: ["Danger", "WeTransferPRLinter"], path: "Submodules/WeTransfer-iOS-CI/Danger-Swift", sources: ["DangerFakeSource.swift"]),
                        .target(name: "Diagnostics", path: "Sources")
                        ],
                      swiftLanguageVersions: [.v5])
