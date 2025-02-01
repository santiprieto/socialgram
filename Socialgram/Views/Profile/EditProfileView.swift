import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var fullName: String
    @State private var description: String
    @State private var isLoading = false
    
    init(user: User) {
        _fullName = State(initialValue: user.fullName)
        _description = State(initialValue: user.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information")) {
                    TextField("Full Name", text: $fullName)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            isLoading = true
                            await authViewModel.updateUserProfile(
                                fullName: fullName,
                                description: description
                            )
                            isLoading = false
                            dismiss()
                        }
                    }
                    .disabled(isLoading)
                }
            }
        }
    }
} 