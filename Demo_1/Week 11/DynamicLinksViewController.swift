//
//  DynamicLinksViewController.swift
//  Demo_1
//
//  Created by USER on 18/06/24.
//

import UIKit
import SDWebImage

let dynamicLinksModel:[DynamicLinksModel] = [
DynamicLinksModel(id: 1, pName: "Burger", pImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-1-568ec.appspot.com/o/Image%201%403x.png?alt=media&token=2acbca5d-f687-4a82-9bb5-1bcabc4111f4")),
DynamicLinksModel(id: 2, pName: "Pasta", pImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-1-568ec.appspot.com/o/Image%206%403x.png?alt=media&token=668ae569-a5c3-48d8-87d9-7cbbf3beb682")),
DynamicLinksModel(id: 3, pName: "Sandwich", pImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-1-568ec.appspot.com/o/Image%2023%403x.png?alt=media&token=1361ff7f-854c-4d36-8177-effbf67ab9b9")),
DynamicLinksModel(id: 4, pName: "Ice-cream", pImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-1-568ec.appspot.com/o/Image%2032%403x.png?alt=media&token=a2b68522-93f9-464f-98e2-e7347ce81521")),
DynamicLinksModel(id: 5, pName: "Noodles", pImage: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-1-568ec.appspot.com/o/Image%2010%403x.png?alt=media&token=b74e235c-f3ba-439a-a8e3-35ead0f5128a"))
]

class DynamicLinksViewController: UIViewController {
 

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DynamicLinksTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}
extension DynamicLinksViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dynamicLinksModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DynamicLinksTableViewCell
        cell.producName.text = dynamicLinksModel[indexPath.row].pName
        cell.productImage.sd_setImage(with: dynamicLinksModel[indexPath.row].pImage, placeholderImage: UIImage(systemName: "person"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = week11.instantiateViewController(withIdentifier: "DynamicLinksDetailsViewController") as! DynamicLinksDetailsViewController
        vc.index = indexPath.row
        vc.id = dynamicLinksModel[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}

struct DynamicLinksModel {
    let id:Int!
    let pName:String!
    let pImage:URL!

}
