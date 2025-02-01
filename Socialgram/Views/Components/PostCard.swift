import SwiftUI

struct PostCard: View {
    let post: Post
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showComments = false
    @State private var showCommentInput = false
    @State private var commentText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(post.username)
                    .font(.headline)
                Spacer()
                Text(post.timestamp.timeAgoDisplay())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            
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
                
                Button(action: {
                    withAnimation {
                        showCommentInput.toggle()
                    }
                }) {
                    Image(systemName: "bubble.right")
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .font(.system(size: 20))
            
            // Likes
            if post.likes > 0 {
                Text("\(post.likes) likes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
            }
            
            // Caption
            HStack {
                Text(post.username)
                    .fontWeight(.semibold) +
                Text(" ") +
                Text(post.caption)
            }
            .padding(.horizontal, 16)
            
            // Comments Preview
            if !post.comments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if post.comments.count > 2 && !showComments {
                        Button(action: {
                            showComments = true
                        }) {
                            Text("View all \(post.comments.count) comments")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    ForEach(showComments ? post.comments : Array(post.comments.prefix(2))) { comment in
                        HStack {
                            Text(comment.username)
                                .fontWeight(.semibold) +
                            Text(" ") +
                            Text(comment.text)
                            
                            Spacer()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // Add comment
            if showCommentInput {
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
                        showCommentInput = false
                    }) {
                        Text("Post")
                            .fontWeight(.semibold)
                            .foregroundColor(!commentText.isEmpty ? .blue : .gray)
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding(16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(0)
        .shadow(radius: 0)
        .padding(.vertical, 8)
    }
} 