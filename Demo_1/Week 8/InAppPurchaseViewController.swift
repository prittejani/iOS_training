//
//  InAppPurchaseViewController.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import UIKit
import StoreKit
import SVProgressHUD

class InAppPurchaseViewController: UIViewController,SKPaymentTransactionObserver{
    
    
    @IBOutlet weak var lblPurchaseStartDate: UILabel!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet weak var lblPurchseEndDate: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    private var model = [SKProduct]()
    
    @IBOutlet var purchaseLabel: UILabel!

    enum Product:String,CaseIterable{
        case monthlySubscription = "pocketcoach.month"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        purchaseLabel.isHidden = true
      purchaseButton.isHidden = true
        fetchReceiptAndVerify()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("in the process")
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                fetchReceiptAndVerify()
                print("purchased")
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("fail")
            case .restored:
                SKPaymentQueue.default().restoreCompletedTransactions()
                fetchReceiptAndVerify()
                print("restored")
            case .deferred:
                print("deffered")
            default: break
            }
        }
    }
    
    func purchase(aproduct:SKProduct){
        let payment = SKPayment(product: aproduct)
        SKPaymentQueue.default().add(payment)
        
    }
    
    @IBAction func addMonthlySubscription(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments(){
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = Product.monthlySubscription.rawValue
            SKPaymentQueue.default().add(paymentRequest)
            
        }else{
            print("user unable to make payment")
        }
        }
    func fetchReceiptAndVerify() {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            print("Receipt URL is nil")
            return
        }
        
        do {
            let receiptData = try Data(contentsOf: receiptURL)
            let receiptString = receiptData.base64EncodedString(options: [])
            verifyReceipt(receiptString: receiptString)
        } catch {
            print("Couldn't read receipt data with error: \(error)")
        }
    }
    func verifyReceipt(receiptString: String) {
        SVProgressHUD.show()
        guard let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt") else { return }
        
        let requestDictionary: [String: Any] = [
            "receipt-data": receiptString,
            "password": "96175639b463462592cf45879f894c26"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
            print("Couldn't create JSON from request dictionary")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error in request: \(error!)")
                return
            }
            
            guard let data = data else {
                print("No data returned from request")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    
                    guard let status = jsonResponse["status"] as? Int, status == 0,
                          let receipt = jsonResponse["receipt"] as? [String: Any],
                          let inApp = receipt["in_app"] as? [[String: Any]] else {
                        print("Receipt verification failed with status: \(jsonResponse["status"] ?? "unknown")")
                        DispatchQueue.main.async {
                            self.purchaseButton.isHidden = false
                            self.purchaseLabel.isHidden = true
                            SVProgressHUD.dismiss()
                        }
                        return
                    }
                    
                    // Check for the latest subscription purchase
                    var latestPurchaseDate: Date?
                    var latestExpirationDate: Date?
                    
                    for purchase in inApp {
                        if let purchaseDateStr = purchase["purchase_date"] as? String,
                           let expiresDateStr = purchase["expires_date"] as? String {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'Etc/GMT'"
                            dateFormatter.timeZone = TimeZone(identifier: "GMT")
                            
                            if let purchaseDate = dateFormatter.date(from: purchaseDateStr),
                               let expiresDate = dateFormatter.date(from: expiresDateStr) {
                                
                                // Check if this is the latest purchase
                                if latestExpirationDate == nil || expiresDate > latestExpirationDate! {
                                    latestPurchaseDate = purchaseDate
                                    latestExpirationDate = expiresDate
                                }
                            }
                        }
                    }
                    
                    if let latestExpirationDate = latestExpirationDate {
                        let currentDate = Date()
                        if currentDate <= latestExpirationDate {
                            // Subscription is active
                            let displayDateFormatter = DateFormatter()
                            displayDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            displayDateFormatter.timeZone = TimeZone(identifier: "GMT")
                            
                            DispatchQueue.main.async {
                                if let purchaseDate = latestPurchaseDate {
                                    let formattedPurchaseDate = displayDateFormatter.string(from: purchaseDate)
                                    let formattedExpiresDate = displayDateFormatter.string(from: latestExpirationDate)
                                    
                                    self.lblPurchaseStartDate.text = "Purchase Date: \(formattedPurchaseDate)"
                                    self.lblPurchseEndDate.text = "Expires Date: \(formattedExpiresDate)"
                                    
                                    print("Purchase Date: \(formattedPurchaseDate)")
                                    print("Expires Date: \(formattedExpiresDate)")
                                    
                                    self.purchaseButton.isHidden = true
                                    self.purchaseLabel.isHidden = false
                                }
                                SVProgressHUD.dismiss()
                            }
                        } else {
                            // Subscription expired
                            DispatchQueue.main.async {
                                self.purchaseButton.isHidden = false
                                self.purchaseLabel.isHidden = true
                                SVProgressHUD.dismiss()
                            }
                        }
                    } else {
                        // No valid subscription found
                        DispatchQueue.main.async {
                            self.purchaseButton.isHidden = false
                            self.purchaseLabel.isHidden = true
                            SVProgressHUD.dismiss()
                        }
                    }
                }
            } catch {
                print("Couldn't parse JSON response with error: \(error)")
                DispatchQueue.main.async {
                    self.purchaseButton.isHidden = false
                    self.purchaseLabel.isHidden = true
                    SVProgressHUD.dismiss()
                }
            }
        }
        
        task.resume()
    }

