//
//  NSUserDefaults+Utils.swift
//  MobileTest
//
//  Created by Titano on 4/4/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    func saveArrayComment(arrayComment: NSArray) {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(arrayComment)
        userDefault.setObject(data, forKey: "kKeyComment")
        userDefault.synchronize()
    }
    
    func arrayComment()->NSArray {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefault.objectForKey("kKeyComment") as? NSData
        if data == nil {
            return []
        }
        return NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSArray
    }
    
    static func arrComment(productId: String) -> NSArray? {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefault.objectForKey("kKeyComment") as? NSData
        if data != nil {
            let array = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSArray
            if array.count > 0 {
                let finalArray = NSMutableArray(capacity: 10)
                let predicate = NSPredicate(format: "SELF.objectId == %@", productId)
                let result = array.filteredArrayUsingPredicate(predicate) as NSArray
                for obj in result {
                    let aComm = obj as! Comment
                    let review = Review()
                    review.objectId = aComm.objectId
                    review.comment = aComm.comment
                    review.rating = aComm.rating
                    review.user = User()
                    review.user?.objectId = aComm.userObjectId
                    review.product = Product()
                    review.product?.objectId = aComm.objectId
                    finalArray.addObject(review)
                }
                return finalArray
            }
        }
        return []
    }
    
    static func saveEmailLastUsed(email: String) {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(email, forKey: "kEmailLastUsed")
        userDefault.synchronize()
    }
    
    static func emailLastUsed()->String {
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let email: String? = userDefault.objectForKey("kEmailLastUsed") as? String
        if (email != nil) {
            return email!
        }
        return ""
    }
}