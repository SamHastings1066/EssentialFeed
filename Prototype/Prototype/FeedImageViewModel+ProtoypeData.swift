//
//  FeedImageViewModel+ProtoypeData.swift
//  Prototype
//
//  Created by sam hastings on 23/12/2024.
//

import Foundation

extension FeedImageViewModel {
    static var prototypeFeed: [FeedImageViewModel] {
        return [
            FeedImageViewModel(
                description: "Trellick is a council block",
                location: "Trellick Tower",
                imageName: "image-0"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Portobello Road",
                imageName: "image-1"
            ),
            FeedImageViewModel(
                description: "Notting Hill carnival - about the best event on the planet. I was introduced to it aged 11. I remember seeing a man jumping on the bonnet of the car in front of us.",
                location: nil,
                imageName: "image-2"
            )
        ]
    }
}
