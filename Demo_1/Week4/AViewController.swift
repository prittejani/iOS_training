//
//  ViewController.swift
//  Webservices
//
//  Created by iMac on 04/03/24.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class AViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{


    @IBOutlet var tableView: UITableView!
    var getUserId:Int = 0
    var users:[Datum] = []
   let activityIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchData(){
            [weak self](users) in
            self?.users = users
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
        tableView.tableFooterView = activityIndicator
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    @objc func refreshData(){
        fetchData(){
            [weak self](users) in
            self?.users = users
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
          self.tableView.refreshControl?.endRefreshing()
          self.tableView.reloadData()
        }
    }

    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
   
        navigationController?.popViewController( animated: true)
    }
    
    func fetchData(completionHandler: @escaping ([Datum]) -> Void){
        SVProgressHUD.show()
        guard let apiUrl = URL(string: "http://192.168.29.72/blog/api/get_user_list") else { return }

        let task = URLSession.shared.dataTask(with: apiUrl,completionHandler: { data,response,error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data{
                print(data)
            }
            let decoder = JSONDecoder()
            if let data = data, let AllUsers = try? decoder.decode(User.self,from: data){
                SVProgressHUD.dismiss()
                completionHandler(AllUsers.data)
                print(AllUsers.data)
            }
        })
        task.resume()
    }
    
    
//    func fetchData(completionHandler: @escaping ([Datum]) -> Void) {
//        let apiUrl = "http://192.168.29.41/blog/api/get_user_list"
//        
//        AF.request(apiUrl,method: .get,encoding: JSONEncoding.default).responseDecodable(of: User.self) { response in
//            switch response.result {
//            case .success(let user):
//                completionHandler(user.data)
//                print(user.data)
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
    
    func deleteData(id:Int){
        let parameters: [String: Any] = [
            "user_id": id
          ]
          
          let url = "http://192.168.29.72/blog/api/delete_user"
          
          AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
              switch response.result {
              case .success(let data):
                  print("User deleted successfully: \(data)")
                  self.fetchData(){
                      [weak self](users) in
                      self?.users = users
                      DispatchQueue.main.async {
                          self!.tableView.reloadData()
                      }
                  }
        
              case .failure(let error):
                  print("Error creating user: \(error)")
                  
              }
          }
    }
    
    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPaginationTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDataViewController") as! PostDataViewController
        navigationController?.pushViewController(vc, animated: true)
    }

     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            if section == 0 {
                return 100
            }
            return 0
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        vc.user = users
        vc.fromCell = true
        vc.index = indexPath.row
    
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApiTableViewCell
        cell.lblUserName.text = users[indexPath.row].name
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
        cell.userImage.clipsToBounds = true
        let url = URL(string: users[indexPath.row].profilePic)
        cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
//        cell.userImage.loadImage(fromURL: url!, placeHolderImage: "user")
        return cell
    }
//    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){(action,view,handler) in
            let alert = UIAlertController(title: "do you want to delete this record?", message: "", preferredStyle: .alert)
                
            let yes = UIAlertAction(title: "Yes", style: .destructive,handler: {(action) in
                do{
                    self.deleteData(id: self.users[indexPath.row].userID)
                
                    print("deleted")
                }
                tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: {(action) -> Void in self.dismiss(animated: true)
            })
    
            alert.addAction(cancel)
            alert.addAction(yes)
            self.present(alert, animated: true)
            
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}


