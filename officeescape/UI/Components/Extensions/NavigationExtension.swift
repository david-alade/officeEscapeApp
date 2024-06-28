//
//  NavigationExtension.swift
//  bibite
//
//  Created by David Alade on 3/14/24.
//  Written by Avighnash Kumar
//

//import Foundation
//import SwiftUI
//
//struct NavigationStackModifier<Item, Destination: View>: ViewModifier {
//    let item: Binding<Item?>
//    let destination: (Item) -> Destination
//
//    func body(content: Content) -> some View {
//        content.background(NavigationLink(isActive: item.mappedToBool()) {
//            if let item = item.wrappedValue {
//                destination(item)
//            } else {
//                EmptyView()
//            }
//        } label: {
//            EmptyView()
//        })
//    }
//}
//
//public extension View {
//    func navigationDestination<Item, Destination: View>(
//        for binding: Binding<Item?>,
//        @ViewBuilder destination: @escaping (Item) -> Destination
//    ) -> some View {
//        self.modifier(NavigationStackModifier(item: binding, destination: destination))
//    }
//}
//
//public extension Binding where Value == Bool {
//    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
//        self.init(
//            get: {
//                bindingOptional.wrappedValue != nil
//            },
//            set: { newValue in
//                guard newValue == false else { return }
//
//                /// We only handle `false` booleans to set our optional to `nil`
//                /// as we can't handle `true` for restoring the previous value.
//                bindingOptional.wrappedValue = nil
//            }
//        )
//    }
//}
//
//extension Binding {
//    public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
//        return Binding<Bool>(bindingOptional: self)
//    }
//}
//
//struct NavigationUtil {
//    static func popToRootView(animated: Bool = false) {
//        findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
//    }
//
//    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
//        guard let viewController = viewController else {
//            return nil
//        }
//
//        if let navigationController = viewController as? UITabBarController {
//            return findNavigationController(viewController: navigationController.selectedViewController)
//        }
//
//        if let navigationController = viewController as? UINavigationController {
//            return navigationController
//        }
//
//        for childViewController in viewController.children {
//            return findNavigationController(viewController: childViewController)
//        }
//
//        return nil
//    }
//}

import Foundation
import SwiftUI

struct NavigationStackModifier<Item, Destination: View>: ViewModifier {
    let item: Binding<Item?>
    let destination: (Item) -> Destination
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: item.mappedToBool()) {
                if let item = item.wrappedValue {
                    destination(item)
                } else {
                    EmptyView()
                }
            }
    }
}

public extension View {
    func navigationDestination<Item, Destination: View>(
        for binding: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self.modifier(NavigationStackModifier(item: binding, destination: destination))
    }
}

public extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: {
                bindingOptional.wrappedValue != nil
            },
            set: { newValue in
                guard newValue == false else { return }
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}

struct NavigationUtil {
    static func popToRootView(animated: Bool = false) {
        findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UITabBarController {
            return findNavigationController(viewController: navigationController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
