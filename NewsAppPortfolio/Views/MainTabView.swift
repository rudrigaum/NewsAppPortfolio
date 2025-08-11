//
//  MainTabView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 11/08/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            Text("Favorites")
                .tabItem {
                    Label("Favorites", systemImage: "bookmark.fill")
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
