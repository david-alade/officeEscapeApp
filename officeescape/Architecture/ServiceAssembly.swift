//
//  ServiceAssembly.swift
//  bibite
//
//  Created by David Alade on 11/9/23.
//

import Swinject
import AVFoundation

final class ServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(AuthedUserServiceProtocol.self) { r in
            return AuthedUserService(authNetworkService: r.resolve(NetworkServiceProtocol.self, name: "authed")!)
        }.inObjectScope(.container)
        
        container.register(NetworkServiceProtocol.self, name: "public") { r in
            return NetworkService()
        }.inObjectScope(.container)
        
        container.register(NetworkServiceProtocol.self, name: "authed") { r in
            let networkService = r.resolve(NetworkServiceProtocol.self, name: "public")!
            return AuthNetworkService(networkService: networkService)
        }.inObjectScope(.container)
        
        container.register(EventServiceProtocol.self) { r in
            return EventService(openAiService: r.resolve(OpenAiStreamServiceProtocol.self)!,
                                networkService: r.resolve(NetworkServiceProtocol.self, name: "authed")!,
                                userService: r.resolve(AuthedUserServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(OpenAiStreamServiceProtocol.self) { r in
            return OpenAiStreamService()
        }.inObjectScope(.weak)
    }
}

