//
//  Brand.swift
//  MobileTest
//
//  Created by Titano on 3/30/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//
import Foundation


class Brand: NSObject {
    var name: String?
    var desc: String?
    var ID: String?
    var updatedAt: String?
    
    init(name: String, desc: String, ID: String, updatedAt: String) {
        self.name = name
        self.desc = desc
        self.ID = ID
        self.updatedAt = updatedAt
    }
    override init() {
        
    }
}