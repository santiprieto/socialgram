import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let userDefaults = UserDefaults.standard
    private let chatKey = "saved_chats"
    
    private var timer: Timer?
    
    init() {
        loadMessages()
        // Start checking for new messages every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.loadMessages()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func loadMessages() {
        if let savedData = userDefaults.data(forKey: chatKey),
           let savedMessages = try? JSONDecoder().decode([Message].self, from: savedData) {
            messages = savedMessages.sorted { $0.timestamp < $1.timestamp }
        }
    }
    
    private func saveMessages() {
        if let encodedMessages = try? JSONEncoder().encode(messages) {
            userDefaults.set(encodedMessages, forKey: chatKey)
        }
    }
    
    func sendMessage(text: String, from senderId: String, to receiverId: String) {
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: senderId,
            receiverId: receiverId,
            text: text,
            timestamp: Date()
        )
        messages.append(newMessage)
        saveMessages()
    }
    
    func getMessages(between user1: String, and user2: String) -> [Message] {
        messages.filter { message in
            (message.senderId == user1 && message.receiverId == user2) ||
            (message.senderId == user2 && message.receiverId == user1)
        }
    }
} 
