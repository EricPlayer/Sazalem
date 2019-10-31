import Foundation

protocol CaptchaPresenter {
    func present(rawCaptchaUrl: String, dismissOnFinish: Bool) throws -> String
    func dismiss()
}

final class CaptchaPresenterImpl: CaptchaPresenter {
    
    private let uiSyncQueue: DispatchQueue
    private weak var controllerMaker: CaptchaControllerMaker?
    private weak var currentController: CaptchaController?
    
    private var displayedController: CaptchaController? {
        return currentController?.isDisplayed == true ? currentController : nil
    }
    
    private let timeout: TimeInterval
    private let urlSession: VKURLSession
    
    init(
        uiSyncQueue: DispatchQueue,
        controllerMaker: CaptchaControllerMaker,
        timeout: TimeInterval,
        urlSession: VKURLSession
        ) {
        self.uiSyncQueue = uiSyncQueue
        self.controllerMaker = controllerMaker
        self.timeout = timeout
        self.urlSession = urlSession
    }
    
    func present(rawCaptchaUrl: String, dismissOnFinish: Bool) throws -> String {
        guard let controllerMaker = controllerMaker else { throw VKError.weakObjectWasDeallocated }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        return try uiSyncQueue.sync {
            var result: String?
            var dismissed = false
            
            let controller = displayedController ?? controllerMaker.captchaController {
                dismissed = true
                semaphore.signal()
            }
            
            currentController = controller
            
            controller.prepareForPresent()
            
            let imageData = try downloadCaptchaImageData(rawUrl: rawCaptchaUrl)
            
            controller.present(
                imageData: imageData,
                onResult: { [weak currentController] givenResult in
                    result = givenResult
                    
                    if dismissOnFinish {
                        currentController?.dismiss()
                    }
                    else {
                        semaphore.signal()
                    }
                }
            )
            
            switch semaphore.wait(timeout: .now() + timeout) {
            case .timedOut:
                throw VKError.captchaPresenterTimedOut
            case .success:
                break
            }
            
            guard !dismissed else {
                throw VKError.captchaWasDismissed
            }
            
            guard let unwrappedResult = result else {
                throw VKError.captchaResultIsNil
            }
            
            return unwrappedResult
        }
    }
    
    func dismiss() {
        currentController?.dismiss()
    }
    
    private func downloadCaptchaImageData(rawUrl: String) throws -> Data {
        guard let url = URL(string: rawUrl) else {
            throw VKError.cantMakeCapthaImageUrl(rawUrl)
        }
        
        let result = urlSession.synchronousDataTaskWithURL(url: url)
        
        if let error = result.error {
            throw VKError.cantLoadCaptchaImage(error)
        }
        else if let data = result.data {
            return data
        }
        
        throw VKError.cantLoadCaptchaImageWithUnknownReason
    }
}
