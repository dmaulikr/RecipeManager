//
//  ImageStore.swift
//  CameraTest
//
//  Created by Christopher Hight on 4/12/17.
//  Copyright © 2017 Chris Hight. All rights reserved.
//
//  Code assistance provided by The Big Nerd Ranch iOS Programming 6th Edition

import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image : UIImage, forKey key : String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forkey: key)
        
        if let data = UIImageJPEGRepresentation(image, 0.5){
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key : String) -> UIImage? {
        
        if let exisitingImage = cache.object(forKey: key as NSString) {
            return exisitingImage
        }
        
        let url = imageURL(forkey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key : String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forkey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch  let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    func imageURL(forkey key : String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
}
