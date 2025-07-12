//
//  LoadingState.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case success
    case failed(Error)
}
