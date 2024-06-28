//
//  EventCoordinatorView.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct EventCoordinatorView: View {
    @ObservedObject var coordinator: EventCoordinator
    @State private var isShowingFullEvent = false
    @State private var selectedEvent: Event?
    @State private var isShowingFullCategory = false
    @State private var selectedCategory: EventCategory?
    
    var body: some View {
        switch coordinator.eventDirectoryState {
        case .loading:
            LoadingScreenView(viewModel: LoadingScreenViewModel())
        case .showingEvents:
            showingEventsView
        case .error:
            ErrorScreenView(viewModel: ErrorScreenViewModel())
        }
    }
    
    var showingEventsView: some View {
        NavigationStack {
            VStack {    
                ScrollView {
                    EventSection(events: coordinator.hikes, title: "Best hikes ever") { event in
                        openEvent(event: event)
                    } onTapCategory: { category in
                        openCategory(category: category)
                    }
                    .padding()
                    
                    EventSection(events: coordinator.foods, title: "Good eats") { event in
                        openEvent(event: event)
                    } onTapCategory: { category in
                        openCategory(category: category)
                    }
                    .padding()
                    
                    EventSection(events: coordinator.beaches, title: "Make a sand castle") { event in
                        openEvent(event: event)
                    } onTapCategory: { category in
                        openCategory(category: category)
                    }
                    .padding()
                    
                    EventSection(events: coordinator.parks, title: "Go for a stroll") { event in
                        openEvent(event: event)
                    } onTapCategory: { category in
                        openCategory(category: category)
                    }
                    .padding()
                }
            }
            .navigationTitle("Palo Alto Office")
            .navigationDestination(isPresented: $isShowingFullEvent) {
                if let event = selectedEvent {
                    
                    EventDetailView(event: event,
                                    beenToEvent: event.events_user_ids?.contains(Int(GlobalConstants.shared.userID) ?? -1) ?? false) {
                        coordinator.beenToEvent(event: event)
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingFullCategory) {
                switch self.selectedCategory {
                case .BEACH:
                    EventList(events: coordinator.beaches) { event in
                        coordinator.beenToEvent(event: event)
                    }
                    .navigationTitle("BEACHES")
                case .FOOD:
                    EventList(events: coordinator.foods) { event in
                        coordinator.beenToEvent(event: event)
                    }
                    .navigationTitle("FOOD")
                case .HIKE:
                    EventList(events: coordinator.hikes) { event in
                        coordinator.beenToEvent(event: event)
                    }
                    .navigationTitle("HIKES")
                case .PARK:
                    EventList(events: coordinator.parks) { event in
                        coordinator.beenToEvent(event: event)
                    }
                    .navigationTitle("PARKS")
                case .none:
                    Text("what?")
                }
            }
        }
    }
    
    private func openCategory(category: EventCategory) {
        self.selectedCategory = category
        self.isShowingFullCategory = true
    }
    
    private func openEvent(event: Event) {
        self.selectedEvent = event
        self.isShowingFullEvent = true
    }
}
