//
//  ToastViewModifier.swift
//
//
//  Created by David Alade on 4/4/24.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var toastMessage: ToastMessage?
    
    var message: String {
        switch toastMessage {
        case .error(let string):
            return string
        case .success(let string):
            return string
        case nil:
            return ""
        }
    }
    
    var duration: TimeInterval = 2
    
    init(toastMessage: Binding<ToastMessage?>, duration: TimeInterval = 2) {
        self._toastMessage = toastMessage
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if self.toastMessage != nil {
                toastView
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            self.toastMessage = nil
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private var toastView: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal, 50)
            .padding(.vertical, 20)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

public extension View {
    func showToast(toastMessage: Binding<ToastMessage?>, duration: TimeInterval = 2) -> some View {
        self.modifier(ToastModifier(toastMessage: toastMessage, duration: duration))
    }
}
