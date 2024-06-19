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
    
    @IBOutlet var TopViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var TopView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchView.layer.cornerRadius = SearchView.frame.size.height/2.3
        SearchView.clipsToBounds = true
        
        Search.layer.cornerRadius = Search.frame.size.height/2
        Search.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
  
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if UIDevice.current.orientation.isLandscape {
                print("landscape")
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.TopView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.TopView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.146714)
                ])
            } else {
                print("portrait")
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.TopView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.TopView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.146714)
                ])
            }
            
            // Force layout update
            self.view.layoutIfNeeded()
            
        }, completion: nil)
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
        let headerView = CustomHeaderView()
        return headerView
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 25))
//
//            let sectionName = UILabel()
//            let viewMore = UILabel()
//        sectionName.frame = CGRect.init(x: headerView.frame.width/18, y: -10, width: headerView.frame.width, height: headerView.frame.height)
//
//        sectionName.text = discoverArray[section].sectionType
//        sectionName.font = .systemFont(ofSize: 20,weight: .bold)
//        sectionName.textColor = .black
//        headerView.layer.backgroundColor = UIColor.red.cgColor
//
//        viewMore.frame = CGRect(x: headerView.frame.width/1.3, y: -10, width: headerView.frame.width, height: headerView.frame.height)
//        viewMore.text = "View more"
//        viewMore.font = .systemFont(ofSize: 14,weight: .regular)
//        viewMore.textColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
//
//            headerView.addSubview(sectionName)
//            headerView.addSubview(viewMore)
//
//            return headerView
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
import UIKit

class CustomHeaderView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Collection"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View more", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(viewMoreButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            viewMoreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewMoreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
