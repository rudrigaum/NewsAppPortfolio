//
//  ArticleRowView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import SwiftUI
import SwiftData


struct ArticleRowView: View {
    @State private var viewModel: ArticleRowViewModel
    @State private var isSaved: Bool = false
    
    init(viewModel: ArticleRowViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: viewModel.article.urlToImage.flatMap { URL(string: $0) }) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.article.title ?? "Untitled")
                    .font(.headline)
                
                Text(viewModel.article.articleDescription ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                if let publishedDate = viewModel.article.publishedAt {
                    Text(publishedDate.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Date not available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if viewModel.article.url != nil {
                Button {
                    viewModel.toggleSavedState()
                    isSaved.toggle()
                } label: {
                    Image(systemName: isSaved ? "star.fill" : "star")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            isSaved = viewModel.isArticleSaved()
        }
        .padding(.vertical, 8)
    }
}
