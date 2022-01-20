//
//  Response.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/5/22.
//

import Foundation

struct NewsResponse: Codable, Hashable {
    let articles: [Article]
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
}

