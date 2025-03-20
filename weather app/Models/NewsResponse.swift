//
//  NewsResponse.swift
//  weather app
//
//  Created by Yakup Atıcı on 11.08.2024.
//

import Foundation
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
}
