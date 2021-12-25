//
//  MainNetworkManager.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

import Foundation

enum Countries {
    case ru, us
}

enum MainNetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class MainNetworkManager {
    static let shared = MainNetworkManager()
    
    private let token = "d44f0aea780a4c3ca5ab14697a86d904"
    
    var country = Countries.ru
    var page = 1
    
    var url: String {
        "https://newsapi.org/v2/top-headlines?"
        + "country=\(country)"
        + "&sortBy=publishedAt"
        + "&pageSize=7"
        + "&page=\(page)"
        + "&apiKey=\(token)"
    }
    
    private init() {}
    
    func fetchNews(url: String, completion: @escaping (Result<ObtainedInfo, MainNetworkError>) -> Void) {
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

class MainImageManager {
    static var shared = MainImageManager()
    
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
