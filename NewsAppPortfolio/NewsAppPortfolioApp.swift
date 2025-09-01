//
//  NewsAppPortfolioApp.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 01/07/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
  var authManager: AuthManager?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    self.authManager = AuthManager()
    
    return true
  }
}

@main
struct NewsAppPortfolioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if let authManager = delegate.authManager {
                MainTabView()
                    .modelContainer(for: Article.self)
                    .environmentObject(authManager)
            } else {
                Text("Loading...")
            }
        }
    }
}

