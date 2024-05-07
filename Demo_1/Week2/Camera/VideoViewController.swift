//
//  VideoViewController.swift
//  Camera
//
//  Created by iMac on 08/03/24.
//

import UIKit
import AVKit

var videoArray:[URL] = []
var videoImage:[Data] = []
class VideoViewController: UIViewController,AVCaptureFileOutputRecordingDelegate{
    
    
    
    var captureSession:AVCaptureSession!
    var audio:AVCaptureDevice!
    var backCamera:AVCaptureDevice!
    var frontCamera:AVCaptureDevice!
    var backInput:AVCaptureInput!
    var frontInput:AVCaptureInput!
    var audioInput:AVCaptureInput!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var movieOutput:AVCaptureMovieFileOutput!
    var takePicture = false
    var isTorch = false
    var isBack = true
    var isVideoOn = true
    var timer:Timer!
    var seconds = 0
    var data:Data!
    var isRecording = false
    var isAutoOn = false
    
//    @IBOutlet weak var resumeButton: UIButton!
//    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var autoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        videoButton.layer.cornerRadius = videoButton.frame.width/2
        videoButton.clipsToBounds = true
        videoButton.layer.borderWidth = 4.0
        videoButton.layer.backgroundColor = UIColor.clear.cgColor
        videoButton.layer.borderColor = UIColor.white.cgColor
        
     
        recordButton.layer.cornerRadius = recordButton.frame.width/2
        recordButton.clipsToBounds = true
        recordButton.layer.borderWidth = 4.0
        recordButton.layer.backgroundColor = UIColor.clear.cgColor
        recordButton.layer.borderColor = UIColor.white.cgColor
        autoButton.isHidden = true
//        pauseButton.isHidden = true
//        resumeButton.isHidden = true
        recordButton.isHidden = true
        recordLabel.isHidden = false
        
        let image = UITapGestureRecognizer(target: self, action: #selector(largeImage))
        capturedImage.addGestureRecognizer(image)
    }
    @objc func largeImage (){
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recordLabel.isHidden = false
        navigationController?.navigationBar.isHidden = false
        setupAndStartCaptureSession()
        
    }
    
//    @IBAction func pauseButton(_ sender: UIButton) {
//        resumeButton.isHidden = false
//        if isRecording{
//            stopRecordingto()
//            pauseButton.isHidden = true
//        }
//    }
//    @IBAction func resumeButton(_ sender: UIButton) {
//        pauseButton.isHidden = true
//        if !isRecording{
//            startRecordingTo()
//            
//        }
//    }
    
    
    @IBAction func onPhotoTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onAutoTapped(_ sender: UIButton) {
        
        if isAutoOn == true{
            autoButton.setTitleColor(.blue, for: .normal)
            isAutoOn = false
        }else{
            autoButton.setTitleColor(.yellow, for: .normal)
            isAutoOn = true
        }
        
    }
    
    
    
    @IBAction func onVideoButtonTapped(_ sender: UIButton) {
//        pauseButton.isHidden = false
       videoButton.isHidden = true
        recordButton.isHidden = false
        if movieOutput.isRecording{
            movieOutput.stopRecording()
        
        }else{
            startRecording()
        }
    }
    @IBAction func onTourchTapped(_ sender: Any) {
        torchConfig()
        
    }
    
    @IBAction func onRecording(_ sender: UIButton) {
        videoButton.isHidden = false
        movieOutput.stopRecording()
        recordButton.isHidden = true
        timer.invalidate()
        recordLabel.text = ""
    }
    func torchConfig(){
        do{
            try backCamera.lockForConfiguration()
            if isTorch{
                backCamera.torchMode = .off
                isTorch = true
            }else {
                backCamera.torchMode = .on
                isTorch = false
            }
            isTorch = !isTorch
            
            backCamera.unlockForConfiguration()
        }catch {
            print("torch is not available to used")
        }
    }

