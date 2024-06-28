//
//  EventView.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var beenToEvent: Bool
    var onIveBeenToEvent: () -> Void
    
    init(event: Event, beenToEvent: Bool, onIveBeenToEvent: @escaping () -> Void) {
        self.event = event
        self.beenToEvent = beenToEvent
        self.onIveBeenToEvent = onIveBeenToEvent
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let firstImageUrlString = event.images?.first, let url = URL(string: firstImageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(10)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(10)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                Text("Location: \(event.location)")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 5)
                
                Text("Category: \(event.category.rawValue.capitalized)")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 5)
                
                Text("JPMC Location: \(event.jpmcLocation.rawValue.capitalized)")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 5)
                
                Text(event.description)
                    .font(.body)
                    .padding(.top, 10)
                
                HStack {
                    Spacer()

                    if beenToEvent {
                        Text("You've been here!")
                            .bold()
                    } else {
                        Button("Ive been here") {
                            onIveBeenToEvent()
                            beenToEvent = true
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                VStack {
                    Text("These colleagues have also been: ")
                    
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(event.event_user_name ?? [], id: \.self) { name in
                                Text(name)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Event Details")
    }
}
