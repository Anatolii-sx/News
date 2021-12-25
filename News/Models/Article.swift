//
//  Article.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

struct ObtainedInfo: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
}
