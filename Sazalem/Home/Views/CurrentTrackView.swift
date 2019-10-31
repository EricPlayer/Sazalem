//
//  CurrentTrackView.swift
//  SazAlem
//
//  Created by Esset Murat on 1/5/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit

class CurrentTrackView : UIView {
    let imageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = #imageLiteral(resourceName: "sound-bars")
        
        return imageView
    }()
    
    let singerName : UILabel = {
        let label = UILabel()
        
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    let songName : UILabel = {
        let label = UILabel()
        
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    let timeLine : UILabel = {
        let label = UILabel()
        
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        addSubview(singerName)
        singerName.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(30)
            make.centerY.equalToSuperview().offset(-10)
            make.right.equalTo(-50)
        }
        
        addSubview(songName)
        songName.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(30)
            make.centerY.equalToSuperview().offset(10)
            make.right.equalTo(-50)
        }
        
        addSubview(timeLine)
        timeLine.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
