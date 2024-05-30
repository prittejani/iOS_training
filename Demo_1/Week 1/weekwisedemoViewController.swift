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

let week1StoryBoard = UIStoryboard(name: "Main", bundle: nil)
let week2StoryBoard = UIStoryboard(name: "tabbar", bundle: nil)
let week5StoryBoard = UIStoryboard(name: "googlemap", bundle: nil)
let services = UIStoryboard(name: "services", bundle: nil)
let actionSheet = UIStoryboard(name: "actionsheet", bundle: nil)
let cameraVideo = UIStoryboard(name: "cameravideo", bundle: nil)
let api = UIStoryboard(name: "api", bundle: nil)
let payment = UIStoryboard(name: "payment", bundle: nil)

class weekwisedemoViewController: UIViewController {
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
        
        weekNameArray = ["Week 1","Week 2","Week 3","Week 4","Week 5","Week 6","Week 7","Week 8"]
      
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle"{
            viaGoogle()
        }else{
            viaFacebook()
        }
        drawerView.isHidden = true
        isDrawerOpened = false
   
        
        
        
//        self.drawerView.frame.size.height = self.view.frame.height/1.11
//    
        userImg.layer.cornerRadius = userImg.frame.width/2
        userImg.clipsToBounds = true
        
        menu = SideMenuNavigationController(rootViewController: sideMenubar())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        
//       view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onviewTapped(_ :))))
//        
        
    }
    @objc func onviewTapped(_ sender:UITapGestureRecognizer){
        if isDrawerOpened{
            //self.view.backgroundColor = .systemBackground
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
          //  self.view.backgroundColor = .systemBackground
            drawerView.isHidden = true
            isDrawerOpened = false
        }
    }
    
    @IBAction func onMenuTapped(_ sender: Any) {
        self.present(menu, animated: true,completion: nil)
    }
        
    @IBAction func onCustomSideBarTapped(_ sender: UIBarButtonItem) {
        if isDrawerOpened{
          //  self.view.backgroundColor = .systemBackground
            drawerView.isHidden = true
            isDrawerOpened = false
        }else{
            //self.view.backgroundColor = .systemGray4
            drawerView.isHidden = false
            isDrawerOpened = true
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
        }
        
    }
    
    
}
class sideMenubar:UIViewController{
   
    
   
    var imageUrl:Data!
    let profileImage = UIImageView()
    let lblname = UILabel()
    let lblemail = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        view.backgroundColor = .systemBlue
 
        
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle"{
            viaGoogle()
        }else{
            viaFacebook()
        }
        
   
        lblemail.frame = CGRect(x: self.view.frame.width/20, y: self.view.frame.height/4, width: 200, height: 21)
        lblemail.textColor = .white

        lblname.frame =  CGRect(x: self.view.frame.width/20, y: self.view.frame.height/4.6, width: 150, height: 21)
        lblname.textColor = .white
    
        let button = UIButton(frame: CGRect(x: self.view.frame.width/20, y: self.view.frame.height/1.08, width: 200, height: 30))
        button.backgroundColor = .white
        button.layer.cornerRadius = 6.0
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(signout), for: .touchUpInside)
    
        
        let imageViewWidth: CGFloat = 90.0
        let imageViewHeight: CGFloat = 90.0
        profileImage.frame = CGRect(x: self.view.frame.width/20, y: self.view.frame.height/14, width: imageViewWidth, height: imageViewHeight)
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
 
        self.view.addSubview(lblname)
        self.view.addSubview(lblemail)
        self.view.addSubview(profileImage)
        self.view.addSubview(button)
    }
    
    func viaGoogle(){
        GIDSignIn.sharedInstance.restorePreviousSignIn{
        user,error in
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
    func viaFacebook(){
            GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large)"]).start{
                    (connection,result,error) in
                    if let userData = result as? [String: Any] {
                        let email = userData["email"]
                        let name = userData["name"]
                        let id = userData["id"]
                        
                        self.lblname.text = "\(name!)"
                        self.lblemail.text = "\(email!)"

                        if let pictureData = userData["picture"] as? [String: Any],
                           let picture = pictureData["data"] as? [String: Any],
                           let pictureURLString = picture["url"] as? String{
                            let url = URL(string: pictureURLString)
                            let imgData = try? Data(contentsOf: url!)
                            self.profileImage.image = UIImage(data: imgData!)
                            
                           }
                     }
                }
    }
    @objc func signout(){
        
        let checkLogin = UserDefaults.standard.string(forKey: "loginForm")
        if checkLogin == "viaGoogle"{
            Switcher.updateRootVC(status: false)
            GIDSignIn.sharedInstance.signOut()
           
        }else if checkLogin == "viaFacebook"{
            Switcher.updateRootVC(status: false)
            LoginManager().logOut()
        }
        
    }
}
extension weekwisedemoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! weekwiseTableViewCell
        cell.lblweekName.text = weekNameArray[indexPath.row] ?? ""
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
            let vc = payment.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
