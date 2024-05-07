//
//  UserModel.swift
//  sql
//
//  Created by iMac on 28/02/24.
//

import Foundation
class UserModel{
    var id:Int = 0
    var name:String = ""
    var mobileno:String = ""
    var email:String = ""


    
    init(id: Int, name: String, mobileno: String,email: String) {
        self.id = id
        self.name = name
        self.mobileno = mobileno
        self.email = email
    }
    
}
