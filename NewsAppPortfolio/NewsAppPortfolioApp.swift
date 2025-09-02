//
//  NewsAppPortfolioApp.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 01/07/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    var authManager: AuthManager?
    var favoritesManager: FavoritesManager?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        self.authManager = AuthManager()
        self.favoritesManager = FavoritesManager(authManager: self.authManager!)
        
        return true
    }
}

@main
struct NewsAppPortfolioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if let authManager = delegate.authManager, let favoritesManager = delegate.favoritesManager {
                MainTabView()
                    .environmentObject(authManager)
                    .environmentObject(favoritesManager)
            } else {
                Text("Loading...")
            }
        }
    }
}
