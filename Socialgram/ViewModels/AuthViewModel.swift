import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Published var searchResults: [User] = []
    @Published var isSearching = false
    
    @Published private(set) var users: [User] = []
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "current_user"
    private let usersKey = "users"
    
    init() {
        Task {
            await loadUsers()
            loadCurrentUser()
        }
    }
    
    private func loadUsers() async {
        if let savedUsersData = userDefaults.data(forKey: usersKey),
           let decodedUsers = try? JSONDecoder().decode([User].self, from: savedUsersData) {
            users = decodedUsers
        }
    }
    
    private func saveUsers() {
        if let encodedUsers = try? JSONEncoder().encode(users) {
            userDefaults.set(encodedUsers, forKey: usersKey)
        }
    }
    
    private func loadCurrentUser() {
        if let savedUserData = userDefaults.data(forKey: currentUserKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            currentUser = decodedUser
            isAuthenticated = true
        }
    }
    
    private func saveCurrentUser() {
        if let currentUser = currentUser,
           let encodedUser = try? JSONEncoder().encode(currentUser) {
            userDefaults.set(encodedUser, forKey: currentUserKey)
        } else {
            userDefaults.removeObject(forKey: currentUserKey)
        }
    }
    
    func login(email: String, password: String) async {
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            if let user = users.first(where: { $0.email == email && $0.password == password }) {
                currentUser = user
                isAuthenticated = true
                saveCurrentUser()
            } else {
                showAlert = true
                alertMessage = "Invalid credentials"
            }
        } catch {
            showAlert = true
            alertMessage = "Login failed. Please try again."
        }
    }
    
    func createUser(email: String, username: String, password: String, fullName: String) async {
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            guard !email.isEmpty && !password.isEmpty && !fullName.isEmpty && !username.isEmpty else {
                showAlert = true
                alertMessage = "Please fill all fields"
                return
            }
            
            // Check if email or username already exists
            guard !users.contains(where: { $0.email == email || $0.username == username }) else {
                showAlert = true
                alertMessage = "Email or username already exists"
                return
            }
            
            let newUser = User(
                id: UUID().uuidString,
                email: email,
                fullName: fullName,
                username: username,
                password: password,
                description: "",
                followers: [],
                following: [],
                posts: []
            )
            users.append(newUser)
            saveUsers()
            
            currentUser = newUser
            isAuthenticated = true
            saveCurrentUser()
        } catch {
            showAlert = true
            alertMessage = "Failed to create account. Please try again."
        }
    }
    
    func logout() async {
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000)
            currentUser = nil
            isAuthenticated = false
            userDefaults.removeObject(forKey: currentUserKey)
        } catch {
            showAlert = true
            alertMessage = "Logout failed. Please try again."
        }
    }
    
    func updateUserProfile(fullName: String?, description: String?) async {
        guard var updatedUser = currentUser else { return }
        
        if let newName = fullName {
            updatedUser.fullName = newName
        }
        
        if let newDescription = description {
            updatedUser.description = newDescription
        }
        
        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
            users[index] = updatedUser
            currentUser = updatedUser
            saveUsers()
            saveCurrentUser()
        }
    }
    
    func searchUsers(with query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        // Filter users excluding the current user
        searchResults = users.filter { user in
            guard user.id != currentUser?.id else { return false }
            return user.username.lowercased().contains(query.lowercased()) ||
                   user.fullName.lowercased().contains(query.lowercased())
        }
    }
    
    func followUser(_ userToFollow: User) async {
        guard var currentUser = currentUser,
              var userToUpdate = users.first(where: { $0.id == userToFollow.id }) else { return }
        
        // Update current user's following list
        if !currentUser.following.contains(userToFollow.id) {
            currentUser.following.append(userToFollow.id)
            userToUpdate.followers.append(currentUser.id)
        } else {
            currentUser.following.removeAll(where: { $0 == userToFollow.id })
            userToUpdate.followers.removeAll(where: { $0 == currentUser.id })
        }
        
        // Update both users in the users array
        if let currentUserIndex = users.firstIndex(where: { $0.id == currentUser.id }),
           let userToUpdateIndex = users.firstIndex(where: { $0.id == userToUpdate.id }) {
            users[currentUserIndex] = currentUser
            users[userToUpdateIndex] = userToUpdate
            
            // Update current user reference
            self.currentUser = currentUser
            
            // Save changes
            saveUsers()
            saveCurrentUser()
        }
    }
    
    func isFollowing(_ user: User) -> Bool {
        guard let currentUser = currentUser else { return false }
        return currentUser.following.contains(user.id)
    }
} 