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
import FirebaseCore
import FirebaseAuth
import CryptoKit
import FirebaseAnalytics

class GoogleSigninViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding{
  
    @IBOutlet var lblResetPassword: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var lblRegistration: UILabel!
  
    @IBOutlet var vStack: UIStackView!
    @IBOutlet var fbLoginButton: UIButton!
    @IBOutlet var emailField: UITextField!
    fileprivate var currentNonce: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current,
            !token.isExpired {
            
        }

        lblRegistration.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRegisterTapped(_:))))
        
        lblResetPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResetPasswordTapped(_:))))
        
        fbLoginButton.addTarget(self, action: #selector(onFacebookLoginTapped), for: .touchUpInside)
        
    }
    @objc func onFacebookLoginTapped() {
        let loginManager = LoginManager()
                loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
                    if let error = error {
                        print("Failed to login: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                            return
                        }
                        UserDefaults.standard.set("viaFacebook", forKey: "loginForm")
                        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                        Switcher.updateRootVC(status: true)

                        // User is signed in
                        print("User is signed in: \(authResult?.user.displayName ?? "")")
                    }
                }
     }
    
    
    @objc func onResetPasswordTapped(_ sender: UITapGestureRecognizer){
        let vc = week1StoryBoard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        present(vc, animated: true)
        
     //   navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onRegisterTapped(_ sender: UITapGestureRecognizer){
        print("tapped")
        let vc = week1StoryBoard.instantiateViewController(withIdentifier: "RegistraionViewController") as! RegistraionViewController
        self.present(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func emailPasswordLoginTapped(_ sender: UIButton) {
        guard let email = emailField.text else{ return }
        guard let password = passwordField.text else{ return }
        
        if (email != "") && (password != ""){
            
            Auth.auth().signIn(withEmail: email, password: password){  authResult, error in
           
                if let error = error {
                    self.customAlert(title: "\(error.localizedDescription)", message: "")
                    print(error.localizedDescription)
                    return
                }else{
                    print(authResult?.user.uid)
                    
                    UserDefaults.standard.set("viaFirebase", forKey: "loginForm")
                    Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                    Switcher.updateRootVC(status: true)
                    self.customAlert(title: "Success", message: "Email login successfully")
                    print("sign in success with email password")
                }
              
              }
            
        }else{
            self.customAlert(title: "Alert!", message: "Please enter email or password")
            print("email or password required")
        }
        
    }
    
    
 
    @IBAction func appleLogin(_ sender: Any) {
        let nonce = randomNonceString()
        currentNonce = nonce
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
                self.customAlert(title: "\(error.localizedDescription)", message: "")
                    print("~~~>>> \(error)")
            }else{
                
                guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString
                else {
                
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.idToken!.tokenString)
                Auth.auth().signIn(with: credential){
                    authResult,error in
                    if let error = error {
                        self.customAlert(title: "\(error.localizedDescription)", message: "")
                        return
                    }
                    
                }
                
                print(user.profile?.name ?? "")
                print(user.profile?.imageURL(withDimension: 320))
                UserDefaults.standard.setValue("viaGoogle", forKey: "loginForm")
                Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
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
        
        guard let nonce = currentNonce else {
               fatalError("Invalid state: A login callback was received, but no login request was sent.")
             }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
             print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
             return
           }
        
        if let userIDData = userIdentifier.data(using: .utf8),let familyName = appleIDCredential.fullName?.givenName?.data(using: .utf8),let email = appleIDCredential.email!.data(using: .utf8){
             
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                       idToken: idTokenString,
                                                       rawNonce: nonce)
            Auth.auth().signIn(with: credential){
                (authResult,error) in
                if let error = error {
                    self.customAlert(title: "\(error.localizedDescription)", message: "")
                
                    return
                }else{
                    Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                    KeychainHelper.standard.save(userIDData, service: "com.app.pocketcoach", account: "appleID")
                    KeychainHelper.standard.save(familyName, service: "com.app.pocketcoach", account: "givenName")
                    KeychainHelper.standard.save(email, service: "com.app.pocketcoach", account: "email")
                    self.customAlert(title: "Apple Signin successfull", message: "")
                }
            }
            
            
        }
        
    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
        
        UserDefaults.standard.setValue("viaApple", forKey: "loginForm")
        Switcher.updateRootVC(status: true)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

        
}


