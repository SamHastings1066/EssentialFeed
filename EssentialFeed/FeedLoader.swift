//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by sam hastings on 02/10/2024.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
