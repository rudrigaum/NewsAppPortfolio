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

    private let newsService: NewsService

    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }

    @MainActor
    func fetchArticles() async {
        loadingState = .loading
        errorMessage = nil

        do {
            let fetchedArticles = try await newsService.fetchTopHeadlines(country: "us")
            self.articles = fetchedArticles
            loadingState = .success
        } catch {
            loadingState = .failed(error)
            errorMessage = error.localizedDescription
            print("Error fetching articles: \(error)") 
        }
    }
}
