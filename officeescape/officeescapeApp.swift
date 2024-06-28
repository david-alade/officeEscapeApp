//
//  officeescapeApp.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

let appAssembler = AppAssembler()

@main
struct officeescapeApp: App {
    @State private var isShowingLandingView = true
    
    var body: some Scene {
        WindowGroup {
            if isShowingLandingView {
                LandingView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingLandingView = false
                            }
                        }
                    }
            } else {
                let rootCoordinator = appAssembler.resolver.resolve(AppRootCoordinator.self)!
                AppRootCoordinatorView(coordinator: rootCoordinator)
            }
        }
    }
}
