//
//  QRCodeReaderController.swift
//  MobileTest
//
//  Created by Titano on 4/1/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class CustomQRCodeReaderController: NSObject, QRCodeReaderViewControllerDelegate {
    
    internal weak var delegate: CustomQRCodeReaderDelegate?
    
    lazy var readerVC = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    
    func initScanQRCode() {
        readerVC.delegate = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if (self.delegate != nil) {
                self.delegate?.scanFinishedWithValue(result?.value)
            }
        }
        readerVC.modalPresentationStyle = .FormSheet
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController?.presentViewController(readerVC, animated: true, completion: nil)
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

public protocol CustomQRCodeReaderDelegate: class {
    func scanFinishedWithValue(value: String?)
}