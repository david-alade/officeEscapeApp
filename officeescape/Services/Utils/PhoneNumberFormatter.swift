//
//  PhoneNumberFormatter.swift
//  truth
//
//  Created by David Alade on 6/17/24.
//

import Foundation

struct PhoneNumberFormatter {
    func format(number: String) -> String {
        var digits = number.filter(\.isNumber)
        
        // Check if the number starts with the country code "1" (for +1) and adjust accordingly
        let startsWithCountryCode = digits.hasPrefix("1")
        if startsWithCountryCode {
            digits.removeFirst()
        }
        
        let zip = digits.prefix(3)
        let middle = digits.dropFirst(3).prefix(3)
        let rest = digits.dropFirst(6)
        
        var formattedNumber = [zip, middle, rest]
            .filter { !$0.isEmpty }
            .joined(separator: "-")
            .prefix(12)
            .description
        if formattedNumber.count > 0 {
            formattedNumber = "+1-\(formattedNumber)"
        }
        
        return formattedNumber
    }
}
