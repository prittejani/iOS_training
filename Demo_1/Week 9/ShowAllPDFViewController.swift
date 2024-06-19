//
//  ShowAllPDFViewController.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit
var pdfNames = Array<String>()
class ShowAllPDFViewController: UIViewController {


    let temporaryDirectory = NSTemporaryDirectory()
    let fileManager = FileManager.default
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getFileNames()
        title = "All PDFs"
        tableView.reloadData()
    }
    func getFileNames(){
        print(FileManager.default.temporaryDirectory.absoluteURL)
        do {
        
            let contents = try fileManager.contentsOfDirectory(atPath: temporaryDirectory)
            for file in contents {
                let filePath = temporaryDirectory + file
                if fileManager.fileExists(atPath: filePath) {
                    let fileExtension = (file as NSString).pathExtension
                    if fileExtension == "pdf" {
                        pdfNames.append(file)
                    }
                }
            }
        } catch {
            print("Error accessing temporary directory: \(error)")
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
extension ShowAllPDFViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllPDFTableViewCell
        cell.lblPDFName.text = pdfNames[indexPath.row]
        return cell
    }
}
