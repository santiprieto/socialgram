import SwiftUI
import PhotosUI

struct PostView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                CustomTextField2("Write a caption...", text: $caption, icon: "text.quote")
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Label("Select Photo", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: publishPost) {
                    Text("Publish")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(image != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(image == nil)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
        }
    }
    
    private func publishPost() {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.8),
              let username = authViewModel.currentUser?.username else {
            return
        }
        
        postViewModel.createPost(
            username: username,
            imageData: imageData,
            caption: caption
        )
        
        // Reset form
        self.image = nil
        self.caption = ""
    }
} 