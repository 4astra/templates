//
//  CustomRecognizeController.swift
//  MobileTest
//
//  Created by Titano on 4/2/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class CustomRecognizeController: NSObject,
    OEEventsObserverDelegate
{
    internal weak var delegate: CustomRecognizeDelegate?
    //recognize voice
    let fliteController = OEFliteController()
    let openEarsEventsObserver = OEEventsObserver()
    let slt = Slt()
    var pathToFirstDynamicallyGeneratedLanguageModel:String?
    var pathToFirstDynamicallyGeneratedDictionary:String?
    
    override init() {
        super.init()
        self.initRecognize()
    }
    
    func initRecognize() {

        OELogging.startOpenEarsLogging()
        OEPocketsphinxController.sharedInstance().verbosePocketSphinx = true
        self.openEarsEventsObserver.delegate = self
        
        do {
            try OEPocketsphinxController.sharedInstance().setActive(true)
        }catch {
            print(error)
        }
        let firstLanguageArray = ["A","B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M","N",
            "O", "P", "Q", "R", "T", "S", "X", "W",
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let languageModelGenerator =  OELanguageModelGenerator()
        let error: NSError? = languageModelGenerator.generateLanguageModelFromArray(firstLanguageArray, withFilesNamed: "FirstOpenEarsDynamicLanguageModel", forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        if (error != nil) {
            print("Error: %@", error?.description)
        }else{
            self.pathToFirstDynamicallyGeneratedLanguageModel = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName("FirstOpenEarsDynamicLanguageModel")
            self.pathToFirstDynamicallyGeneratedDictionary = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName("FirstOpenEarsDynamicLanguageModel")
        }
    }
    
    //    OEEventsObserver delegate methods
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        print("Result heard: %@", hypothesis)
        if (self.delegate != nil) {
            self.delegate?.recognizeFinishedWithValue(hypothesis)
        }
    }
    
    func beginListening() {
        if(!OEPocketsphinxController.sharedInstance().isListening) {
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
        }
    }
    
    func stopListening() {
        var error: NSError?
        if (OEPocketsphinxController.sharedInstance().isListening) {
            error = OEPocketsphinxController.sharedInstance().stopListening()
            if(error != nil) {
                print("Stop listening error: %@", error)
            }
        }
    }
}

public protocol CustomRecognizeDelegate: class {
    func recognizeFinishedWithValue(hypothesis: String!)
}
