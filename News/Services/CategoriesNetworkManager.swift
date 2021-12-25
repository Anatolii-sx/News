//
//  CategoriesNetworkManager.swift
//  News
//
//  Created by Анатолий Миронов on 25.12.2021.
//

import Foundation

enum CategoriesCountries {
    case ru, us
}

//enum Language {
//    case ru, en
//}

enum CategoriesNetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class CategoriesNetworkManager {
    static let shared = CategoriesNetworkManager()
    
    private let token = "35d0b5eef7e44127a1a1c570f8d158b6"
    
    var country = CategoriesCountries.ru
    var category = ""
    var page = 1

//    var searchKeyword = ""
//    var searchLink: String {
//        "&q=\(searchKeyword)"
//    }
//
//    var searchLinkFinished: String {
//        searchKeyword.isEmpty ? "" : searchLink
//    }
    
    var url: String {
        "https://newsapi.org/v2/top-headlines?"
        + "country=\(country)"
        + "&category=\(category)"
        + "&sortBy=publishedAt"
        + "&pageSize=7"
        + "&page=\(page)"
        + "&apiKey=\(token)"
    }
    
    private init() {}
    
    func fetchNews(url: String, completion: @escaping (Result<ObtainedInfo, CategoriesNetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            print(url)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let info = try JSONDecoder().decode(ObtainedInfo.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(info))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

class CategoriesImageManager {
    static var shared = CategoriesImageManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }

            guard url == response.url else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
}

