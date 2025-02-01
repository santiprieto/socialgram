import SwiftUI

struct UserSearchResults: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List(authViewModel.searchResults) { user in
            NavigationLink(destination: UserProfileView(user: user)) {
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
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
} 