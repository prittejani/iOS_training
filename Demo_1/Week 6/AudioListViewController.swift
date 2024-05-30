//
//  AudioListViewController.swift
//  Pods
//
//  Created by iMac on 18/04/24.
//

import UIKit

var audioFiles:[URL] = []
class AudioListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
       
    }

    override func viewWillAppear(_ animated: Bool) {
        audioFiles.removeAll()
        fetchAudioFiles()
    }
    
    func fetchAudioFiles(){
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            do{
                let fileUrls = try FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil)
                for fileUrl in fileUrls{
                    var isDirectory: ObjCBool = false
                    if  FileManager.default.fileExists(atPath: fileUrl.path, isDirectory: &isDirectory){
                        
                        if !isDirectory.boolValue{
                            if fileUrl.pathExtension.lowercased() == "mp3" || fileUrl.pathExtension.lowercased() == "wav" || fileUrl.pathExtension.lowercased() == "m4a" {
                                audioFiles.append(fileUrl)
                            }
                        }
                    }
                }
            }catch{
                customAlert(title: "Alert!!", message: "\(error)")
            }
        }
    }

//        var path:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print(path)
//        let files = try? FileManager.default.contentsOfDirectory(atPath: path.path)
//      
//             for file in files! {
//                let fileExtension = file.components(separatedBy: ["."]).last
//                 
//                if fileExtension == "mp3"{
//                print(file)
//                audioFiles.append(path.appendingPathComponent(file))
//                print(audioFiles)
//            }
//        }
    
    
    @IBAction func addMusic(_ sender: UIBarButtonItem) {
        let audioPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        audioPicker.delegate = self
        present(audioPicker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else{
            return
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioUrl  = selectedFileUrl.lastPathComponent
        let saveAudioUrl = documentDirectory.appendingPathComponent(audioUrl)
        let accessGranted = selectedFileUrl.startAccessingSecurityScopedResource()
        if accessGranted{
            do{
                try FileManager.default.copyItem(at: selectedFileUrl, to: saveAudioUrl)
                audioFiles.append(selectedFileUrl)
                print(audioFiles)
                tableView.reloadData()
            }catch{
                customAlert(title: "Alert!!", message: "File already exist")
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




extension AudioListViewController:UITableViewDelegate,UITableViewDataSource,UIDocumentPickerDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultTableViewCell
        cell.lblAudioName.text = "\(audioFiles[indexPath.row].lastPathComponent)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = audio_video.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
