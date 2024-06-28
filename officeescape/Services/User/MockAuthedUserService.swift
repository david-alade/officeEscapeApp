//
//  MockAuthedUserService.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Combine
import Foundation

// Define the mock user
let mockUser = User(id: "1234", profile: UserProfile(bio: "Developer", name: "John Doe", jpmc_location: "New York", interests: ["Coding", "Reading"]))

// Define the mock service
final class MockAuthedUserService: AuthedUserServiceProtocol {
    var state = CurrentValueSubject<AuthedUserState, Never>(.signedIn(mockUser))
    
    func updateUserProfile(updatePayload: User.UpdateUserPayload) -> AnyPublisher<Void, AppError> {
        if case let .signedIn(user) = state.value {
            let newUser = updatePayload.update(currentUser: user)
            state.send(.signedIn(newUser))
        }
        return Just(())
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
}
