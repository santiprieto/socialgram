//
//  ContentView.swift
//  Socialgram
//
//  Created by Santiago Prieto on 1/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var postViewModel = PostViewModel()
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                AuthView()
                    .environmentObject(authViewModel)
            } else {
                MainTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(postViewModel)
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .tag(1)
            
            PostView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Post")
                }
                .tag(2)
            
            MessagesView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "message.fill" : "message")
                    Text("Messages")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
}
