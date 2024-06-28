//
//  PublisherExtension.swift
//  
//
//  Created by David Alade on 6/12/24.
//

import Combine

public extension Publisher where Failure: Error {
    func handle(receiveValue: @escaping ((Self.Output) -> Void) = { value in },
                receiveError: @escaping ((Self.Failure) -> Void) = { error in
                }) -> AnyCancellable {
        return self
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Ignoring the .finished case by default
                case .failure(let error):
                    receiveError(error)
                }
            }, receiveValue: receiveValue)
    }
}
