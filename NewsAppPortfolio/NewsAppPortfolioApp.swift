//
//  NewsAppPortfolioApp.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 01/07/25.
//

import SwiftUI

@main
struct NewsAppPortfolioApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: Article.self)
        }
    }
}
