//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 17/10/2024.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var deleteCachedCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedCallCount += 1
    }
    
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (store, _) = makeSUT()
        XCTAssertEqual(store.deleteCachedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (store, sut) = makeSUT()
        
        sut.save(items)
        XCTAssertEqual(store.deleteCachedCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }

    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (store: FeedStore, sut: LocalFeedLoader) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        return (store, sut)
    }
}

