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
  /// Cancel
  static let cancel = L10n.tr("CANCEL")
  /// Category
  static let category = L10n.tr("CATEGORY")
  /// Complete
  static let complete = L10n.tr("COMPLETE")
  /// Email
  static let email = L10n.tr("EMAIL")
  /// Network error
  static let generalNetworkError = L10n.tr("GENERAL_NETWORK_ERROR")
  /// In your cart
  static let inYourCart = L10n.tr("IN_YOUR_CART")
  /// kg
  static let kg = L10n.tr("KG")
  /// lbs
  static let lbs = L10n.tr("LBS")
  /// Login
  static let login = L10n.tr("LOGIN")
  /// Need to buy
  static let needToBuy = L10n.tr("NEED_TO_BUY")
  /// On the shelf
  static let onTheShelf = L10n.tr("ON_THE_SHELF")
  /// (opt)
  static let optionalIndicator = L10n.tr("OPTIONAL_INDICATOR")
  /// Overview
  static let overview = L10n.tr("OVERVIEW")
  /// Password
  static let password = L10n.tr("PASSWORD")
  /// per
  static let per = L10n.tr("PER")
  /// Milk, chicken, juice...
  static let searchPlaceholder = L10n.tr("SEARCH_PLACEHOLDER")
  /// Select Category
  static let selectCategory = L10n.tr("SELECT_CATEGORY")
  /// Select Price
  static let selectPrice = L10n.tr("SELECT_PRICE")
  /// Select Quantity Indicator
  static let selectQuantityIndicator = L10n.tr("SELECT_QUANTITY_INDICATOR")
  /// unit
  static let unit = L10n.tr("UNIT")
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
