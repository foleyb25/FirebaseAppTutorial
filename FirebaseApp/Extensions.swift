//
//  Extensions.swift
//  FirebaseApp
//
//  Created by Brian Foley on 5/17/20.
//  Copyright © 2020 Brian Foley. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURL(urlString: String) {
        
        
        self.image = nil 
        //check cache for images first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // then start new download
        let url = URL(string: urlString)
       URLSession.shared.dataTask(with: url!, completionHandler:  { (data, response, error) in
           if error != nil {
               print(error!)
               return
           }
           
           DispatchQueue.main.async {
            
            if let downloadedImage = UIImage(data: data!) {
            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                self.image = downloadedImage
            }
            
           }
        }).resume()
    }
}
