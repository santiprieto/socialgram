import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    var fullName: String
    let username: String
    let password: String
    var description: String
    var followers: [String]
    var following: [String]
    var posts: [String]
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
} 