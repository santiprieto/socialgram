import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var notifications: [Notification] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let postsKey = "saved_posts"
    
    init() {
        loadSavedPosts()
    }
    
    func loadSavedPosts() {
        if let savedPostsData = userDefaults.data(forKey: postsKey),
           let decodedPosts = try? JSONDecoder().decode([Post].self, from: savedPostsData) {
            posts = decodedPosts.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    private func savePosts() {
        if let encodedPosts = try? JSONEncoder().encode(posts) {
            userDefaults.set(encodedPosts, forKey: postsKey)
        }
    }
    
    func createPost(username: String, imageData: Data, caption: String) {
        let newPost = Post(
            id: UUID().uuidString,
            username: username,
            userImageURL: "", // You might want to add user profile image
            imageURL: "", // We'll store the actual image data
            caption: caption,
            likes: 0,
            isLiked: false,
            timestamp: Date(),
            comments: []
        )
        
        // Save image to local storage or cloud storage
        saveImage(imageData, for: newPost.id)
        
        posts.insert(newPost, at: 0)
        savePosts()
    }
    
    private func saveImage(_ imageData: Data, for postId: String) {
        // Save to local documents directory
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("\(postId).jpg")
            try? imageData.write(to: fileURL)
        }
    }
    
    func loadImage(for postId: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("\(postId).jpg")
            if let imageData = try? Data(contentsOf: fileURL) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    func fetchPosts() async {
        isLoading = true
        
        // Simulate API call with sample data
        let samplePosts = [
            Post(
                id: UUID().uuidString,
                username: "nature_photography",
                userImageURL: "https://source.unsplash.com/random/100x100?portrait",
                imageURL: "https://source.unsplash.com/random/800x800?nature",
                caption: "Beautiful sunset at the beach 🌅",
                likes: 342,
                isLiked: false,
                timestamp: Date().addingTimeInterval(-3600),
                comments: generateSampleComments()
            ),
            
            Post(
                id: UUID().uuidString,
                username: "foodie_adventures",
                userImageURL: "https://source.unsplash.com/random/100x100?face",
                imageURL: "https://source.unsplash.com/random/800x800?food",
                caption: "Delicious homemade pasta 🍝",
                likes: 892,
                isLiked: true,
                timestamp: Date().addingTimeInterval(-7200),
                comments: generateSampleComments()
            )
        ]
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        posts = samplePosts
        isLoading = false
    }
    
    private func generateSampleComments() -> [Comment] {
        return [
            Comment(
                id: UUID().uuidString,
                username: "user1",
                text: "Amazing shot! 📸",
                timestamp: Date().addingTimeInterval(-1800)
            ),
            Comment(
                id: UUID().uuidString,
                username: "user2",
                text: "Love this! ❤️",
                timestamp: Date().addingTimeInterval(-900)
            )
        ]
    }
    
    func likePost(post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isLiked.toggle()
            posts[index].likes += posts[index].isLiked ? 1 : -1
            savePosts()
        }
    }
    
    func addComment(to post: Post, text: String, username: String) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            let comment = Comment(
                id: UUID().uuidString,
                username: username,
                text: text,
                timestamp: Date()
            )
            posts[index].comments.append(comment)
            savePosts()
        }
    }
    
    private func createNotification(username: String, type: NotificationType, postId: String) {
        let notification = Notification(
            id: UUID().uuidString,
            username: username,
            type: type,
            postId: postId,
            timestamp: Date()
        )
        notifications.append(notification)
    }
    
    // Helper method to create a sample post
    func createPost(username: String, userImageURL: String, imageURL: String, caption: String) -> Post {
        return Post(
            id: UUID().uuidString,
            username: username,
            userImageURL: userImageURL,
            imageURL: imageURL,
            caption: caption,
            likes: 0,
            isLiked: false,
            timestamp: Date(),
            comments: []
        )
    }
} 
