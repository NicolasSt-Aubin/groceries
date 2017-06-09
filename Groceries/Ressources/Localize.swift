// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs
// swiftlint:disable type_name

enum L10n {
  /// Add
  static let add = L10n.tr("ADD")
  /// Category
  static let category = L10n.tr("CATEGORY")
  /// Email
  static let email = L10n.tr("EMAIL")
  /// Network error
  static let generalNetworkError = L10n.tr("GENERAL_NETWORK_ERROR")
  /// Login
  static let login = L10n.tr("LOGIN")
  /// Need to buy
  static let needToBuy = L10n.tr("NEED_TO_BUY")
  /// (opt)
  static let optionalIndicator = L10n.tr("OPTIONAL_INDICATOR")
  /// Overview
  static let overview = L10n.tr("OVERVIEW")
  /// Password
  static let password = L10n.tr("PASSWORD")
  /// Milk, chicken, juice...
  static let searchPlaceholder = L10n.tr("SEARCH_PLACEHOLDER")
  /// Welcome
  static let welcome = L10n.tr("WELCOME")
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs
