//
//  EventCoordinator.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Foundation
import Swinject
import Combine

final class EventCoordinator: ViewModel {
    private let resolver: Resolver
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var hikes: [Event] = []
    @Published var parks: [Event] = []
    @Published var beaches: [Event] = []
    @Published var foods: [Event] = []
    
    @Published var eventDirectoryState: EventDirectoryState = .loading
    
    enum EventDirectoryState {
        case loading
        case showingEvents
        case error
    }
//    
//    let exampleEvents: [Event] = [
//        Event(
//            id: 1,
//            location: "Central Park",
//            description: "A nice day out in Central Park.",
//            images: ["central_park_1.jpg", "central_park_2.jpg"],
//            userID: 101,
//            category: .PARK,
//            jpmcLocation: .NEWYORK
//        ),
//        Event(
//            id: 2,
//            location: "Palo Alto Foothills",
//            description: "A beautiful hike through the Palo Alto Foothills.",
//            images: ["palo_alto_hike_1.jpg", "palo_alto_hike_2.jpg"],
//            userID: 102,
//            category: .HIKE,
//            jpmcLocation: .PALOALTO
//        ),
//        Event(
//            id: 3,
//            location: "Seattle Waterfront",
//            description: "Enjoy delicious food at the Seattle Waterfront.",
//            images: ["seattle_food_1.jpg", "seattle_food_2.jpg"],
//            userID: 103,
//            category: .FOOD,
//            jpmcLocation: .SEATTLE
//        ),
//        Event(
//            id: 4,
//            location: "Santa Monica Beach",
//            description: "Relax at the Santa Monica Beach.",
//            images: ["santa_monica_beach_1.jpg", "santa_monica_beach_2.jpg"],
//            userID: nil,
//            category: .BEACH,
//            jpmcLocation: .PLANO
//        )
//    ]
    
    private var eventService: EventServiceProtocol
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.eventService = resolver.resolve(EventServiceProtocol.self)!
        self.fetchEvents()
    }
    
    func fetchEvents() {
        self.eventService.fetchEvents()
            .receive(on: DispatchQueue.main)
            .handle { events in
                for event in events {
                    switch event.category {
                    case .BEACH:
                        self.beaches.append(event)
                    case .FOOD:
                        self.foods.append(event)
                    case .HIKE:
                        self.hikes.append(event)
                    case .PARK:
                        self.parks.append(event)
                    }
                }
                self.eventDirectoryState = .showingEvents
            } receiveError: { error in
                self.eventDirectoryState = .error
                print("CAUGHT ERROR FETCHING EVENTS: \(error)")
            }.store(in: &self.cancelBag)
    }
    
    func beenToEvent(event: Event) {
        eventService.iveBeenToThisEvent(event: event)
            .handle { _ in
                print("BEEN THERE")
            } receiveError: { error in
                print("Error being there: \(error)")
            }.store(in: &self.cancelBag)
    }
}
