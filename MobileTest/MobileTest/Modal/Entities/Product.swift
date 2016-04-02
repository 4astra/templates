
//
//  Product.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import Foundation

class Product: NSObject {
    var productName: String?
    var price: String?
    var objectId: String?
    var updatedAt: String?
    var desc: String?
    var availabilityStatus: String?
    var brand: Brand?
    
    init(productName: String, price: String, objectId: String, updatedAt: String, desc: String) {
        self.productName = productName
        self.price = price
        self.objectId = objectId
        self.updatedAt = updatedAt
        self.desc = desc
    }
    
    override init() {
        
    }
}