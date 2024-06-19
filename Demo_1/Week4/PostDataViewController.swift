//
//  PostDataViewController.swift
//  Webservices
//
//  Created by iMac on 01/04/24.
//

import UIKit
import Alamofire
import SDWebImage
import AVFoundation
import SVProgressHUD

class PostDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var userData:[PostDataArray] = []
    var current_page = 0
    var total_page = 67
    var currentIndexPath: IndexPath?
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var tableView: UITableView!
    var avPlayer:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    var videoURL:URL!
    override func viewDidLoad() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        
        tableView.delegate = self
        tableView.dataSource = self
        SVProgressHUD.show()
        fetchData()
        super.viewDidLoad()
        tableView.tableFooterView = activityIndicator
    }
    
    func fetchData(){

        guard let url = URL(string: "http://88.208.196.241/Staging/api/user_post_list_testing")else{return}
        let header:HTTPHeaders = ["UserId":"12"]
        let parameters:[String:Any] = ["post_page_no":"\(current_page + 1)","post_page_item":"10"]
        print(url)
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: header).responseDecodable(of: PostModel.self){
            response in
            
            switch response.result{
            case .success(let postModel):
                if self.userData.isEmpty{
                    self.userData = postModel.data.postDataArray
                }else{
                    self.current_page += 1
                    print("~~~~>>>>\(self.current_page)")
                    print("PAGE \(self.current_page)")
                    self.userData.append(contentsOf: postModel.data.postDataArray)
                }
                DispatchQueue.main.async { [self] in
                    SVProgressHUD.dismiss()
                    activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                }
                print("~~>> \(self.userData)")
            case .failure(let error):
                print("~~>> \(error)")
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 460.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ACustomTableViewCell
        
        cell.lblUserName.text = "\(userData[indexPath.row].postUserName)"
        cell.lblPostDiscription.text = "\(userData[indexPath.row].postDesc)"
        cell.lblPostId.text = "\(userData[indexPath.row].postID)"
        
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.height/2
        cell.userImageView.clipsToBounds = true
        
        let url = URL(string: userData[indexPath.row].postUserProfilePic)
        cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
        
        if  !userData[indexPath.row].imageData.isEmpty{
            let posturl = URL (string: userData[indexPath.row].imageData[0].postImage)!
            let postExtention = posturl.pathExtension
            if postExtention == "mp4" {
                
                if userData[indexPath.row].imageData[0].videoThumb != "" {
                    
                   // let postVideoImageURL = URL(string: userData[indexPath.row].imageData[0].videoThumb)!
                    let postVideoImageURL = URL(string: "https://st4.depositphotos.com/6504442/38405/v/450/depositphotos_384052258-stock-illustration-light-blue-vector-backdrop-dots.jpg")!
                   cell.postImageView.sd_setImage(with: postVideoImageURL, placeholderImage: UIImage(named: "person"))
                    cell.isVideoCell = true
                    cell.player = AVPlayer(url: posturl)
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: cell.player.currentItem, queue: .main){
                        [self]_ in
                        cell.player.seek(to: CMTime.zero)
                        cell.player.play()
                    }
                }
                
            } else{
                cell.isVideoCell = false
                cell.postImageView.layer.cornerRadius = 10
                cell.postImageView.sd_setImage(with: posturl, placeholderImage: UIImage(systemName: "person"))
                cell.containerView.addSubview(cell.postImageView)
            }
        }else{
            cell.postImageView.image = UIImage(named: "no-image")
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let videoCell = cell as! ACustomTableViewCell
        if videoCell.isVideoCell {
            let playerLayer = AVPlayerLayer(player: videoCell.player)
            playerLayer.videoGravity = .resizeAspect
            playerLayer.frame = videoCell.postImageView.bounds
            videoCell.postImageView.layer.addSublayer(playerLayer)
            videoCell.playerLayer = playerLayer
            videoCell.player.seek(to: .zero)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } catch {
              print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            
            let reset = {
                videoCell.player.pause()
                videoCell.player.seek(to: .zero)
                videoCell.player.play()
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: videoCell.player.currentItem, queue: nil) { notification in
                reset()
            }
        }
        
        let postData = userData
        if indexPath.row == postData.count - 1 && current_page <= total_page {
            
            if current_page == total_page {
                customAlert(title: "Sorry..", message: "No more data available")
            }else{
                activityIndicator.startAnimating()
                fetchData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let videoCell = cell as! ACustomTableViewCell
        if videoCell.isVideoCell {
            videoCell.player.pause()
            videoCell.playerLayer.removeFromSuperlayer()
        }
        print("video paused")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return activityIndicator
        }
        return nil
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 100
//        }
//        return 0
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? ACustomTableViewCell {
                let intersectingRect = tableView.rectForRow(at: indexPath).intersection(tableView.bounds)
                let visibleHeight = intersectingRect.height
                
                if visibleHeight == cell.bounds.height {
                    
                    if currentIndexPath != indexPath {
                        if cell.isVideoCell {
                            
                            cell.player.play()
                            
                        }
                    }
                } else {
                    if cell.isVideoCell {
                        cell.player.pause()
                        currentIndexPath = nil
                    }
                }
            }
        }
    }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}
