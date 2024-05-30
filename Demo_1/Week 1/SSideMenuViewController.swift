//
//  SideMenuViewController.swift
//  Demo_1
//
//  Created by iMac on 02/04/24.
//

import UIKit

class SSideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tkName = [1,2,3,4,5,6,7,8,9,10]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }


}
extension SSideMenuViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tkName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InbuiltSidebarTableViewCell1
            cell.userImage.image = UIImage(named: "w1")
            cell.userName.text = "Bruno Pham"
            return cell
        }else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! InbuiltSidebaeTableViewCell2
            cell2.lblTask.text = "\(tkName[indexPath.row])"
            return cell2

        }
    }
    
 
    
}
