//
//  SearchView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 11/08/25.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = NewsViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Search for articles...", text: $viewModel.searchQuery)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: viewModel.searchQuery) { newQuery in
                        Task {
                            try await Task.sleep(nanoseconds: 500_000_000)
                            await viewModel.fetchArticles(for: newQuery)
                        }
                    }
                
                Group {
                    switch viewModel.loadingState {
                    case .idle:
                        Text("Start typing to search.")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.secondary)
                    case .loading:
                        List {
                            ForEach(0..<5) { _ in
                                SkeletonArticleRowView()
                            }
                        }
                        .listStyle(.plain)
                        .redacted(reason: .placeholder)
                    case .success:
                        if viewModel.articles.isEmpty && !viewModel.searchQuery.isEmpty {
                            EmptySearchView(message: "No results found for '\(viewModel.searchQuery)'.")
                        } else {
                            List(viewModel.articles) { article in
                                ArticleRowWrapperView(viewModel: ArticleRowViewModel(article: article, modelContext: modelContext))
                            }
                            .listStyle(.plain)
                            .refreshable {
                                await viewModel.fetchArticles(for: viewModel.searchQuery)
                            }
                        }
                    case .failed(let error):
                        VStack {
                            Text("Error loading news: \(viewModel.errorMessage ?? error.localizedDescription)")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Try Again") {
                                Task {
                                    await viewModel.fetchArticles()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}
