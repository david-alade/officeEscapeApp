//
//  AuthedUserServiceProtocol.swift
//  truth
//
//  Created by David Alade on 6/13/24.
//

import Combine

protocol AuthedUserServiceProtocol {
    var state: CurrentValueSubject<AuthedUserState, Never> { get }
    
    func updateUserProfile(updatePayload: User.UpdateUserPayload) -> AnyPublisher<Void, AppError>
}

enum AuthedUserState {
    case none
    case loading(String)
    case signedIn(User)
    case error(AppError)
    case appLaunch
}
