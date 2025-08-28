//
//  AuthManager.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 17/08/25.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    private var authHandler: AuthStateDidChangeListenerHandle?
    
    init() {
    }
    
    @MainActor
      func startListeningToAuthChanges() {
          authHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
              self?.isAuthenticated = user != nil
          }
      }
      
    @MainActor
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    deinit {
        if let authHandler = authHandler {
            Auth.auth().removeStateDidChangeListener(authHandler)
        }
    }
}
