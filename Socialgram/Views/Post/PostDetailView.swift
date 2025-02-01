import SwiftUI

struct PostDetailView: View {
    let post: Post
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var commentText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Text(post.username)
                        .font(.headline)
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                // Image
                if let image = postViewModel.loadImage(for: post.id) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                // Actions
                HStack(spacing: 16) {
                    Button(action: {
                        postViewModel.likePost(post: post)
                    }) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(post.isLiked ? .red : .primary)
                    }
                    
                    Image(systemName: "bubble.right")
                    
                    Spacer()
                }
                .padding(.horizontal)
                .font(.system(size: 20))
                
                // Likes
                if post.likes > 0 {
                    Text("\(post.likes) likes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                }
                
                // Caption
                HStack {
                    Text(post.username)
                        .fontWeight(.semibold) +
                    Text(" ") +
                    Text(post.caption)
                }
                .padding(.horizontal)
                
                // Comments
                if !post.comments.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(post.comments) { comment in
                            HStack {
                                Text(comment.username)
                                    .fontWeight(.semibold) +
                                Text(" ") +
                                Text(comment.text)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Add comment
                HStack {
                    CustomTextField2("Add a comment...", text: $commentText, icon: "text.bubble")
                    
                    Button(action: {
                        guard !commentText.isEmpty,
                              let username = authViewModel.currentUser?.username else { return }
                        
                        postViewModel.addComment(
                            to: post,
                            text: commentText,
                            username: username
                        )
                        commentText = ""
                    }) {
                        Text("Post")
                            .fontWeight(.semibold)
                            .foregroundColor(!commentText.isEmpty ? .blue : .gray)
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding()
            }
        }
    }
} 
