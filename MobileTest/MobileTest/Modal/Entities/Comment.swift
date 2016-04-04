//
//  Comment.swift
//  MobileTest
//
//  Created by Titano on 4/4/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class Comment: NSObject, NSCoding {
    var comment: String?
    var rating: String?
    var objectId: String?
    var productObjectId: String?
    var userObjectId: String?
    
    override init() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        self.comment = aDecoder.decodeObjectForKey("comment") as? String
        self.objectId = aDecoder.decodeObjectForKey("objectId") as? String
        self.userObjectId = aDecoder.decodeObjectForKey("userObjectId") as? String
        self.productObjectId = aDecoder.decodeObjectForKey("productObjectId") as? String
        self.rating = aDecoder.decodeObjectForKey("rating") as? String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.comment, forKey: "comment")
        aCoder.encodeObject(self.objectId, forKey: "objectId")
        aCoder.encodeObject(self.userObjectId, forKey: "userObjectId")
        aCoder.encodeObject(self.productObjectId, forKey: "productObjectId")
        aCoder.encodeObject(self.rating, forKey: "rating")
    }
}
