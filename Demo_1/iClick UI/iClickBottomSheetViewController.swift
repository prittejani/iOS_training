//
//  BottomSheetViewController.swift
//  Demo_1
//
//  Created by iMac on 23/05/24.
//

import UIKit

class iClickBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomsheetView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let settingName = ["Collections","Comment Likes","Followers","Likes","Donate"]
    
    @IBOutlet weak var closeButton: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 16.0
        backView.clipsToBounds = true
        bottomsheetView.layer.cornerRadius = 18.0
        bottomsheetView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        closeButton.layer.cornerRadius = closeButton.frame.size.height/2
        closeButton.clipsToBounds = true
        closeButton.layer.borderWidth = 1.0
        closeButton.layer.borderColor = UIColor.systemGray5.cgColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCloseButtonTapped(_:)))
        closeButton.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func onCloseButtonTapped(_ sender : UITapGestureRecognizer){
     
        self.dismiss(animated: true)
    }
}
extension iClickBottomSheetViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BottomSheetTableViewCell
        cell.lblSettingName.text = settingName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
