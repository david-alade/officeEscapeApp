//
//  PopupViewModifer.swift
//
//
//  Created by David Alade on 4/7/24.
//

import SwiftUI

public struct PopupViewModifier<PopupContent>: ViewModifier where PopupContent: View {
    @Binding var isShowing: Bool
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    let message: String
    let popupContent: () -> PopupContent
    
    public init(isShowing: Binding<Bool>, maxWidth: CGFloat, maxHeight: CGFloat, message: String, @ViewBuilder popupContent: @escaping () -> PopupContent) {
        self._isShowing = isShowing
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.message = message
        self.popupContent = popupContent
    }
    
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                Rectangle()
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowing = false
                    }
                
                VStack {
                    if message.count > 0 {
                        Text(message)
                            .padding()
                    }
                    
                    popupContent()
                }
                .background(Color.white)
                .cornerRadius(12)
                .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                .padding(.horizontal)
            }
        }
    }
}

public extension View {
    func showPopup<PopupContent: View>(
        isShowing: Binding<Bool>,
        maxWidth: CGFloat = 300,
        maxHeight: CGFloat = 300,
        message: String = "",
        @ViewBuilder popupContent: @escaping () -> PopupContent
    ) -> some View {
        self.modifier(PopupViewModifier(isShowing: isShowing, maxWidth: maxWidth, maxHeight: maxHeight, message: message, popupContent: popupContent))
    }
}
