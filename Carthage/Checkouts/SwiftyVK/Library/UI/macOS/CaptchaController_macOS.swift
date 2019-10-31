import Cocoa

final class CaptchaControllerMacOS: NSViewController, NSTextFieldDelegate, CaptchaController {
    
    @IBOutlet private weak var imageView: NSImageView?
    @IBOutlet private weak var textField: NSTextField?
    @IBOutlet private weak var preloader: NSProgressIndicator?
    @IBOutlet private weak var closeButton: NSButton?
    private var onResult: ((String) -> ())?
    var onDismiss: (() -> ())?
   
    var isDisplayed: Bool {
        return DispatchQueue.anywayOnMain {
            isViewLoaded && view.window != nil
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        textField?.delegate = self
        
        textField?.wantsLayer = true
        textField?.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.1).cgColor
        textField?.layer?.cornerRadius = 5
        textField?.layer?.masksToBounds = true
        textField?.layer?.borderWidth = 1
        textField?.layer?.borderColor = NSColor.lightGray.cgColor
        
        imageView?.wantsLayer = true
        imageView?.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.1).cgColor
        imageView?.layer?.cornerRadius = 10
        imageView?.layer?.masksToBounds = true
        imageView?.layer?.borderWidth = 1
        imageView?.layer?.borderColor = NSColor.lightGray.cgColor
        
        closeButton?.wantsLayer = true
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        onDismiss?()
    }
    
    func prepareForPresent() {
        DispatchQueue.main.async {
            self.imageView?.image = nil
            self.preloader?.startAnimation(nil)
        }
    }
    
    func present(imageData: Data, onResult: @escaping (String) -> ()) {
        DispatchQueue.main.sync {
            imageView?.image = NSImage(data: imageData)
            textField?.stringValue = ""
            textField?.becomeFirstResponder()
            preloader?.stopAnimation(nil)
        }
        
        self.onResult = onResult
    }
    
    @IBAction func dismissByButtonTap(_ sender: Any) {
        dismiss(nil)
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(nil)
        }
    }
    
    @objc
    func controlTextDidEndEditing(_ obj: Notification) {
        guard
            imageView?.image != nil,
            let result = textField?.stringValue,
            !result.isEmpty
            else {
                return
        }
        
        onResult?(result)
    }
}
