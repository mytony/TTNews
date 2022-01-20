//
//  NetworkManager.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import UIKit

enum Category: CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseComponents = URLComponents(string: "https://newsapi.org")
    private let apiKey = Keys.newsAPI
    private let cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    static let defaultPageSize = 20
    
    private var categories = [String]()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getTopHeadlines(category: String = "", page: Int = 1) async throws -> NewsResponse {
        guard var components = baseComponents else {
            throw TNError.unknownError
        }

        components.path = "/v2/top-headlines"
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: category),
            URLQueryItem(name: "page", value: String(page)),
        ]
        
        guard let url = components.url else {
            throw TNError.unknownError
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TNError.invalidResponse
        }

        do {
            return try decoder.decode(NewsResponse.self, from: data)
        } catch {
            print(error)
            throw TNError.invalidData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }

        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
