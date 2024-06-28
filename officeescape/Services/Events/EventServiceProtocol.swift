//
//  EventServiceProtocol.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Combine

protocol EventServiceProtocol {
    var response: PassthroughSubject<EventService.GptResponse, Never> { get }

    func askForEventAdvice(query: String)
    func fetchEvents() -> AnyPublisher<[Event], AppError>
    func iveBeenToThisEvent(event: Event) -> AnyPublisher<Void, AppError>
}
