import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var chatViewModel = ChatViewModel()
    @State private var showNewMessage = false
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(authViewModel.users.filter { $0.id != authViewModel.currentUser?.id }) { user in
                        NavigationLink {
                            ChatView(otherUser: user)
                                .environmentObject(chatViewModel)
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray.opacity(0.3))
                                
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.system(size: 14, weight: .semibold))
                                    if let lastMessage = chatViewModel.getMessages(
                                        between: authViewModel.currentUser?.id ?? "",
                                        and: user.id
                                    ).last {
                                        Text(lastMessage.text)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewMessage = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showNewMessage) {
                NewMessageView { user in
                    selectedUser = user
                    showNewMessage = false
                }
            }
            .onChange(of: selectedUser) { user in
                if let user = user {
                    selectedUser = nil
                    // Use path-based navigation to push ChatView
                    // This requires iOS 16+
                    // For earlier versions, you'll need to use a different navigation approach
                }
            }
        }
    }
}

struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    let onSelectUser: (User) -> Void
    
    private var filteredUsers: [User] {
        guard let currentUser = authViewModel.currentUser else { return [] }
        let searchResults = authViewModel.users.filter { user in
            user.id != currentUser.id &&
            currentUser.followers.contains(user.id) &&
            (searchText.isEmpty ||
             user.username.lowercased().contains(searchText.lowercased()) ||
             user.fullName.lowercased().contains(searchText.lowercased()))
        }
        return searchResults
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search followers", text: $searchText)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                List(filteredUsers) { user in
                    Button(action: {
                        onSelectUser(user)
                        dismiss()
                    }) {
                        HStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(user.fullName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .foregroundColor(.primary)
                }
                .listStyle(.plain)
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ChatView: View {
    let otherUser: User
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State private var messageText = ""
    
    private var chatMessages: [Message] {
        guard let currentUserId = authViewModel.currentUser?.id else { return [] }
        return chatViewModel.getMessages(between: currentUserId, and: otherUser.id)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chatMessages) { message in
                            MessageBubble(message: message, isCurrentUser: message.senderId == authViewModel.currentUser?.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: chatMessages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(chatMessages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Message...", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    guard let currentUserId = authViewModel.currentUser?.id else { return }
                    chatViewModel.sendMessage(
                        text: messageText,
                        from: currentUserId,
                        to: otherUser.id
                    )
                    messageText = ""
                }) {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(otherUser.username)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            Text(message.text)
                .padding(12)
                .background(isCurrentUser ? Color.blue : Color(.systemGray6))
                .foregroundColor(isCurrentUser ? .white : .primary)
                .cornerRadius(16)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isCurrentUser ? .trailing : .leading)
            
            if !isCurrentUser { Spacer() }
        }
    }
} 