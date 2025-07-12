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
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = article.urlToImage,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                }
                .cornerRadius(8)
            }

            Text(article.title)
                .font(.headline)
                .lineLimit(2)

            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }

            HStack {
                Text(article.source?.name ?? "Fonte Desconhecida")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(formattedDate(from: article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    private func formattedDate(from dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "pt_BR")
            return displayFormatter.string(from: date)
        }
        return "Data Desconhecida"
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: Article(
            source: Source(id: "techcrunch", name: "TechCrunch"),
            author: "Frederic Lardinois",
            title: "Exemplo de Título da Notícia Muito Longo Para Testar as Linhas",
            description: "Esta é uma descrição de exemplo para a notícia. Ela deve ser longa o suficiente para testar o limite de linhas.",
            url: "https://techcrunch.com/example",
            urlToImage: "https://techcrunch.com/wp-content/uploads/2023/11/IMG_20231102_173922.jpg?w=1390&crop=1",
            publishedAt: "2023-11-03T10:00:00Z",
            content: "Conteúdo completo do artigo de exemplo."
        ))
        .previewLayout(.sizeThatFits) // Ajusta a prévia ao tamanho do conteúdo
        .padding()
    }
}
