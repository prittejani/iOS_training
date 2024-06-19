//
//  APIManager.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func getFakePostData(completion: @escaping ([MVCDataModel]?) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
      
        AF.request(url).responseJSON { response in
            if let responseData = response.data {
                do {
                    let decoder = JSONDecoder()
                    let responseArray = try decoder.decode([MVCDataModel].self, from: responseData)
                    completion(responseArray)
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            } else {
                print("Error receiving data: \(String(describing: response.error))")
                completion(nil)
            }
        }
        
    }
    
}
