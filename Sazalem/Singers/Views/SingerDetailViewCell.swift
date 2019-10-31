//
//  SingerDetailViewCell.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit

class SingerDetailViewCell : UITableViewCell {
    var id : Int?
    var index : Int?
    var isPlaying = false
    var isPaused = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 72, y: textLabel!.frame.origin.y, width: frame.width - 120, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 72, y: detailTextLabel!.frame.origin.y, width: frame.width -  120, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .gray
    }
    
    lazy var playButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        return button
    }()
    
    let timeLine : UILabel = {
        let label = UILabel()
        
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(32)
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
