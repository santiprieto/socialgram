import SwiftUI

struct ProfileView: View {
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Profile Header
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("150")
                                    .font(.headline)
                                Text("Posts")
                                    .font(.caption)
                            }
                            
                            VStack {
                                Text("1.2K")
                                    .font(.headline)
                                Text("Followers")
                                    .font(.caption)
                            }
                            
                            VStack {
                                Text("1K")
                                    .font(.headline)
                                Text("Following")
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Username")
                            .font(.headline)
                        Text("Bio description goes here.\nMultiple lines of text can go here.")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Edit Profile Button
                    Button(action: {}) {
                        Text("Edit Profile")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    // Posts Grid
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(0..<15) { _ in
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
            .navigationTitle("Profile")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
    }
} 