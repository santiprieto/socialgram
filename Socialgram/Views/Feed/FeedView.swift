import SwiftUI

struct FeedView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(postViewModel.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Feed")
            .refreshable {
                postViewModel.loadSavedPosts()
            }
        }
    }
}

struct CommentsView: View {
    let post: Post
    @State private var commentText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(post.comments) { comment in
                            CommentRow(comment: comment)
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Post") {
                        // Handle posting comment
                        commentText = ""
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.username)
                    .font(.system(size: 14, weight: .semibold))
                Text(comment.text)
                    .font(.system(size: 14))
                Text(comment.timestamp, style: .relative)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
} 
