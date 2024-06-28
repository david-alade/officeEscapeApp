//
//  Event.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

struct Event: Codable, DecodableResponse {
    let id: Int
    var created_at: String? = nil
    let location: String
    let description: String
    let images: [String]?
    let userID: Int?
    let category: EventCategory
    let jpmcLocation: JpmcLocation
    let events_user_ids: [Int]?
    var event_user_name: [String]? = []
}

enum JpmcLocation: String, Codable, DecodableResponse {
    case PALOALTO, SEATTLE, NEWYORK, PLANO
}

enum EventCategory: String ,Codable, DecodableResponse {
    case PARK, HIKE, FOOD, BEACH
}
