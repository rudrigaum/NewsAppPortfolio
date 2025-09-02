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
    @Query(sort: \Article.publishedAt, order: .reverse) private var savedArticles: [Article]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack {
                if savedArticles.isEmpty {
                    ContentUnavailableView("No news saved", systemImage: "star.slash")
                } else {
                    List(savedArticles) { article in
                        ArticleRowWrapperView(viewModel: ArticleRowViewModel(article: article, modelContext: modelContext))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved News")
        }
    }
}
