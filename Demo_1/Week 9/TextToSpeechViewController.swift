//
//  ViewController.swift
//  test
//
//  Created by USER on 30/05/24.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController, AVSpeechSynthesizerDelegate,UITextViewDelegate{

    @IBOutlet var textView: UITextView!
    
        let speechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet var speakButton: UIButton!
    override func viewDidLoad() {
        textView.delegate = self
        textView.text = "Add Content here.."
        
        textView.textColor = UIColor.gray
        textView.layer.cornerRadius = 15.0
        title = "Text to Speech"
        
        speechSynthesizer.delegate = self
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Content here.." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//          if text == "\n" {
//              textView.resignFirstResponder()
//              return false
//          }
//          return true
//    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add Content here.."
            textView.textColor = UIColor.gray
        }
    }
    

    @IBAction func onSpeakTapped(_ sender: UIButton) {
        if speechSynthesizer.isPaused{
            speechSynthesizer.continueSpeaking()
            speakButton.setTitle("Stop", for: .normal)
        }
        else if speechSynthesizer.isSpeaking{
            speechSynthesizer.pauseSpeaking(at: .immediate)
            speakButton.setTitle("Continue", for: .normal)
        }
        else{
            
            guard textView.text != nil else {return}
            
            let utterance = AVSpeechUtterance(string: textView.text)
            utterance.voice = AVSpeechSynthesisVoice(language: "hi-IN")
            utterance.voice = AVSpeechSynthesisVoice(identifier: "Alex")
            utterance.rate = 0.5
            
            
            speechSynthesizer.speak(utterance)
            speakButton.setTitle("Stop", for: .normal)
        }
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakButton.setTitle("Listen", for: .normal)
    }
}

