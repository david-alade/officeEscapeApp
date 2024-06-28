//
//  ProfileViewModel.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    private var cancelBag = Set<AnyCancellable>()
    private var authedUserService: AuthedUserServiceProtocol
    
    @Published var user: User = User()
    
    init(authedUserService: AuthedUserServiceProtocol) {
        self.authedUserService = authedUserService
        self.setupBindings()
    }
    
    private func setupBindings() {
        self.authedUserService.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .signedIn(let user):
                    self?.user = user
                default:
                    self?.user = User()
                }
            }
            .store(in: &cancelBag)
    }
    
    func updateInterests(interest: String) {
        var currentInterests = user.profile.interests
        currentInterests.append(interest)
        
        self.authedUserService.updateUserProfile(updatePayload: User.UpdateUserPayload(interests: currentInterests))
            .receive(on: DispatchQueue.main)
            .handle { _ in
                print("done")
            } receiveError: { error in
                print(error)
            }.store(in: &self.cancelBag)
    }
}
