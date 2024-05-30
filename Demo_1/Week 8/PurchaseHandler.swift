//
//  PurchaseHandler.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import Foundation
import StoreKit
import SwiftUI
import Observation


enum PassStatus:Comparable,Hashable{
    case notPurchased
    case oneDay
    case week
    case month
    
    init?(productId:Product.ID,ids:PassIdentifiers) {
        switch productId{
        case ids.oneDay: self = .oneDay
        case ids.week: self = .week
        case ids.month: self = .month
        default:
            return nil
        }
    }
    var description:String {
        switch self{
        case .notPurchased:
            "Not Purchased"
        case .oneDay:
            "One Day"
        case .week:
            "Week"
        case .month:
            "Month"
        }
    }
}
struct PassIdentifiers {
   //var group: String
   
   var month: String
   var week: String
   var oneDay: String
}
extension EnvironmentValues {
    private enum PassIDsKey:EnvironmentKey{
        static var defaultValue = PassIdentifiers(month: "com.app.Month", week: "com.purchase.Week", oneDay: "com.purchase.Oneday")
    }
    var passIds:PassIdentifiers{
        get { self[PassIDsKey.self] }
        set {self[PassIDsKey.self] = newValue }
    }
}
@available(iOS 17.0, *)
@Observable class PassStatusModel{
    var passStatus:PassStatus = .notPurchased
}
