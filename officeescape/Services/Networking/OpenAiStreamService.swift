//
//  OpenAiStreamService.swift
//  
//
//  Created by David Alade on 6/12/24.
//

import Foundation
import Combine

class OpenAiStreamService: OpenAiStreamServiceProtocol {
    private var _resultStream = PassthroughSubject<String, Never>()
    var resultStream: AnyPublisher<String, Never> {
        _resultStream.eraseToAnyPublisher()
    }

    func startStream<T: DecodableResponse>(endpoint: Endpoint<T>) {
        Task {
            do {
                guard let request = endpoint.request() else {
                    print("Failed to create request")
                    return
                }

                var asyncBytes: URLSession.AsyncBytes!
                var response: URLResponse!
                
                // Start the bytes request
                (asyncBytes, response) = try await URLSession.shared.bytes(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error")
                    return
                }
                
                for try await line in asyncBytes.characters {
                    print("got line: \(line)")
                    self._resultStream.send(String(line))
                }
                
                print("Stream finished.")
                self._resultStream.send(completion: .finished)
            } catch {
                print(error)
            }
        }
    }
}
