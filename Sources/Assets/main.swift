import Foundation
//@import SwiftGenAssetsEnumBuilder

guard Process.argc >= 2 else {
    print("Usage: swiftgen-assets path/to/dir/containing/xcassets")
    exit(-1)
}

if ["-v","--version"].contains(Process.arguments[1]) {
    print(SwiftGenVersion)
    exit(0)
}

// MARK: Main Entry Point

let scanDir = Process.arguments[1]
let enumName: String
if Process.argc > 2 {
    enumName = Process.arguments[2]
} else {
    enumName = "Assets"
}

let enumBuilder = SwiftGenAssetsEnumBuilder()
enumBuilder.parseDirectory(scanDir)
let output = enumBuilder.build(enumName: enumName)

print(output)
