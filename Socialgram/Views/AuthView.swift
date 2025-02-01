import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var isLogin = true
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Logo
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text("Socialgram")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 60)
                        
                        // Form fields
                        VStack(spacing: 20) {
                            CustomTextField(
                                text: $authViewModel.email,
                                placeholder: "Email",
                                systemImage: "envelope",
                                isSecure: false
                            )
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            
                            CustomTextField(
                                text: $authViewModel.password,
                                placeholder: "Password",
                                systemImage: "lock",
                                isSecure: true
                            )
                            .focused($focusedField, equals: .password)
                            
                            // Login button
                            Button(action: {
                                authViewModel.login()
                            }) {
                                ZStack {
                                    Text(isLogin ? "Log In" : "Sign Up")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                        )
                                        .opacity(authViewModel.isLoading ? 0 : 1)
                                    
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    }
                                }
                            }
                            .disabled(authViewModel.isLoading)
                        }
                        .padding(.horizontal)
                        
                        // Toggle between login and signup
                        Button(action: { isLogin.toggle() }) {
                            Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
            }
            .alert("Error", isPresented: $authViewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(authViewModel.errorMessage ?? "An error occurred")
            }
        }
    }
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