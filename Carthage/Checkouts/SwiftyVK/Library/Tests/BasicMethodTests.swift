import Foundation
import XCTest
@testable import SwiftyVK

final class BasicMethodTests: XCTestCase {
    
    func test_setConfig() {
        // Given
        let originalMethod = Methods.Basic(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.withConfig(Config(attemptsMaxLimit: .limited(1000)))
        // Then
        XCTAssertEqual(mutatedMethod.toRequest().config.attemptsMaxLimit.count, 1000)
    }
    
    func test_setOnSuccess() {
        // Given
        let originalMethod = Methods.Basic(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.withOnSuccess { _ in }
        // Then
        XCTAssertNotNil(mutatedMethod.toRequest().callbacks.onSuccess)
    }
    
    func test_setOnError() {
        // Given
        let originalMethod = Methods.Basic(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.withOnError { _ in }
        // Then
        XCTAssertNotNil(mutatedMethod.toRequest().callbacks.onError)
    }
    
    func test_setOnProgress() {
        // Given
        let originalMethod = Methods.Basic(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.withOnProgress { _ in }
        // Then
        XCTAssertNotNil(mutatedMethod.toRequest().callbacks.onProgress)
    }
    
    func test_setNext() {
        // Given
        let originalMethod = Methods.Basic(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod
            .chain { _ in Request(type: .url("")).toMethod() }
            .chain { _ in Request(type: .url("")).toMethod() }
            .chain { _ in Request(type: .url("")).toMethod() }

        do {
            let lastRequest = try mutatedMethod.toRequest().next(with: Data())?.next(with: Data())?.next(with: Data())
            // Then
            XCTAssertNotNil(lastRequest)
        } catch let error {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
