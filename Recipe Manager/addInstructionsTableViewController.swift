//
//  addInstructionsTableViewController.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/29/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class addInstructionsTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        //makes tableview fit in tabbar parent view
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        
        //setup to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addInstructionsTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            forName: changedRecipeNotification,
            object: nil,
            queue: nil) { (note : Notification) -> Void in
                self.tableView.reloadData()
        }
        
        NotificationCenter.default.post(name: changedRecipeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return (recipe.Steps.count + 1)
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipe = appDelegate.recipes[appDelegate.indexRow!]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addInstruction", for: indexPath) as! addInstructionTableViewCell
            cell.instructionsText.layer.borderWidth = CGFloat(0.4)
            cell.instructionsText.layer.borderColor = UIColor.lightGray.cgColor
            cell.instructionsText.layer.cornerRadius = CGFloat(6)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = recipe.Steps[(indexPath.row - 1)]
            return cell
        } else {
            
            let image = appDelegate.imageStore.image(forKey: "\(recipe.itemKey) \(recipe.Steps[indexPath.row-1])")
            if image != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addedInstructionsCell", for: indexPath) as! addedInstructionsTableViewCell
                cell.addedInstructionsImage.image = image
                cell.addedInstructionsText.text = recipe.Steps[(indexPath.row - 1)]
                cell.addedInstructionsText.sizeToFit()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "textOnlyCell", for: indexPath) as! addedInstructionsTableViewCell
                cell.addedInstructionsText.text = recipe.Steps[(indexPath.row - 1)]
                cell.addedInstructionsText.sizeToFit()
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
    
    // MARK: - Camera imagePicker

    @IBAction func addImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //sets mini image in the instructions
        let cellindexPath = NSIndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: cellindexPath as IndexPath) as! addInstructionTableViewCell
        cell.instructionMiniImage.image = image
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Deleting Cells

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        //first two lines shou
        return indexPath.row > 1
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let recipe = appDelegate.recipes[appDelegate.indexRow!]
            appDelegate.imageStore.deleteImage(forKey: "\(recipe.itemKey) \(recipe.Steps[indexPath.row-1])")
            appDelegate.recipes[appDelegate.indexRow!].Steps.remove(at: (indexPath.row-1))
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }



}
