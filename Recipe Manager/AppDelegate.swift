//
//  AppDelegate.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/18/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit
import CoreData

struct Recipe {
    
    var recipeName : String
    var recipeType : String
    var Ingredients : [String]
    var Steps : [String]
    let itemKey : String
    
    init(_ recipeName: String, _ recipeType: String) {
        //init all vars
        self.recipeName = recipeName
        self.recipeType = recipeType
        self.Ingredients = ["Ingredients"]
        self.Steps = ["Instructions"]
        self.itemKey = UUID().uuidString
        
    }
    
    init(name recipeName: String, type recipeType: String, ingred ingredients : [String], steps Instructions : [String], key itemKey : String){
        self.recipeName = recipeName
        self.recipeType = recipeType
        self.Ingredients = ingredients
        self.Steps = Instructions
        self.itemKey = itemKey
    }
}

let addRecipeNotification = Notification.Name("recipeNotification")
let changedRecipeNotification = Notification.Name("changedRecipeNotification")


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var imageStore = ImageStore()
    var indexRow : Int?
    var recipes : [Recipe] = []
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drinks", "Side Dishes", "Snacks", "Soups"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let archiveName = sandboxArchivePath()

        if FileManager.default.fileExists(atPath: archiveName){
            
            loadSandBoxData(archiveName)
            
        } else {
            //jimmy rigging adding some data back into bundle for shipment
            let uuidJG = "739D07BE-ABB4-44F7-9677-3E4D5E3E1158 "
            let keys = ["Add ice to the glass",
                        "Add the 1 part of Jameson to the glass",
                        "Add the 2 parts ginger ale.  Now, drink!",
                        "main",
                        "Roll the lime, cut it in half, cut the half into thirds"]
            let data = NSDataAsset(name: "GEHMain")
            let url = imageStore.imageURL(forkey: "5C83AEE3-D905-44B1-8E1D-798AABE5EA01 main")
            let _ = try? data?.data.write(to: url, options: [.atomic])
            
            for key in keys {
                let urlKey = uuidJG + key
                let data = NSDataAsset(name: urlKey)
                let url = imageStore.imageURL(forkey: urlKey)
                let _ = try? data?.data.write(to: url, options: [.atomic])
            }
        
            let path = Bundle.main.path(forResource: "recipeManager", ofType: "plist")
            loadSandBoxData(path!)
            
        }
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self

        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        controller.managedObjectContext = self.persistentContainer.viewContext
        return true
    }
    
    func sandboxArchivePath() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        return dir.appendingPathComponent("recipeManager.plist")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //creates an array of dictionaries. each dictionary is a recipe with appropriate sections
        let archiveName = sandboxArchivePath()
        NSLog("\(archiveName)")
        let recipesToStore : NSMutableArray = []
        
        for recipe in recipes {
            let tempIngredList : NSMutableArray = []
            let tempInstrList : NSMutableArray = []
            
            for ingred in recipe.Ingredients {
                tempIngredList.add(ingred as NSString)
            }
            
            for step in recipe.Steps {
                tempInstrList.add(step as NSString)
            }
            
            let recipeDict : NSDictionary = ["recipeName" : recipe.recipeName as NSString,
                                             "recipeType" : recipe.recipeType as NSString,
                                             "Ingredients" : tempIngredList,
                                             "steps" : tempInstrList,
                                             "itemKey" : recipe.itemKey as NSString]
            recipesToStore.add(recipeDict)
        }
        recipesToStore.write(toFile: archiveName, atomically: true)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Recipe_Manager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadSandBoxData(_ archivePath : String) {
        
        let recipeArray = NSMutableArray(contentsOfFile: archivePath) as! [[String : AnyObject]]
        var tempRecipes : [Recipe] = []
        
        for newRecipe in recipeArray {
            
            let savedIngred =  newRecipe["Ingredients"] as! NSArray
            var tempIngredArray : [String] = []
            for ingred in savedIngred {
                tempIngredArray.append(ingred as! String)
            }
            
            let savedSteps = newRecipe["steps"] as! NSArray
            var tempStepsArray : [String] = []
            for step in savedSteps {
                tempStepsArray.append(step as! String)
            }
            
            tempRecipes.append(Recipe(name: newRecipe["recipeName"] as! String,
                                      type: newRecipe["recipeType"] as! String,
                                      ingred: tempIngredArray,
                                      steps: tempStepsArray,
                                      key: newRecipe["itemKey"] as! String))
        }
        self.recipes = tempRecipes
    }

}

