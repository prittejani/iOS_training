//
//  ExpandableTableViewViewController.swift
//  test
//
//  Created by USER on 03/06/24.
//

import UIKit


struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool
}

var data:[FAQItem]!
class ExpandableTableViewViewController: UIViewController {

  
    @IBOutlet var tableView: UITableView!
    var expandedCell:IndexSet = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expandable TableView"
        tableView.delegate = self
        tableView.dataSource = self

        data = [
        
        FAQItem(question: "What is your return policy?", answer: "Our return policy allows you to return items within 30 days of purchase. Items must be in their original condition, with all tags attached, and accompanied by the original receipt or proof of purchase. Please note that certain items, such as personalized products and perishable goods, are non-returnable. For more information, visit our Return Policy page.", isExpanded: false),
        FAQItem(question: "How can I track my order?", answer: "Once your order has been shipped, you will receive a confirmation email with a tracking number. You can use this tracking number on our Order Tracking page to monitor the status of your delivery. If you have any issues or do not receive your tracking information, please contact our customer service team.", isExpanded: false),
        FAQItem(question: "What payment methods do you accept?", answer: "We accept a variety of payment methods including Visa, MasterCard, American Express, Discover, PayPal, and Apple Pay. For more details on payment options, visit our Payment Information page.", isExpanded: false),
        FAQItem(question: "How do I contact customer support?", answer: "You can reach our customer support team by email at support@example.com or by phone at (123) 456-7890. Our support hours are Monday to Friday, 9 AM to 5 PM. You can also visit our Contact Us page for more ways to get in touch.", isExpanded: false),
        FAQItem(question: "Do you offer international shipping?", answer: "Yes, we offer international shipping to many countries. Shipping rates and delivery times vary depending on the destination. For a full list of countries we ship to and more details on international shipping, please visit our Shipping Information page.", isExpanded: false)
        ,
        FAQItem(question: "Do you offer international shipping?", answer: "Yes, we offer international shipping to many countries. Shipping rates and delivery times vary depending on the destination. For a full list of countries we ship to and more details on international shipping, please visit our Shipping Information page,Yes, we offer international shipping to many countries. Shipping rates and delivery times vary depending on the destination. For a full list of countries we ship to and more details on international shipping, please visit our Shipping Information page,Yes, we offer international shipping to many countries. Shipping rates and delivery times vary depending on the destination. For a full list of countries we ship to and more details on international shipping, please visit our Shipping Information page.", isExpanded: false)
        ]
        
    }
    
}
extension ExpandableTableViewViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExpandableTableViewCell
        cell.lblQuestion.text = data[indexPath.row].question
        cell.lblAnswer.text = data[indexPath.row].answer
        if expandedCell.contains(indexPath.row){
            cell.lblAnswer.numberOfLines = 0
            cell.expandButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        }else{
            cell.expandButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.lblAnswer.text = ""
        }
        cell.expandedClick = {
            if self.expandedCell.contains(indexPath.row){
                self.expandedCell.remove(indexPath.row)
               data[indexPath.row].isExpanded = false
            }else{
                self.expandedCell.insert(indexPath.row)
                data[indexPath.row].isExpanded = true
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedCell.contains(indexPath.row){
            expandedCell.remove(indexPath.row)
            data[indexPath.row].isExpanded = false
        }else{
            expandedCell.insert(indexPath.row)
            data[indexPath.row].isExpanded = true
        }
        
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    
   
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedCell.contains(indexPath.row){
            return UITableView
                .automaticDimension
        }else{
            return 50
        }
        
    }
}
