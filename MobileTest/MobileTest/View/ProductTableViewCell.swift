//
//  ProductTableViewCell.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ibProductName: UILabel!
    @IBOutlet weak var ibProductReview: UILabel!
    @IBOutlet weak var ibBrandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellInfo(info: Product, brandName: String, reviewArray: NSArray) {
        ibProductName.text = info.productName
        ibBrandName.text = brandName
        
        let predicate = NSPredicate(format: "SELF.product.objectId == %@", info.objectId!)
        let results = reviewArray.filteredArrayUsingPredicate(predicate)
        var comments = String()
        for obj in results {
            let review = obj as! Review
            comments = comments.stringByAppendingFormat("%@\n\n", review.comment!)
        }
        ibProductReview.text = comments
    }
    
}
