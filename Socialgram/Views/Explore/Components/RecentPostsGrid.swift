import SwiftUI

struct RecentPostsGrid: View {
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
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
    }
} 