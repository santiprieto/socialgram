import Foundation

struct Post: Identifiable {
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

struct Comment: Identifiable {
    let id: String
    let username: String
    let text: String
    let timestamp: Date
}

struct Notification: Identifiable {
    let id: String
    let username: String
    let type: NotificationType
    let postId: String?
    let timestamp: Date
}

enum NotificationType {
    case like
    case comment
} 
