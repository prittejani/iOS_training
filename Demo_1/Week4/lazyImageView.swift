//
//  lazyImageView.swift
//  Webservices
//
//  Created by iMac on 18/03/24.
//

import Foundation
import UIKit

class LazyImageView : UIImageView
{
    
    private let imageCache = NSCache<AnyObject,UIImage>()
    
    func loadImage(fromURL imageURL:URL, placeHolderImage:String){
        self.image = UIImage(named: placeHolderImage)
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject){
            debugPrint("from cache...")
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            if let imageData = try? Data(contentsOf: imageURL){
                if let image = UIImage(data:  imageData){
                    DispatchQueue.main.async {
                        debugPrint("from server...")
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