//    func verifyReceipt(receiptString: String) {
//        SVProgressHUD.show()
//        guard let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt") else { return }
//
//        let requestDictionary: [String: Any] = [
//            "receipt-data": receiptString,
//            "password": "96175639b463462592cf45879f894c26"
//        ]
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
//            print("Couldn't create JSON from request dictionary")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error in request: \(error!)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data returned from request")
//                return
//            }
//
//            do {
//                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Response: \(jsonResponse)")
//
//                    guard let status = jsonResponse["status"] as? Int, status == 0,
//                          let receipt = jsonResponse["receipt"] as? [String: Any],
//                          let inApp = receipt["in_app"] as? [[String: Any]] else {
//                        print("Receipt verification failed with status: \(jsonResponse["status"] ?? "unknown")")
//                        DispatchQueue.main.async {
//                            self.purchaseButton.isHidden = false
//                            self.purchaseLabel.isHidden = true
//                            SVProgressHUD.dismiss()
//                        }
//                        return
//                    }
//
//                    // Check for the latest subscription purchase
//                    var latestExpirationDate: Date?
//                    for purchase in inApp {
//                        if let expiresDate = purchase["expires_date"] as? String {
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'Etc/GMT'"
//                            dateFormatter.timeZone = TimeZone(identifier: "GMT")
//                            if let expirationDate = dateFormatter.date(from: expiresDate) {
//                                if latestExpirationDate == nil || expirationDate > latestExpirationDate! {
//                                    latestExpirationDate = expirationDate
//                                }
//                            }
//                        }
//                    }
//
//                    if let latestExpirationDate = latestExpirationDate {
//                        let currentDate = Date()
//                        if currentDate > latestExpirationDate {
//                            // Subscription expired
//                            DispatchQueue.main.async {
//                                self.purchaseButton.isHidden = false
//                                self.purchaseLabel.isHidden = true
//                                SVProgressHUD.dismiss()
//                            }
//                        } else {
//                            // Subscription is active
//                            DispatchQueue.main.async {
//                                self.purchaseButton.isHidden = true
//                                self.purchaseLabel.isHidden = false
//                                SVProgressHUD.dismiss()
//                            }
//                        }
//                    } else {
//                        // No valid subscription found
//                        DispatchQueue.main.async {
//                            self.purchaseButton.isHidden = false
//                            self.purchaseLabel.isHidden = true
//                            SVProgressHUD.dismiss()
//                        }
//                    }
//                }
//            } catch {
//                print("Couldn't parse JSON response with error: \(error)")
//                DispatchQueue.main.async {
//                    self.purchaseButton.isHidden = false
//                    self.purchaseLabel.isHidden = true
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }
//
//        task.resume()
//    }

//    func verifyReceipt(receiptString: String) {
//        SVProgressHUD.show()
//        guard let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt") else { return }
//
//        let requestDictionary: [String: Any] = [
//            "receipt-data": receiptString,
//            "password": "96175639b463462592cf45879f894c26"
//        ]
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
//            print("Couldn't create JSON from request dictionary")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error in request: \(error!)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data returned from request")
//                return
//            }
//
//            do {
//                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Response: \(jsonResponse)")
//                    if let status = jsonResponse["status"] as? Int, status == 0,
//                       let receipt = jsonResponse["receipt"] as? [String: Any],
//                       let inApp = receipt["in_app"] as? [[String: Any]] {
//                        for purchase in inApp {
//                            if let purchaseDate = purchase["purchase_date"] as? String,
//                               let expiresDate = purchase["expires_date"] as? String {
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'Etc/GMT'"
//                                dateFormatter.timeZone = TimeZone(identifier: "GMT")
//
//                                if let date = dateFormatter.date(from: expiresDate), let ddate = dateFormatter.date(from: purchaseDate) {
//                                        let displayDateFormatter = DateFormatter()
//                                        displayDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        displayDateFormatter.timeZone = TimeZone(identifier: "GMT")
//
//                                        let formattedPurchaseDate = displayDateFormatter.string(from: ddate)
//                                        let formattedExpiresDate = displayDateFormatter.string(from: date)
//
//                                        DispatchQueue.main.async {
//                                            self.lblPurchaseStartDate.text = "Purchase Date: \(formattedPurchaseDate)"
//                                            self.lblPurchseEndDate.text = "Expires Date: \(formattedExpiresDate)"
//
//                                            print("Purchase Date: \(formattedPurchaseDate)")
//                                            print("Expires Date: \(formattedExpiresDate)")
//                                            self.purchaseButton.isHidden = true
//                                            self.purchaseLabel.isHidden = false
//                                            SVProgressHUD.dismiss()
//                                        }
//                                        print("purchase not expired")
//                                }
//                            }
//                        }
//
//                    } else {
//                        print("Receipt verification failed with status: \(jsonResponse["status"] ?? "unknown")")
//                    }
//                }
//            } catch {
//                print("Couldn't parse JSON response with error: \(error)")
//            }
//        }
//
//        task.resume()
//    }
}
