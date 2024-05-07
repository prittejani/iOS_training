//
//  DefaultCameraViewController.swift
//  Camera
//
//  Created by iMac on 08/03/24.
//

import UIKit
import AVFoundation
import AVKit

class DefaultCameraViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{



    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblImageNotShow: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblVideoNotShow: UILabel!
    var videourl:URL!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    @IBOutlet weak var contentViews: UIView!
     override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderColor = UIColor.gray.cgColor
        btnPlay.setTitle("", for: .normal)
        btnPlay.isHidden = true
        if imageView.image == nil {
            imageView.isHidden = true
            lblImageNotShow.isHidden = false
        }else{
            imageView.isHidden = false
            lblImageNotShow.isHidden = true
        }
         imageView.layer.cornerRadius = 10.0
    }
    
    @IBAction func onCamerTapped(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .camera
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }
    
    @IBAction func onGalleryTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .photoLibrary
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }
    @IBAction func onVideoTapped(_ sender: UIButton) {
        playerLayer.backgroundColor = UIColor.white.cgColor
        btnPlay.isHidden = true
        playerLayer.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .photoLibrary
            picCameraImage.mediaTypes = ["public.movie"]
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }

    @IBAction func btnPlay(_ sender: UIButton) {
        btnPlay.isHidden = true
        player = AVPlayer(url: videourl)
         playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = contentViews.bounds

        contentViews.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspect
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main){ [self]_ in
            player.seek(to: CMTime.zero)
            btnPlay.isHidden = false
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
       
        if let image = info[.originalImage] as? UIImage{
           
            imageView.isHidden = false
            imageView.image = image
            if imageView.image == nil {
                imageView.isHidden = true
                lblImageNotShow.isHidden = false
            }else{
                
                imageView.isHidden = false
                lblImageNotShow.isHidden = true
            }
        }else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            playerLayer.backgroundColor = UIColor.white.cgColor
            btnPlay.isHidden = true
            videourl = videoUrl
            let player = AVPlayer(url: videoUrl)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = contentViews.bounds
       
            playerLayer.videoGravity = .resizeAspect
            contentViews.layer.addSublayer(playerLayer)
            player.play()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main){ [self]_ in 
                player.seek(to: CMTime.zero)
            
                btnPlay.isHidden = false
            }
        }
        else{
            lblImageNotShow.text = "Image not appeared"
        }
    }
}
