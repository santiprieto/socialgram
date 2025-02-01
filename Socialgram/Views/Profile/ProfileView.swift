import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var showEditProfile = false
    @State private var selectedPost: Post? = nil
    @State private var showLogoutAlert = false
    
    private var userPosts: [Post] {
        postViewModel.posts.filter { $0.username == authViewModel.currentUser?.username }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(authViewModel.currentUser?.fullName ?? "")
                                    .font(.title2)
                                    .bold()
                                
                                Text("@\(authViewModel.currentUser?.username ?? "")")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showEditProfile = true
                            }) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 120, height: 32)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        if let description = authViewModel.currentUser?.description, !description.isEmpty {
                            Text(description)
                                .padding(.horizontal)
                        }
                        
                        HStack(spacing: 30) {
                            VStack {
                                Text("\(userPosts.count)")
                                    .font(.subheadline)
                                    .bold()
                                Text("Posts")
                                    .font(.footnote)
                            }
                            
                            VStack {
                                Text("\(authViewModel.currentUser?.followers.count ?? 0)")
                                    .font(.subheadline)
                                    .bold()
                                Text("Followers")
                                    .font(.footnote)
                            }
                            
                            VStack {
                                Text("\(authViewModel.currentUser?.following.count ?? 0)")
                                    .font(.subheadline)
                                    .bold()
                                Text("Following")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
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
            .onAppear {
                // Load saved posts when view appears
                postViewModel.loadSavedPosts()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            showLogoutAlert = true
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                if let user = authViewModel.currentUser {
                    EditProfileView(user: user)
                }
            }
            .sheet(item: $selectedPost) { post in
                PostDetailView(post: post)
            }
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    Task {
                        await authViewModel.logout()
                    }
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
} 
