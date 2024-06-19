//
//  EmployeeListViewController.swift
//  Demo_1
//
//  Created by USER on 13/06/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import SVProgressHUD

var employeeArray:[EmployeeModel] = []
class EmployeeListViewController: UIViewController {
    
    @IBOutlet var lblNotData: UILabel!
    @IBOutlet var tableView: UITableView!
   
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        lblNotData.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        employeeArray.removeAll()
        fetchEmployeeData()
    }
 
    @IBAction func onAddEmployeeTapped(_ sender: UIBarButtonItem) {
        let vc = week10.instantiateViewController(withIdentifier: "CreateEmployeeViewController") as! CreateEmployeeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func fetchEmployeeData(){
        SVProgressHUD.show()
      let employeesRef = ref.child("employees")
      employeesRef.observeSingleEvent(of: .value, with: { (snapshot) in
          guard snapshot.exists() else {
              self.lblNotData.isHidden = false
              print("No data available")
              SVProgressHUD.dismiss()
              return
          }
          self.lblNotData.isHidden = true
          for case let child as DataSnapshot in snapshot.children {
      
              if let employeeData = child.value as? [String: Any] {
                  let name = employeeData["name"] as? String ?? "No name"
                  let designation = employeeData["designation"] as? String ?? "No designation"
                  let gender = employeeData["gender"] as? String ?? "No gender"
                  let mobileno = employeeData["mobileno"] as? String ?? "No mobileno"
                  let profileImage = employeeData["profileImage"] as? String ?? "No profileImage"
                  let salary = employeeData["salary"] as? Int ?? 0
                  let id = employeeData["id"] as? String ?? "No id"
                  let email = employeeData["email"] as? String ?? "No email"
        
                  let emp = EmployeeModel(id: id, name: name, profileImage: profileImage, designation: designation, email: email, gender: gender, mobileno: mobileno, salary: salary)
                  employeeArray.append(emp)
                  
                  self.tableView.reloadData()
              }
              SVProgressHUD.dismiss()
          }
          
          print(employeeArray)
      }) { (error) in
          self.customAlert(title: "\(error.localizedDescription)", message: "")
          print("Failed to fetch data with error: \(error.localizedDescription)")
      }

    }
    
}
extension EmployeeListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        cell.lblEmployeeName.text = employeeArray[indexPath.row].name
        let url = URL(string: employeeArray[indexPath.row].profileImage)
        cell.profileImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = week10.instantiateViewController(withIdentifier: "CreateEmployeeViewController") as! CreateEmployeeViewController
        vc.isFromCell = true
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){(action,view,handler) in
            let alert = UIAlertController(title: "do you want to delete this record?", message: "", preferredStyle: .alert)
                
            let yes = UIAlertAction(title: "Yes", style: .destructive,handler: {(action) in
     
                Database.database().reference().child("employees").child(employeeArray[indexPath.row].id).removeValue()
                let cloudStoreUrl = URL(string: employeeArray[indexPath.row].profileImage)?.lastPathComponent
                Storage.storage().reference().child("EmployeeImages/\(cloudStoreUrl!)").delete{
                    error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                print("deleted")
                employeeArray.remove(at: indexPath.row)
                self.tableView.reloadData()
                if employeeArray.isEmpty {
                    self.lblNotData.isHidden = false
                }else{
                    self.lblNotData.isHidden = true
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: {(action) -> Void in self.dismiss(animated: true)})
            alert.addAction(cancel)
            alert.addAction(yes)
            self.present(alert, animated: true)
            
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


}
