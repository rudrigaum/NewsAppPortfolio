//
//  FavoritesManager.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 02/09/25.
//

import Foundation

import FirebaseFirestore
import Combine
import FirebaseAuth

@MainActor
class FavoritesManager: ObservableObject {
    @Published var savedArticles: [Article] = []
    
    private let firestore = Firestore.firestore()
    private let authManager: AuthManager
    private var listenerRegistration: ListenerRegistration?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        setupSubscription()
    }
    
    private func setupSubscription() {
        authManager.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                if isAuthenticated {
                    self.startListening()
                } else {
                    self.stopListening()
                    self.savedArticles = []
                }
            }
            .store(in: &cancellables)
    }
    
    func startListening() {
        guard let userId = authManager.currentUserId else { return }
        let favoritesCollection = firestore.collection("users").document(userId).collection("favorites")
        
        listenerRegistration = favoritesCollection.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching articles: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.savedArticles = documents.compactMap { document in
                try? document.data(as: Article.self)
            }
        }
    }
    
    func stopListening() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func saveArticle(_ article: Article) async {
        guard authManager.isAuthenticated, let userId = authManager.currentUserId else { return }
        
        let favoritesCollection = firestore.collection("users").document(userId).collection("favorites")
        
        do {
            let encodedArticle = try Firestore.Encoder().encode(article)
            try await favoritesCollection.document(article.title ?? UUID().uuidString).setData(encodedArticle)
        } catch {
            print("Error saving article: \(error.localizedDescription)")
        }
    }
    
    func removeArticle(_ article: Article) async {
        guard authManager.isAuthenticated, let userId = authManager.currentUserId else { return }
        
        let favoritesCollection = firestore.collection("users").document(userId).collection("favorites")
        
        do {
            try await favoritesCollection.document(article.title ?? UUID().uuidString).delete()
        } catch {
            print("Error removing article: \(error.localizedDescription)")
        }
    }

    func isArticleSaved(_ article: Article) -> Bool {
        savedArticles.contains { $0.title == article.title }
    }
}
