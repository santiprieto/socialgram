import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedPost: Post?
    @State private var showComments = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.posts) { post in
                        PostCard(post: post,
                               onLike: { viewModel.likePost(post) },
                               onComment: { selectedPost = post },
                               onShare: { viewModel.sharePost(post) })
                    }
                }
            }
            .refreshable {
                await viewModel.fetchPosts()
            }
            .navigationTitle("Socialgram")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("socialgram_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showMessages = true
                    } label: {
                        Image(systemName: "paperplane")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(item: $selectedPost) { post in
                CommentsView(post: post)
            }
        }
    }
}

struct PostCard: View {
    let post: Post
    let onLike: () -> Void
    let onComment: () -> Void
    let onShare: () -> Void
    
    @State private var showDoubleTapHeart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // User header
            HStack {
                AsyncImage(url: URL(string: post.userImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .foregroundColor(.gray.opacity(0.3))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.system(size: 14, weight: .semibold))
                    Text("Location")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button(role: .none, action: {}) {
                        Label("Save Post", systemImage: "bookmark")
                    }
                    Button(role: .none, action: {}) {
                        Label("Share Post", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive, action: {}) {
                        Label("Report", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // Post image
            AsyncImage(url: URL(string: post.imageURL)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            if showDoubleTapHeart {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.white)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .onTapGesture(count: 2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showDoubleTapHeart = true
                                onLike()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation {
                                    showDoubleTapHeart = false
                                }
                            }
                        }
                case .failure:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            
            // Action buttons
            HStack(spacing: 16) {
                Button(action: onLike) {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(post.isLiked ? .red : .primary)
                }
                .animation(.spring(response: 0.3), value: post.isLiked)
                
                Button(action: onComment) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 20))
                }
                
                Button(action: onShare) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // Likes
            if post.likes > 0 {
                Text("\(post.likes) likes")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal)
            }
            
            // Caption
            HStack {
                Text(post.username)
                    .font(.system(size: 14, weight: .semibold)) +
                Text(" ") +
                Text(post.caption)
                    .font(.system(size: 14))
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            // Timestamp
            Text(post.timestamp, style: .relative)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom, 8)
        }
        .background(Color(UIColor.systemBackground))
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
