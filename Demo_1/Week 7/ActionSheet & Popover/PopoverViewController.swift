//
//  PopoverViewController.swift
//  Demo_1
//
//  Created by iMac on 30/04/24.
//

import UIKit

class PopoverViewController: UIViewController {
    var didSelectItem: ((String) -> Void)?

    var foodName = Array<String>()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        foodName = ["Indian", "Chinese", "Thai", "Italian", "Japanese", "Mexican", "French","Amrerican","Spanish","Korean"]
    }
    
    @IBAction func onCancelTapped(_ sender: UIButton) {
        didSelectItem?("Popover")
        dismiss(animated: true)
    }
}
extension PopoverViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PopOverTableViewCell
        cell.lblName.text = foodName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let selectedItem = foodName[indexPath.row]
//        didSelectItem?(selectedItem)
        dismiss(animated: true,completion: nil)
    }
    
}
