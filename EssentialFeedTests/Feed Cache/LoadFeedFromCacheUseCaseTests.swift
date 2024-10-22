//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 21/10/2024.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages,[])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (store, sut) = makeSUT()
        
        sut.load()
        XCTAssertEqual(store.receivedMessages,[.retrieve])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (store: FeedStoreSpy, sut: LocalFeedLoader) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        return (store, sut)
    }
    
}
