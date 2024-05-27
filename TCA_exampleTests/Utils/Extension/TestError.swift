//
//  TestError.swift
//  TCA_exampleTests
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

@testable import TCA_example
import Foundation

struct TestError: APIError {
    static let message = "Test error message"

    var errorDescription: String? {
        return NSLocalizedString(TestError.message,
                                 value: "",
                                 comment: "")
    }
}
