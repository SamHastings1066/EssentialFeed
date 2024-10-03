//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 02/10/2024.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    private init() {}
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadRequestDataFromURL() {
        // Arrange: GIVEN a client and an sut.
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        // Act: WHEN sut.load() is invoked.
        sut.load()
        
        // Assert: THEN assert that a URL request was initiated in the client.
        XCTAssertNotNil(client.requestedURL)
    }
}
