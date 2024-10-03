//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 02/10/2024.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient // create a client property
    
    init(client: HTTPClient) { // inject the client property in the constructor
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
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
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client) // Mock the HTTPClient with a HTTPClientSpy when testing
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadRequestDataFromURL() {
        // Arrange: GIVEN a client and an sut.
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client) // Mock the HTTPClient with a HTTPClientSpy when testing
        
        // Act: WHEN sut.load() is invoked.
        sut.load()
        
        // Assert: THEN assert that a URL request was initiated in the client.
        XCTAssertNotNil(client.requestedURL)
    }
}
