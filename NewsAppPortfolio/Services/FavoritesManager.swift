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

class FavoritesManager: ObservableObject {
    private var db = Firestore.firestore()
    private var articlesRef: CollectionReference {
        guard let user = Auth.auth().currentUser else {
            fatalError("User is not authenticated.")
        }
        return db.collection("users").document(user.uid).collection("articles")
    }

    @Published var favoriteArticles = [Article]()
    
    private var cancellables = Set<AnyCancellable>()
    private var authStateSubscription: AnyCancellable?
    private var snapshotListener: ListenerRegistration?

    init(authManager: AuthManager) {
        authStateSubscription = authManager.$user
            .sink { [weak self] user in
                guard let self = self else { return }
                if user != nil {
                    self.startListeningForFavorites()
                } else {
                    self.stopListeningForFavorites()
                }
            }
    }

    func startListeningForFavorites() {
        guard Auth.auth().currentUser != nil else { return }

        stopListeningForFavorites()

        snapshotListener = articlesRef.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting favorite articles: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }

            self.favoriteArticles = documents.compactMap { doc in
                try? doc.data(as: Article.self)
            }
        }
    }
    
    func stopListeningForFavorites() {
        snapshotListener?.remove()
        snapshotListener = nil
        favoriteArticles = []
    }
    
    func saveArticle(_ article: Article) async throws {
        do {
            try articlesRef.document(article.id).setData(from: article)
        } catch {
            print("Error saving article: \(error.localizedDescription)")
            throw error
        }
    }
    
    func removeArticle(_ article: Article) async throws {
        do {
            try await articlesRef.document(article.id).delete()
        } catch {
            print("Error removing article: \(error.localizedDescription)")
            throw error
        }
    }

    func isArticleFavorite(_ article: Article) -> Bool {
        return favoriteArticles.contains(where: { $0.id == article.id })
    }
}
