//
//  TruthNetworkingProtocol.swift
//  
//
//  Created by David Alade on 6/12/24.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func request<T: DecodableResponse>(_ endpoint: Endpoint<T>) -> AnyPublisher<T, NetworkError>
    func upload<T: DecodableResponse>(fileURL: URL, endpoint: Endpoint<T>) -> AnyPublisher<UploadTaskResponse<T>, NetworkError>
}
