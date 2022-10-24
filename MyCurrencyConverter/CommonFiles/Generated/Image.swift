// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
import UIKit.UIImage

// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name line_length nesting type_body_length type_name file_length
public enum Image {
    public static var downArrow: UIImage {
        return image(named: "downArrow")
    }
    public static var dropDown: UIImage {
        return image(named: "dropDown")
    }
    public static var upArrow: UIImage {
        return image(named: "upArrow")
    }

    private static func image(named name: String) -> UIImage {
        let bundle = Bundle(for: BundleToken.self)
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            fatalError("Unable to load image named \(name).")
        }
        return image
    }
}

private final class BundleToken {}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name file_length
