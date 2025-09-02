//
//  SavedArticlesView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/08/25.
//

import Foundation
import SwiftUI
import SwiftData


struct SavedArticlesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            VStack {
                if favoritesManager.savedArticles.isEmpty {
                    ContentUnavailableView("No news saved", systemImage: "bookmark.slash")
                } else {
                    List(favoritesManager.savedArticles, id: \.title) { article in
                        ArticleRowView(article: article)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved News")
        }
    }
}

