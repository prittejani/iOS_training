//
//  CollectionviewInsideTableviewViewController.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit

class CollectionviewInsideTableviewViewController: UIViewController {
    var cachedPosition = Dictionary<IndexPath,CGPoint>()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CollectionView inside Tableview"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
}
extension CollectionviewInsideTableviewViewController:UITableViewDelegate,UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as?  CollectionViewTableViewCell{
               cachedPosition[indexPath] = cell.collectionView.contentOffset
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionViewTableViewCell
        cell.collectionView.tag = indexPath.row
        cell.collectionView.contentOffset = cachedPosition[indexPath] ?? .zero
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
