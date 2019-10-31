import Foundation
import XCTest
@testable import SwiftyVK

final class AttemptTests: XCTestCase {
    
    func test_sendTask_giveSuccess_whenSuccessed() {
        // Given
        guard let data = JsonReader.read("response.empty") else {
            return
        }
        
        var response: Response?
        let context = makeContext(callbacks: .init(onFinish: { response = $0 }))
        
        configureTask(in: context.session) { task, handler in
            task.onResume = { handler(data, nil, nil) }
        }
        // When
        context.attempt.main()
        // Then
        XCTAssertNotNil(response?.data)
    }
    
    func test_sendTask_giveErrorResponse_whenFailed() {
        // Given
        var response: Response?
        let context = makeContext(callbacks: .init(onFinish: { response = $0 }))
        
        configureTask(in: context.session) { task, handler in
            task.onResume = { handler( nil, nil, NSError(domain: "", code: 1, userInfo: nil)) }
        }
        // When
        context.attempt.main()
        // Then
        XCTAssertNotNil(response?.error)
    }
    
    func test_sendTask_notGiveResponse_whenCancelled() {
        // Given
        let context = makeContext(callbacks: .init(onFinish: { _ in
                XCTFail("Operation should be cancelled without call completion")
        }))
        let exp = expectation(description: "")
        
        configureTask(in: context.session) { task, handler in
            task.onResume = {
                Thread.sleep(forTimeInterval: 0.5)
                handler(nil, nil, nil)
            }

            task.onCancel = {
                Thread.sleep(forTimeInterval: 1)
                exp.fulfill()
            }
        }
        // When
        OperationQueue().addOperation(context.attempt)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            context.attempt.cancel()
        }
        // Then
        waitForExpectations(timeout: 5)
    }
    
    func test_addObservers_whenSended() {
        // Given
        var addObserverForCountOfBytesReceivedCallCount = 0
        var addObserverForCountOfBytesSentCallCount = 0
        let context = makeContext()
        
        configureTask(in: context.session) { task, handler in
            task.onResume = { handler(nil, nil, nil) }
            
            task.onAddObserver = { _, keyPath, _, _ in
                if keyPath == "countOfBytesReceived" {
                    addObserverForCountOfBytesReceivedCallCount += 1
                } else if keyPath == "countOfBytesSent" {
                    addObserverForCountOfBytesSentCallCount += 1
                } else {
                    XCTFail("Unexpected keyPath: \(keyPath)")
                }
            }
        }
        // When
        context.attempt.main()
        // Then
        XCTAssertEqual(addObserverForCountOfBytesReceivedCallCount, 1)
        XCTAssertEqual(addObserverForCountOfBytesSentCallCount, 1)
    }
    
    func test_removeObservers_whenDeinit() {
        // Given
        var removeObserverForCountOfBytesReceivedCallCount = 0
        var removeObserverForCountOfBytesSentCallCount = 0
        
        var context: (attempt: AttemptImpl, session: URLSessionMock)? = makeContext()
        weak var session = context!.session
        
        configureTask(in: session!) { task, handler in
            task.onResume = {
                context = nil
                handler(nil, nil, nil)
                
            }
            
            task.onRemoveObserver = { _, keyPath in
                if keyPath == "countOfBytesReceived" {
                    removeObserverForCountOfBytesReceivedCallCount += 1
                } else if keyPath == "countOfBytesSent" {
                    removeObserverForCountOfBytesSentCallCount += 1
                } else {
                    XCTFail("Unexpected keyPath: \(keyPath)")
                }
            }
        }
        // When
        context!.attempt.main()
        // Then
        XCTAssertEqual(removeObserverForCountOfBytesReceivedCallCount, 1)
        XCTAssertEqual(removeObserverForCountOfBytesSentCallCount, 1)
    }
    
    func test_observing_whenTaskSentBytes() {
        // Given
        var onSentCallCount = 0
        
        let context = makeContext(callbacks:
            AttemptCallbacks(
                onSent: { sent, total in
                    // Then
                    onSentCallCount += 1
                    XCTAssertEqual(sent, 100)
                    XCTAssertEqual(total, 1000)
                }
            )
        )
        
        configureTask(in: context.session) { task, handler in
            task.countOfBytesSent = 100
            task.countOfBytesExpectedToSend = 1000
            handler(nil, nil, nil)
        }
        // When
        context.attempt.main()
        context.attempt.observeValue(forKeyPath: #keyPath(URLSessionTask.countOfBytesSent), of: nil, change: nil, context: nil)
        // Then
        XCTAssertEqual(onSentCallCount, 1)
    }
    
    func test_observing_whenTaskRecieveBytes() {
        // Given
        var onRecieveCallCount = 0

        let context = makeContext(callbacks:
            AttemptCallbacks(
                onRecive: { recieve, total in
                    // Then
                    onRecieveCallCount += 1
                    XCTAssertEqual(recieve, 100)
                    XCTAssertEqual(total, 1000)
                }
            )
        )
        
        configureTask(in: context.session) { task, handler in
            task.countOfBytesReceived = 100
            task.countOfBytesExpectedToReceive = 1000
            handler(nil, nil, nil)
        }
        // When
        context.attempt.main()
        context.attempt.observeValue(forKeyPath: #keyPath(URLSessionTask.countOfBytesReceived), of: nil, change: nil, context: nil)
        // Then
        XCTAssertEqual(onRecieveCallCount, 1)
    }
    
    func test_observing_whenKeyPathIsNotKnown() {
        // Given
        var observerCallCount = 0
        
        let context = makeContext(callbacks:
            AttemptCallbacks(
                onSent: { sent, total in
                    observerCallCount += 1
                },
                onRecive: { _, _ in
                    observerCallCount += 1
                }
            )
        )
        
        configureTask(in: context.session) { task, handler in
            handler(nil, nil, nil)
        }
        // When
        context.attempt.main()
        context.attempt.observeValue(forKeyPath: #keyPath(URLSessionTask.currentRequest), of: nil, change: nil, context: nil)
        // Then
        XCTAssertEqual(observerCallCount, 0)
    }
}

private var attemptQueue = DispatchQueue.global(qos: .background)

private func makeContext(callbacks: AttemptCallbacks = .default) -> (attempt: AttemptImpl, session: URLSessionMock) {
    let request = URLRequest(url: URL(string: "http://test.com")!)
    let session = URLSessionMock()
    
    let attempt = AttemptImpl(
        request: request,
        session: session,
        callbacks: callbacks
    )
    
    return (attempt, session)
}

private func configureTask(in session: URLSessionMock, configuration: @escaping ((URLSessionTaskMock, @escaping CompletionHandler) -> ())) {
    session.onDataTask = { completionHandler in
        let task = URLSessionTaskMock()
        configuration(task, completionHandler)
        return task
    }
}

private typealias CompletionHandler = (Data?, URLResponse?, Error?) -> ()
