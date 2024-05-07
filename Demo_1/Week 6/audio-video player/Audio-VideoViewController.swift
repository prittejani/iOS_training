//
//  Audio-VideoViewController.swift
//  Demo_1
//
//  Created by iMac on 11/04/24.
//

import UIKit

let audio_video = UIStoryboard(name: "audio_video_player", bundle: nil)

class Audio_VideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func onDefaultTapped(_ sender: UIButton) {
        let vc = audio_video.instantiateViewController(withIdentifier: "AudioListViewController") as! AudioListViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onCustomTapped(_ sender: UIButton) {
        let vc = audio_video.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resolution(_ sender: UIButton) {
        let vc = audio_video.instantiateViewController(withIdentifier: "ResolutionViewController") as! ResolutionViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func autoResizing(_ sender: UIButton) {
        let vc = audio_video.instantiateViewController(withIdentifier: "AutoResizingViewController") as! AutoResizingViewController
        navigationController?.pushViewController(vc, animated: true)

    }
    
    
}
