//
//  AuthManager.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 17/08/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    private var db: Firestore
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        self.db = Firestore.firestore()
        self.startListeningToAuthChanges()
    }
    
    func startListeningToAuthChanges() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.user = user
                self.isAuthenticated = (user != nil)
            }
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    @MainActor
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Erro ao sair da conta: \(error.localizedDescription)")
            throw error
        }
    }
}
