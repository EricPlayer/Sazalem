//
//  CommentViewCell.swift
//  Sazalem
//
//  Created by Esset Murat on 1/31/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit

class CommentViewCell : UITableViewCell {
    let authorLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Әлия Әбікен"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let commentLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Компания «ЛюксМонт-М» сделал отличный ремонт нашего офиса в Бизнес Центре Линкор. Компания «ЛюксМонт-М» сделал отличный ремонт нашего офиса в Бизнес Центре Линкор."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        
        label.text = "5 минут назад"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .right
        
        return label
    }()
    
    func setupViews() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(timeLabel.snp.left).offset(-10)
        }
        
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
