//
//  APIManager.swift
//  MobileTest
//
//  Created by Titano on 3/30/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class APIManager {
    
    //constant
    let apiBase = "https://api.parse.com/1/classes/";
    let headers = [
        "X-Parse-Application-Id": "MlR6vYpYvLRxfibxE5cg0e73jXojL6jWFqXU6F8L",
        "X-Parse-REST-API-Key": "7BTXVX1qUXKUCnsngL8LxhpEHKQ8KKd798kKpD9W"
    ]
    
    //Singlestone
    class var sharedInstance : APIManager {
        struct Static {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }
    
    
    func methodGET(apiName: String, param: [String: AnyObject]?, completion:(responseJSON: [String: AnyObject]?) -> Void) {
        
        //Show a indicator
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.showHUDAddedTo(appDelegate.window?.rootViewController?.view, animated: true)
        
        let url = apiBase + apiName + "/"
        Alamofire.request(
            .GET, url, parameters:param, headers: headers
            )
            .responseJSON { response in
                
                MBProgressHUD.hideAllHUDsForView(appDelegate.window?.rootViewController?.view, animated: true)
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(responseJSON: nil)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    completion(responseJSON: nil)
                    return
                }
                completion(responseJSON: responseJSON)
                return
        }
    }
    
    func methodPOST(apiName: String, param: [String: AnyObject]?, completion:(responseJSON: [String: AnyObject]?) -> Void) {
        
        //Show a indicator
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.showHUDAddedTo(appDelegate.window?.rootViewController?.view, animated: true)
        
        let url = apiBase + apiName + "/"
        Alamofire.request(
            .POST, url, parameters:param, encoding:.JSON, headers: headers
            )
            .responseJSON { response in
                
                MBProgressHUD.hideAllHUDsForView(appDelegate.window?.rootViewController?.view, animated: true)
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(responseJSON: nil)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    completion(responseJSON: nil)
                    return
                }
                completion(responseJSON: responseJSON)
                return
        }
    }
    
}