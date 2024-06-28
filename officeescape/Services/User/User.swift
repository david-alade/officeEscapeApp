import Foundation

/**
 Represents a user profile
 */

struct User: Identifiable, Codable, DecodableResponse {
    private(set) var id: String
    var profile: UserProfile
}

extension User: Equatable {
    // MARK: For create user endpoint
    struct CreateUserPayload: Encodable {
        var id: Int
    }
    
    struct UpdateUserPayload: Encodable {
        var bio: String?
        var name: String?
        var jpmc_location: String?
        var interests: [String]?
        
        init(name: String? = nil,
             bio: String? = nil,
             jpmc_location: String? = nil,
             interests: [String]? = nil
        ) {
            self.bio = bio
            self.name = name
            self.jpmc_location = jpmc_location
            self.interests = interests
        }
        
        func update(currentUser: User) -> User {
            var updatedUser = currentUser
            
            if let newBio = self.bio {
                updatedUser.profile.bio = newBio
            }
            
            if let newName = self.name {
                updatedUser.profile.name = newName
            }
            
            if let newLocation = self.jpmc_location {
                updatedUser.profile.jpmc_location = newLocation
            }
            
            if let newInterests = self.interests {
                updatedUser.profile.interests = newInterests
            }
            
            return updatedUser
        }
    }
    
    init() {
        self.id = ""
        self.profile = UserProfile()
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserProfile: Codable, Equatable, DecodableResponse {
    var bio: String
    var name: String
    var jpmc_location: String
    var interests: [String]
}

extension UserProfile {
    init() {
        self.bio = ""
        self.name = ""
        self.jpmc_location = ""
        self.interests = []
    }
    
    enum CodingKeys: String, CodingKey {
        case bio
        case name
        case jpmc_location
        case interests
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.jpmc_location = try container.decodeIfPresent(String.self, forKey: .jpmc_location) ?? ""
        self.interests = try container.decodeIfPresent([String].self, forKey: .interests) ?? []
    }
}
