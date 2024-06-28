//
//  ViewModelAssembly.swift
//  bibite
//
//  Created by David Alade on 11/9/23.
//

import Swinject
import AVFoundation

final class ViewModelAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(LoadingScreenViewModel.self) { _ in
            LoadingScreenViewModel()
        }.inObjectScope(.transient)
        
        container.register(ErrorScreenViewModel.self) { r in
            ErrorScreenViewModel()
        }.inObjectScope(.transient)
        
        container.register(ProfileViewModel.self) { r in
            ProfileViewModel(authedUserService: r.resolve(AuthedUserServiceProtocol.self)!)
        }.inObjectScope(.weak)
        
        container.register(IntelligentViewModel.self) { r in
            IntelligentViewModel(eventService: r.resolve(EventServiceProtocol.self)!)
        }.inObjectScope(.weak)
        
        container.register(MapViewModel.self) { r in
            MapViewModel(eventService: r.resolve(EventServiceProtocol.self)!)
        }.inObjectScope(.weak)
    }
}

