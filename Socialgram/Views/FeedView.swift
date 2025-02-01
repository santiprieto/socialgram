import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<10) { _ in
                        PostCard()
                    }
                }
            }
            .navigationTitle("Socialgram")
        }
    }
}

struct PostCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            // User header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                Text("username")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
            .padding(.horizontal)
            
            // Post image
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.gray)
            
            // Action buttons
            HStack {
                Button(action: {}) {
                    Image(systemName: "heart")
                }
                Button(action: {}) {
                    Image(systemName: "message")
                }
                Button(action: {}) {
                    Image(systemName: "paperplane")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "bookmark")
                }
            }
            .padding(.horizontal)
            
            // Likes
            Text("100 likes")
                .font(.headline)
                .padding(.horizontal)
            
            // Caption
            Text("username ")
                .font(.headline) +
            Text("This is the post caption")
                .font(.body)
            
            Text("2 hours ago")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 4)
        }
        .padding(.vertical)
    }
} 