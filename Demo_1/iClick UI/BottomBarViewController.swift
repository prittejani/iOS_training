//
//  BottomBarViewController.swift
//  Demo_1
//
//  Created by iMac on 25/05/24.
//

import UIKit

class BottomBarViewController: UIViewController {

   
    required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
       }

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var activity: UIImageView!
    @IBOutlet weak var home: UIImageView!
    @IBOutlet weak var discover: UIImageView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabbar: CustomTabBar!
    let greycolor:UIColor = .systemGray4
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
           super.viewDidLoad()
        setupMiddleButton()
        firstLoad()
       }
       func setupMiddleButton() {
        
           middleButton.layer.cornerRadius = (middleButton.layer.frame.width / 2)
           middleButton.clipsToBounds = true
           
           view2.layer.cornerRadius = 20.0
           view3.layer.cornerRadius = 20.0
           view2.clipsToBounds = true
           view3.clipsToBounds = true
    
   }
    func firstLoad (){
        home.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
        discover.tintColor = greycolor
        activity.tintColor = greycolor
        profile.tintColor = greycolor
        guard let home = iClick.instantiateViewController(withIdentifier: "iClickHomeViewController") as? iClickHomeViewController else {return}
        contentView.addSubview(home.view)
        home.view.frame = contentView.bounds
        home.didMove(toParent: self)
    }
    @IBAction func onTabbarItemPressed(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 1 {
            home.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
            discover.tintColor = greycolor
            activity.tintColor = greycolor
            profile.tintColor = greycolor
            guard let home = iClick.instantiateViewController(withIdentifier: "iClickHomeViewController") as? iClickHomeViewController else {return}
            contentView.addSubview(home.view)
            home.view.frame = contentView.bounds
            home.didMove(toParent: self)
            
        }else if tag == 2 {
            home.tintColor = greycolor
            discover.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
            activity.tintColor = greycolor
            profile.tintColor = greycolor
            guard let discover = iClick.instantiateViewController(withIdentifier: "DiscoverViewController") as? DiscoverViewController else {return}
            contentView.addSubview(discover.view)
            discover.view.frame = contentView.bounds
            discover.didMove(toParent: self)

            
        }else if tag == 3 {
            home.tintColor = greycolor
            discover.tintColor = greycolor
            activity.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
            profile.tintColor = greycolor
            guard let activity = iClick.instantiateViewController(withIdentifier: "ActivityViewController") as? ActivityViewController else {return}
            contentView.addSubview(activity.view)
            activity.view.frame = contentView.bounds
            activity.didMove(toParent: self)
        }else {
            home.tintColor = greycolor
            discover.tintColor = greycolor
            activity.tintColor = greycolor
            profile.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)

            guard let profile = iClick.instantiateViewController(withIdentifier: "iClickProfileViewController") as? iClickProfileViewController else {return}
            contentView.addSubview(profile.view)
            profile.view.frame = contentView.bounds
            profile.didMove(toParent: self)
        }
    }

}
