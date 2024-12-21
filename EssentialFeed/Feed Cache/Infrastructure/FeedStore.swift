//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by sam hastings on 21/10/2024.
//

public typealias CachedFeed = (feed: [LocalFeedImage],  timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Error?
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Error?
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievedResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievedResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible for dispatching to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible for dispatching to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible for dispatching to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
