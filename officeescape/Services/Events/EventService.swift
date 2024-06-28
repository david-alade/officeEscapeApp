//
//  EventService.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Combine
import Foundation

final class EventService: EventServiceProtocol {
    var response = PassthroughSubject<GptResponse, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private var openAiService: OpenAiStreamServiceProtocol
    private var networkService: NetworkServiceProtocol
    private var userService: AuthedUserServiceProtocol
    
    init(openAiService: OpenAiStreamServiceProtocol, networkService: NetworkServiceProtocol, userService: AuthedUserServiceProtocol) {
        self.userService = userService
        self.networkService = networkService
        self.openAiService = openAiService
        self.openAiService.resultStream
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.response.send(.end)
                case .failure(let failure):
                    print("Caught error: \(failure)")
                }
            }, receiveValue: { [weak self] string in
                print("Recieved: \(string)")
                self?.response.send(GptResponse.content(string))
            }).store(in: &self.cancelBag)
    }
    
    enum GptResponse {
        case content(String)
        case end
    }
    
    func fetchEvents() -> AnyPublisher<[Event], AppError> {
        do {
            let publisher = try networkService.request(Endpoint<[Event]>.fetchEvents())
                .mapError { AppError.network($0) }
                .eraseToAnyPublisher()
            return publisher
        } catch {
            print("Error fetching: \(error)")
            return Fail(error: error as! Never).setFailureType(to: AppError.self).eraseToAnyPublisher()
        }
    }
    
    func askForEventAdvice(query: String) {
        do {
            var interests = ""
            switch self.userService.state.value {
            case .signedIn(let user): interests = user.profile.interests.joined(separator: " ")
            default: break
            }
            
            let body: [String: String] = [
                "interests": interests,
                "query": query
            ]
            
            var endpoint = try Endpoint<VoidResponse>(
                path: "/events/AIrecommendations",
                method: .post,
                body: body
            )
            
            endpoint.addAuthToken(token: GlobalConstants.shared.userID)
            
            self.openAiService.startStream(endpoint: endpoint)
        } catch {
            print("caught error: \(error)")
        }
    }
    
    func iveBeenToThisEvent(event: Event) -> AnyPublisher<Void, AppError> {
        do {
            return try self.networkService.request(Endpoint<VoidResponse>.iveBeenToEvent(event: event))
                .map { _ in
                    return ()
                }
                .mapError { AppError.network($0) }
                .eraseToAnyPublisher()
        } catch {
            print("EERROR: \(error)")
            return Fail(error: error)
                .mapError { _ in AppError.unknown(error) }
                .eraseToAnyPublisher()
        }
    }
}
