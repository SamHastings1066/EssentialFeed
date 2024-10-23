//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 23/10/2024.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}


func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
