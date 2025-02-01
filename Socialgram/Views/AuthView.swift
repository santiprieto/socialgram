import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showCreateAccount = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome")
                    .font(.largeTitle)
                    .bold()
                
                CustomTextField2("Email", text: $email, icon: "envelope")
                CustomTextField2("Password", text: $password, isSecure: true, icon: "lock")
                
                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button("Create Account") {
                    showCreateAccount = true
                }
                .sheet(isPresented: $showCreateAccount) {
                    CreateUserView()
                }
            }
            .padding()
            .alert("Error", isPresented: $authViewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.alertMessage)
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    let isSecure: Bool
    
    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
        }
        .placeholder(when: text.isEmpty) {
            Text(placeholder)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
                    .padding(.leading)
                Spacer()
            }
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
} 