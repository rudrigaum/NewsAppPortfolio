//
//  ArticleRowWrapperView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 14/08/25.
//

import Foundation
import SwiftUI

struct ArticleRowWrapperView: View {
    @State private var viewModel: ArticleRowViewModel
    
    init(viewModel: ArticleRowViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ArticleRowView(viewModel: viewModel)
    }
}
