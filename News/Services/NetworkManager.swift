//
//  NetworkManager.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let token = "d44f0aea780a4c3ca5ab14697a86d904"
    
    var url: String {
    "https://newsapi.org/v2/top-headlines?country=ru&from=2021-11-28&sortBy=popularity&pageSize=10&page=1&apiKey=\(token)"
    }
    
//    var urlUs: String {
//    "https://newsapi.org/v2/top-headlines?country=us&from=2021-11-28&sortBy=popularity&pageSize=10&page=1&apiKey=\(token)"
//    }
    
    
    private init() {}
    
    func fetchNews(url: String, completion: @escaping (Result<News, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let info = try JSONDecoder().decode(News.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(info))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

class ImageManager {
    static var shared = ImageManager()
    
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
