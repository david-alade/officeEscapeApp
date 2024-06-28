//
//  BackButtonModifer.swift
//  bibite
//
//  Created by David Alade on 3/29/24.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    var dismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("Back")
                    })
                }
            }
    }
}

struct CustomBackButtonWithTitleModifier: ViewModifier {
    var dismiss: () -> Void
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("Back")
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                }
            }
    }
}

extension View {
    func customBackButton(withTiitle title: String, dismiss: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonModifier(dismiss: dismiss))
            .navigationTitle(title)
    }
    
    func customBackButton(dismiss: @escaping () -> Void) -> some View {
        modifier(CustomBackButtonModifier(dismiss: dismiss))
    }
}
