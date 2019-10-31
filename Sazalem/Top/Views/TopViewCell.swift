//
//  TopViewCell.swift
//  SazAlem
//
//  Created by Myrzamurat on 04/24/19.
//  Copyright © 2019 Gani Myrzamurat. All rights reserved.
//

import UIKit

class TopViewCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 85, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .gray
        
    }
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "temp")
        
        return imageView
    }()
    
    let timeLine : UILabel = {
        let label = UILabel()
        
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        addSubview(timeLine)
        timeLine.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
