//
//  DynamicLinksDetailsViewController.swift
//  Demo_1
//
//  Created by USER on 18/06/24.
//

import UIKit
import SDWebImage
import FirebaseDynamicLinks

class DynamicLinksDetailsViewController: UIViewController {

    @IBOutlet var pImageView: UIImageView!
    
    @IBOutlet var pName: UILabel!
    
    var index:Int!
    var id:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pName.text = dynamicLinksModel[index].pName
        pImageView.sd_setImage(with: dynamicLinksModel[index].pImage, placeholderImage: UIImage(systemName: ""))
    }
    
    
    @IBAction func onShareTapped(_ sender: UIBarButtonItem) {
        
        //let linkParameter = URL(string: "https://www.prit.com/items?id=\(dynamicLinksModel[index].id)")
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.prit.com"
        components.path = "/items"
        
        let itemsIdQueryItem = URLQueryItem(name: "itemId", value: String(dynamicLinksModel[index].id))
        components.queryItems = [itemsIdQueryItem]
        guard let linkParameter = components.url else { return }
        print("I am Sharing \(linkParameter.absoluteString)")
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://pritdemo.page.link") else {
            print("fail to create dynamic link")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        shareLink.iOSParameters?.appStoreID = "6451137917"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = String(dynamicLinksModel[index].pName) + "From Demo 1"
        shareLink.socialMetaTagParameters?.descriptionText = "Try out atleast one time " + String(dynamicLinksModel[index].pName)
        shareLink.socialMetaTagParameters?.imageURL = dynamicLinksModel[index].pImage
        
        guard let longUrl = shareLink.url else { return }
        print("Long Url = \(longUrl)")
        
        shareLink.shorten { (url,warnings,error) in
            if let error = error {
                print("Short Url Error \(error.localizedDescription)")
                return
            }
            if let warnings = warnings{
                for warning in warnings {
                    print("Dynamiclink warning \(warning)")
                }
            }
            guard let url = url else { return }
            print("Short Url share \(url.absoluteString)")
            self.showShareSheet(url: url)
        }
    
    }
    
    func showShareSheet(url:URL){
        let promptText = "Checkout the party items " + String(dynamicLinksModel[index].pName) + " From Demo 1"
        let activityVC = UIActivityViewController(activityItems: [promptText,url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
}
