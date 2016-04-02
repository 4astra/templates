//
//  ProductBusinessController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductBusinessController {

    static func getAllProduct(completion: (productArray: NSMutableArray)-> Void) {
        APIManager.sharedInstance.methodGET("Product", param: nil) { (responseJSON) -> Void in
            if (responseJSON != nil) {
                let json = JSON(responseJSON!)
                let result:[JSON] = json["results"].arrayValue
                let productArray = NSMutableArray()
                for dict in result {
                    let product = Product(
                        productName: dict["productName"].stringValue,
                        price: dict["price"].stringValue,
                        objectId: dict["objectId"].stringValue,
                        updatedAt: dict["updatedAt"].stringValue,
                        desc: dict["description"].stringValue
                    )
                    product.brand = Brand()
                    product.brand?.ID = dict["brandID"]["objectId"].stringValue
                    product.availabilityStatus = dict["availabilityStatus"].stringValue
                    productArray.addObject(product)
                }
                completion(productArray: productArray)
            }else {
                completion(productArray: [])
            }
        }
    }
}
