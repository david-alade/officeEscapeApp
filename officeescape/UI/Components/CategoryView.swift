//
//  CategoryView.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct EventList: View {
    let events: [Event]
    var onIveBeenToEvent: (Event) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(events, id: \.id) { event in
                        NavigationLink(destination:
                                        EventDetailView(event: event,
                                                        beenToEvent: event.events_user_ids?.contains(Int(GlobalConstants.shared.userID) ?? -1) ?? false,
                                                        onIveBeenToEvent: {
                            onIveBeenToEvent(event)
                        })) {
                            VerticalEventCard(event: event) {
                                
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Events")
        }
    }
}

struct VerticalEventCard: View {
    let event: Event
    var onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let firstImageUrlString = event.images?.first, let url = URL(string: firstImageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .background(Color.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .background(Color.gray.opacity(0.2))
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .background(Color.gray.opacity(0.2))
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .background(Color.gray.opacity(0.2))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(event.description)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(event.category.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .onTapGesture {
            onTap()
        }
    }
}

