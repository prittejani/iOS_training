//
//  CameraViewController.swift
//  Camera
//
//  Created by iMac on 08/03/24.
//

import AVFoundation
import UIKit
var imageArray:[Data] = []
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    
    var captureSession:AVCaptureSession!
    var audio:AVCaptureDevice!
    var backCamera:AVCaptureDevice!
    var frontCamera:AVCaptureDevice!
    var backInput:AVCaptureInput!
    var frontInput:AVCaptureInput!
    var audioInput:AVCaptureInput!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var data:Data!
    var stillImageOutput:AVCapturePhotoOutput!
    var movieOutput:AVCaptureMovieFileOutput!
    var fileUrl:URL!
    var takePicture = false
    var isTorch = false
    var isBack = true
    var videoOn = true
    var isAutoOn = false
    
    @IBOutlet weak var cameraPreview: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var capturedImage: UIImageView!
    
    @IBOutlet weak var flipCamera: UIBarButtonItem!
    @IBOutlet weak var autoButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2
        cameraButton.clipsToBounds = true
        cameraButton.layer.borderWidth = 4.0
        cameraButton.layer.backgroundColor = .none
       
        cameraButton.layer.borderColor = UIColor.white.cgColor
        let image = UITapGestureRecognizer(target: self, action: #selector(largeImage))
        capturedImage.addGestureRecognizer(image)
        navigationItem.setHidesBackButton(true, animated: false)
       
    }

    @objc func largeImage (){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CCollectionViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setupAndStartCaptureSession()
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
          super.traitCollectionDidChange(previousTraitCollection)
          
          let isDarkMode = traitCollection.userInterfaceStyle == .dark
   
          do {
              try backCamera?.lockForConfiguration()
              if isDarkMode {
                  if backCamera?.isTorchModeSupported(.on) ?? false {
                      try backCamera?.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                  }
              } else {
                  if backCamera?.isTorchModeSupported(.off) ?? false {
                      backCamera?.torchMode = .off
                  }
              }
              backCamera?.unlockForConfiguration()
          } catch {
              print("Could not configure torch mode: \(error)")
          }
      }
    
    @IBAction func onAutoTapped(_ sender: UIButton) {
    
        if isAutoOn == true{
            autoButton.tintColor = .blue
            isAutoOn = false
        }else{
            isTorch = false
            do {
                try backCamera.lockForConfiguration()
                backCamera.torchMode = .off
                backCamera.unlockForConfiguration()
            }catch{
                print(error)
            }
            autoButton.tintColor = .yellow
            isAutoOn = true
        }
    }
    
    @IBAction func onCameraTapped(_ sender: UIButton) {
        if isAutoOn{
            takePicture = true
            do {
                try backCamera.lockForConfiguration()
                backCamera.torchMode = .on
                backCamera.unlockForConfiguration()
            }catch{
                print(error)
            }
    
            let settings = AVCapturePhotoSettings()
            if let photopreviewType = settings.availablePreviewPhotoPixelFormatTypes.first{
                settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:photopreviewType]
            }
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){ [self] in
                do {
                    try backCamera.lockForConfiguration()
                    backCamera.torchMode = .off
                    backCamera.unlockForConfiguration()
                }catch{
                    print(error)
                }
            }
            
        }else{
            takePicture = true
            
            let settings = AVCapturePhotoSettings()
            if let photopreviewType = settings.availablePreviewPhotoPixelFormatTypes.first{
                settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String:photopreviewType]
            }
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        let vc = self.navigationController?.viewControllers[1] as! CViewController
        navigationController?.popToViewController(vc, animated: true)
    }
    
    @IBAction func tourchTapped(_ sender: UIBarButtonItem) {
        torchConfig()
        isAutoOn = false
        autoButton.tintColor = .blue
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
    
    @IBAction func flipCameraTapped(_ sender: UIBarButtonItem) {
        if isBack == false {
              captureSession.removeInput(frontInput)
              if !captureSession.inputs.contains(frontInput) {
                  captureSession.addInput(backInput)
              }
              isBack = true
          } else {
              captureSession.removeInput(backInput)
              if !captureSession.inputs.contains(backInput) {
                  captureSession.addInput(frontInput)
              }
              isBack = false
          }
    }

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()else{
            return
        }  
        guard let cgImage = photo.cgImageRepresentation()else{
            return
        }
        if isBack{
            data = imageData
            _ = UIImage(data: data)
            imageArray.append(data)
            print(imageArray)
            capturedImage.image = UIImage(data: data)
        }else{
            
            var image = UIImage(cgImage: cgImage,scale: 1.0,orientation: .leftMirrored)
            let d = image.jpegData(compressionQuality: 1.0)
            data = d
            _ = UIImage(data: data)
            imageArray.append(data)
            print(imageArray)
            capturedImage.image =  UIImage(data: data)
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
        
        self.stillImageOutput = AVCapturePhotoOutput()
        
        if self.captureSession.canAddOutput(self.stillImageOutput){
            self.captureSession.addOutput(self.stillImageOutput)
        }else{
            fatalError("could not add video output")
        }
        stillImageOutput.connections.first?.videoOrientation = .portrait
      
    }
}
extension CameraViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
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

    
