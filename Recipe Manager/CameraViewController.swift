//
//  CameraViewController.swift
//  Recipe Manager
//
//  Created by Christopher Hight on 4/25/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recipe = appDelegate.recipes[appDelegate.indexRow!]
        imageView.image = appDelegate.imageStore.image(forKey: "\(recipe.itemKey) main")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
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
        let recipe = appDelegate.recipes[appDelegate.indexRow!]
        appDelegate.imageStore.setImage(image, forKey: "\(recipe.itemKey) main")
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
