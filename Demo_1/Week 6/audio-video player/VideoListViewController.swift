//
//  VideoListViewController.swift
//  Demo_1
//
//  Created by iMac on 23/04/24.
//

import UIKit


var videoFiles:[URL] = []
class VideoListViewController: UIViewController,UIDocumentPickerDelegate{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        videoFiles.removeAll()
        fetchVideoFiles()
        
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
    
    @IBAction func addVideos(_ sender: UIBarButtonItem) {
        let videoPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.movie])
        videoPicker.delegate = self
        present(videoPicker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else{
            return
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoUrl  = selectedFileUrl.lastPathComponent
        let saveAudioUrl = documentDirectory.appendingPathComponent(videoUrl)
        let accessGranted = selectedFileUrl.startAccessingSecurityScopedResource()
        if accessGranted{
            do{
                try FileManager.default.copyItem(at: selectedFileUrl, to: saveAudioUrl)
                videoFiles.append(selectedFileUrl)
                print(videoFiles)
                tableView.reloadData()
            }catch{
                customAlert(title: "Alert!!", message: "File is already exist")
            }
        }else{
            customAlert(title: "Alert!!", message: "You have not permission to view it")
        }
    }
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
        cell.lblVideoName.text = "\(videoFiles[indexPath.row].lastPathComponent)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = audio_video.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.index = indexPath.row
    //  present(vc, animated: true)
       navigationController?.pushViewController(vc, animated: true)
    }
    
}
