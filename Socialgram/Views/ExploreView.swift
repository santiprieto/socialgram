import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Search bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                // Grid of photos
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(0..<30) { _ in
                        NavigationLink(destination: FeedView()) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width / 3) - 1,
                                     height: (UIScreen.main.bounds.width / 3) - 1)
                                .clipped()
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Explore")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
} 