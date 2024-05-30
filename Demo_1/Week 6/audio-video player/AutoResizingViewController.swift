//
//  AutoResizingViewController.swift
//  Demo_1
//
//  Created by iMac on 26/04/24.
//

import UIKit
import MediaPlayer

class AutoResizingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        }
    override func viewWillAppear(_ animated: Bool) {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                // Permission granted, fetch audio files
                self.fetchAudioFiles()
            } else {
                print("Permission denied to access media library.")
            }
        }
                tableView.estimatedRowHeight = 100
                tableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchAudioFiles() {
        let mediaQuery = MPMediaQuery.playlists()
        guard let items = mediaQuery.items else {
            print("No audio files found.")
            return
        }
        
        for item in items {
            guard let title = item.title else { continue }
            print("Title: \(title)")
            // You can access other metadata properties of the audio file here
        }
    }
}
extension AutoResizingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! resizingTableViewCell
            cell.photo.image = UIImage(named: "r14")
            cell.lblOne.text = "iOS Development"
            cell.lblThree.text = "11.00"
            cell.lblTwo.text = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
            return cell
        
    }
}


