//
//  CustomTabBarViewController.swift
//  tabbar
//
//  Created by iMac on 23/02/24.
//

import UIKit

class CustomTabBarViewController: UIViewController {
    
    

    
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet var homeImage: UIImageView!
    
    @IBOutlet var searchImage: UIImageView!
    
    @IBOutlet var likeImage: UIImageView!
    
    @IBOutlet var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarDesign()
        firstLoad()
    }
    func tabbarDesign(){
        tabbarView.layer.cornerRadius =
        tabbarView.frame.size.height / 2
        tabbarView.clipsToBounds = true
    }
    func firstLoad (){
        homeImage.tintColor = .red
        searchImage.tintColor = .systemBlue
        likeImage.tintColor = .systemBlue
        profileImage.tintColor = .systemBlue
        guard let home = week2StoryBoard.instantiateViewController(withIdentifier: "HometabbarViewController") as? HometabbarViewController else {return}
        contentView.addSubview(home.view)
        home.didMove(toParent: self)
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func onTabbarItemPressed(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 1 {
            homeImage.tintColor = .red
            searchImage.tintColor = .systemBlue
            likeImage.tintColor = .systemBlue
            profileImage.tintColor = .systemBlue
            guard let home = week2StoryBoard.instantiateViewController(withIdentifier: "HometabbarViewController") as? HometabbarViewController else {return}
            contentView.addSubview(home.view)
            home.didMove(toParent: self)
            
        }else if tag == 2 {
            homeImage.tintColor = .systemBlue
            searchImage.tintColor = .red
            likeImage.tintColor = .systemBlue
            profileImage.tintColor = .systemBlue
            guard let search = week2StoryBoard.instantiateViewController(withIdentifier: "SearchtabbarViewController") as? SearchtabbarViewController else {return}
            contentView.addSubview(search.view)
            search.didMove(toParent: self)
            
        }else if tag == 3 {
            homeImage.tintColor = .systemBlue
            searchImage.tintColor = .systemBlue
            likeImage.tintColor = .red
            profileImage.tintColor = .systemBlue
            guard let like = week2StoryBoard.instantiateViewController(withIdentifier: "LiketabbarViewController") as? LiketabbarViewController else {return}
            contentView.addSubview(like.view)
            like.didMove(toParent: self)
        }else {
            homeImage.tintColor = .systemBlue
            searchImage.tintColor = .systemBlue
            likeImage.tintColor = .systemBlue
            profileImage.tintColor = .red
            guard let profile = week2StoryBoard.instantiateViewController(withIdentifier: "ProfiletabbarViewController") as? ProfiletabbarViewController else {return}
            contentView.addSubview(profile.view)
            profile.didMove(toParent: self)
        }
    }
    
}
