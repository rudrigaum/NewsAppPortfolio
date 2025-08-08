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
            VStack(spacing: 0) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(NewsViewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                Group {
                    switch viewModel.loadingState {
                    case .idle:
                        Text("Selecione uma categoria para carregar as notícias")
                    case .loading:
                        List {
                            ForEach(0..<5) { _ in
                                SkeletonArticleRowView()
                            }
                        }
                        .listStyle(.plain)
                                                .redacted(reason: .placeholder)
                    case .success:
                        List(viewModel.articles) { article in
                            ArticleRowView(article: article)
                        }
                        .listStyle(.plain)
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
            }
            .navigationTitle("Principais Notícias")
            .onChange(of: viewModel.selectedCategory) { newCategory in
                Task {
                    await viewModel.fetchArticles(category: newCategory)
                }
            }
            .onAppear {
                if case .idle = viewModel.loadingState {
                    Task {
                        await viewModel.fetchArticles(category: viewModel.selectedCategory)
                    }
                }
            }
        }
    }
}
