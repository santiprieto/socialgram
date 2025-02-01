import SwiftUI
import PhotosUI

struct PostView: View {
    @State private var selectedImage: PhotosPickerItem?
    @State private var displayImage: Image?
    @State private var caption = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if let displayImage = displayImage {
                    displayImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                } else {
                    PhotosPicker(selection: $selectedImage) {
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                            Text("Select Photo")
                        }
                        .frame(height: 400)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                    }
                }
                
                TextField("Write a caption...", text: $caption, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button(action: {
                    // Handle post creation
                }) {
                    Text("Share")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} 