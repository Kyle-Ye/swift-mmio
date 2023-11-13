// swift-tools-version: 5.9

import CompilerPluginSupport
import Foundation
import PackageDescription

var package = Package(
  name: "swift-mmio",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13),
  ],
  products: [
    .library(name: "MMIO", targets: ["MMIO"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.1")
  ],
  targets: [
    .target(
      name: "MMIO",
      dependencies: ["MMIOMacros", "MMIOVolatile"]),
    .testTarget(
      name: "MMIOFileCheckTests",
      dependencies: ["MMIO"],
      exclude: ["Tests"]),
    .testTarget(
      name: "MMIOTests",
      dependencies: ["MMIO"]),

    .macro(
      name: "MMIOMacros",
      dependencies: [
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ]),
    .testTarget(
      name: "MMIOMacrosTests",
      dependencies: [
        "MMIOMacros",
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]),

    .target(name: "MMIOVolatile"),
  ])

// MARK: - Package Feature Flags
// Replace this with a native spm feature flag if/when supported
let interposable = "FEATURE_INTERPOSABLE"
try package.defineFeature(named: interposable, override: nil) { package in
  let targetAllowSet = Set(["MMIO", "MMIOVolatile", "MMIOMacros"])
  package.targets = package.targets.filter { targetAllowSet.contains($0.name) }
  package.targets.append(
    .testTarget(name: "MMIOInterposableTests", dependencies: ["MMIO"]))
  for target in package.targets {
    target.swiftSetting(.define(interposable))
  }
}

// MARK: - Language Feature Flags
for target in package.targets {
  // SE-0401 Remove Actor Isolation Inference caused by Property Wrappers
  // Swift 5.9
  target.swiftSetting(.enableUpcomingFeature("DisableOutwardActorInference"))

  // SE-0384 Importing Forward Declared Objective-C Interfaces and Protocols
  // Swift 5.9
  target.swiftSetting(.enableUpcomingFeature("ImportObjcForwardDeclarations"))

  // SE-0354 Regex Literals
  // Swift 5.7
  target.swiftSetting(.enableUpcomingFeature("BareSlashRegexLiterals"))

  // SE-0335 Introduce existential any
  // Swift 5.6
  target.swiftSetting(.enableUpcomingFeature("ExistentialAny"))

  // SE-0286 Forward-scan matching for trailing closures
  // Swift 5.3
  target.swiftSetting(.enableUpcomingFeature("ForwardTrailingClosures"))

  // SE-0274 Concise magic file names
  // Swift 5.8
  target.swiftSetting(.enableUpcomingFeature("ConciseMagicFile"))
}

// MARK: - Helpers
extension Package {
  func defineFeature(
    named featureName: String,
    override: Bool?,
    body: (Package) throws -> Void
  ) throws {
    let key = "SWIFT_MMIO_\(featureName)"
    let environment = ProcessInfo.processInfo.environment[key] != nil
    if override ?? environment {
      try body(self)
    }
  }
}

extension Target {
  func swiftSetting(_ value: SwiftSetting) {
    var swiftSettings = self.swiftSettings ?? []
    swiftSettings.append(value)
    self.swiftSettings = swiftSettings
  }
}
