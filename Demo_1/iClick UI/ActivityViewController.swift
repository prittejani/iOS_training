//
//  ActivityViewController.swift
//  Pods
//
//  Created by iMac on 23/05/24.
//

import UIKit

class ActivityViewController: UIViewController{

    var activityProfileImage:[UIImage] = [UIImage(named: "model1")!,UIImage(named: "model2")!,UIImage(named: "model3")!,UIImage(named: "model4")!]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let navView = UIView()
        navView.backgroundColor = .yellow
        navView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        
        let activityLabel = UILabel()
        activityLabel.text = "Activity"
        
        let stackView = UIStackView(arrangedSubviews: [activityLabel])
        stackView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        navigationItem.titleView = stackView
        navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
    
    @IBAction func onSettingTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "iClickBottomSheetViewController") as! iClickBottomSheetViewController
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 25.0
            sheet.prefersGrabberVisible = true
            present(vc, animated: true, completion: nil)
        }
    }
}

extension ActivityViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell
        cell.userProfileImage.image = activityProfileImage.randomElement()
        if indexPath.row % 2 == 0 {
            cell.likeIcon.isHidden = false
            
            cell.postedImage.contentMode = .scaleAspectFit
            let texts = ["added", "liked"]
            cell.lblLikedOrAdded.text = texts.randomElement()
            cell.postedImage.image = UIImage(named: "w2")
        }else{
            cell.likeIcon.isHidden = true
            cell.postedImage.contentMode = .center
            let texts = ["added", "liked"]
            cell.lblLikedOrAdded.text = texts.randomElement()
            
            cell.postedImage.image = UIImage(named: "followButton")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
