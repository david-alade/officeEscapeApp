//
//  AppRootCoordinator.swift
//  truth
//
//  Created by David Alade on 6/12/24.
//

import Swinject
import Combine

final class AppRootCoordinator: ViewModel {
    private let resolver: Resolver
    private var cancelBag = Set<AnyCancellable>()
    
    private var authedUserService: AuthedUserServiceProtocol
    
    @Published private(set) var appCoordinator: AppCoordinator?
    @Published private(set) var loadingScreenViewModel: LoadingScreenViewModel?
    @Published private(set) var errorScreenViewModel: ErrorScreenViewModel?
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.authedUserService = resolver.resolve(AuthedUserServiceProtocol.self)!
        self.setupBindings()
    }
    
    private func setupBindings() {
        self.authedUserService.state
            .map { state -> LoadingScreenViewModel? in
                switch state {
                case .loading(let loadingMessage):
                    return self.resolver.resolve(LoadingScreenViewModel.self)!
                        .setup(text: loadingMessage)
                default: return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$loadingScreenViewModel)
        
        self.authedUserService.state
            .map { state -> ErrorScreenViewModel? in
                switch state {
                case .error(_): return self.resolver.resolve(ErrorScreenViewModel.self)!
                default: return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorScreenViewModel)
        
        self.authedUserService.state
            .receive(on: DispatchQueue.main)
            .handle { state in
                switch state {
                case .signedIn(let user):
                    print("Got user: \(user)")
                    self.appCoordinator = self.resolver.resolve(AppCoordinator.self)!
                default: break
                }
            }.store(in: &self.cancelBag)
    }
}
