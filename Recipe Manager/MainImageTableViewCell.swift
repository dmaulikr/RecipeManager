//
//  MainImageTableViewCell.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/26/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class MainImageTableViewCell: UITableViewCell {

    @IBOutlet var mainImageRecipe: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
