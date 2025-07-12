//
//  NetworkError.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/07/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case apiKeyMissing
}
