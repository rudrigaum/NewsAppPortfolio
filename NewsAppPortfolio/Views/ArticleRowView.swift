//
//  ArticleRowView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import Foundation
import SwiftUI

struct ArticleRowView: View {
    let article: Article

    var body: some View {
        NavigationLink(destination: ArticleDetailView(article: article)) {
            VStack(alignment: .leading, spacing: 8) {
                if let imageUrl = article.urlToImage,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                    }
                    .cornerRadius(8)
                }

                Text(article.title ?? "Title unavailable")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                if let description = article.articleDescription {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack {
                    Text(article.source?.name ?? "Unknown Source")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let publishedDate = article.publishedAt {
                        Text(publishedDate.formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Date not available")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }

}
