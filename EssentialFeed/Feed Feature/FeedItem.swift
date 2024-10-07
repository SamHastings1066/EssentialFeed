//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by sam hastings on 02/10/2024.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, image: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = image
    }
}

extension FeedItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
}

