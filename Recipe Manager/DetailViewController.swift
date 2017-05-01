//
//  DetailViewController.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/18/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController  {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    
    var chosenRecipe : Int?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        let iRow = appDelegate.indexRow
        if !(iRow == nil) {
            self.title = appDelegate.recipes[iRow!].recipeName
        }

        NotificationCenter.default.addObserver(
            forName: changedRecipeNotification,
            object: nil,
            queue: nil) { (note : Notification) -> Void in
                self.tableView.reloadData()
        }
        
        
        NotificationCenter.default.post(name: changedRecipeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let iRow = appDelegate.indexRow
        if !(iRow == nil) {
            let recipe = appDelegate.recipes[iRow!]
            return (recipe.Ingredients.count + recipe.Steps.count + 1)
        } else {
            self.title = nil
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainImageCell", for: indexPath) as! MainImageTableViewCell
            let recipe = appDelegate.recipes[appDelegate.indexRow!]
            cell.mainImageRecipe.image = appDelegate.imageStore.image(forKey: "\(recipe.itemKey) main")
            //cell.mainImageRecipe.removeFromSuperview()
            return cell

        } else if indexPath.row < (appDelegate.recipes[appDelegate.indexRow!].Ingredients.count + 1) {
            
            let recipe = appDelegate.recipes[appDelegate.indexRow!]

            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
                cell.textLabel?.font = UIFont(name: "Avenir", size: 25)
                cell.textLabel?.text = recipe.Ingredients[indexPath.row - 1]
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            cell.textLabel?.font = UIFont(name: "System", size: 25)
            cell.textLabel?.text = recipe.Ingredients[indexPath.row - 1]
            return cell
            
        } else {
            
            let recipe = appDelegate.recipes[appDelegate.indexRow!]
            let step = (indexPath.row - (recipe.Ingredients.count + 1))

            if step == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
                cell.textLabel?.font = UIFont(name: "Avenir", size: 25)
                cell.textLabel?.text = recipe.Steps[step]
                return cell
            }

            let image = appDelegate.imageStore.image(forKey: "\(recipe.itemKey) \(recipe.Steps[step])")
            
            if image != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "instructionsCell", for: indexPath) as! InstructionsTableViewCell
                cell.instructionsImage.image = image
                cell.instructionsText.text = recipe.Steps[step]
                cell.instructionsText.sizeToFit()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "instructionTextOnlyCell", for: indexPath) as! InstructionsTableViewCell
                cell.instructionsText.text = recipe.Steps[step]
                cell.instructionsText.sizeToFit()
                return cell
            }
            
           
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}

