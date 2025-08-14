//
//  ArticleRowViewModel.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 13/08/25.
//

import SwiftUI
import SwiftData

@Observable
final class ArticleRowViewModel {
    
    let article: Article
    private let modelContext: ModelContext
    
    init(article: Article, modelContext: ModelContext) {
        self.article = article
        self.modelContext = modelContext
    }
    
    func isArticleSaved() -> Bool {
        guard let uniqueURL = article.url else { return false }
        do {
            let predicate = #Predicate<Article> { savedArticle in
                savedArticle.url == uniqueURL
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            let result = try modelContext.fetch(descriptor)
            return !result.isEmpty
        } catch {
            return false
        }
    }
    
    func toggleSavedState() {
        guard let uniqueURL = article.url else { return }
        
        do {
            let predicate = #Predicate<Article> { savedArticle in
                savedArticle.url == uniqueURL
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            let result = try modelContext.fetch(descriptor)
            
            if let articleToDelete = result.first {
                modelContext.delete(articleToDelete)
            } else {
                let newArticle = Article(
                    source: article.source,
                    author: article.author,
                    title: article.title,
                    articleDescription: article.articleDescription,
                    url: article.url,
                    urlToImage: article.urlToImage,
                    publishedAt: article.publishedAt,
                    content: article.content
                )
                modelContext.insert(newArticle)
            }
            try? modelContext.save()
        } catch {
        }
    }
}
