//
//  LargeImageViewController.swift
//  Camera
//
//  Created by iMac on 11/03/24.
//

import UIKit

class LargeImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:Data!
    var getCurrentIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    tabBarController?.tabBar.isHidden = true
        if let img = image{
        imageView.image = UIImage(data: img)
        }
        navigationController?.navigationItem.hidesBackButton = false
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipe))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipe))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func responseToSwipe(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.left:
                if getCurrentIndex < imageArray.count - 1{
                    getCurrentIndex+=1
                    imageView.image = UIImage(data: imageArray[getCurrentIndex])
                }
                
            case UISwipeGestureRecognizer.Direction.right:
                if getCurrentIndex > 0{
                    getCurrentIndex-=1
                    imageView.image = UIImage(data: imageArray[getCurrentIndex])
                }
                
            default:
                break
            }
        }
    }

}
