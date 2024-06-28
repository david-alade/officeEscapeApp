//
//  AppCoordinatorView.swift
//  truth
//
//  Created by David Alade on 6/16/r24.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var isPresentingSetupProfileView = false
    
    var body: some View {
        TabView(selection: $coordinator.currentTab.onUpdate({ oldValue, newValue in
            coordinator.tappedTab(oldTab: oldValue, newTab: newValue)
        })) {
            EventCoordinatorView(coordinator: coordinator.eventCoordinator)
                .tabItem {
                    Image(systemName: "folder")
                }
                .tag(BottomTab.homepage)
            
            ProfileView(viewModel: coordinator.profileViewModel)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                }
                .tag(BottomTab.profile)
            
            IntelligentView(viewModel: coordinator.intelligentViewModel)
                .tabItem {
                    Image(systemName: "brain.filled.head.profile")
                }
                .tag(BottomTab.AI)
        }
        .ignoresSafeArea()
    }
}
