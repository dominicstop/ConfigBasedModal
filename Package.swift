// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ConfigBasedModal",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    .library(
      name: "ConfigBasedModal",
      targets: ["ConfigBasedModal"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/dominicstop/ComputableLayout",
      .upToNextMajor(from: "0.7.0")
    ),
    .package(
      url: "https://github.com/dominicstop/DGSwiftUtilities",
      .upToNextMajor(from: "0.22.0")
    ),
  ],
  targets: [
    .target(
      name: "ConfigBasedModal",
      dependencies: [
        "ComputableLayout",
        "DGSwiftUtilities",
      ],
      path: "Sources",
      linkerSettings: [
        .linkedFramework("UIKit"),
      ]
    ),
  ]
)
