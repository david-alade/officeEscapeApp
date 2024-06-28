//
//  EventEndpoints.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Foundation

// MARK: Event endpoints
extension Endpoint {
    static func fetchEvents() throws -> Endpoint<[Event]>  {
        let body: [String: String] = [
            "jpmcLocation": String(describing: JpmcLocation.PALOALTO)
        ]
        return try Endpoint<[Event]>(
            path: "/events",
            method: .post,
            body: body
        )
    }
    
    static func chatWithEvents() -> Endpoint<VoidResponse> {
        return Endpoint<VoidResponse>(
            path: "/events/chat",
            method: .post
        )
    }
    
    static func iveBeenToEvent(event: Event) throws -> Endpoint<VoidResponse> {
        let eventID: [String: Int] = [
            "event_user_id": event.id
        ]
        
        return try Endpoint<VoidResponse>(
            path: "/events/beenToEvent",
            method: .post,
            body: eventID
        )
    }
}
