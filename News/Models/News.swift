//
//  News.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

struct ObtainedInfo: Decodable {
    let status: String?
    let news: [News]?
    let page: Int?
}

struct News: Decodable {
    let title: String?
    let description: String?
    let image: String?
    let url: String?
}
