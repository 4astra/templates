//
//  DetailProductTableViewCell.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class DetailProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ibUsername: UILabel!
    @IBOutlet weak var ibComment: UILabel!
    @IBOutlet weak var ibRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellInfo(review: Review, userArray: NSMutableArray?) {
        ibComment.text = review.comment
        ibRate.text = "Rate: " + review.rating!
        
        if (userArray != nil) {
            let predicate = NSPredicate(format: "SELF.objectId == %@", (review.user?.objectId)!)
            let result = (userArray?.filteredArrayUsingPredicate(predicate))! as NSArray
            if (result.count > 0) {
                let user = result.lastObject as! User
                ibUsername.text = user.userName
            }
        }
    }
    
}
