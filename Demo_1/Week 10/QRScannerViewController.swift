//
//  QRScannerViewController.swift
//  Demo_1
//
//  Created by iMac on 29/05/24.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
  
    @IBOutlet weak var scannerView: UIView!
    var captureSession: AVCaptureSession!
       var previewLayer: AVCaptureVideoPreviewLayer!
      var passQRContent: ((String) -> Void)?
       override func viewDidLoad() {
           
           super.viewDidLoad()
      
           captureSession = AVCaptureSession()

           guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
           let videoInput: AVCaptureDeviceInput

           do {
               videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
           } catch {
               return
           }

           if (captureSession.canAddInput(videoInput)) {
               captureSession.addInput(videoInput)
           } else {
               failed()
               return
           }

           let metadataOutput = AVCaptureMetadataOutput()

           if (captureSession.canAddOutput(metadataOutput)) {
               captureSession.addOutput(metadataOutput)

               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
           } else {
               failed()
               return
           }

           previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           previewLayer.frame = scannerView.layer.bounds
           previewLayer.videoGravity = .resizeAspectFill
           scannerView.layer.addSublayer(previewLayer)

           captureSession.startRunning()
       }

       func failed() {
           let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
           ac.addAction(UIAlertAction(title: "OK", style: .default))
           present(ac, animated: true)
           captureSession = nil
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           if (captureSession?.isRunning == false) {
               captureSession.startRunning()
           }
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           if (captureSession?.isRunning == true) {
               captureSession.stopRunning()
           }
       }

       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession.stopRunning()

           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               found(code: stringValue)
               navigationController?.popViewController(animated: true)
           }

           dismiss(animated: true)
       }

       func found(code: String) {
           passQRContent?(code)
          // customAlert(title: "", message: "\(code)")
           
           print(code)
       }

       override var prefersStatusBarHidden: Bool {
           return true
       }

       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default,handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}
