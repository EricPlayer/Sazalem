//
//  AddCommentViewController.swift
//  Sazalem
//
//  Created by Esset Murat on 1/31/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddCommentViewController : UIViewController {
    var songID : Int?
    
    let commentLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Сіздің пікіріңіз"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        
        return label
    }()
    
    let commentTextView : UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    let underlineView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray
        
        return view
    }()
    
    lazy var addCommentButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("ПІКІР ҚОСУ", for: .normal)
        button.setBackgroundImage(UIImage(named: "button_background")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddCommentButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupViews() {
        view.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        view.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentTextView).offset(3)
            make.bottom.equalTo(commentTextView.snp.top)
        }
        
        view.addSubview(underlineView)
        underlineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(commentTextView)
            make.height.equalTo(1)
        }
        
        view.addSubview(addCommentButton)
        addCommentButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc
    func handleAddCommentButton() {
        if let id = songID, UserDefaults.standard.integer(forKey: "user_id") != 0, let text = commentTextView.text {
            let user_id = UserDefaults.standard.integer(forKey: "user_id")
            
            let body : Parameters = [
                "song_id" : id,
                "user_id" : user_id,
                "comment_text" : text,
                "user_url" : "iOs"
            ]
            
            Alamofire.request("http://sazalem.com/ajaxfile/api/ko_add_comment_v2.php", method: .post, parameters: body).responseJSON { (response) in
                indicator.showSuccess(withStatus: "Пікіріңіз қосылды")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
}
