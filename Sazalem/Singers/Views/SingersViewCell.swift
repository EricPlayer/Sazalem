//
//  SingersViewCell.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit

class SingersViewCell : UITableViewCell {
    
    var singerID : Int? {
        didSet {
            loadSingerSongs()
        }
    }
    
    var singerSongsCount : Int? {
        didSet {
            if let count = singerSongsCount {
                detailTextLabel?.text = "\(count) ән"
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 60, y: textLabel!.frame.origin.y, width: frame.width - 110, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 60, y: detailTextLabel!.frame.origin.y, width: frame.width - 110, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .gray
    }
    
    let number : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(number)
        number.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.left).offset(30)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
