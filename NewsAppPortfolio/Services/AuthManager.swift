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
    
    // Observa o estado de autenticação do Firebase.
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // Firestore database reference
    private var db: Firestore
    
    init() {
        self.db = Firestore.firestore()
        self.startListeningToAuthChanges()
    }
    
    // Inicia a escuta por mudanças no estado de autenticação do Firebase.
    func startListeningToAuthChanges() {
        // Remove qualquer ouvinte existente para evitar duplicações
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        // Adiciona um novo ouvinte
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            // Assegura que a atualização de estado aconteça no Main Actor
            Task { @MainActor in
                self.user = user
                self.isAuthenticated = (user != nil)
            }
        }
    }
    
    // MARK: - Autenticação
    
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
