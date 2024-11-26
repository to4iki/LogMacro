// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "LogMacro",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "LogMacro",
      targets: ["LogMacro"]
    ),
    .executable(
      name: "LogMacroClient",
      targets: ["LogMacroClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "LogMacroClient",
      dependencies: ["LogMacro"]
    ),
    .macro(
      name: "LogMacroImplementation",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ],
      path: "./Sources/Implementation"
    ),
    .target(
      name: "LogMacro",
      dependencies: ["LogMacroImplementation"],
      path: "./Sources/Interface"
    ),
    .testTarget(
      name: "LogMacroTests",
      dependencies: [
        "LogMacroImplementation",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
