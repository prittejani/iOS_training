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

class weekwisedemoViewController: UIViewController {

    var menu:SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        menu = SideMenuNavigationController(rootViewController: sideMenubar())
        menu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
            //SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    @IBAction func onMenuTapped(_ sender: Any) {
        self.present(menu, animated: true,completion: nil)
    }
    
    @IBAction func weekOneTapped(_ sender: UIButton) {
        let vc = week1StoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func week2Tapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "week2ViewController") as! week2ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func week3Tapped(_ sender: UIButton) {
        let vc = sqlStoryBoard.instantiateViewController(withIdentifier: "week3wiseViewController") as! week3wiseViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func week4Tapped(_ sender: UIButton) {
        let vc = api.instantiateViewController(withIdentifier: "AViewController") as! AViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func week5Tapped(_ sender: UIButton) {
        let vc = services.instantiateViewController(withIdentifier: "iOS_19ViewController") as! iOS_19ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func week6Tapped(_ sender: UIButton) {
        let vc = audio_video.instantiateViewController(withIdentifier: "Audio_VideoViewController") as! Audio_VideoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func week7Tapped(_ sender: UIButton) {
        
        let vc = actionSheet.instantiateViewController(withIdentifier: "week7ViewController") as! week7ViewController
        navigationController?.pushViewController(vc, animated: true)

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
