//
//  MVVMViewController.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import UIKit

class MVVMViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var mvvmArray:[mvvmViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM"
        tableView.register(UINib(nibName: "mvvmTableViewCell", bundle: nil), forCellReuseIdentifier: "mvvmTableViewCell")
        self.fetchData()
        
    }
    func fetchData(){
        Services.shared.fetchData{
            data,error in
            if let error = error {
                print(error)
                return
            }
            
            self.mvvmArray = data!.map({return mvvmViewModel(mvvmList: $0)})
            print(self.mvvmArray)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
                
            
        }
    }
}
extension MVVMViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mvvmArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mvvmTableViewCell", for: indexPath) as! mvvmTableViewCell
        cell.todo = self.mvvmArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
