//
//  FavouriteViewCell.swift
//  Sazalem
//
//  Created by Esset Murat on 1/28/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit

class FavouriteViewCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
