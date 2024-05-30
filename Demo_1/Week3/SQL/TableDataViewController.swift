//
//  TableDataViewController.swift
//  sql
//
//  Created by iMac on 28/02/24.
//

import UIKit
var users = Array<UserModel>()
let sqlStoryBoard = UIStoryboard(name: "sql", bundle: nil)
class TableDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoRecoordFound: UILabel!
    var db = SqlHelper()
   
   
    var longPressGesture: UILongPressGestureRecognizer!
       
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressedRecognized(_:)))
        self.tableView.addGestureRecognizer(longPressGesture)
        print(users.count)
        tableView.reloadData()
        print("~~>> print data \(db.read())")
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        users = db.read()
        print(users.count)
        if users.count != 0{
            lblNoRecoordFound.isHidden = true
            tableView.isHidden = false
        }else{
            lblNoRecoordFound.isHidden = false
            tableView.isHidden = true
        }
        tableView.reloadData()
    }
    @IBAction func addUser(_ sender: UIButton) {
        let vc = sqlStoryBoard.instantiateViewController(withIdentifier: "ViewController4") as! ViewController4
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomSQLTableViewCell
        cell.lblName.text = users[indexPath.row].name + "     " + users[indexPath.row].mobileno + "     " + users[indexPath.row].email
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [self](action,view,handler) in
            let alert = UIAlertController(title: "do you want to delete this record?", message: "", preferredStyle: .alert)
                
            let yes = UIAlertAction(title: "Yes", style: .destructive,handler: {(action) in
                self.db.delete(id: users[indexPath.row].id)
                users.remove(at: indexPath.row)
                users = self.db.read()
                tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: {(action) -> Void in self.dismiss(animated: true)
            })
    
            alert.addAction(cancel)
            alert.addAction(yes)
            self.present(alert, animated: true)

            if users.count != 0{
                lblNoRecoordFound.isHidden = true
                tableView.isHidden = false
            }else{
                lblNoRecoordFound.isHidden = false
                tableView.isHidden = true
            }
            
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController4") as! ViewController4
        vc.user = users[indexPath.row]
        vc.fromTableView = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func  longPressedRecognized(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            if let section = self.tableView.indexPathForRow(at: sender.location(in: self.tableView))?.section{
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
            }
        }
    }
}
