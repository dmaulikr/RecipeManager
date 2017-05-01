//
//  NewRecipeViewController.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/20/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pickData : [String]?

    @IBOutlet var recipeName: UITextField!
    @IBOutlet var recipeType: UIPickerView!
    @IBOutlet var typeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickData = appDelegate.categories
        recipeType.dataSource = self
        recipeType.delegate = self
        recipeName.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickData!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickData?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeLabel.text = pickData?[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButton(_ sender: Any) {
        
        if !((recipeName.text?.isEmpty)!) {
            appDelegate.recipes.append(Recipe(recipeName.text!, typeLabel.text!))
            let newItemKey = appDelegate.recipes[appDelegate.recipes.count - 1].itemKey
            appDelegate.imageStore.setImage(#imageLiteral(resourceName: "RMPlaceholder"), forKey: "\(newItemKey) main")
            NotificationCenter.default.post(name: addRecipeNotification, object: nil)
        }
    
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
