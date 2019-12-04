// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Diagnostics",
                      platforms: [
                        .macOS(.v10_15),
                        .iOS(.v11),
                        .tvOS(.v12),
                        .watchOS(.v6)],
                      products: [.library(name: "Diagnostics",
                                          targets: ["Diagnostics"])],
                      targets: [.target(name: "Diagnostics",
                                        path: "Sources")],
                      swiftLanguageVersions: [.v5])
