//
//  NewsService.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 10/07/25.
//

import Foundation

class NewsService {
    
    private let apiKey = APIConfig.newsAPIKey

    private let baseUrl = "https://newsapi.org/v2/top-headlines"

    func fetchTopHeadlines(category: String? = nil, country: String = "us") async throws -> [Article] {
        guard !apiKey.isEmpty else {
            throw NetworkError.apiKeyMissing
        }

        var components = URLComponents(string: baseUrl)
        var queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "country", value: country)
        ]

        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }

        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw NetworkError.badURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            return newsResponse.articles
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
