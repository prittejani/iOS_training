//
//  HometabbarViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit

class HometabbarViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
extension HometabbarViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! testTableViewCell
        cell.lbl.text = "Item \(indexPath.row)"
        return cell
    }
}
