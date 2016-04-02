//
//  AddReviewViewController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import AVFoundation
import Cosmos

class AddReviewViewController: UIViewController,
    UITextFieldDelegate,
    CustomQRCodeReaderDelegate,
    CustomRecognizeDelegate,
    OEEventsObserverDelegate
{
    
    @IBOutlet weak var ibProductID: UITextField!
    @IBOutlet weak var ibComment: UITextField!
//    @IBOutlet weak var ibRating: UITextField!
    @IBOutlet weak var ibSaveButton: UIButton!
    @IBOutlet weak var ibListeningButton: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    var product: Product?
    
    var productArray = NSMutableArray()
    
    let recognizeVoice = CustomRecognizeController()
    var isListening: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Review"
        self.isListening = false
        self.recognizeVoice.delegate = self
        enableControls(false)
        //Cosmos Rating View
        self.cosmosView.settings.fillMode = .Full
        self.cosmosView.rating = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ProductBusinessController.getAllProduct { (productArray) -> Void in
            self.productArray = NSMutableArray(array: productArray)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.product != nil) {
            ibProductID.text = self.product?.objectId
            enableControls(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.ibProductID) {
            var words = textField.text
            words = words?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if words != nil {
                let predicate = NSPredicate(format: "SELF.objectId == %@", words!)
                let result = self.productArray.filteredArrayUsingPredicate(predicate) as NSArray
                
                if (result.count > 0) {
                    enableControls(true)
                }else {
                    enableControls(false)
                    let alert = UIAlertController(title: "Alert", message: "Product ID not found", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        self.view.endEditing(true)
        return true
    }
    
    func enableControls(state: Bool) {
        self.ibComment.enabled = state
        self.ibSaveButton.enabled = state
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
    }
    
    @IBAction func addReview(sender: AnyObject) {
        var comment = self.ibComment.text
        if comment == nil {
            comment = ""
        }

        let numRating = NSNumber(double: self.cosmosView.rating)
        
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
                "objectId": "s1k6Vzf9Uk"
            ]
        ]
        
        ReviewBusinessController.addReviewProduct(param) { (message) -> Void in
            if message != nil {
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func showRecognizeVoiceController(sender: AnyObject) {
        if (self.isListening == false) {
            self.isListening = true
            self.ibListeningButton.setTitle("Stop Listening", forState: UIControlState.Normal)
            self.recognizeVoice.beginListening()
        }else {
            self.isListening = false
            self.ibListeningButton.setTitle("Start Listening", forState: UIControlState.Normal)
             self.recognizeVoice.stopListening()
        }
    }
    // CustomRecognize Delegate
    func recognizeFinishedWithValue(hypothesis: String!) {
        print("A heard: %@", hypothesis)
        let value: String? = ibProductID.text
        ibProductID.text = value! + hypothesis
    }
    
    @IBAction func showScanQRController(sender: AnyObject) {
        initScanQRCode()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
