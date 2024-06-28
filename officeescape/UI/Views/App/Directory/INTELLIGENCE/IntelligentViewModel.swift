//
//  IntelligentViewModel.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Foundation
import Combine

class IntelligentViewModel: ViewModel {
    @Published var responseString: String = ""
    @Published var aiState: AiState = .none

    private var cancelBag = Set<AnyCancellable>()
    private let eventService: EventServiceProtocol
    
    var doneStreamingSubject = PassthroughSubject<Void, Never>()
    
    enum AiState {
        case loading
        case streaming
        case none
    }
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
        self.subscribeToResponse()
    }
    
    func askQuestion(_ question: String) {
        self.responseString = ""
        eventService.askForEventAdvice(query: question)
        aiState = .loading
    }
    
    private func subscribeToResponse() {
        self.eventService.response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.aiState = .streaming
                switch response {
                case .content(let string):
                    print(string)
                    self?.responseString += string
                case .end:
                    print("done streaming")
                    self?.aiState = .none
                    self?.doneStreamingSubject.send(())
                }
            }.store(in: &self.cancelBag)
    }
}
