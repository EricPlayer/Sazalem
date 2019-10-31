import XCTest
@testable import SwiftyVK

final class TokenStorageTests: XCTestCase {
    
    func test_getSaved() {
        // Given
        let repository = TokenStorageImpl(serviceKey: "")
        let id = "testId"
        // When
        repository.removeFor(sessionId: id)

        let token = TokenMock()
        
        do {
            try repository.save(token, for: id)
        } catch let error {
            XCTFail("\(error)")
        }
        
        let restoredToken = repository.getFor(sessionId: id) as? TokenMock
        // Then
        XCTAssertEqual(restoredToken?.token, token.token)
    }
    
    func test_getRemoved() {
        // Given
        let repository = TokenStorageImpl(serviceKey: "")
        let id = "testId"
        // When
        repository.removeFor(sessionId: id)
        let restoredToken = repository.getFor(sessionId: id) as? TokenMock
        // Then
        XCTAssertNil(restoredToken?.token)
    }
}
