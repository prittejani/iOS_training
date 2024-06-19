//
//  ViewController.swift
//  FileManager
//
//  Created by iMac on 29/02/24.
//

import UIKit

let fileManagerStoryboard = UIStoryboard(name: "fileManager", bundle: nil)

var fileNameArray = Array<String>()
class ViewController5: UIViewController,UITableViewDelegate,UITableViewDataSource, UIDocumentPickerDelegate{
   
    
 
    @IBOutlet weak var noFilesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cancel:UIBarButtonItem!

    override func viewDidLoad() {
        fileNameArray.removeAll()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getFileNames()
        navigationController?.navigationBar.prefersLargeTitles = false
        if fileNameArray.count == 0 {
            tableView.isHidden = true
            noFilesView.isHidden = false
        }else{
           tableView.reloadData()
            tableView.isHidden = false
            noFilesView.isHidden = true
        }
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if fileNameArray.count == 0 {
            tableView.isHidden = true
            noFilesView.isHidden = false
        }else{
           tableView.reloadData()
            tableView.isHidden = false
            noFilesView.isHidden = true
        }
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func getFileNames(){
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            do{
                let fileUrls = try FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil)
                for fileUrl in fileUrls{
                    var isDirectory: ObjCBool = false
                    if  FileManager.default.fileExists(atPath: fileUrl.path, isDirectory: &isDirectory){
            
                        if !isDirectory.boolValue{
                            if fileUrl.pathExtension.lowercased() == "pdf" || fileUrl.pathExtension.lowercased() == "txt"{
                                fileNameArray.append("\(fileUrl.lastPathComponent)")
                            }
                            
                        }
                    }
                }
                print("~~~~~~~~~~~>>\(fileNameArray)")
            }catch{
                customAlert(title: "Alert!!", message: "\(error)")
            }
        }
    }
   

    @IBAction func onCreateTapped(_ sender: UIBarButtonItem) {
        let vc = fileManagerStoryboard.instantiateViewController(withIdentifier: "CreateFileViewController") as! CreateFileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return fileNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomFileManagerTableViewCell
        cell.lblFileName.text = fileNameArray[indexPath.row]
        if fileNameArray[indexPath.row].hasSuffix("txt"){
            cell.fileImage.image = UIImage(named: "text")
        }else{
            cell.fileImage.image = UIImage(named: "pdf")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileExtension = fileNameArray[indexPath.row].components(separatedBy: ["."])[1]
        if fileExtension == "pdf"{
            let vc = fileManagerStoryboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = docDir.appendingPathComponent(fileNameArray[indexPath.row])
            vc.pdfUrl = filePath
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateFileViewController") as! CreateFileViewController
        
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = URL(fileURLWithPath: fileNameArray[indexPath.row],relativeTo: documentDirectory)
            print("\(fileUrl)")
            let savedData = try Data(contentsOf: fileUrl)
            if let savedString = String(data: savedData, encoding: .utf8){
                vc.fileName = fileNameArray[indexPath.row]
                vc.fileContent = savedString
                vc.fileIndex = indexPath.row
                vc.isUpdate = true
            }
        }catch{
            print("\(error)")
        }
            navigationController?.pushViewController(vc, animated: true)
    }
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){(action,view,handler) in
            
            let alert = UIAlertController(title: "do you want to delete this file ?", message: "", preferredStyle: .alert)
                
            let yes = UIAlertAction(title: "Yes", style: .destructive,handler: {(action) in
                do{
                    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let filePath = docDir.appendingPathComponent(fileNameArray[indexPath.row])
                    try FileManager.default.removeItem(atPath: filePath.path)
                    fileNameArray.remove(at: indexPath.row)
                    tableView.reloadData()
                    if fileNameArray.count == 0 {
                        tableView.isHidden = true
                        self.noFilesView.isHidden = false
                    }else{
                        tableView.isHidden = false
                        self.noFilesView.isHidden = true
                    }
                    print("deleted")
                }catch{
                    print("not deleted")
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: {(action) -> Void in self.dismiss(animated: true)
            })
    
            alert.addAction(cancel)
            alert.addAction(yes)
            self.present(alert, animated: true)
            
           
        }
        let downloadAction = UIContextualAction(style: .normal, title: "Download"){(action,view,handler) in
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let newFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileNameArray[indexPath.row])
            let data = try? Data(contentsOf: docDir.appendingPathComponent(fileNameArray[indexPath.row]))
            try?data?.write(to: newFilePath,options: .atomic)
            let activityViewController = UIActivityViewController(activityItems: [newFilePath], applicationActivities: [])
            self.present(activityViewController, animated: true)
        }
        deleteAction.backgroundColor = .red
        downloadAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,downloadAction])
        return configuration
    }
    
    
    
    @IBAction func filePicker(_ sender: UIBarButtonItem) {
            
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf,.text])
        filePicker.delegate = self
        present(filePicker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else{
            return
        }
        //print("Selected file url ~~~>>> \(selectedFileUrl)")
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfUrl  = selectedFileUrl.lastPathComponent
        let savePdfUrl = documentDirectory.appendingPathComponent(pdfUrl)
        let accessGranted = selectedFileUrl.startAccessingSecurityScopedResource()
        if accessGranted{
            do{
                try FileManager.default.copyItem(at: selectedFileUrl, to: savePdfUrl)
                print("~~~~>>>> pdf saved succcessfully")
                fileNameArray.append(pdfUrl)
                print(fileNameArray)
                if fileNameArray.count == 0 {
                    tableView.isHidden = true
                    noFilesView.isHidden = false
                }else{
                   tableView.reloadData()
                    tableView.isHidden = false
                    noFilesView.isHidden = true
                }
                print("save pdf url ~~~>>> \(savePdfUrl)")
                tableView.reloadData()
            }catch{
                print("~~~~~~>>>>>>> \(error)")
                customAlert(title: "Alert!!", message: "Item with the same name alreay exist")
            }}else{
                customAlert(title: "Alert!!", message: "Permission not granted")
            }
    }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}
