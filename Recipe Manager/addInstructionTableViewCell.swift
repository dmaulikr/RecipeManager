//
//  addInstructionTableViewCell.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/29/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class addInstructionTableViewCell: UITableViewCell {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var instructionsText: UITextView!
    @IBOutlet var instructionMiniImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addInstructionButton(_ sender: Any) {
        
        if !(instructionsText.text?.isEmpty)! {
            appDelegate.recipes[appDelegate.indexRow!].Steps.append(instructionsText.text)
            
            if !(instructionMiniImage.image! == #imageLiteral(resourceName: "MainImage")) {
                let recipe = appDelegate.recipes[appDelegate.indexRow!]
                let key = "\(recipe.itemKey) \(instructionsText.text!)"
                appDelegate.imageStore.setImage(instructionMiniImage.image!, forKey: key)
            }

            instructionsText.text = ""
            instructionMiniImage.image = #imageLiteral(resourceName: "MainImage")
            NotificationCenter.default.post(name: changedRecipeNotification, object: nil)
        }
    }

}
