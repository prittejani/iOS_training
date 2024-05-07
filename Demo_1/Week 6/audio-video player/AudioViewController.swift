//
//  AudioViewController.swift
//  Demo_1
//
//  Created by iMac on 18/04/24.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioViewController: UIViewController,AVAudioPlayerDelegate{
    
    @IBOutlet weak var audioImageView: UIImageView!
    
    
    @IBOutlet weak var audioDurationSlider: UISlider!
    @IBOutlet weak var audioDurationLabel: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    var audioPlayer:AVAudioPlayer!
    var timer:Timer!
    let volumeControl = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    var isPlaying = true
    var index:Int!
    var isSliderBeingUsed = false
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    
    @IBOutlet weak var audioName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(volumeControl)
        
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
        [weak self] timer in
            self?.setVolume()
        })
        configure()
        audioDurationSlider.addTarget(self, action: #selector(changeAudioSlider(sender: event:)), for: .allEvents)
        
    }
    
    override func viewDidLayoutSubviews() {
        volumeControl.frame = CGRect(x: -120, y: -120, width: 100, height: 100);
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer.pause()
    }
    
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
    
    @objc func changeAudioSlider(sender: UISlider, event:UIEvent){
        isSliderBeingUsed = true
    }
 
    @IBAction func audioSliderTouch(_ sender: UISlider) {
        if isSliderBeingUsed {
               audioPlayer.currentTime = TimeInterval(audioDurationSlider.value)
               if isPlaying {
                   audioPlayer.play(atTime: audioPlayer.currentTime)
               }
           }

           isSliderBeingUsed = false
    }
    
    @IBAction func onVolumeChange(_ sender: UISlider) {
        let volume = sender.value
              let volumeViewSlider = volumeControl.subviews.first(where: { $0 is UISlider }) as? UISlider
                  volumeViewSlider?.setValue(volume, animated: false)
    }
    
    func configure(){
        do{
            print(audioFiles[index])
            let audioFileURL = audioFiles[index]
            audioName.text = "\(audioFiles[index].lastPathComponent)"
            print(audioFileURL)
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer.delegate = self
            guard let audioPlayer = audioPlayer else{ return }
            audioPlayer.play()
            audioPlayer.volume = 0.5
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeCounter), userInfo: true, repeats: true)

            totalDurationLabel.text = "\(formattedTimeFrom(seconds: audioPlayer.duration))"
            
            audioDurationSlider.minimumValue = Float(audioPlayer.currentTime)
            audioDurationSlider.maximumValue = Float(audioPlayer.duration)
            
        }catch{
            print("something went wrong...")
        }
    }
    
    @objc func timeCounter(){
        audioDurationSlider.value = Float(audioPlayer.currentTime)
        audioDurationLabel.text = "\(formattedTimeFrom(seconds: audioPlayer.currentTime))"
    }
    

    
    @IBAction func playAudio(_ sender: UIButton) {
        if isPlaying{
            isPlaying = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            audioPlayer?.pause()
        }else{
            isPlaying = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            audioPlayer.play()
        }
    }
    
    @IBAction func skipForward(_ sender: UIButton) {
        audioPlayer.currentTime += 10
        print(audioPlayer.currentTime)
        if (audioPlayer.currentTime > audioPlayer.duration) {
            
            audioPlayer.currentTime = audioPlayer.currentTime
        }else if audioPlayer.currentTime < audioPlayer.duration{
            
            audioPlayer.play()
        }
    }
    
    @IBAction func skipBackward(_ sender: UIButton) {
        audioPlayer.currentTime -= 10
        print(audioPlayer.currentTime)
        if (audioPlayer.currentTime > audioPlayer.duration) {
            
            audioPlayer.currentTime = audioPlayer.currentTime
        }else if audioPlayer.currentTime < audioPlayer.duration{
            audioPlayer.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            timer.invalidate()
            player.currentTime = 0
            if index < audioFiles.count - 1{
                index += 1
            }else{
                index = 0
            }
            configure()
        }
    }
    @IBAction func backWardAudio(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            configure()
        }else{
            index = 0
            configure()
        }
    }
    
    @IBAction func forWardAudio(_ sender: UIButton) {
        print(audioFiles[index])
        if index < audioFiles.count - 1 {
            index += 1
            print(audioFiles[index])
            configure()
        }else{
            index = 0
            configure()
        }
    }
    
    
    func formattedTimeFrom(seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
