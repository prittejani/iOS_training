//
//  APIHelper.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import Foundation
import Alamofire

class APIHelper {
    static let shared = APIHelper()
    private init() {}
    
    func getFakePostData(completion: @escaping ([MVVMDataModel]?) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
      
        AF.request(url).responseJSON { response in
            if let responseData = response.data {
                do {
                    let decoder = JSONDecoder()
                    let responseArray = try decoder.decode([MVVMDataModel].self, from: responseData)
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
