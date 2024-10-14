//
//  XCTestCase-MeoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by sam hastings on 10/10/2024.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Possible memory leak.", file: file, line: line)
        }
    }
}
