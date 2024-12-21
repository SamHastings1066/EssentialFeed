//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by sam hastings on 07/10/2024.
//

import Foundation


public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible for dispatching to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
