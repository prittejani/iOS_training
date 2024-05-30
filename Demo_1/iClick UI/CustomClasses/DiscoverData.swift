//
//  DiscoverData.swift
//  Demo_1
//
//  Created by iMac on 21/05/24.
//

import Foundation
import UIKit

struct DiscoverData{
    var objectArray = [
        TableViewCellModel(category: "Topics", images: [
                CollectionViewCellModel(image: "topic1"),
                CollectionViewCellModel(image: "topic2"),
        
        ]),
        TableViewCellModel(category: "Collection", images: [
        CollectionViewCellModel(image: "collection1"),
        CollectionViewCellModel(image: "collection2"),
        ]),
        TableViewCellModel(category: "Collection 2", images: [
        CollectionViewCellModel(image: "collection1"),
        CollectionViewCellModel(image: "collection2"),
        ])
    ]
}
