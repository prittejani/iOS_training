//
//  SpeechToTextViewController.swift
//  test
//
//  Created by USER on 30/05/24.
//

import UIKit
import Speech

class SpeechToTextViewController: UIViewController,UITextViewDelegate{
    // set permission to microphone and speech reco audio
   private let recognizer = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private let audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask!
    @IBOutlet var btnSpeak: UIButton!
    @IBOutlet var textView: UITextView!
    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Speech to Text"
        textView.delegate = self
        textView.layer.cornerRadius = 15.0
        requestMicrophonePermission()
    }
   
    func requestMicrophonePermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Microphone permission granted")
                } else {
                    print("Microphone permission denied")
                }
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    @IBAction func onSpeakTapped(_ sender: UIButton) {
        if isOn{
            self.stopAudioCapture()
            btnSpeak.setTitle("Speak", for: .normal)
            isOn = false
        }else{
            startSpeaking()
            btnSpeak.setTitle("Stop", for: .normal)
            isOn = true
        }
    }
    
    
    func startSpeaking(){
      

        // Request speech recognition authorization here if not already done.
        let audioSession = AVAudioSession.sharedInstance()
               do {
                   try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                   try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                   let inputNode = audioEngine.inputNode
                   let recordingFormat = inputNode.outputFormat(forBus: 0)
                   inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                       self.request.append(buffer)
                   }
                   audioEngine.prepare()
                   try audioEngine.start()
                   
                   // Start speech recognition
                   recognitionTask = recognizer?.recognitionTask(with: request, resultHandler: { [self] result, error in
                       if let result = result {
                           // Transcription result
                           print("Transcription: \(result.bestTranscription.formattedString)")
                           textView.text = result.bestTranscription.formattedString
                       } else if let error = error {
                           print("Recognition error: \(error)")
                       }
                   })
               } catch {
                   print("Error starting audio capture: \(error)")
               }

    }

    func stopAudioCapture() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request.endAudio()
        recognitionTask.cancel()
        recognitionTask = nil
    }

}
