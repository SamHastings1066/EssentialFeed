//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by sam hastings on 21/10/2024.
//

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
