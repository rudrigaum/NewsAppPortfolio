//
//  ArticleDetailView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import Foundation
import SwiftUI


struct ArticleDetailView: View {
    let article: Article
    
    @State private var showingSafariView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if let imageUrl = article.urlToImage,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    }
                }

                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack {
                    Text(article.author ?? "Autor Desconhecido")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(article.source?.name ?? "Fonte Desconhecida")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(formattedDate(from: article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Divider()

                Text(article.content ?? article.description ?? "Nenhum conteúdo ou descrição disponível.")
                    .font(.body)
                    .padding(.bottom)
                
                if let articleURL = URL(string: article.url) {
                    Button {
                        showingSafariView = true
                    } label: {
                        Label("Read Full Arcticle", systemImage: "safari.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Capsule().fill(Color.blue))
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $showingSafariView) {
                        SafariView(url: articleURL)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detalhes da Notícia")
        .navigationBarTitleDisplayMode(.inline)
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

// Prévia para o Xcode Canvas
struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { 
            ArticleDetailView(article: Article(
                source: Source(id: "techcrunch", name: "TechCrunch"),
                author: "Frederic Lardinois",
                title: "Exemplo de Título da Notícia Detalhada e Muito Longa Para Testar a Quebra de Linhas em Telas Maiores.",
                description: "Esta é uma descrição detalhada de exemplo para a notícia. Ela deve ser suficientemente longa para testar o comportamento de rolagem e a formatação do texto. Aqui poderíamos ter parágrafos adicionais com mais informações sobre o evento ou tópico em questão.",
                url: "https://techcrunch.com/example",
                urlToImage: "https://techcrunch.com/wp-content/uploads/2023/11/IMG_20231102_173922.jpg?w=1390&crop=1",
                publishedAt: "2023-11-03T10:00:00Z",
                content: "Este é o conteúdo completo do artigo, que pode ser bastante extenso. Ele incluiria todas as informações, citações e dados que compõem a notícia. A ideia é simular um artigo real, que muitas vezes é bem mais longo que apenas a descrição inicial. Pode haver vários parágrafos aqui para preencher a tela e garantir que o ScrollView funcione como esperado. Os usuários podem querer rolar para baixo para ler todo o contexto."
            ))
        }
    }
}
