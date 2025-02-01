import SwiftUI
import Combine

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showMessages = false
    
    init() {
        Task {
            await fetchPosts()
        }
    }
    
    @MainActor
    func fetchPosts() async {
        isLoading = true
        
        // Simulate API call with sample data
        let samplePosts = [
            Post(id: "1",
                 username: "nature_photography",
                 userImageURL: "https://source.unsplash.com/random/100x100?portrait",
                 imageURL: "https://source.unsplash.com/random/800x800?nature",
                 caption: "Beautiful sunset at the beach 🌅",
                 likes: 342,
                 isLiked: false,
                 timestamp: Date().addingTimeInterval(-3600),
                 comments: generateSampleComments()),
            
            Post(id: "12",
                 username: "foodie_adventures",
                 userImageURL: "https://source.unsplash.com/random/100x100?face",
                 imageURL: "https://source.unsplash.com/random/800x800?food",
                 caption: "Delicious homemade pasta 🍝", likes: 892,
                 isLiked: true,
                 timestamp: Date().addingTimeInterval(-7200),
                 comments: generateSampleComments()),
            
            // Add more sample posts as needed
        ]
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        posts = samplePosts
        isLoading = false
    }
    
    func likePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isLiked.toggle()
            posts[index].likes += posts[index].isLiked ? 1 : -1
        }
    }
    
    func sharePost(_ post: Post) {
        guard let url = URL(string: post.imageURL) else { return }
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func generateSampleComments() -> [Comment] {
        return [
            Comment(id: "", username: "user1", text: "Amazing shot! 😍", timestamp: Date().addingTimeInterval(-1800)),
            Comment(id: "", username: "user2", text: "Love the composition!", timestamp: Date().addingTimeInterval(-900)),
            Comment(id: "", username: "user3", text: "Where is this?", timestamp: Date().addingTimeInterval(-300))
        ]
    }
} 
