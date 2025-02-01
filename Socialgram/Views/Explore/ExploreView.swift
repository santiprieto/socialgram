import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search users", text: $searchText)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .onChange(of: searchText) { newValue in
                            authViewModel.searchUsers(with: newValue)
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            authViewModel.searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if searchText.isEmpty {
                    // Show recent posts when not searching
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 2) {
                            ForEach(postViewModel.posts) { post in
                                if let image = postViewModel.loadImage(for: post.id) {
                                    NavigationLink(destination: PostDetailView(post: post)) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width/3 - 1,
                                                   height: UIScreen.main.bounds.width/3 - 1)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // Show search results
                    List(authViewModel.searchResults) { user in
                        NavigationLink(destination: UserProfileView(user: user)) {
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray.opacity(0.3))
                                
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(user.fullName)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Explore")
        }
    }
}

// Add this view to show other users' profiles
struct UserProfileView: View {
    let user: User
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPost: Post?
    
    private var userPosts: [Post] {
        postViewModel.posts.filter { $0.username == user.username }
    }
    
    // Computed property to get the updated user data
    private var updatedUser: User {
        // Get the most recent version of the user from the users array
        if let updated = authViewModel.users.first(where: { $0.id == user.id }) {
            return updated
        }
        return user
    }
    
    // Computed properties for counts
    private var followersCount: Int {
        updatedUser.followers.count
    }
    
    private var followingCount: Int {
        updatedUser.following.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.fullName)
                                .font(.title2)
                                .bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await authViewModel.followUser(user)
                            }
                        }) {
                            Text(authViewModel.isFollowing(user) ? "Following" : "Follow")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 120, height: 32)
                                .background(authViewModel.isFollowing(user) ? Color.gray.opacity(0.2) : Color.blue)
                                .foregroundColor(authViewModel.isFollowing(user) ? .black : .white)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !user.description.isEmpty {
                        Text(user.description)
                            .padding(.horizontal)
                    }
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(userPosts.count)")
                                .font(.subheadline)
                                .bold()
                            Text("Posts")
                                .font(.footnote)
                        }
                        
                        VStack {
                            Text("\(followersCount)")
                                .font(.subheadline)
                                .bold()
                            Text("Followers")
                                .font(.footnote)
                        }
                        .animation(.spring(), value: followersCount)
                        
                        VStack {
                            Text("\(followingCount)")
                                .font(.subheadline)
                                .bold()
                            Text("Following")
                                .font(.footnote)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Posts Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 2) {
                    ForEach(userPosts) { post in
                        if let image = postViewModel.loadImage(for: post.id) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width/3 - 1,
                                       height: UIScreen.main.bounds.width/3 - 1)
                                .clipped()
                                .onTapGesture {
                                    selectedPost = post
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post)
        }
    }
} 