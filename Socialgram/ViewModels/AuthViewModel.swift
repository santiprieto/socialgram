import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Basic validation
            guard !email.isEmpty, !password.isEmpty else {
                self.errorMessage = "Please fill in all fields"
                self.showError = true
                self.isLoading = false
                return
            }
            
            // Here you would typically make an API call
            // For now, we'll simulate a successful login
            if self.email.contains("@") && self.password.count >= 6 {
                self.isAuthenticated = true
            } else {
                self.errorMessage = "Invalid email or password"
                self.showError = true
            }
            
            self.isLoading = false
        }
    }
    
    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
    }
} 