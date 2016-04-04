//
//  UserBussinessController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserBussinessController: APIManager {
    static func getAllUser(completion: (userArray: NSMutableArray)->Void) {
        APIManager.sharedInstance.methodGET("User", param: nil) { (responseJSON) -> Void in
            if (responseJSON != nil) {
                //print(responseJSON)
                let json = JSON(responseJSON!)
                let result:[JSON] = json["results"].arrayValue
                let userArray = NSMutableArray()
                for dict in result {
                    let user = User()
                    user.objectId = dict["objectId"].stringValue
                    user.userName = dict["userName"].stringValue
                    user.email = dict["email"].stringValue
                    userArray.addObject(user)
                }
                completion(userArray: userArray)
            }else {
                completion(userArray: [])
            }
        }
    }
}
