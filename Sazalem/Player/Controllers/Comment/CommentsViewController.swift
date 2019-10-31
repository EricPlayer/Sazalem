//
//  CommentsViewController.swift
//  Sazalem
//
//  Created by Esset Murat on 1/31/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit

class CommentsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellID = "commentCellID"
    var songID : Int?
    var pageComment = 0
    var comments = [Comment]()
    var isLoad = true
    
    /*

    var comments : [Comment]? {
        didSet {
            tableView.reloadData()
        }
    }
    */
    lazy var tableView : UITableView = {
        let tb = UITableView()
        
        tb.delegate = self
        tb.dataSource = self
        tb.tableFooterView = UIView()
        
        return tb
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
        loadComments(pageComment : pageComment, isLoad: isLoad)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc
    func handleAddCommentButton() {
        let addCommentViewController = AddCommentViewController()
        
        addCommentViewController.songID = self.songID
        
        navigationController?.pushViewController(addCommentViewController, animated: true)
    }
    
    func setupViews() {
        view.addSubview(addCommentButton)
        addCommentButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(addCommentButton.snp.top)
        }
    }
    
    @objc
    func handleCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        navigationItem.title = "Пікірлер"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(handleCloseButton))
        
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        setupViews()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CommentViewCell
        
        if indexPath.row == (comments.count) - 1 && isLoad {
            loadComments(pageComment: pageComment, isLoad:isLoad)
        }

        cell.authorLabel.text = comments[indexPath.row].author
        cell.commentLabel.text = comments[indexPath.row].comment_text
        
        if let date = comments[indexPath.row].created {
            cell.timeLabel.text = date.timeAgo(date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
