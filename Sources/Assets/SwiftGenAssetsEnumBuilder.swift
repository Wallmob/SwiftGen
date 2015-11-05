import Foundation
//@import SwiftIdentifier
//@import SwiftGenIndentation

public final class SwiftGenAssetsEnumBuilder {
    private var assetNames = [String]()
    
    public init() {}
    
    public func addAssetName(name: String) -> Bool {
        if assetNames.contains(name) {
            return false
        }
        else {
            assetNames.append(name)
            return true
        }
    }
    
    public func parseDirectory(path: String) {
        if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
            while let path = dirEnum.nextObject() as? NSString {
                if path.pathExtension == "imageset" {
                    let assetName = (path.lastPathComponent as NSString).stringByDeletingPathExtension
                    self.addAssetName(assetName)
                }
            }
        }
    }
    
    public func build(enumName enumName : String = "Asset", indentation indent : SwiftGenIndentation = .Spaces(4)) -> String {
        var text = "// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen\n\n"
        let t = indent.string
        
        text += "import Foundation\n"
        text += "import UIKit\n"
        text += "\n"
        
        guard !assetNames.isEmpty else {
            return text + "// No image found\n"
        }
        
        text += "private class \(enumName)Dummy {}"
        text += "\n"
        
        text += "extension UIImage {\n"

        text += "\(t)enum \(enumName) : String {\n"
        
        for name in assetNames {
            let caseName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "\(t)\(t)case \(caseName) = \"\(name)\"\n"
        }
        
        text += "\n"
        text += "\(t)\(t)var image: UIImage {\n"
        text += "\(t)\(t)\(t)return UIImage(asset: self)\n"
        text += "\(t)\(t)}\n"
        text += "\n"
        text += "\(t)\(t)var bundle: NSBundle {\n"
        text += "\(t)\(t)\(t)return NSBundle(forClass: \(enumName)Dummy.self)\n"
        text += "\(t)\(t)}\n"

        text += "\(t)}\n\n"
        
        text += "\(t)convenience init(asset: \(enumName)) {\n"
        text += "\(t)\(t)self.init(named: asset.rawValue, inBundle: asset.bundle, compatibleWithTraitCollection: nil)!\n"
        text += "\(t)}\n"
        text += "}\n"
        
        return text
    }
}
