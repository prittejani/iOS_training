//
//  Services.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import Foundation

class Services {
    static let shared = Services()
    
    func fetchData(completion: @escaping ([mvvmDataModel]?, Error?) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch courses:", err)
                return
            }
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode([mvvmDataModel].self, from: data)
                DispatchQueue.main.async {
                    completion(courses, nil)
                }
            } catch let jsonErr {
                completion(nil, jsonErr)
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }
}
