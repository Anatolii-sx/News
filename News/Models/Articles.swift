//
//  News.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

struct News: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Articles]?
}

struct Articles: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let url: String?
}
