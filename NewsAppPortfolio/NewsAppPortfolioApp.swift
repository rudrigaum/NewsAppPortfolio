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
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct NewsAppPortfolioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authManager: AuthManager
    @StateObject private var favoritesManager: FavoritesManager
    
    init() {
        let authManagerInstance = AuthManager()
        self._authManager = StateObject(wrappedValue: authManagerInstance)
        
        self._favoritesManager = StateObject(wrappedValue: FavoritesManager(authManager: authManagerInstance))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: Article.self)
                // Injeta ambos os gerenciadores no ambiente
                .environmentObject(authManager)
                .environmentObject(favoritesManager)
                .task {
                    // Este bloco de código é executado de forma assíncrona
                    // após a View aparecer, o que garante que o Firebase
                    // já foi configurado antes de tentarmos acessá-lo.
                    authManager.startListeningToAuthChanges()
                }
        }
    }
}
