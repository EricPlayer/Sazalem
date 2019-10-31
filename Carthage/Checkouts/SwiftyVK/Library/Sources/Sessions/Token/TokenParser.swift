import Foundation

protocol TokenParser: class {
    func parse(tokenInfo: String) -> (token: String, expires: TimeInterval, info: [String: String])?
}

final class TokenParserImpl: TokenParser {
    
    func parse(tokenInfo: String) -> (token: String, expires: TimeInterval, info: [String: String])? {
        var token: String?
        var expires: TimeInterval?
        var info = [String: String]()
        
        let components = tokenInfo.components(separatedBy: "&")
        
        components.forEach { component in
            let componentPair = component.components(separatedBy: "=")
            
            if let key = componentPair.first, let value = componentPair.last {
                
                switch key {
                case "access_token":
                    token = value
                case "expires_in":
                    expires = TimeInterval(value)
                default:
                    break
                }
                
                info[key] = value
            }
        }
        
        guard let unwrappedToken = token, let unwrappedExpires = expires else {
            return nil
        }
        
        return (unwrappedToken, unwrappedExpires, info)
    }
}
