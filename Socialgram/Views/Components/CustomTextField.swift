import SwiftUI

struct CustomTextField2: View {
    let placeholder: String
    let text: Binding<String>
    let isSecure: Bool
    let icon: String
    
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false, icon: String) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
} 
