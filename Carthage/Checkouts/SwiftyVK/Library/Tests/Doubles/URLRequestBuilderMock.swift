@testable import SwiftyVK

final class URLRequestBuilderMock: UrlRequestBuilder {
    
    var onBuild: (() throws -> URLRequest)?
    
    func build(type: RequestType, config: Config, capthca: Captcha?, token: Token?) throws -> URLRequest {
        return try onBuild?() ?? URLRequest(url: URL(string: "http://te.st")!)
    }
    
}
