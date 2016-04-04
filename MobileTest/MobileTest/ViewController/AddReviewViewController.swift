//
//  AddReviewViewController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import AVFoundation
import KMPlaceholderTextView
import HCSStarRatingView

class AddReviewViewController: UIViewController,
    UITextFieldDelegate,
    CustomQRCodeReaderDelegate,
    CustomRecognizeDelegate,
    OEEventsObserverDelegate
{
    
    @IBOutlet weak var ibProductID: UITextField!
    @IBOutlet weak var ibEmail: UITextField!
    @IBOutlet weak var ibCommentView: KMPlaceholderTextView!
    @IBOutlet weak var ibSaveButton: UIButton!
    @IBOutlet weak var ibListeningButton: UIButton!
    @IBOutlet weak var cosmosView: HCSStarRatingView!
    @IBOutlet weak var ibScanQRButton: UIButton!
    
    var product: Product?
    
    var productArray = NSMutableArray()
    var commentArray = NSMutableArray()
    var userArray = NSMutableArray()
    var userObjectID: String = "s1k6Vzf9Uk" //default
    let recognizeVoice = CustomRecognizeController()
    var isListening: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Review"
        self.isListening = false
        self.recognizeVoice.delegate = self
        self.ibCommentView.inputAccessoryView = UIToolbar.keyboardToolbar(self)
        self.ibProductID.inputAccessoryView = UIToolbar.keyboardToolbar(self)
        self.ibEmail.inputAccessoryView = UIToolbar.keyboardToolbar(self)
        self.ibProductID.addTarget(self, action: "valueTextChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        enableControls(false)
        //Cosmos Rating View
        self.cosmosView.maximumValue = 10
        self.cosmosView.minimumValue = 0
        self.cosmosView.value = 5.0
        self.cosmosView.allowsHalfStars = false
        
        self.ibEmail.text = NSUserDefaults.emailLastUsed()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefault = NSUserDefaults.standardUserDefaults()
        self.commentArray = NSMutableArray(array: userDefault.arrayComment())
        
        if(self.userArray.count <= 0) {
            allUser()
        }
    }
    
    func allUser() {
        UserBussinessController.getAllUser { (userArray) -> Void in
            self.userArray = NSMutableArray(array: userArray)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.product != nil) {
            ibProductID.text = self.product?.objectId
            enableControls(true)
        }
    }
    
    func valueTextChange(textField: UITextField) {
        let isExistentProductId = checkProductIDIsExist(textField.text) as Bool
        if (!isExistentProductId) {
            enableControls(false)
        }else {
            enableControls(true)
        }
    }
    
    func checkProductIDIsExist(productID: String?)->Bool {
        var words = productID
        words = words?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if words != nil {
            let predicate = NSPredicate(format: "SELF.objectId == %@", words!)
            let result = self.productArray.filteredArrayUsingPredicate(predicate) as NSArray
            
            if (result.count > 0) {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.ibProductID) {
            let isExistentProductId = checkProductIDIsExist(textField.text) as Bool
            if (!isExistentProductId) {
                enableControls(false)
                let alert = UIAlertController(title: "Alert", message: "Product ID not found", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }else {
                enableControls(true)
            }
        }
        self.view.endEditing(true)
        return true
    }
    
    func enableControls(state: Bool) {
        //self.ibCommentView.editable = state
        self.ibSaveButton.enabled = state
    }
    
    func userInteractionEnabled(state: Bool) {
        self.ibCommentView.userInteractionEnabled = state
        self.ibEmail.userInteractionEnabled = state
        self.ibSaveButton.userInteractionEnabled = state
        self.ibProductID.userInteractionEnabled = state
        self.cosmosView.userInteractionEnabled = state
        self.ibScanQRButton.userInteractionEnabled = state
    }
    // CutomScanQRCode Delegate
    func initScanQRCode() {
        let customQRCode = CustomQRCodeReaderController()
        customQRCode.initScanQRCode()
        customQRCode.delegate = self
    }
    
    func scanFinishedWithValue(value: String?) {
        print(value)
        ibProductID.text = value
        let isExistentProductId = checkProductIDIsExist(value) as Bool
        if (!isExistentProductId) {
            enableControls(false)
            let alert = UIAlertController(title: "Alert", message: "Product ID not found", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else {
            enableControls(true)
        }

    }
    
    @IBAction func addReview(sender: AnyObject) {
        
        let hasEmail: Int = getUserObjectIdFromEmail();
        if (hasEmail == -1) {
            let alert = UIAlertController(title: "Alert", message: "Email is not valid", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        var comment = self.ibCommentView.text
        if comment == nil {
            comment = ""
        }

        let numRating = NSNumber(integer: Int(self.cosmosView.value))
        
        let param: [String : AnyObject] = [
            "comment":"\(comment)",
            "rating": numRating,
            "productID": [
                "__type": "Pointer",
                "className": "Product",
                "objectId": "\(self.ibProductID.text!)"
            ],
            "userID": [
                "__type": "Pointer",
                "className": "User",
                "objectId": "\(userObjectID)"
            ]
        ]
        
        ReviewBusinessController.addReviewProduct(param) { (message) -> Void in
            if message != nil {
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else {
                let userDefault = NSUserDefaults.standardUserDefaults()
                let aComment = Comment()
                aComment.objectId = self.ibProductID.text!
                aComment.comment = self.ibCommentView.text! + ""
                aComment.rating = String(self.cosmosView.value)
                aComment.userObjectId = "s1k6Vzf9Uk"
                self.commentArray.addObject(aComment)
                userDefault.saveArrayComment(self.commentArray)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func showRecognizeVoiceController(sender: AnyObject) {
        if (self.isListening == false) {
            self.isListening = true
            self.ibListeningButton.setTitle("Stop Listening", forState: UIControlState.Normal)
            self.recognizeVoice.beginListening()
            userInteractionEnabled(false)
        }else {
            self.isListening = false
            self.ibListeningButton.setTitle("Start Listening", forState: UIControlState.Normal)
             self.recognizeVoice.stopListening()
            userInteractionEnabled(true)
        }
    }
    // CustomRecognize Delegate
    func recognizeFinishedWithValue(hypothesis: String!) {
        //print("A heard: %@", hypothesis)
        let value: String? = ibProductID.text
        ibProductID.text = value! + hypothesis
    }
    
    @IBAction func showScanQRController(sender: AnyObject) {
        initScanQRCode()
    }
    
    func endEditing(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func getUserObjectIdFromEmail()->Int {
        var email:String? = ibEmail.text
        email = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (email != "" || email != nil) {
            let predicate = NSPredicate(format: "SELF.email == %@", email!)
            let result = self.userArray.filteredArrayUsingPredicate(predicate) as NSArray
            if result.count > 0 {
                NSUserDefaults.saveEmailLastUsed(email!)
                let user = result.firstObject as! User
                self.userObjectID = user.objectId!
                return 1
            }else {
                return -1
            }
        }
        return 0
    }
}
