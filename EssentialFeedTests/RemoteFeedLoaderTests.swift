//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 02/10/2024.
//

import EssentialFeed
import XCTest

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        // Arrange: GIVEN a client and an sut.
        let url = URL(string: "https://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act: WHEN sut.load() is invoked.
        sut.load()
        
        // Assert: THEN assert that a URL request was initiated in the client.
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // Arrange: GIVEN a client and an sut.
        let url = URL(string: "https://a-given.com")!
        let (sut, client) = makeSUT(url: url)
        
        // Act: WHEN sut.load() is invoked.
        sut.load()
        sut.load()
        
        // Assert: THEN assert that a URL request was initiated in the client.
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
}
