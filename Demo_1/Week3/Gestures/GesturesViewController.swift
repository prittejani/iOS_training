//
//  GesturesViewController.swift
//  Gestures
//
//  Created by iMac on 04/03/24.
//

import UIKit

class GesturesViewController: UIViewController {

    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var lblGesture: UILabel!
    
    @IBOutlet weak var lblInfo: UILabel!
    var tag:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
                                        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
                                       
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
                                          
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upSwipe(_:)))
                                                
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(downSwipe(_:)))
                                            
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        
                                                
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
       
        
        switch tag {
        case 1:
            itemView.addGestureRecognizer(tapGesture)
            doubleTapGesture.numberOfTapsRequired = 2
            itemView.addGestureRecognizer(doubleTapGesture)
            longPressGesture.minimumPressDuration = 1.0
            itemView.addGestureRecognizer(longPressGesture)
            break
        case 2:
            leftSwipe.direction = .left
            itemView.addGestureRecognizer(leftSwipe)
            rightSwipe.direction = .right
            itemView.addGestureRecognizer(rightSwipe)
            upSwipe.direction = .up
            itemView.addGestureRecognizer(upSwipe)
            downSwipe.direction = .down
            itemView.addGestureRecognizer(downSwipe)
            break
        case 3:
            itemView.addGestureRecognizer(rotateGesture)
            break
        case 4:
            itemView.addGestureRecognizer(pinchGesture)
            break
        case 5:
            itemView.addGestureRecognizer(panGesture)
            break
        default:
            break
        }
    }
    @objc func tapGesture(_ sender: UITapGestureRecognizer){
        lblGesture.text = "Tapped"
        lblInfo.isHidden = true
    }
    
    @objc func doubleTap(_ sender: UITapGestureRecognizer){
        lblGesture.text = "DoubleTapped"
        lblInfo.isHidden = true
    }
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        lblGesture.text = "LongPress"
        lblInfo.isHidden = true
    }
    @objc func leftSwipe(_ sender: UISwipeGestureRecognizer){
      lblGesture.text = "LeftSwipe"
        lblInfo.isHidden = true
     }
    @objc func rightSwipe(_ sender: UISwipeGestureRecognizer){
      lblGesture.text = "RightSwipe"
        lblInfo.isHidden = true
       }
    @objc func upSwipe(_ sender: UISwipeGestureRecognizer){
      lblGesture.text = "UpSwipe"
        lblInfo.isHidden = true
    }
     @objc func downSwipe(_ sender: UISwipeGestureRecognizer){
      lblGesture.text = "DownSwipe"
         lblInfo.isHidden = true
    }
    @objc func rotate(_ sender: UIRotationGestureRecognizer){
     itemView.transform = itemView.transform.rotated(by: sender.rotation)
     sender.rotation = 0
        lblInfo.text = "X axis is \(itemView.frame.origin.x) \n Y axis is \(itemView.frame.origin.y)"
     lblGesture.text = "Rotate"
    }
     @objc func pinch(_ sender: UIPinchGestureRecognizer){
        itemView.transform = itemView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
         lblInfo.text = "X axis is \(itemView.frame.origin.x) \n Y axis is \(itemView.frame.origin.y)"
        lblGesture.text = "Pinch Gesture"
       }
    @objc func pan(_ sender: UIPanGestureRecognizer){
        switch sender.state{
        case .changed:
            print("changed")
            self.view.bringSubviewToFront(itemView)
            let translation = sender.translation(in: self.view)
            itemView.center = CGPoint(x: itemView.center.x + translation.x, y: itemView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            lblInfo.text = "X axis is \(itemView.frame.origin.x) \n Y axis is \(itemView.frame.origin.y)"
            lblGesture.text = "Pan Gesture"
        case .began:
            print("began")
            lblInfo.text = "X axis is \(itemView.frame.origin.x) \n Y axis is \(itemView.frame.origin.y)"
        default:
            break
        }
    }
}
