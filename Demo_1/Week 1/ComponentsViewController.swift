//
//  ComponentsViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

class ComponentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let datePicker = UIDatePicker()
    
    var componentsArray = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        componentsArray = ["Label","Button","TextField","DatePicker","Slider","Switch","Stepper","ProgressBar","Collection View","Table View","SegmentControl"]
        navigationItem.title = "UI Components"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentsCell", for: indexPath) as! ComponentsTableViewCell
        cell.lblComponents.text = componentsArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentsArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let alert = UIAlertController(title: "Label", message: "you can see the lable in table view text, that is label", preferredStyle: .alert)
    
            let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(saveAction)
            present(alert, animated: true)
        } else if indexPath.row == 1{
            let alert = UIAlertController(title: "Button", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [self]
                save -> Void in
                let coverdalert = UIAlertController(title: "Your Button Action is ", message: "You Tapped button", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                present(coverdalert, animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }else if indexPath.row == 2{
            let alert = UIAlertController(title: "Textfield", message: "", preferredStyle: .alert)
            alert.addTextField { [self] (textField : UITextField!) in
                textField.placeholder = "Enter Email"
                textField.delegate = self
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [self]
                save -> Void in
                
                let textfield =  alert.textFields![0] as UITextField
                if var val = textfield.text{
                    val = textfield.text!
                    if isValidEmail(email: val) {
                        let coverdalert = UIAlertController(title: "Your email is ", message: "\(val)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        coverdalert.addAction(okAction)
                        present(coverdalert, animated: true)}
                    else{
                        
                        let coverdalert = UIAlertController(title: "Email is not valid", message: "try again!!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        coverdalert.addAction(okAction)
                        present(coverdalert, animated: true)
                    }}
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }else if indexPath.row == 3{
            let myDatePicker: UIDatePicker = UIDatePicker()
            myDatePicker.datePickerMode = .date
            myDatePicker.preferredDatePickerStyle = .wheels
            myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
            let alertController = UIAlertController(title: "Date Pickr\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
            alertController.view.addSubview(myDatePicker)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let coverdalert = UIAlertController(title: "Your Date is ", message: "\(dateFormatter.string(from: myDatePicker.date))", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                self.present(coverdalert, animated: true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }else if indexPath.row == 4{
            let slider:UISlider = UISlider()
            
            let alertController = UIAlertController(title: "Slider", message: nil, preferredStyle: .alert)
            slider.minimumValue = 10
            slider.maximumValue = 30
            alertController.view.addSubview(slider)
            slider.frame = CGRect(x: 90, y: 10, width: 100, height:80)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                
                slider.value = round(slider.value)
                let coverdalert = UIAlertController(title: "Your Slider value is ", message: "\(slider.value)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                self.present(coverdalert, animated: true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }else if indexPath.row == 5{
            let Switch:UISwitch = UISwitch()
            
            let alertController = UIAlertController(title: "Switch\n", message: nil, preferredStyle: .alert)
            
            alertController.view.addSubview(Switch)
            Switch.frame = CGRect(x: 100, y: 50, width: 100, height:80)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                var switchValue = ""
                if Switch.isOn {
                    switchValue = "ON"
                }else{
                    switchValue = "OFF"
                }
                let coverdalert = UIAlertController(title: "Switch is ", message: "\(switchValue)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                self.present(coverdalert, animated: true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }else if indexPath.row == 6 {
            let Steper:UIStepper = UIStepper()
            
            let alertController = UIAlertController(title: "Stepper\n", message: nil, preferredStyle: .alert)
            
            alertController.view.addSubview(Steper)
            Steper.frame = CGRect(x: 100, y: 50, width: 100, height:80)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                
                let coverdalert = UIAlertController(title: "Stepper value is", message: "\(Steper.value.description)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                self.present(coverdalert, animated: true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }else if indexPath.row == 7 {
            let ProgressView:UIProgressView = UIProgressView()
        
            let alertController = UIAlertController(title: "Progress View\n", message: nil, preferredStyle: .actionSheet)
            let progress = Progress(totalUnitCount: 4)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
                (timer) in
                guard progress.isFinished == false else{
                    timer.invalidate()
                    return
                }
                progress.completedUnitCount += 1
                ProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
            })
              ProgressView.tintColor = self.view.tintColor
            alertController.view.addSubview(ProgressView)
            ProgressView.frame = CGRect(x: 130, y: 50, width: 100, height:80)
            let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                
                let coverdalert = UIAlertController(title: "Progress value is", message: "\(ProgressView.progress)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                coverdalert.addAction(okAction)
                self.present(coverdalert, animated: true)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }else if indexPath.row == 8 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9 {
            let alert = UIAlertController(title: "Table View", message: "you are already in table view", preferredStyle: .alert)
    
            let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }else if indexPath.row == 10 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SegmentViewController") as! SegmentViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
