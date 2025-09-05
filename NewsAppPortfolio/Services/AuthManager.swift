//
//  AuthManager.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 17/08/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices

// >>>>> NOVO: Protocolo para a injeção de dependência <<<<<
// Define o contrato do que o gerenciador de autenticação deve fazer.
protocol AuthProtocol: ObservableObject {
    var isAuthenticated: Bool { get }
    var user: User? { get }
    var currentUserId: String? { get }
    
    func startListeningToAuthChanges()
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signInWithGoogle(presentingViewController: UIViewController) async throws
    func signOut() throws
}

class AuthManager: AuthProtocol {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    // Construtor
    init() {
        // CORREÇÃO: Removemos a chamada para 'startListeningToAuthChanges()'.
        // Essa função agora será chamada na sua App.
    }
    
    // >>>>> NOVO: `@MainActor` para garantir que as atualizações de UI ocorram na thread principal <<<<<
    @MainActor
    func startListeningToAuthChanges() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            self.user = user
            self.isAuthenticated = (user != nil)
        }
    }
    
    // MARK: - Funções de Autenticação
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    // >>>>> NOVO: A função agora recebe o view controller como parâmetro <<<<<
    @MainActor
    func signInWithGoogle(presentingViewController: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Firebase ClientID not found."])
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "ID Token not found."])
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: gidSignInResult.user.accessToken.tokenString)
        try await Auth.auth().signIn(with: credential)
    }
    
    @MainActor
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    deinit {
        if let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        }
    }
}
