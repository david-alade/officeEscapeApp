//
//  OpenAiStreamServiceProtocol.swift
//  
//
//  Created by David Alade on 6/12/24.
//

import Combine

protocol OpenAiStreamServiceProtocol {
    func startStream<T: DecodableResponse>(endpoint: Endpoint<T>)
    var resultStream: AnyPublisher<String, Never> { get }
}
