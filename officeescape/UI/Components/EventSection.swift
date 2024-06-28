//
//  EventSection.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct EventSection: View {
    var events: [Event]
    var title: String
    var onTapEvent: (Event) -> Void
    var onTapCategory: (EventCategory) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.title2)
                    .onTapGesture {
                        onTapCategory(events[0].category)
                    }
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(events, id: \.id) { event in
                        EventCard(event: event) {
                            print("Tapped event")
                            onTapEvent(event)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
