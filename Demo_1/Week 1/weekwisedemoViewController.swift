//
//  weekwisedemoViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit
import SideMenu
import GoogleSignIn
import SDWebImage
import FacebookLogin
import FBSDKLoginKit
import AuthenticationServices

let week1StoryBoard = UIStoryboard(name: "Main", bundle: nil)
let week2StoryBoard = UIStoryboard(name: "tabbar", bundle: nil)
let week5StoryBoard = UIStoryboard(name: "googlemap", bundle: nil)
let services = UIStoryboard(name: "services", bundle: nil)
let actionSheet = UIStoryboard(name: "actionsheet", bundle: nil)
let cameraVideo = UIStoryboard(name: "cameravideo", bundle: nil)
let api = UIStoryboard(name: "api", bundle: nil)
let payment = UIStoryboard(name: "payment", bundle: nil)
let iClick = UIStoryboard(name: "iClick", bundle: nil)
let week9 = UIStoryboard(name: "week9", bundle: nil)

class weekwisedemoViewController: UIViewController{
    var weekNameArray = Array<String>()
    @IBOutlet weak var drawerView: UIView!
    var menu:SideMenuNavigationController!
    var isDrawerOpened = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var userEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        weekNameArray = ["Week 1","Week 2","Week 3","Week 4","Week 5","Week 6","Week 7","Week 8","iClick UI","Week 9"]
        
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle"{
            viaGoogle()
        }else if checkLogin == "viaApple"{
    
            viaApple()
        }else{
            viaFacebook()
        }
        drawerView.isHidden = true
        isDrawerOpened = false
        
        userImg.layer.cornerRadius = userImg.frame.width/2
        userImg.clipsToBounds = true
        
        //    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onviewTapped(_ :))))
    
    }
    @objc func onviewTapped(_ sender:UITapGestureRecognizer){
        print("view tapped")
        if isDrawerOpened{
            
            drawerView.isHidden = true
            isDrawerOpened = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isDrawerOpened{
          
            drawerView.isHidden = true
            isDrawerOpened = false
        }
    }
    
    @IBAction func onMenuTapped(_ sender: Any) {
        if isDrawerOpened{

            drawerView.isHidden = true
            isDrawerOpened = false
        }else{
            drawerView.isHidden = false
            isDrawerOpened = true
        }
     
    }
    
    func viaApple() {
            
        if let userIDData = KeychainHelper.standard.read(service: "com.app.pocketcoach", account: "appleID"),
                 let userID = String(data: userIDData, encoding: .utf8) {
            
                  print("Retrieved userID: \(userID)")
            if let familyNameData = KeychainHelper.standard.read(service: "com.app.pocketcoach", account: "givenName"),
                     let familyName = String(data: familyNameData, encoding: .utf8) {
                  self.userName.text = "\(familyName)"
                  }
            if let emailData = KeychainHelper.standard.read(service: "com.app.pocketcoach", account: "email"),
                     let email = String(data: emailData, encoding: .utf8) {
                self.userEmail.text = "\(email)"
                  }
              }
    }
    func viaGoogle(){
        GIDSignIn.sharedInstance.restorePreviousSignIn{
        user,error in
                if error == nil || user != nil {
                guard let profilePicURL = user?.profile?.imageURL(withDimension: 100) else {
                print("Failed to get profile picture URL")
                return
            }
              self.userImg.sd_setImage(with: profilePicURL, placeholderImage: UIImage(named: "google"))
              self.userName.text = user?.profile?.name
              self.userEmail.text = user?.profile?.email
            }
        }
    }
    func viaFacebook(){
            GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large)"]).start{
                    (connection,result,error) in
                    if let userData = result as? [String: Any] {
                        let email = userData["email"]
                        let name = userData["name"]
                        let id = userData["id"]
                        
                        self.userName.text = "\(name!)"
                        self.userEmail.text = "\(email!)"

                        if let pictureData = userData["picture"] as? [String: Any],
                           let picture = pictureData["data"] as? [String: Any],
                           let pictureURLString = picture["url"] as? String{
                            let url = URL(string: pictureURLString)
                            let imgData = try? Data(contentsOf: url!)
                            self.userImg.image = UIImage(data: imgData!)
                            
                           }
                     }
                }
    }
    
    @IBAction func onLogoutTapped(_ sender: UIButton) {
        
        signout()
    }
    func signout(){
        
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle"{
            Switcher.updateRootVC(status: false)
            GIDSignIn.sharedInstance.signOut()
           
        }else if checkLogin == "viaFacebook"{
            Switcher.updateRootVC(status: false)
            LoginManager().logOut()
        }else if checkLogin == "viaApple"{
            Switcher.updateRootVC(status: false)
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedOperation = .operationLogout
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.performRequests()
            print("apple logout")
            KeychainHelper.standard.delete(service: "com.app.kardder", account: "appleID")
            KeychainHelper.standard.delete(service: "com.app.kardder", account: "givenName")
            KeychainHelper.standard.delete(service: "com.app.kardder", account: "email")
        }
        
    }
    
}

