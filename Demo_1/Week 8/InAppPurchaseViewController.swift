//
//  InAppPurchaseViewController.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class InAppPurchaseViewController: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver{
    
    
    @IBOutlet weak var lblPurchaseStartDate: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPurchseEndDate: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    private var model = [SKProduct]()
    var pName:String!
    enum Product:String,CaseIterable{
        case monthlySubscription = "pocketcoach.month"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        lblProductName.text = "Monthly Plan"
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let oProduct = response.products.first{

            print("product is available")
            self.purchase(aproduct: oProduct)
        }else{
            print("product is not available")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("in the process")
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchased")
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("fail")
            case .restored:
                print("restored")
            case .deferred:
                print("deffered")
            default: break
            }
        }
    }
    
    func purchase(aproduct:SKProduct){
        let payment = SKPayment(product: aproduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
        
    }
    
    @IBAction func addMonthlySubscription(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments(){
            let set:Set<String> = [Product.monthlySubscription.rawValue]
            let productRequest = SKProductsRequest(productIdentifiers: set)
            productRequest.delegate = self
            productRequest.start()
        }
    }
    func fetchData(){
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "96175639b463462592cf45879f894c26")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "pocketcoach.month"
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}
//extension InAppPurchaseViewController:UITableViewDelegate,UITableViewDataSource{
//    
//}
