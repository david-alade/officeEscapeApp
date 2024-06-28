//
//  endKeyboardEditing.swift
//  bibite
//
//  Created by David Alade on 2/1/24.
//

import Foundation
import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
