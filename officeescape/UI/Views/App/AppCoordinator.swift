//
//  AppCoordinator.swift
//  truth
//
//  Created by David Alade on 6/16/24.
//

import Swinject
import Combine

enum BottomTab: String {
    case homepage
    case profile
    case AI
    case map
}

final class AppCoordinator: ViewModel {
    private let resolver: Resolver
    private var cancelBag = Set<AnyCancellable>()
    private var authedUserService: AuthedUserServiceProtocol
    
    @Published var eventCoordinator: EventCoordinator
    @Published var profileViewModel: ProfileViewModel
    @Published var intelligentViewModel: IntelligentViewModel
    @Published var mapViewModel: MapViewModel
    @Published var currentTab: BottomTab = .homepage

    init(resolver: Resolver) {
        self.resolver = resolver
        self.authedUserService = resolver.resolve(AuthedUserServiceProtocol.self)!
        self.eventCoordinator = resolver.resolve(EventCoordinator.self)!
        self.profileViewModel = resolver.resolve(ProfileViewModel.self)!
        self.intelligentViewModel = resolver.resolve(IntelligentViewModel.self)!
        self.mapViewModel = resolver.resolve(MapViewModel.self)!
    }
    
    func tappedTab(oldTab: BottomTab, newTab: BottomTab) {
        if oldTab == newTab {
//            if newTab == .profile {
//                self.profileTabCoordinator?.pressedTabButton()
//            } else if newTab == .homepage {
//                self.homeTabCoordinator?.pressedTabButton()
//            }
        }
    }
}
