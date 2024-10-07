//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by sam hastings on 02/10/2024.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

