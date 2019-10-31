@testable import SwiftyVK

final class TokenMock: NSObject, InvalidatableToken {
    
    var token: String?
    var isValid: Bool

    let info: [String: String] = [:]
    
    init(token: String = "testToken", valid: Bool = true) {
        self.token = token
        self.isValid = valid
    }
    
    init?(coder aDecoder: NSCoder) {
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        isValid = aDecoder.decodeObject(forKey: "isValid") as? Bool ?? false
    }
    
    func get() -> String? {
        return token
    }
    
    var onInvalidate: (() -> ())?
    
    func invalidate() {
        onInvalidate?()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
    }
}
