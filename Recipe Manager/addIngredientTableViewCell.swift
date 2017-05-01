//
//  addIngredientTableViewCell.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/27/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class addIngredientTableViewCell: UITableViewCell {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var newIngredientText: UITextField!
    @IBOutlet var quantityText: UITextField!
    @IBOutlet var measurementText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButton(_ sender: Any) {
        
        let ingredient =  (quantityText.text!)+" "+(measurementText.text!)+" "+(newIngredientText.text!)
        if !(newIngredientText.text?.isEmpty)! {
            appDelegate.recipes[appDelegate.indexRow!].Ingredients.append("• " + ingredient)
            quantityText.text = ""
            measurementText.text = ""
            newIngredientText.text = ""
            NotificationCenter.default.post(name: changedRecipeNotification, object: nil)
        }
        
    }
}
