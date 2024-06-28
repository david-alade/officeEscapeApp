//
//  AuthedUserEndpoints.swift
//  truth
//
//  Created by David Alade on 6/13/24.
//

import Foundation

// MARK: User endpoints
extension Endpoint {
    static func createUser(createPayload: User.CreateUserPayload) throws -> Endpoint<VoidResponse> {
        return try Endpoint<VoidResponse>(
            path: "/users",
            method: .post,
            body: createPayload
        )
    }
    
    static func fetchUser() -> Endpoint<UserProfile> {
        return Endpoint<UserProfile>(
            path: "/users/getProfile",
            method: .get
        )
    }
    
    static func updateUser(updatePayload: User.UpdateUserPayload) throws -> Endpoint<VoidResponse>{
        return try Endpoint<VoidResponse>(
            path: "/users/updateProfile",
            method: .patch,
            body: updatePayload
        )
    }
    
    static func deleteUser() -> Endpoint<VoidResponse> {
        return Endpoint<VoidResponse>(
            path: "/users",
            method: .delete
        )
    }
}
