//
//  MapViewModel.swift
//  officeescape
//
//  Created by David Alade on 6/28/24.
//

import MapKit
import Foundation
import Combine

class IdentifiablePointAnnotation: MKPointAnnotation, Identifiable {
    let id = UUID()
}

class MapViewModel: ViewModel {
    private var cancelBag = Set<AnyCancellable>()
    @Published var events: [Event] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.4419,
            longitude: -122.1430),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var annotations: [IdentifiablePointAnnotation] = []
    
    private var eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
        self.fetchEvents()
    }
    
    private func fetchCoordinates() {
        for event in events {
            getCoordinateFrom(address: event.location) { coordinate in
                let annotation = IdentifiablePointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = event.description
                self.annotations.append(annotation)
            }
        }
    }
    
    private func fetchEvents() {
        self.eventService.fetchEvents()
            .receive(on: DispatchQueue.main)
            .handle { events in
                self.events = events
                self.fetchCoordinates()
            } receiveError: { error in
                print("CAUGHT ERROR FETCHING EVENTS: \(error)")
            }.store(in: &self.cancelBag)
    }
    
    private func getCoordinateFrom(address: String, completion: @escaping (CLLocationCoordinate2D) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks, let location = placemarks.first?.location {
                completion(location.coordinate)
            }
        }
    }
}
