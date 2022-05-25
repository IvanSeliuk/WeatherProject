//
//  News.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import Foundation

// MARK: - News
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author, title: String?
    let articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: ID
    let name: Name
}

enum ID: String, Codable {
    case theWallStreetJournal = "the-wall-street-journal"
}

enum Name: String, Codable {
    case theWallStreetJournal = "The Wall Street Journal"
}
