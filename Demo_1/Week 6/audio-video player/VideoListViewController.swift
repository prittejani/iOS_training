//
//  VideoListViewController.swift
//  Demo_1
//
//  Created by iMac on 23/04/24.
//

import UIKit
import Photos
import SVProgressHUD
import AVKit

var videoFiles:[URL] = []
var videosThumb: [PHAsset] = []
class VideoListViewController: UIViewController,UIDocumentPickerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.showsVerticalScrollIndicator = false
        SVProgressHUD.show()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
            SVProgressHUD.dismiss()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        videoFiles.removeAll()
        fetchVideoFiles()
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
 
             if status == .restricted || status == .denied
             {
                 print("Status: Restricted or Denied")
             }
            
             if status == .limited
             {
                 self?.fetchVideos()
                 print("Status: Limited")
             }
             
             if status == .authorized
             {
                 self?.fetchVideos()
                 print("Status: Full access")
             }
         }
    }
    func fetchVideos() {
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
        
        let dispatchGroup = DispatchGroup()
        
        fetchResults.enumerateObjects { (object, _, _) in
            videosThumb.append(object)
            dispatchGroup.enter()
            
            self.getVideoURL(for: object) { url in
                if let url = url {
                    videoFiles.append(url)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    func getVideoURL(for asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
            if let urlAsset = avAsset as? AVURLAsset {
                completion(urlAsset.url)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchVideoFiles(){
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            do{
                let fileUrls = try FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil)
                for fileUrl in fileUrls{
                    var isDirectory: ObjCBool = false
                    if  FileManager.default.fileExists(atPath: fileUrl.path, isDirectory: &isDirectory){
                        
                        if !isDirectory.boolValue{
                            if fileUrl.pathExtension.lowercased() == "mp4" || fileUrl.pathExtension.lowercased() == "mov"{
                                videoFiles.append(fileUrl)
                            }
                        }
                    }
                }
            }catch{
                customAlert(title: "Alert!!", message: "\(error)")
            }
        }
    }
    
//    @IBAction func addVideos(_ sender: UIBarButtonItem) {
//        let videoPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.movie])
//        videoPicker.delegate = self
//        present(videoPicker, animated: true)
//    }
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let selectedFileUrl = urls.first else{
//            return
//        }
//        
//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let videoUrl  = selectedFileUrl.lastPathComponent
//        let saveAudioUrl = documentDirectory.appendingPathComponent(videoUrl)
//        let accessGranted = selectedFileUrl.startAccessingSecurityScopedResource()
//        if accessGranted{
//            do{
//                try FileManager.default.copyItem(at: selectedFileUrl, to: saveAudioUrl)
//                videoFiles.append(selectedFileUrl)
//                print(videoFiles)
//                tableView.reloadData()
//            }catch{
//                customAlert(title: "Alert!!", message: "File is already exist")
//            }
//        }else{
//            customAlert(title: "Alert!!", message: "You have not permission to view it")
//        }
//    }
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
}
extension VideoListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return videoFiles.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoTableViewCell
        let videoAsset = videosThumb[indexPath.row]
        
        cell.lblVideoName.text = "VID\(videoAsset.creationDate ?? Date())"
        PHCachingImageManager.default().requestImage(for: videoAsset, targetSize: CGSize(width: 100, height: 100),contentMode: .aspectFill,options: nil) { (photo, _) in
            cell.videoImageView.image = photo
        }
       // let longPress = UILongPressGestureRecognizer(target: self, action: #selector(VideoListViewController.handleLongPress(sender:)))
    //    cell.addGestureRecognizer(longPress)
      

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = audio_video.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.index = indexPath.row
    
       navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let videoAsset = videosThumb[indexPath.row]
                PHCachingImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil) { [weak self] (video, _, _) in
                    if let video = video
                    {
                        DispatchQueue.main.async {
                            self?.playVideo(video)
                        }
                    }
                }
            }
        }
    }
    private func playVideo(_ video: AVAsset) {
            let playerItem = AVPlayerItem(asset: video)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
}
