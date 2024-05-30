//
//  DiscoverViewController.swift
//  Demo_1
//
//  Created by iMac on 21/05/24.
//

import UIKit
var discoverArray = [
    DiscoverData(sectionType: "Topic", image: [UIImage(named: "topic1")!,UIImage(named: "topic2")!,UIImage(named: "topic1")!,UIImage(named: "topic2")!],info: ["","","",""]),
    DiscoverData(sectionType: "Collection", image: [UIImage(named: "collection1")!,UIImage(named: "collection2")!,UIImage(named: "collection1")!,UIImage(named: "collection2")!],info: ["70 photos","10 photos","10 photos","70 photos"]),  
    DiscoverData(sectionType: "Collection", image: [UIImage(named: "collection1")!,UIImage(named: "collection2")!,UIImage(named: "collection1")!,UIImage(named: "collection2")!],info: ["70 photos","10 photos","10 photos","70 photos"]),
    
]
class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Search: UIImageView!
    @IBOutlet weak var SearchView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchView.layer.cornerRadius = SearchView.frame.size.height/2
        SearchView.clipsToBounds = true
        
        Search.layer.cornerRadius = Search.frame.size.height/2
        Search.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
    }

}
extension DiscoverViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return discoverArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return discoverArray[section].sectionType
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height/10))
            
            let sectionName = UILabel()
            let viewMore = UILabel()
        sectionName.frame = CGRect.init(x: headerView.frame.width/18, y: -10, width: headerView.frame.width, height: headerView.frame.height)
        
        sectionName.text = discoverArray[section].sectionType
        sectionName.font = .systemFont(ofSize: 20,weight: .bold)
        sectionName.textColor = .black
        //headerView.layer.backgroundColor = UIColor.red.cgColor
    
        viewMore.frame = CGRect(x: headerView.frame.width/1.3, y: -10, width: headerView.frame.width, height: headerView.frame.height)
        viewMore.text = "View more"
        viewMore.font = .systemFont(ofSize: 14,weight: .regular)
        viewMore.textColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
        
            headerView.addSubview(sectionName)
            headerView.addSubview(viewMore)
            
            return headerView
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return tableView.frame.height/20
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiscoverTableViewCell
        cell.collectionView.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
