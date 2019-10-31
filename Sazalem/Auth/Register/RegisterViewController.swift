//
//  RegisterViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/26/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController {
    
    /*
    let labelOne: UILabel = {
        let label = UILabel()
        label.text = "Scroll Top"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelTwo: UILabel = {
        let label = UILabel()
        label.text = "Scroll Bottom"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    */
    let scrollView : UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .gray
        
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
    
    lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        return button
    }()
    
    let nameTextField = LoginViewController.createTextField(placeholder: "АТЫ-ЖӨНІҢІЗ")
    let emailTextField = LoginViewController.createTextField(placeholder: "E-MAIL")
    let passwordTextField = LoginViewController.createTextField(placeholder: "ҚҰПИЯСӨЗ")
    let confirmPasswordTextField = LoginViewController.createTextField(placeholder: "ҚҰПИЯСӨЗДІ ҚАЙТАЛАҢЫЗ")
    
    lazy var signUpButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Тіркелу", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func handleClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleRegisterButton() {
        if passwordTextField.text == confirmPasswordTextField.text {
            register()
        } else {
            print("error")
        }
    }
    
    func setupViews() {
        //let screensize: CGRect = UIScreen.main.bounds
        //let screenWidth = screensize.width
        /*
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        
        scrollView.addSubview(labelTwo)
        
        NSLayoutConstraint(item: labelTwo, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        view.addSubview(scrollView)*/
        
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true

        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(15)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        scrollView.addSubview(inputFieldView)
        
        inputFieldView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(30)
            //make.left.equalTo(20)
            //make.right.equalTo(-20)
            make.height.equalTo(315)
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
        
        inputFieldView.addSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }

        inputFieldView.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }

        inputFieldView.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }

        inputFieldView.addSubview(confirmPasswordTextField)
        
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }

        scrollView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(inputFieldView.snp.bottom).offset(15)
            //make.left.equalTo(40)
            //make.right.equalTo(-40)
            make.height.equalTo(50)
        }
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40.0).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40.0).isActive = true
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Register page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
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
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        
        //let contentInsets: UIEdgeInsets = .zero
        
        //self.scrollView.contentInset = contentInsets
        
        //self.scrollView.scrollIndicatorInsets = contentInsets
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
    }

    @objc func keyboardWillShow(aNotification: NSNotification) {
        
        var info = aNotification.userInfo!
        
        let kbSize: CGSize = ((info["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size)!
        
        //print("kbSize = \(kbSize)")
        
        //let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //scrollView.contentInset = contentInsets
        
        //scrollView.scrollIndicatorInsets = contentInsets
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + kbSize.height)
        //scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kbSize.height).isActive = true
        //scrollView.contentSize = CGSize(width: screenWidth, height: 2000)

    }

}
