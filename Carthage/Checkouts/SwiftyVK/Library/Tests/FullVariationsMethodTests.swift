import Foundation
import XCTest
@testable import SwiftyVK

final class FullVariationsMethodTests: XCTestCase {
    
    func test_setConfig() {
        // Given
        let originalMethod = Methods.SuccessableFailableProgressableConfigurable(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.configure(with: .default)
        // Then
        XCTAssertTrue(type(of: mutatedMethod) == Methods.SuccessableFailableProgressable.self)
    }
    
    func test_setOnSuccess() {
        // Given
        let originalMethod = Methods.SuccessableFailableProgressableConfigurable(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.onSuccess { _ in }
        // Then
        XCTAssertTrue(type(of: mutatedMethod) == Methods.FailableProgressableConfigurable.self)
    }
    
    func test_setOnError() {
        // Given
        let originalMethod = Methods.SuccessableFailableProgressableConfigurable(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.onError { _ in }
        // Then
        XCTAssertTrue(type(of: mutatedMethod) == Methods.SuccessableProgressableConfigurable.self)
    }
    
    func test_setOnProgress() {
        // Given
        let originalMethod = Methods.SuccessableFailableProgressableConfigurable(Request(type: .url("")))
        // When
        let mutatedMethod = originalMethod.onProgress { _ in }
        // Then
        XCTAssertTrue(type(of: mutatedMethod) == Methods.SuccessableFailableConfigurable.self)
    }
}
