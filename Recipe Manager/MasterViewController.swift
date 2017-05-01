//
//  MasterViewController.swift
//  mdetail
//
//  Created by Christopher Hight on 4/20/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes"
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        NotificationCenter.default.addObserver(
            forName: addRecipeNotification,
            object: nil,
            queue: nil) { (note : Notification) -> Void in
                    self.tableView.reloadData()
        }
        
        
        NotificationCenter.default.post(name: addRecipeNotification, object: nil)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let cellRecipe = appDelegate.recipes[indexPath.row]
        cell.textLabel?.text = cellRecipe.recipeName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let recipe = appDelegate.recipes[indexPath.row]
            appDelegate.imageStore.deleteImage(forKey: "\(recipe.itemKey) main")
            for step in recipe.Steps {
                appDelegate.imageStore.deleteImage(forKey: "\(recipe.itemKey) \(step)")
            }
            appDelegate.recipes.remove(at: indexPath.row)
            appDelegate.indexRow = nil
            NotificationCenter.default.post(name: changedRecipeNotification, object: nil)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
  
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                appDelegate.indexRow = indexPath.row
            }
        }
    }
    
}

