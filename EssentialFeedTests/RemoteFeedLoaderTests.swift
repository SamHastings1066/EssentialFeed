//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 02/10/2024.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    
    func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-given.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client, url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadRequestDataFromURL() {
        // Arrange: GIVEN a client and an sut.
        let url = URL(string: "https://a-given.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        // Act: WHEN sut.load() is invoked.
        sut.load()
        
        // Assert: THEN assert that a URL request was initiated in the client.
        XCTAssertEqual(client.requestedURL, url)
    }
}
