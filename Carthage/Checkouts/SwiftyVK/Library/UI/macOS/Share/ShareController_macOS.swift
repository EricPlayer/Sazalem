import Cocoa

@available(iOS 8.0, macOS 10.11, *)
final class ShareControllerMacOS: NSViewController, ShareController, NSTextViewDelegate {
    @IBOutlet private weak var textViewContainer: NSView?
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var doneButton: NSButton?
    @IBOutlet private weak var doneActivity: NSProgressIndicator?
    @IBOutlet private weak var buttonsView: NSView?
    @IBOutlet private weak var linkTitleLabel: NSTextField?
    @IBOutlet private weak var linkAdressLabel: NSTextField?
    @IBOutlet private weak var progressIndicator: NSProgressIndicator?
    @IBOutlet private weak var placeholderView: ColoredBackgroundViewMacOS?
    @IBOutlet private weak var noConnectionLabel: NSTextField?
    @IBOutlet private weak var imagesCollectionView: ShareImageCollectionViewMacOS?
    @IBOutlet private weak var imagesHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var tlinkHeightConstraint: NSLayoutConstraint?
    private var textView: NSTextView?
    
    private var context: ShareContext = ShareContext()
    private var onPost: ((ShareContext) -> ())?

    var onDismiss: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton?.alphaValue = 0
        noConnectionLabel?.alphaValue = 0
        placeholderView?.alphaValue = 0
        progressIndicator?.startAnimation(nil)
        buttonsView?.wantsLayer = true

        buttonsView?.layer?.backgroundColor = NSColor(
            calibratedRed: 0.314,
            green: 0.448,
            blue: 0.6,
            alpha: 1
            ).cgColor
        
        setUpTextView()
        imagesCollectionView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpTextView() {
        textView = DynamicTextView()
        
        guard let textView = textView, let textViewContainer = textViewContainer else { return }
        
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = NSFont.systemFont(ofSize: 16)
        textView.usesRuler = false
        textView.isRichText = false
        textView.textContainerInset = .zero
        textView.textContainer?.lineFragmentPadding = 0
        
        textViewContainer.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: textViewContainer.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: textViewContainer.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: textViewContainer.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: textViewContainer.bottomAnchor).isActive = true
        
        textViewHeightConstraint?.isActive = false
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        onDismiss?()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        imagesHeightConstraint?.constant = context.images.isEmpty ? 0 : 135
        tlinkHeightConstraint?.constant = context.link != nil ? 58 : 0
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let preferencesController = segue.destinationController as? SharePreferencesControllerMacOS {
            preferencesController.set(preferences: context.preferences)
        }
    }
    
    func share(_ context: ShareContext, onPost: @escaping (ShareContext) -> ()) {
        self.context = context
        self.onPost = onPost
        
        updateView()
    }
    
    private func updateView() {
        DispatchQueue.anywayOnMain {
            textView?.string = context.message ?? ""
            view.window?.makeFirstResponder(textView)
            imagesCollectionView?.set(images: context.images)
            linkTitleLabel?.stringValue = context.link?.title ?? ""
            linkAdressLabel?.stringValue = context.link?.url.absoluteString ?? ""
        }
        
        showPlaceholder(false)
        updateSendButton()
    }

    func showPlaceholder() {
        showPlaceholder(true)
    }
    
    private func showPlaceholder(_ enable: Bool) {
        enablePostButton(!enable)
        
        DispatchQueue.anywayOnMain {
            self.placeholderView?.animator().alphaValue = enable ? 1 : 0
        }
    }
    
    func enablePostButton(_ enable: Bool) {
        DispatchQueue.anywayOnMain {
            if enable {
                doneButton?.animator().isEnabled = true
                doneButton?.animator().alphaValue = 1
                doneActivity?.animator().stopAnimation(nil)
            }
            else {
                doneButton?.animator().isEnabled = false
                doneButton?.animator().alphaValue = 0
                doneActivity?.animator().startAnimation(nil)
            }
        }
    }
    
    func showError(title: String, message: String, buttontext: String) {
        DispatchQueue.anywayOnMain {
            guard let window = view.window else { return }
            let alert = NSAlert()
            alert.messageText = message
            alert.addButton(withTitle: buttontext)
            alert.alertStyle = .warning
            alert.beginSheetModal(for: window, completionHandler: nil)
        }
    }
    
    func showWaitForConnection() {
        DispatchQueue.anywayOnMain {
            self.noConnectionLabel?.animator().alphaValue = 1
        }
    }
    
    func close() {
        DispatchQueue.anywayOnMain {
            self.dismiss(self)
        }
    }
    
    private func updateSendButton() {
        DispatchQueue.anywayOnMain {
            doneButton?.isEnabled = textView?.string.isEmpty == false || context.hasAttachments
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let strongSelf = self else { return }
            self?.onPost?(strongSelf.context)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        close()
    }

    @objc
    func controlTextDidChange(_ notification: Notification) {
        guard let field = notification.object as? NSTextField else { return }
        context.message = field.stringValue
        updateSendButton()
    }
    
    func textDidChange(_ notification: Notification) {
        guard let field = notification.object as? NSTextField else { return }
        context.message = field.stringValue
        updateSendButton()
    }
}
