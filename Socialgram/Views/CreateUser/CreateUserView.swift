import SwiftUI

struct CreateUserView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var username = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .padding(.vertical, 24)
            
            CustomTextField2("Full Name", text: $fullName, icon: "person")
            CustomTextField2("Username", text: $username, icon: "person.circle")
            CustomTextField2("Email", text: $email, icon: "envelope")
            CustomTextField2("Password", text: $password, isSecure: true, icon: "lock")
            
            Button(action: {
                Task {
                    isLoading = true
                    await authViewModel.createUser(
                        email: email,
                        username: username,
                        password: password,
                        fullName: fullName
                    )
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .disabled(isLoading)
            
            Button("Already have an account? Sign In") {
                dismiss()
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
    }
} 
