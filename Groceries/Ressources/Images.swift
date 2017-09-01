// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable nesting

struct AssetType: ExpressibleByStringLiteral {
  fileprivate var value: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS) || os(watchOS)
    let image = Image(named: value, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: value)
    #endif
    guard let result = image else { fatalError("Unable to load image \(value).") }
    return result
  }

  init(stringLiteral value: String) {
    self.value = value
  }

  init(extendedGraphemeClusterLiteral value: String) {
    self.init(stringLiteral: value)
  }

  init(unicodeScalarLiteral value: String) {
    self.init(stringLiteral: value)
  }
}

// swiftlint:disable type_body_length
enum Asset {
  static let addIcon: AssetType = "add-icon"
  static let categoryIcon: AssetType = "category-icon"
  static let checkIcon: AssetType = "check-icon"
  static let clearIcon: AssetType = "clear-icon"
  static let dairy: AssetType = "dairy"
  static let emailIcon: AssetType = "email-icon"
  static let logo: AssetType = "logo"
  static let logoutIcon: AssetType = "logout-icon"
  static let misterT: AssetType = "mister_t"
  static let optionsIcon: AssetType = "options-icon"
  static let passwordIcon: AssetType = "password-icon"
  static let poultry: AssetType = "poultry"
  static let priceIcon: AssetType = "price-icon"
  static let redMeat: AssetType = "red-meat"
  static let searchIcon: AssetType = "search-icon"
  static let settingsIcon: AssetType = "settings-icon"
  static let starLord: AssetType = "star_lord"
  static let tonyStark: AssetType = "tony_stark"
  static let userIcon: AssetType = "user-icon"
  static let vegies: AssetType = "vegies"
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: AssetType) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.value, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: asset.value)
    #endif
  }
}

private final class BundleToken {}
