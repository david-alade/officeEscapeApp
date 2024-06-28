//
//  BindingExtension.swift
//  bibite
//
//  Created by David Alade on 3/27/24.
//

import Foundation
import SwiftUI

public extension Binding {
    func onUpdate(_ closure: @escaping (_ oldValue: Value, _ newValue: Value) -> Void) -> Binding<Value> {
        Binding(
            get: {
                self.wrappedValue
            },
            set: { newValue in
                let oldValue = self.wrappedValue
                self.wrappedValue = newValue
                closure(oldValue, newValue)
            }
        )
    }
}
