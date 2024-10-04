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
    
    func test_load_deliversErrorOnClientError() {
        // Arrange: GIVEN the sut and its HTTP client
        let (sut, client) = makeSUT()
        
        // Act: WHEN we tell the sut to load; and WHEN we we complete the client request with an Error
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) } // equivalent to "error in capturedError = error"
        
        let clientError = NSError(domain: "Test", code: 0)
        client.completions[0](clientError)
        
        // Assert: THEN we expect the captured load error to be a connectivity error.
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        var completions = [(Error) -> Void]()
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
    }
}
