//
//  Date+Extension.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 12/08/25.
//

import Foundation

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: self)
    }
}