    @IBAction func flipCamera(_ sender: Any) {
        
                  if isBack == false{
                      captureSession.removeInput(frontInput)
                      captureSession.addInput(backInput)
                      isBack = true
                  }else{
                      captureSession.removeInput(backInput)
                      captureSession.addInput(frontInput)
                      isBack = false
                  }
    }
    
    
    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo){
                self.captureSession.sessionPreset = .photo
            }
            
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            
            DispatchQueue.main.async{
                self.setupPreviewLayer()
            }
            self.setupOutput()
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    func setupInputs(){
        if let device = AVCaptureDevice.default(for: .audio){
            audio = device
            
        }else{
            fatalError("No Back audio speaker")
        }
        guard let audioinput = try? AVCaptureDeviceInput(device: audio) else{
            fatalError("could not create input device audio")
        }
        audioInput = audioinput
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,position: .back){
            backCamera = device
            
        }else{
            fatalError("No Back Camera")
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,position: .front){
            frontCamera = device
        }else{
            fatalError("No Front Camera")
        }
        guard let backinput = try? AVCaptureDeviceInput(device: backCamera) else{
            fatalError("could not create input device from back camera")
        }
        backInput = backinput
        if !captureSession.canAddInput(backInput){
            fatalError("could not add back camera input to capture session")
        }
        
        guard let frontinput = try? AVCaptureDeviceInput(device: frontCamera) else{
            fatalError("could not create input device from front camera")
        }
        frontInput = frontinput
        if !captureSession.canAddInput(frontInput){
            fatalError("could not add front camera input to capture session")
        }
     
        if isBack {
            captureSession.addInput(backInput)
        }else{
            captureSession.addInput(frontInput)
        }
        
    }
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = self.cameraPreview.bounds
        cameraPreview.layer.addSublayer(previewLayer)
        
    }
    func setupOutput(){
        
        self.movieOutput = AVCaptureMovieFileOutput()
        
        if self.captureSession.canAddOutput(self.movieOutput){
            self.captureSession.addOutput(self.movieOutput)
        }else{
            fatalError("could not add video output")
        }
        movieOutput.connections.first?.videoOrientation = .portrait
    }
    
    func startRecording (){
        if isAutoOn{
            do {
                try backCamera.lockForConfiguration()
                backCamera.torchMode = .on
                backCamera.unlockForConfiguration()
            }catch{
                print(error)
            }
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let tempURL = paths[0].appendingPathComponent("videos\(videoArray.count + 1).mp4")
            videoArray.append(tempURL)
            movieOutput.startRecording(to: tempURL, recordingDelegate: self)
            isVideoOn = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }else{
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let tempURL = paths[0].appendingPathComponent("videos\(videoArray.count + 1).mp4")
            videoArray.append(tempURL)
            movieOutput.startRecording(to: tempURL, recordingDelegate: self)
            isVideoOn = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }
    }
//    func startRecordingTo(){
//        guard let output = movieOutput else { return }
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let outputPath =  paths[0].appendingPathComponent("videos\(videoArray.count + 1).mp4") as! String
//        let outputFileURL = URL(fileURLWithPath: outputPath)
//        output.startRecording(to: outputFileURL, recordingDelegate: self)
//        isRecording = true
//    }
//    func stopRecordingto(){
//        guard let output = movieOutput, isRecording else { return }
//        output.stopRecording()
//        isRecording = false
//    }
    
    @objc func timerUpdate(){
        let totalSeconds = CMTimeGetSeconds(movieOutput.recordedDuration)
        let hours = Int(totalSeconds / 3600)
        let minitues = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        let r = "\(String(format: "%0.2d:%0.2d:%0.2d",hours,minitues,seconds))"
        recordLabel.text = "\(r)"
        
    }

    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        print(outputFileURL)
      //  videoArray.append(outputFileURL)
        print(videoArray)
        if isAutoOn || isTorch{
            do {
                try backCamera.lockForConfiguration()
                backCamera.torchMode = .off
                backCamera.unlockForConfiguration()
            }catch{
                print(error)
            }
        }
        if let thumbnailImage = getThumbnailImage(forUrl: outputFileURL){
            capturedImage.image = thumbnailImage
            capturedImage.transform = capturedImage.transform.rotated(by: .pi/2)
            data = thumbnailImage.jpegData(compressionQuality: 0)
            videoImage.append(data)
            print(videoImage)
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
}
extension VideoViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if !takePicture {
            return
        }
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{
            return
        }
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
            self.capturedImage.image = uiImage
            self.takePicture = false
        }
    }
}