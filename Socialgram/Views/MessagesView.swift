import SwiftUI

struct MessagesView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { _ in
                    NavigationLink(destination: ChatView()) {
                        MessageRow()
                    }
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}

struct MessageRow: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                Text("Last message preview...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("2h")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ChatView: View {
    @State private var messageText = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<20) { i in
                        MessageBubble(isFromCurrentUser: i % 2 == 0)
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {}) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Username")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageBubble: View {
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }
            
            Text("This is a message")
                .padding(10)
                .background(isFromCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isFromCurrentUser ? .white : .primary)
                .cornerRadius(10)
            
            if !isFromCurrentUser { Spacer() }
        }
    }
} 