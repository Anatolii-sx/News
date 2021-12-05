//
//  NetworkManager.swift
//  News
//
//  Created by Анатолий Миронов on 28.11.2021.
//

import Foundation

enum Countries {
    case ru, us, eu
}

enum Language {
    case ru, en
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let token = "byGRBCiwcNwLuktoITblPykiz0SUgeZih5ZzISMbWfa2Dxaj"
    var country = Countries.ru
    var language = Language.ru
    var page = 1
    
    var searchKeyword = ""
    var searchLink: String {
        "search?keywords=\(searchKeyword)&"
    }
    
    var main: String {
        searchKeyword.isEmpty ? "latest-news?": searchLink
    }
    
    var url: String {
    "https://api.currentsapi.services/v1/"
        + main
        + "page_number=\(page)"
        + "&page_size=7"
        + "&country=\(country)"
        + "&language=\(language)"
        + "&apiKey=\(token)"
    }
    
    private init() {}
    
    func fetchNews(url: String, completion: @escaping (Result<ObtainedInfo, NetworkError>) -> Void) {
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

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
//        var currentURL = url.absoluteString
//        if currentURL.contains("//cdnimg.rg.ru") {
//            let url = currentURL.replacingOccurrences(of: "//cdnimg.rg.ru", with: "https://cdnimg.rg.ru")
//            currentURL = url
//            print(currentURL)
//        }
//        // OPTIONAL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//        let newURL = URL(string: currentURL)!
//        print(newURL)
        
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
