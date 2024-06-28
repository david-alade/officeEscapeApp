//
//  CoordinatorAssembly.swift
//  bibite
//
//  Created by David Alade on 11/9/23.
//

import Swinject

final class CoordinatorAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(AppRootCoordinator.self) { r in
            AppRootCoordinator(resolver: r)
        }.inObjectScope(.container)
        
        container.register(AppCoordinator.self) { r in
            AppCoordinator(resolver: r)
        }.inObjectScope(.weak)
        
        container.register(EventCoordinator.self) { r in
            EventCoordinator(resolver: r)
        }.inObjectScope(.weak)
    }
}