class sideMenubar: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var imageUrl: Data!
    let profileImage = UIImageView()
    let lblname = UILabel()
    let lblemail = UILabel()
    let tableView = UITableView()
    var week5TaskArray = ["SMS","Call","Mail","Share","Google Map"]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(red: 147/255, green: 190/255, blue: 230/255, alpha: 1)
      
 
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle" {
            viaGoogle()
        } else {
            viaFacebook()
        }
        
        lblemail.frame = CGRect(x: self.view.frame.width/20, y: self.view.frame.height/4, width: 200, height: 21)
        lblemail.textColor = .white

        lblname.frame =  CGRect(x: self.view.frame.width/20, y: self.view.frame.height/4.6, width: 150, height: 21)
        lblname.textColor = .white
    
        let imageViewWidth: CGFloat = 90.0
        let imageViewHeight: CGFloat = 90.0
        profileImage.frame = CGRect(x: self.view.frame.width/20, y: self.view.frame.height/14, width: imageViewWidth, height: imageViewHeight)
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        
        tableView.frame = CGRect(x: 0, y: self.view.frame.height/3.3, width: self.view.frame.width, height: self.view.frame.height/1.7 )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle  = .none
        tableView.separatorColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(lblname)
        self.view.addSubview(lblemail)
        self.view.addSubview(profileImage)
        self.view.addSubview(tableView)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
                   tableView.deselectRow(at: selectedIndexPath, animated: true)
               }
    }
    
    func viaGoogle() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                guard let profilePicURL = user?.profile?.imageURL(withDimension: 100) else {
                    print("Failed to get profile picture URL")
                    return
                }
                self.profileImage.sd_setImage(with: profilePicURL, placeholderImage: UIImage(named: "google"))
                self.lblname.text = user?.profile?.name
                self.lblemail.text = user?.profile?.email
            }
        }
    }
    
    func viaFacebook() {
        GraphRequest(graphPath: "me", parameters: ["fields": "email,name,picture.type(large)"]).start { connection, result, error in
            if let userData = result as? [String: Any] {
                let email = userData["email"] as? String
                let name = userData["name"] as? String
                self.lblname.text = name
                self.lblemail.text = email
                
                if let pictureData = userData["picture"] as? [String: Any],
                   let picture = pictureData["data"] as? [String: Any],
                   let pictureURLString = picture["url"] as? String,
                   let url = URL(string: pictureURLString),
                   let imgData = try? Data(contentsOf: url) {
                    self.profileImage.image = UIImage(data: imgData)
                }
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week5TaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(week5TaskArray[indexPath.row])"
        cell.selectionStyle  = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = services.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
            navigationController?.pushViewController(vc, animated: true)
        
        case 1:
            let vc = services.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            let vc = services.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
            navigationController?.pushViewController(vc, animated: true)
        
        case 3:
            let vc = services.instantiateViewController(withIdentifier: "WhatsappShareViewController") as! WhatsappShareViewController
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = Demo_1.googleMap.instantiateViewController(withIdentifier: "GoogleMapViewController") as! GoogleMapViewController
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        self.dismiss(animated: true)
    }
}

extension weekwisedemoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weekwiseTableViewCell
        cell.lblweekName.text = "\(weekNameArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = week1StoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = week2StoryBoard.instantiateViewController(withIdentifier: "week2ViewController") as! week2ViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = sqlStoryBoard.instantiateViewController(withIdentifier: "week3wiseViewController") as! week3wiseViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let vc = api.instantiateViewController(withIdentifier: "AViewController") as! AViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            let vc = services.instantiateViewController(withIdentifier: "iOS_19ViewController") as! iOS_19ViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            let vc = audio_video.instantiateViewController(withIdentifier: "Audio_VideoViewController") as! Audio_VideoViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 6{
            let vc = actionSheet.instantiateViewController(withIdentifier: "week7ViewController") as! week7ViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7 {
            let vc = payment.instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 8 {
            let vc = iClick.instantiateViewController(withIdentifier: "iClickTabbarViewController") as! iClickTabbarViewController
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9 {
            let vc = week9.instantiateViewController(withIdentifier: "ScanHomeViewController") as! ScanHomeViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
