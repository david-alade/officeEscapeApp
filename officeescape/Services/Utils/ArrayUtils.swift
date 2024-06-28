//
//  ArrayUtils.swift
//  oneswipe
//
//  Created by David Alade on 6/26/24.
//

extension Array {
    func safelyAccessElement(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
