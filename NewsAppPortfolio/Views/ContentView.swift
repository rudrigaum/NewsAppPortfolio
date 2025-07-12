//
//  ContentView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 01/07/25.
//

import SwiftUI

struct ContentView: View {
    
        @StateObject private var viewModel = NewsViewModel()

        var body: some View {
            NavigationView {
                Group {
                    switch viewModel.loadingState {
                    case .idle:
                        Text("Pressione para carregar as notícias")
                            .onAppear {
                                if case .idle = viewModel.loadingState {
                                    Task {
                                        await viewModel.fetchArticles()
                                    }
                                }
                            }
                    case .loading:
                        ProgressView("Carregando notícias...")
                    case .success:
                        List(viewModel.articles) { article in
                            ArticleRowView(article: article)
                        }
                        .refreshable {
                            await viewModel.fetchArticles()
                        }
                    case .failed(let error):
                        VStack {
                            Text("Erro ao carregar notícias: \(viewModel.errorMessage ?? error.localizedDescription)")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Tentar Novamente") {
                                Task {
                                    await viewModel.fetchArticles()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .navigationTitle("Principais Notícias")
            }
        }
    }


#Preview {
    ContentView()
}
