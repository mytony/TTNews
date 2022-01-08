//
//  Response.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import Foundation

struct Response: Codable, Hashable {
    let status: String
    let totalResults: Int?      // only in top-headlines
    let articles: [Article]?    // only in top-headlines
    let sources: [Source]?      // only in top-headlines/sources
}

struct Article: Codable, Hashable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
}

struct Source: Codable, Hashable {
    let id: String?
    let name: String
    
    // only for top-headlines/sources
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}

