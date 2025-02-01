import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var users: [User] = [
        User(id: "1", email: "jf@gmail.com", fullName: "Jimena Ferreiro", password: "123456789"),
        User(id: "2", email: "mt@gmail.com", fullName: "Mathias Casti", password: "123456789"),
        User(id: "3", email: "sc@gmail.com", fullName: "Sol Cardoso", password: "123456789")
    ]
    
    func login(email: String, password: String) {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            isAuthenticated = true
        } else {
            showAlert = true
            alertMessage = "Invalid credentials"
        }
    }
    
    func createUser(email: String, password: String, fullName: String) {
        guard !email.isEmpty && !password.isEmpty && !fullName.isEmpty else {
            showAlert = true
            alertMessage = "Please fill all fields"
            return
        }
        
        // Check if email already exists
        guard !users.contains(where: { $0.email == email }) else {
            showAlert = true
            alertMessage = "Email already exists"
            return
        }
        
        let newUser = User(id: UUID().uuidString, email: email, fullName: fullName, password: password)
        users.append(newUser)
        currentUser = newUser
        isAuthenticated = true
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
    }
}

struct User: Identifiable {
    let id: String
    let email: String
    let fullName: String
    let password: String
} 