//
//  GoogleSigninViewController.swift
//  Demo_1
//
//  Created by iMac on 02/04/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FacebookLogin
import FBSDKLoginKit

class GoogleSigninViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding,LoginButtonDelegate{
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var fbLoginButton = FBLoginButton()
        fbLoginButton = FBLoginButton(frame: CGRect(x: self.view.frame.width/21, y: self.view.frame.height/3.4, width: self.view.frame.width/1.1, height: self.view.frame.height/22))

        view.addSubview(fbLoginButton)

        if let token = AccessToken.current,
            !token.isExpired {
            
        }
        fbLoginButton.roundCorners(corners: [.allCorners], radius: 5.0)
        fbLoginButton.permissions = ["public_profile","email"]
        fbLoginButton.delegate = self
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    
        if result!.isCancelled {
            print("user is not logined")
        }else{
            
        UserDefaults.standard.set("viaFacebook", forKey: "loginForm")
            Switcher.updateRootVC(status: true)
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    @IBAction func appleLogin(_ sender: Any) {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self){
            signInResult,error in
            if let error = error {
                    print("~~~>>> \(error)")
            }else{
                let user = signInResult?.user
                print(user?.profile?.name ?? "")
                print(user?.profile?.imageURL(withDimension: 320))
                UserDefaults.standard.setValue("viaGoogle", forKey: "loginForm")
                Switcher.updateRootVC(status: true)
            }
        }
    }
   
}

extension GoogleSigninViewController :ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "ERROR", message: "\(error.localizedDescription)", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               present(alert, animated: true, completion: nil)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    let userIdentifier = appleIDCredential.user
    let fullName = appleIDCredential.fullName
    let email = appleIDCredential.email
        
        if let userIDData = userIdentifier.data(using: .utf8),let familyName = appleIDCredential.fullName?.givenName?.data(using: .utf8),let email = appleIDCredential.email!.data(using: .utf8){
            KeychainHelper.standard.save(userIDData, service: "com.app.pocketcoach", account: "appleID")
            KeychainHelper.standard.save(familyName, service: "com.app.pocketcoach", account: "givenName")
            KeychainHelper.standard.save(email, service: "com.app.pocketcoach", account: "email")
        }
        
    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
        
        UserDefaults.standard.setValue("viaApple", forKey: "loginForm")
        Switcher.updateRootVC(status: true)
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}


