//
//  NetworkManager.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseComponents = URLComponents(string: "https://newsapi.org")
    private let apiKey = "PUT YOUR KEY HERE"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getTopHeadlines(page: Int) async throws -> Response {
        guard var components = baseComponents else {
            throw TNError.unknownError
        }

//        components.path = "/v2/top-headlines/sources"
        components.path = "/v2/top-headlines"
        components.queryItems = [
//            URLQueryItem(name: "country", value: "tw"),
            URLQueryItem(name: "country", value: "us"),
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
            return try decoder.decode(Response.self, from: data)
        } catch {
            print(error)
            throw TNError.invalidData
        }
    }
    
    func getTopHeadlinesSources() async throws -> Response {
        guard var components = baseComponents else {
            throw TNError.unknownError
        }

        components.path = "/v2/top-headlines/sources"
        components.queryItems = [
//            URLQueryItem(name: "country", value: "tw"),
            URLQueryItem(name: "country", value: "us"),
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
            return try decoder.decode(Response.self, from: data)
        } catch {
            print(error)
            throw TNError.invalidData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }

        // Intentionally not give error to the users but the placeholder image instead.
        // Because it would be overwhelming if error pops up for every failed profile image.
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
