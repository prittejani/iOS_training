//
//  MVCViewController.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import UIKit

class MVCViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    var allMvcData:[MVCDataModel] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVC Model"
        
        tableView.delegate = self
        tableView.dataSource = self


        APIManager.shared.getFakePostData{
            data in
            if let posts = data {
                self.allMvcData = posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }else{
                print("error ")
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMvcData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mvcTableViewCell
        cell.lblTitle.text = "\(self.allMvcData[indexPath.row].title)"
        cell.lblDescription.text = "\(allMvcData[indexPath.row].body)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

