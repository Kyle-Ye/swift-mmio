// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-mmio-lldb",
  products: [.library(name: "LLDB", type: .dynamic, targets: ["LLDB"])],
  targets: [.target(name: "LLDB")],
  cxxLanguageStandard: .cxx11)
