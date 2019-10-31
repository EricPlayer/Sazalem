//
//  LoginViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/15/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    //var activeField: UITextField?
    
    let scrollView : UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .green
        
        return view
        
    }()
    
    let inputFieldView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let logoImage : UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = #imageLiteral(resourceName: "logo")
        
        return imageView
    }()
    
    let emailTextField = createTextField(placeholder: "E-MAIL")
    let passwordTextField = createTextField(placeholder: "ҚҰПИЯСӨЗ")
    
    let forgotPasswordButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("ҚҰПИЯ СӨЗДІ УМЫТТЫҢЫЗБА?", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Кіру", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    let orLoginWithLabel : UILabel = {
        let label = UILabel()
        
        label.text = "немесе"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var vkButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "vk"), for: .normal)
        button.tintColor = .white
        button.tag = 0
        button.addTarget(self, action: #selector(handleSocailLogin(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var facebookButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        button.tintColor = .white
        button.tag = 1
        button.addTarget(self, action: #selector(handleSocailLogin(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var googlePlusButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "google-plus"), for: .normal)
        button.tintColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(handleSocailLogin(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var registerButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("ТІРКЕЛУ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func handleRegisterButton() {
        present(RegisterViewController(), animated: true, completion: nil)
    }
    
    @objc
    func handleLoginButton() {
        emailLogin()
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true

        scrollView.addSubview(inputFieldView)
        inputFieldView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-40)
            //make.left.equalTo(20)
            //make.right.equalTo(-20)
            make.height.equalTo(200)
        }
        inputFieldView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        inputFieldView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true

        
        scrollView.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputFieldView.snp.top).offset(-35)
            make.width.equalTo(62)
            make.height.equalTo(70)
        }
        
        inputFieldView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        inputFieldView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        inputFieldView.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-20)
        }
        
        scrollView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(inputFieldView.snp.bottom).offset(20)
            //make.left.equalTo(55)
            //make.right.equalTo(-55)
            make.height.equalTo(50)
        }
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55.0).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -55.0).isActive = true

        
        scrollView.addSubview(orLoginWithLabel)
        orLoginWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.equalTo(55)
            make.right.equalTo(-55)
        }
        orLoginWithLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55.0).isActive = true
        orLoginWithLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -55.0).isActive = true
        

        scrollView.addSubview(vkButton)
        vkButton.snp.makeConstraints { (make) in
            make.top.equalTo(orLoginWithLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        scrollView.addSubview(facebookButton)
        facebookButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(vkButton)
            make.right.equalTo(vkButton.snp.left).offset(-25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        scrollView.addSubview(googlePlusButton)
        googlePlusButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(vkButton)
            make.left.equalTo(vkButton.snp.right).offset(25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        scrollView.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(vkButton.snp.bottom).offset(20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-20)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Login page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        //1  Add this observers to observe keyboard shown and hidden events
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackgroundGradient()
        setupViews()
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
    }
    
    
    //3  ViewController activeField is an object of UITextField which will be used to manage and resign current active textField
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeField = nil
        
    }*/
    
    // Called when the UIKeyboardWillHide is sent
    
    //4  This method is called from selector. So it requires @objc keyword and this method will adjust your scrollView (here myScrollView  ?)  and textFields to show as original.
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        //let contentInsets: UIEdgeInsets = .zero
        
        //self.scrollView.contentInset = contentInsets
        
        //self.scrollView.scrollIndicatorInsets = contentInsets
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)

    }
    
    // Called when the UIKeyboardWillShow is sent
    
    //5
    //This method will adjust your scrollView and will show textFields above the keyboard.
    @objc func keyboardWillShow(aNotification: NSNotification) {
        
        var info = aNotification.userInfo!
        
        let kbSize: CGSize = ((info["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size)!
        
        print("kbSize = \(kbSize)")
        
        //let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //scrollView.contentInset = contentInsets
        
        //scrollView.scrollIndicatorInsets = contentInsets
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + kbSize.height)

        /*
        var aRect: CGRect = self.view.frame
        
        aRect.size.height -= kbSize.height
        
        if !aRect.contains(activeField!.frame.origin) {
            
            self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            
        }*/
        
    }
}
