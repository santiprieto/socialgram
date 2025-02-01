import SwiftUI

struct CreateUserView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .padding(.vertical, 20)
            
            CustomTextField2("Full Name", text: $fullName, icon: "person")
            CustomTextField2("Email", text: $email, icon: "envelope")
            CustomTextField2("Password", text: $password, isSecure: true, icon: "lock")
            
            Button(action: {
                authViewModel.createUser(email: email, password: password, fullName: fullName)
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            Button("Already have an account? Sign In") {
                dismiss()
            }
            .padding()
        }
    }
} 
