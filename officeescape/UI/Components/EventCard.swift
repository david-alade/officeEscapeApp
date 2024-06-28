//
//  EventCard.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct EventCard: View {
    let event: Event
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            if let firstImageUrlString = event.images?.first, let url = URL(string: firstImageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 80)
                            .cornerRadius(10)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 80)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 80)
                            .cornerRadius(10)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 80)
                            .cornerRadius(10)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 80)
                    .cornerRadius(10)
            }
            
            Text(event.description)
                .font(.headline)
                .padding(.top, 5)
            
            Text(event.location)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(maxWidth: 150, maxHeight: 130)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.trailing, 10)
        .onTapGesture {
            onTap()
        }
    }
}
