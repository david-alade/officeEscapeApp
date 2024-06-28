//
//  AuthenticatedNetworking.swift
//
//
//  Created by David Alade on 6/12/24.
//

import Combine
import Foundation

final class AuthNetworkService: NetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func request<T: DecodableResponse>(_ endpoint: Endpoint<T>) -> AnyPublisher<T, NetworkError> {
        var modifiedEndpoint = endpoint
        modifiedEndpoint.addAuthToken(token: GlobalConstants.shared.userID)
        return self.networkService.request(modifiedEndpoint)
    }
    
    func upload<T>(fileURL: URL, endpoint: Endpoint<T>) -> AnyPublisher<UploadTaskResponse<T>, NetworkError> where T : DecodableResponse {
        var modifiedEndpoint = endpoint
        modifiedEndpoint.addAuthToken(token: GlobalConstants.shared.userID)
        return self.networkService.upload(fileURL: fileURL, endpoint: modifiedEndpoint)
    }
}
