//
//  AuthedUserService.swift
//  truth
//
//  Created by David Alade on 6/13/24.
//

import Combine
import Foundation

final class AuthedUserService: AuthedUserServiceProtocol {
    private var cancelBag = Set<AnyCancellable>()
    private var authNetworkService: NetworkServiceProtocol
    
    var state = CurrentValueSubject<AuthedUserState, Never>(.appLaunch)
    
    init(authNetworkService: NetworkServiceProtocol) {
        self.authNetworkService = authNetworkService
        self.fetchUser()
    }
    
    func updateUserProfile(updatePayload: User.UpdateUserPayload) -> AnyPublisher<Void, AppError> {
        do {
            let endpoint = try Endpoint<VoidResponse>.updateUser(updatePayload: updatePayload)
            return self.authNetworkService.request(endpoint)
                .mapError { AppError.network($0) }
                .receive(on: DispatchQueue.main)
                .map { _ in
                    if case let .signedIn(user) = self.state.value {
                        let newUser = updatePayload.update(currentUser: user)
                        self.state.send(.signedIn(newUser))
                    }
                    
                    return ()
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: (AppError.network(NetworkError.endpointError(.encodingError)))).eraseToAnyPublisher()
        }
    }
    
    private func fetchUser() {
        let endpoint = Endpoint<UserProfile>.fetchUser()
        
        return self.authNetworkService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .handle { user in
                print("Got user: \(user)")
                self.state.value = .signedIn(User(id: GlobalConstants.shared.userID, profile: user))
            } receiveError: { error in
                self.state.value = .error(AppError.network(error))
                print(error)
            }.store(in: &self.cancelBag)
    }
}

