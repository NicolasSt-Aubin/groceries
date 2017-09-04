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
  static let burger: AssetType = "burger"
  static let categoryIcon: AssetType = "category-icon"
  static let checkIcon: AssetType = "check-icon"
  static let clearIcon: AssetType = "clear-icon"
  static let dairy: AssetType = "dairy"
  static let emailIcon: AssetType = "email-icon"
  enum Loading {
    static let loading0000Layer90: AssetType = "loading_0000_Layer-90"
    static let loading0001Layer89: AssetType = "loading_0001_Layer-89"
    static let loading0002Layer88: AssetType = "loading_0002_Layer-88"
    static let loading0003Layer87: AssetType = "loading_0003_Layer-87"
    static let loading0004Layer86: AssetType = "loading_0004_Layer-86"
    static let loading0005Layer85: AssetType = "loading_0005_Layer-85"
    static let loading0006Layer84: AssetType = "loading_0006_Layer-84"
    static let loading0007Layer83: AssetType = "loading_0007_Layer-83"
    static let loading0008Layer82: AssetType = "loading_0008_Layer-82"
    static let loading0009Layer81: AssetType = "loading_0009_Layer-81"
    static let loading0010Layer80: AssetType = "loading_0010_Layer-80"
    static let loading0011Layer79: AssetType = "loading_0011_Layer-79"
    static let loading0012Layer78: AssetType = "loading_0012_Layer-78"
    static let loading0013Layer77: AssetType = "loading_0013_Layer-77"
    static let loading0014Layer76: AssetType = "loading_0014_Layer-76"
    static let loading0015Layer75: AssetType = "loading_0015_Layer-75"
    static let loading0016Layer74: AssetType = "loading_0016_Layer-74"
    static let loading0017Layer73: AssetType = "loading_0017_Layer-73"
    static let loading0018Layer72: AssetType = "loading_0018_Layer-72"
    static let loading0019Layer71: AssetType = "loading_0019_Layer-71"
    static let loading0020Layer70: AssetType = "loading_0020_Layer-70"
    static let loading0021Layer69: AssetType = "loading_0021_Layer-69"
    static let loading0022Layer68: AssetType = "loading_0022_Layer-68"
    static let loading0023Layer67: AssetType = "loading_0023_Layer-67"
    static let loading0024Layer66: AssetType = "loading_0024_Layer-66"
    static let loading0025Layer65: AssetType = "loading_0025_Layer-65"
    static let loading0026Layer64: AssetType = "loading_0026_Layer-64"
    static let loading0027Layer63: AssetType = "loading_0027_Layer-63"
    static let loading0028Layer62: AssetType = "loading_0028_Layer-62"
    static let loading0029Layer61: AssetType = "loading_0029_Layer-61"
    static let loading0030Layer60: AssetType = "loading_0030_Layer-60"
    static let loading0031Layer59: AssetType = "loading_0031_Layer-59"
    static let loading0032Layer58: AssetType = "loading_0032_Layer-58"
    static let loading0033Layer57: AssetType = "loading_0033_Layer-57"
    static let loading0034Layer56: AssetType = "loading_0034_Layer-56"
    static let loading0035Layer55: AssetType = "loading_0035_Layer-55"
    static let loading0036Layer54: AssetType = "loading_0036_Layer-54"
    static let loading0037Layer53: AssetType = "loading_0037_Layer-53"
    static let loading0038Layer52: AssetType = "loading_0038_Layer-52"
    static let loading0039Layer51: AssetType = "loading_0039_Layer-51"
    static let loading0040Layer50: AssetType = "loading_0040_Layer-50"
    static let loading0041Layer49: AssetType = "loading_0041_Layer-49"
    static let loading0042Layer48: AssetType = "loading_0042_Layer-48"
    static let loading0043Layer47: AssetType = "loading_0043_Layer-47"
    static let loading0044Layer46: AssetType = "loading_0044_Layer-46"
    static let loading0045Layer45: AssetType = "loading_0045_Layer-45"
    static let loading0046Layer44: AssetType = "loading_0046_Layer-44"
    static let loading0047Layer43: AssetType = "loading_0047_Layer-43"
    static let loading0048Layer42: AssetType = "loading_0048_Layer-42"
    static let loading0049Layer41: AssetType = "loading_0049_Layer-41"
    static let loading0050Layer40: AssetType = "loading_0050_Layer-40"
    static let loading0051Layer39: AssetType = "loading_0051_Layer-39"
    static let loading0052Layer38: AssetType = "loading_0052_Layer-38"
    static let loading0053Layer37: AssetType = "loading_0053_Layer-37"
    static let loading0054Layer36: AssetType = "loading_0054_Layer-36"
    static let loading0055Layer35: AssetType = "loading_0055_Layer-35"
    static let loading0056Layer34: AssetType = "loading_0056_Layer-34"
    static let loading0057Layer33: AssetType = "loading_0057_Layer-33"
    static let loading0058Layer32: AssetType = "loading_0058_Layer-32"
    static let loading0059Layer31: AssetType = "loading_0059_Layer-31"
    static let loading0060Layer30: AssetType = "loading_0060_Layer-30"
    static let loading0061Layer29: AssetType = "loading_0061_Layer-29"
    static let loading0062Layer28: AssetType = "loading_0062_Layer-28"
    static let loading0063Layer27: AssetType = "loading_0063_Layer-27"
    static let loading0064Layer26: AssetType = "loading_0064_Layer-26"
    static let loading0065Layer25: AssetType = "loading_0065_Layer-25"
    static let loading0066Layer24: AssetType = "loading_0066_Layer-24"
    static let loading0067Layer23: AssetType = "loading_0067_Layer-23"
    static let loading0068Layer22: AssetType = "loading_0068_Layer-22"
    static let loading0069Layer21: AssetType = "loading_0069_Layer-21"
    static let loading0070Layer20: AssetType = "loading_0070_Layer-20"
    static let loading0071Layer19: AssetType = "loading_0071_Layer-19"
    static let loading0072Layer18: AssetType = "loading_0072_Layer-18"
    static let loading0073Layer17: AssetType = "loading_0073_Layer-17"
    static let loading0074Layer16: AssetType = "loading_0074_Layer-16"
    static let loading0075Layer15: AssetType = "loading_0075_Layer-15"
    static let loading0076Layer14: AssetType = "loading_0076_Layer-14"
    static let loading0077Layer13: AssetType = "loading_0077_Layer-13"
    static let loading0078Layer12: AssetType = "loading_0078_Layer-12"
    static let loading0079Layer11: AssetType = "loading_0079_Layer-11"
    static let loading0080Layer10: AssetType = "loading_0080_Layer-10"
    static let loading0081Layer9: AssetType = "loading_0081_Layer-9"
    static let loading0082Layer8: AssetType = "loading_0082_Layer-8"
    static let loading0083Layer7: AssetType = "loading_0083_Layer-7"
    static let loading0084Layer6: AssetType = "loading_0084_Layer-6"
    static let loading0085Layer5: AssetType = "loading_0085_Layer-5"
    static let loading0086Layer4: AssetType = "loading_0086_Layer-4"
    static let loading0087Layer3: AssetType = "loading_0087_Layer-3"
    static let loading0088Layer2: AssetType = "loading_0088_Layer-2"
    static let loading0089Layer1: AssetType = "loading_0089_Layer-1"
  }
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
