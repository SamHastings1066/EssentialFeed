//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by sam hastings on 02/10/2024.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
