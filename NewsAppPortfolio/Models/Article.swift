//
//  Article.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 10/07/25.
//

import Foundation
import SwiftData

@Model
class Article: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case source
        case author
        case title
        case articleDescription = "description"
        case url
        case urlToImage
        case publishedAt
        case content
    }
    
    @Attribute(.unique)
    var id: String = UUID().uuidString
    var source: Source?
    var author: String?
    var title: String?
    var articleDescription: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Date?
    var content: String?
    
    init(id: String = UUID().uuidString, source: Source? = nil, author: String? = nil, title: String? = nil, articleDescription: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: Date? = nil, content: String? = nil) {
        self.id = id
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.source = try container.decodeIfPresent(Source.self, forKey: .source)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.articleDescription = try container.decodeIfPresent(String.self, forKey: .articleDescription)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        
        let dateString = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        let dateFormatter = ISO8601DateFormatter()
        self.publishedAt = dateFormatter.date(from: dateString ?? "")
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(articleDescription, forKey: .articleDescription)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(urlToImage, forKey: .urlToImage)
        
        let dateFormatter = ISO8601DateFormatter()
        try container.encodeIfPresent(dateFormatter.string(from: publishedAt ?? Date()), forKey: .publishedAt)
        
        try container.encodeIfPresent(content, forKey: .content)
    }
}
