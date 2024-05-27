//
//  XCTestCase+.swift
//  TCA_exampleTests
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

import XCTest

extension XCTestCase {
    func wait(interval: TimeInterval = 0.3, completion: @escaping (() -> Void)) {
        let expectation = expectation(description: "")

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            expectation.fulfill()
        }

        waitForExpectations(timeout: interval + 0.1) // add 0.1 for sure asyn after called
    }
}
