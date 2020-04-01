//
//  MarsRoversAPIDateFormatter.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 01/04/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import Foundation

//https://useyourloaf.com/blog/swift-codable-with-custom-dates/
extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
