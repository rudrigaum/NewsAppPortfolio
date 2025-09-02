//
//  ArticleRowView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import SwiftUI
import SwiftData

struct ArticleRowView: View {
    let article: Article
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var favoritesManager: FavoritesManager

    @State private var showingAuthPrompt = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: article.urlToImage.flatMap { URL(string: $0) }) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title ?? "Sem título")
                    .font(.headline)
                
                Text(article.articleDescription ?? "Sem descrição")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                if let publishedDate = article.publishedAt {
                    Text(publishedDate.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Data não disponível")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if article.url != nil {
                Button {
                    if authManager.isAuthenticated {
                        Task {
                            if favoritesManager.isArticleSaved(article) {
                                await favoritesManager.removeArticle(article)
                            } else {
                                await favoritesManager.saveArticle(article)
                            }
                        }
                    } else {
                        showingAuthPrompt = true
                    }
                } label: {
                    Image(systemName: favoritesManager.isArticleSaved(article) ? "star.fill" : "star")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingAuthPrompt) {
            SignUpPromptView()
        }
    }
}
