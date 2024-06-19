//
//  TodoListViewController.swift
//  Demo_1
//
//  Created by USER on 14/06/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

var todosRecord: [Todo] = []

class TodoListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let firebaseDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        fetchTodos()
    }
    func fetchTodos() {
        todosRecord.removeAll()
        let currentUserId = Auth.auth().currentUser?.uid
        db.collection("users").document(currentUserId!).collection("todos").order(by: "createDate").getDocuments {
            (querySnapshot, error) in
            if let error = error {
                self.customAlert(title: "\(error.localizedDescription)", message: "")
                return
            }
            for documents in querySnapshot!.documents {
                if let todo = Todo(dictionary: documents.data()) {
                    todosRecord.append(todo)
                }
            }
            self.tableView.reloadData()
            print("~~~~>>> \(todosRecord)")
        }
     }
    
    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        let vc = week10.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension TodoListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.lblTitle.text = todosRecord[indexPath.row].taskTitle
        cell.createDate.text = dateFormatter.string(from: todosRecord[indexPath.row].createDate)
        cell.doneDate.text = todosRecord[indexPath.row].doneDate == nil ? "" : dateFormatter.string(from: todosRecord[indexPath.row].doneDate!)
        cell.statusImage.image = todosRecord[indexPath.row].status == true ? UIImage(named: "approved") : UIImage(named: "pending")
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){(action,view,handler) in
            let alert = UIAlertController(title: "do you want to delete this record?", message: "", preferredStyle: .alert)

            let yes = UIAlertAction(title: "Yes", style: .destructive,handler: {(action) in
                let todoToDelete = todosRecord[indexPath.row]
                
                guard let userID = Auth.auth().currentUser?.uid else { return }
                
                todosRecord.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                let todoCollectionRef = db.collection("users").document(userID).collection("todos")
                let todoDocRef = todoCollectionRef.document(todoToDelete.id)

                todoDocRef.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Record Deleted Successfully")
                    }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = week10.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        vc.index = indexPath.row
        vc.isFromCell = true
        navigationController?.pushViewController(vc, animated: true)
    }

    
}
