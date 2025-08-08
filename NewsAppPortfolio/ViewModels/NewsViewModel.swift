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
    
    private let newsService: NewsService
    
    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }
    
    @MainActor
    func fetchArticles(category: String? = nil) async {
        if let category = category {
            self.selectedCategory = category
        }
        
        loadingState = .loading
        errorMessage = nil
        
        do {
            let articles = try await newsService.fetchTopHeadlines(category: self.selectedCategory.lowercased())
            self.articles = articles
            loadingState = .success
        } catch {
            errorMessage = error.localizedDescription
            loadingState = .failed(error)
        }
    }
}
