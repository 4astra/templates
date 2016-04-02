//
//  Review.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import Foundation

class Review: NSObject {
    var comment: String?
    var rating: String?
    var objectId: String?
    var createdAt: String?
    var updatedAt: String?
    var product: Product?
    var user: User?
    
    override init() {
        
    }
}