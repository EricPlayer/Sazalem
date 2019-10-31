//
//  SettingsViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit

class SettingsViewController : UIViewController {
    
    lazy var subscriptionButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 25
        button.setBackgroundImage(#imageLiteral(resourceName: "button_background"), for: .normal)
        button.setTitle("Жарнаманы өшіру", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSubButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func handleSubButton() {
        present(SubscriptionViewController(), animated: true, completion: nil)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Setting page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = .white
        
        view.addSubview(subscriptionButton)
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            subscriptionButton.setTitle("Жарнаманы өшіру", for: .normal)
        } else {
            subscriptionButton.setTitle("Жазылымды өшіру", for: .normal)
        }

        subscriptionButton.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(-50)
            make.height.equalTo(50)
        }
    }
}
