//
//  AutoResizingViewController.swift
//  Demo_1
//
//  Created by iMac on 26/04/24.
//

import UIKit

class AutoResizingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}
extension AutoResizingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! resizingTableViewCell
            cell.photo.image = UIImage(named: "r14")
            cell.lblOne.text = "iOS Development"
            cell.lblThree.text = "11.00"
            cell.lblTwo.text = "Auto Resizing Demo"
            return cell
        }else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! resizingTableViewCell2
            cell2.photo2.image = UIImage(named: "r2")
            cell2.lblq.text = "iOS Development"
            cell2.lbls.text = "11.00"
            cell2.lblr.text = "Auto Resizing Demo"
            return cell2
        }
    }
}

