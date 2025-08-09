//
//  NewsViewModel.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 10/07/25.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    static let categories: [String] = ["general", "technology", "business", "health", "sports", "science"]
    @Published var selectedCategory: String = "general"
    @Published var searchQuery: String = ""
    private var searchTask: Task<Void, Never>? = nil
    
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }
    
    @MainActor
    func fetchArticles(for query: String? = nil) async {
        
        loadingState = .loading
        errorMessage = nil
        
        do {
            let fetchedArticles: [Article]
            
            if let query = query, !query.isEmpty {
                fetchedArticles = try await newsService.fetchTopHeadlines(query: query)
            } else {

                fetchedArticles = try await newsService.fetchTopHeadlines(category: self.selectedCategory)
            }
            
            self.articles = fetchedArticles
            loadingState = .success
        } catch {
            errorMessage = error.localizedDescription
            loadingState = .failed(error)
        }
    }
}
