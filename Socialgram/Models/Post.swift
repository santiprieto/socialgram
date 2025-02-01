import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let username: String
    let userImageURL: String
    let imageURL: String
    let caption: String
    var likes: Int
    var isLiked: Bool
    let timestamp: Date
    var comments: [Comment]
}

struct Comment: Identifiable, Codable {
    let id: String
    let username: String
    let text: String
    let timestamp: Date
}

struct Notification: Identifiable, Codable {
    let id: String
    let username: String
    let type: NotificationType
    let postId: String?
    let timestamp: Date
}

enum NotificationType: Codable {
    case like
    case comment
} 
