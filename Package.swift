// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Diagnostics",
                      platforms: [
                        .macOS(.v10_15),
                        .iOS(.v13),
                        .tvOS(.v12),
                        .watchOS(.v6)],
                      products: [
                        .library(name: "Diagnostics", type: .static, targets: ["Diagnostics"])
                        ],
                      targets: [
                        .target(
                            name: "Diagnostics",
                            path: "Sources",
                            resources: [
                                .process("style.css"),
                                .process("functions.js")
                            ]),
                        .testTarget(name: "DiagnosticsTests", dependencies: ["Diagnostics"], path: "DiagnosticsTests")
                        ],
                      swiftLanguageVersions: [.v5])
