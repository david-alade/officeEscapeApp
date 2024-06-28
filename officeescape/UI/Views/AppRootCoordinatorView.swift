//
//  AppRootCoordinatorView.swift
//  truth
//
//  Created by David Alade on 6/12/24.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @ObservedObject var coordinator: AppRootCoordinator
    
    var body: some View {
        if let appCoordinator = coordinator.appCoordinator {
            AppCoordinatorView(coordinator: appCoordinator)
        } else if let loadingScreenViewModel = coordinator.loadingScreenViewModel {
            LoadingScreenView(viewModel: loadingScreenViewModel)
        } else if let errorScreenViewModel = coordinator.errorScreenViewModel {
            ErrorScreenView(viewModel: errorScreenViewModel)
        } else {
            LandingView()
        }
    }
}
