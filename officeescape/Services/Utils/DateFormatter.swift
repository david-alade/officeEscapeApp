//
//  DateFormatter.swift
//  oneswipe
//
//  Created by David Alade on 6/23/24.
//

import Foundation

extension DateFormatter {
    static let customFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
