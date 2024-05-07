//
//  VideoViewController.swift
//  Demo_1
//
//  Created by iMac on 23/04/24.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoControlUI: UIView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundSlider: UISlider!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var videoDuration: UILabel!
    @IBOutlet weak var videoTotalDuration: UILabel!
    var index:Int!
    let volumeControl = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    var timer:Timer!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var isPlaying:Bool = false
    var isFullScreen:Bool = false
    var isVideoControlUIHidden:Bool = false
    var isSliderBeingUsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(volumeControl)
        videoConfigure()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
        [weak self] timer in
            self?.setVolume()
        })
//        soundSlider.addTarget(self, action: #selector(setVolume(sender: event:)), for: .valueChanged)
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
            self.videoSlider.addGestureRecognizer(panGesture)
        videoSlider.addTarget(self, action: #selector(changeVideoSlider(sender: event:)), for: .valueChanged)
    }
    override func viewDidLayoutSubviews() {
        volumeControl.frame = CGRect(x: -120, y: -120, width: 100, height: 100);
    }
    @objc func panGesture(gesture:UIPanGestureRecognizer){
         let currentPoint = gesture.location(in: videoSlider)
         let percentage = currentPoint.x/videoSlider.bounds.size.width;
         let delta = Float(percentage) *  (videoSlider.maximumValue - videoSlider.minimumValue)
         let value = videoSlider.minimumValue + delta
        videoSlider.setValue(value, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        videoControlUI.clipsToBounds = true
        videoControlUI.layer.cornerRadius = 12.0
        videoPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoControlTapped)))
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    @objc func onVideoControlTapped(){
        if isVideoControlUIHidden {
            videoControlUI.isHidden = false
            isVideoControlUIHidden = false
        }else{
            videoControlUI.isHidden = true
            isVideoControlUIHidden = true
        }
    }
    
//    @objc func setVolume(sender: UISlider, event:UIEvent) {
//        if let touchEvent = event.allTouches?.first {
//            if touchEvent.phase == .ended {
//                let audioSession = AVAudioSession.sharedInstance()
//                do {
//                    try audioSession.setActive(true)
//                    let currentVolume = audioSession.outputVolume
//                    soundSlider.value = currentVolume
//                    } catch {
//                    print("Error in sound\(error.localizedDescription)")
//                }
//            }
//        }
//
//    }
    @objc func setVolume() {
        let audioSession = AVAudioSession.sharedInstance()
               do {
                   try audioSession.setActive(true)
                   let currentVolume = audioSession.outputVolume
                   soundSlider.value = currentVolume
               } catch {
                   print("Error in sound\(error.localizedDescription)")
               }
    }
    
    @IBAction func onVolumeChange(_ sender: UISlider) {
        
        let volume = sender.value
        let volumeViewSlider = volumeControl.subviews.first(where: { $0 is UISlider }) as? UISlider
        volumeViewSlider?.setValue(volume, animated: false)
    }
    
    @objc func changeVideoSlider(sender: UISlider, event:UIEvent){
        isSliderBeingUsed = true
        
    }
    
    @IBAction func onVideoSlidreTouch(_ sender: UISlider) {
        let time = CMTime(seconds: Double(sender.value), preferredTimescale: 60)
        player.seek(to: time)
        if isPlaying {
            player.play()
        }
        isSliderBeingUsed = false
    }
    
    private func videoConfigure(){
        isPlaying = true
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        let url = videoFiles[index]
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerLayer.frame = self.view.bounds
        //playerLayer.videoGravity = .resize
        self.videoPlayerView.layer.addSublayer(playerLayer)
        player.play()
        
        player.volume = 0.5
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeCounter), userInfo: true, repeats: true)

        let totalDuration = getTotalDurationOfVideo(at: videoFiles[index])
        videoTotalDuration.text = "\(formattedTimeFrom(seconds: CMTimeGetSeconds(totalDuration)))"
        
        videoSlider.minimumValue = Float(player.currentTime().seconds)
        videoSlider.maximumValue = Float(CMTimeGetSeconds(totalDuration))
        
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc func replayVideo(){
        playerLayer.removeFromSuperlayer()
        timer.invalidate()
        if index < videoFiles.count - 1 {
            index += 1
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }else{
            index = 0
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }
    
    }
    func getTotalDurationOfVideo(at url: URL) -> CMTime {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        return duration
    }
    
    @objc func timeCounter(){
        videoSlider.value = Float(player.currentTime().seconds)
        videoDuration.text = "\(formattedTimeFrom(seconds: player.currentTime().seconds))"
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        if isPlaying {
            player.pause()
            isPlaying = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        } else{
            player.play()
            isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func skipForward(_ sender: UIButton) {
        let currentTime = player.currentTime()
        let targetTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        let totalDuration = getTotalDurationOfVideo(at: videoFiles[index])
        if targetTime.seconds > totalDuration.seconds{
            player.seek(to: .zero)
        }else{
            print(targetTime.seconds)
            player.seek(to: targetTime)
        }
    }
    
    @IBAction func skipBackward(_ sender: UIButton) {
        let currentTime = player.currentTime()
        let targetTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        player.seek(to: targetTime)
    }
    
    @IBAction func forwardVideo(_ sender: UIButton) {
        if index < videoFiles.count - 1 {
            index += 1
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }else{
            index = 0
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }
        
    }
    
    @IBAction func previousVideo(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }else{
            index = 0
            playerLayer.removeFromSuperlayer()
            videoConfigure()
        }
    }
    
    @IBAction func fullScreen(_ sender: UIButton) {
        if isFullScreen{
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            playerLayer.frame = videoPlayerView.bounds
            playerLayer.videoGravity = .resizeAspect
            isFullScreen = false
        }else{
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            playerLayer.frame = videoPlayerView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            isFullScreen = true
        }
    }

    
    func formattedTimeFrom(seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds)
        let hours = Int(totalSeconds / 3600)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d",hours,minutes,seconds)
    }
    
}
