//
//  PlayVideoViewController.swift
//  Camera
//
//  Created by iMac on 11/03/24.
//

import UIKit
import AVKit
import AVFoundation

class PlayVideoViewController: UIViewController {
    
    @IBOutlet weak var playView: UIView!
    var videourl:URL!
    var player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var isPlaying = false
    var getCurrentIndex:Int = 0
    
   
    
    @IBOutlet weak var swipeView: UIView!
    override func viewDidLoad() {
        
        tabBarController?.tabBar.isHidden = true
        
        self.playView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/1.5)
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipe))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipe))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
      //  playView.contentMode = .scaleAspectFit
        playView.isHidden = false
        swipeView.isHidden = true
        player = AVPlayer(url: videourl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playView.bounds
        if let playerLayer = playerLayer {
            playView.contentMode = .scaleToFill
            playerLayer.videoGravity = .resizeAspectFill
            playView.layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main){ [self]_ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    @objc func responseToSwipe(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.left:
                playView.isHidden = true
                swipeView.isHidden = false
                if getCurrentIndex < cvideoArray.count - 1{
                    getCurrentIndex+=1
                    player = AVPlayer(url: cvideoArray[getCurrentIndex])
                    playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = swipeView.bounds
                    if let playerLayer = playerLayer {
                        playerLayer.removeFromSuperlayer()
                  //      playView.contentMode = .scaleToFill
                        playerLayer.videoGravity = .resizeAspectFill
                        swipeView.layer.addSublayer(playerLayer)
                    }
                }
                
            case UISwipeGestureRecognizer.Direction.right:
                playView.isHidden = true
                swipeView.isHidden = false
                if getCurrentIndex > 0{
                    getCurrentIndex-=1
                    player = AVPlayer(url: cvideoArray[getCurrentIndex])
                    playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = swipeView.bounds
                    if let playerLayer = playerLayer {
                        playerLayer.removeFromSuperlayer()
                    //    playView.contentMode = .scaleToFill
                        playerLayer.videoGravity = .resizeAspectFill
                        swipeView.layer.addSublayer(playerLayer)
                    }
                }
                
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func pauseVideo(_ sender: UIButton) {
        player.pause()
    }
    
    @IBAction func play(_ sender: Any) {
        player.play()
    
    }
    
}
