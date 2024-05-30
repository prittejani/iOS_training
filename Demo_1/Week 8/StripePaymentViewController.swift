//
//  StripePaymentViewController.swift
//  Demo_1
//
//  Created by iMac on 08/05/24.
//

import UIKit
import Stripe
import SVProgressHUD


class StripePaymentViewController: UIViewController {
    
    @IBOutlet weak var paymentButton: UIButton!
    let secretKey = "sk_test_51PE3n1EDo3VmufhKpWQZeJir6vnuSLpkRrmoj1jKvPdL3O57jorwKdTF8tBENxE3Z3aTN3kcAPZ589MwCpD5vC5V00iTISQesd"
    var paymentSheet:PaymentSheet!
    var CustomerId:String = ""
    var epharmalKey:String = ""
    var clientSecret:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentButton.isHidden = true
        createCustomer()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            SVProgressHUD.dismiss()
            self.paymentButton.isHidden = false
        }
    }


    @IBAction func openPaymentSheet(_ sender: UIButton) {
       
        self.paymentSheet.present(from: self){paymentResult in
            switch paymentResult {
            case .completed:
                self.customAlert(title: "Thank you", message: "Payment received successfully.")
                print("Payment complete")
            case .canceled:
                self.customAlert(title: "Cancel", message: "Payment is canceled.")
                print("Payment canceled")
            case .failed(let error):
                self.customAlert(title: "Sorry..", message: "Payment is failed to unknow error")
                print("Payment failed: \(error)")
            }
        }
    }
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    func createCustomer() {
        let url = URL(string: "https://api.stripe.com/v1/customers")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let customerData:Data = "name=Prit Tejani&email=prittejani40@gmail.com".data(using: .utf8)!
        request.httpBody = customerData
        
  
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
       
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let customerId = json["id"] as? String {
                   
                    self.CustomerId = customerId
                    print("Customer ID:", self.CustomerId)
                  self.createEphemeralKey()
                } else if let errorMessage = json["error"] as? [String: Any],
                          let message = errorMessage["message"] as? String {
                    print("Error:", message)
                }
            }
        }
        task.resume()
    }

    func createEphemeralKey() {
    
        let urlString = "https://api.stripe.com/v1/ephemeral_keys"
        guard let url = URL(string: urlString) else { return }
        
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("2024-04-10", forHTTPHeaderField: "Stripe-Version")
        
        let parameters = "customer=\(CustomerId)".data(using: .utf8)
        request.httpBody = parameters
       
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let ephemeralKeySecret = json["secret"] as? String {
                
                    self.epharmalKey = ephemeralKeySecret
                    print(self.epharmalKey)
                    self.createPaymentIntent()
                    
                } else {
                    let error = NSError(domain: "Invalid Response", code: 0, userInfo: nil)
                    print(error)
                }
            } catch {
                print("Catch ~~>> \(error)")
            }
        }.resume()
    }


    func createPaymentIntent(){
     
        let urlString = "https://api.stripe.com/v1/payment_intents"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        
    
        let parameters = "amount=1000000&currency=INR&customer=\(CustomerId)"
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let clientSecret = json["client_secret"] as? String {
                   
                    self.clientSecret = clientSecret
                    print(self.clientSecret)
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "Prit"
                    configuration.allowsDelayedPaymentMethods = true
                    configuration.customer = .init(id: self.CustomerId, ephemeralKeySecret: self.epharmalKey)
                    
                    self.paymentSheet = PaymentSheet(paymentIntentClientSecret: self.clientSecret, configuration: configuration)
                    
      
                } else {
                    let error = NSError(domain: "Invalid Response", code: 0, userInfo: nil)
                    print(error)
                }
            } catch {
                print(error)
                
            }
        }.resume()
    }
}
