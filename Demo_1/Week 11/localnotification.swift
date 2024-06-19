//
//  localnotification.swift
//  Demo_1
//
//  Created by USER on 15/06/24.
//

import Foundation

class LocalNotificationManager{
    var notifications = [LocalNotification]()
}
struct LocalNotification {
    var id:String
    var title:String
    var subtitle:String
    var datetime:Date
    var repeats:Bool
    
    init(id:String,title:String = "",subtitle:String = "",datetime:Date = Date(),repeats:Bool = false){
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.datetime = datetime
        self.repeats = repeats
    }
}
