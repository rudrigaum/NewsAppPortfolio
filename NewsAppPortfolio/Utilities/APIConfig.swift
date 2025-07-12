//
//  APIConfig.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 10/07/25.
//

import Foundation

struct APIConfig {
    static let newsAPIKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            fatalError("Secrets.plist not found or malformed")
        }
        guard let key = dict["NewsAPIKey"] as? String else {
            fatalError("NewsAPIKey not found in Secrets.plist")
        }
        return key
    }()
}
