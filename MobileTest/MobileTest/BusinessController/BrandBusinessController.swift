
//
//  BrandBusinessController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class BrandBusinessController {
    
    static func getAllBrand(completion: (brandArray: NSMutableArray)->Void) {
        APIManager.sharedInstance.methodGET("Brand", param: nil) { (responseJSON) -> Void in
            if (responseJSON != nil) {
                let json = JSON(responseJSON!)
                let result:[JSON] = json["results"].arrayValue
                let brandArray = NSMutableArray()
                for dict in result {
                    //print(dict)
                    let brand = Brand(
                        name: dict["name"].stringValue,
                        desc: dict["description"].stringValue,
                        ID: dict["objectId"].stringValue,
                        updatedAt: dict["updatedAt"].stringValue
                    )
                    brandArray.addObject(brand)
                }
                completion(brandArray: brandArray);
            }else {
                completion(brandArray: [])
            }
        }
    }
}
