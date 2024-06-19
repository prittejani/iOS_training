//
//  mvvmViewModel.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import Foundation
import UIKit

struct mvvmViewModel{
    var title:String?
    var status:String?
    var backColor:UIColor?
    
    init(mvvmList:mvvmDataModel) {
        self.title = mvvmList.title
        if (mvvmList.completed!){
            self.status = "Completed"
            self.backColor = .green
        }else{
            self.status = "Pending"
            self.backColor = .gray
        }
    }
    
}
