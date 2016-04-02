//
//  ReviewBusinessController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewBusinessController {

    static func getAllReview(completion: (reviewArray: NSMutableArray)->Void) {
        APIManager.sharedInstance.methodGET("Review", param: nil) { (responseJSON) -> Void in
            if (responseJSON != nil) {
                let json = JSON(responseJSON!)
                let result:[JSON] = json["results"].arrayValue
                let reviewArray = NSMutableArray()
                for dict in result {
                    //print(dict)
                    let review = Review()
                    review.objectId = dict["objectId"].stringValue
                    review.comment = dict["comment"].stringValue
                    review.product = Product()
                    review.product?.objectId = dict["productID"]["objectId"].stringValue
                    review.rating = dict["rating"].stringValue
                    review.updatedAt = dict["updatedAt"].stringValue
                    review.createdAt = dict["createdAt"].stringValue
                    review.user = User()
                    review.user?.objectId = dict["userID"]["objectId"].stringValue
                    reviewArray.addObject(review)
                }
                completion(reviewArray: reviewArray);
            }else {
                completion(reviewArray: [])
            }
        }
    }
    
    
    static func addReviewProduct(param: [String: AnyObject]?, completion:(message: String?)->Void){
        APIManager.sharedInstance.methodPOST("Review", param: param) { (responseJSON) -> Void in
            //print(responseJSON)
            let json = JSON(responseJSON!)
            let createdAt = json["createdAt"].stringValue
            if createdAt == "" {
                completion(message: json["error"].stringValue)
            }else {
                completion(message: nil)
            }
            
            
        }
    }
}
