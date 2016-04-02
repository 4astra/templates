//
//  DetailProductViewController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate
{

    @IBOutlet weak var ibProductName: UILabel!
    @IBOutlet weak var ibBrandName: UILabel!
    @IBOutlet weak var ibDescription: UILabel!
    @IBOutlet weak var ibCommentTable: UITableView!
    var product: Product!
    var brandName: String?
    var reviewArray: NSArray?
    var reviewFilterArray = NSMutableArray()
    var userArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ibCommentTable.registerNib(UINib(nibName: "DetailProductTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailProductTableViewCell")
        //init item on Navigation Bar
        initItemsOnNavigationBar()
        //get all User
        allUser()
    
    }
    
    func initItemsOnNavigationBar() {
        self.title = "Detail"
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 100, 30)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        button.setTitle("Add Review", forState: UIControlState.Normal)
        button.setTitle("Add Review", forState: UIControlState.Selected)
        button.addTarget(self, action: "addReview:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button);
    }
    
    func allUser() {
        UserBussinessController.getAllUser { (userArray) -> Void in
            self.userArray = NSMutableArray(array: userArray)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.ibCommentTable.reloadData()
            }
        };
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.ibProductName.text = product.productName!
        self.ibBrandName.text = brandName
        self.ibDescription.text = product.desc
        let predicate = NSPredicate(format: "SELF.product.objectId == %@", product.objectId!)
        self.reviewFilterArray = NSMutableArray(array: self.reviewArray!.filteredArrayUsingPredicate(predicate))
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.ibCommentTable.reloadData()
        }
    }
    
    func addReview(sender: UIButton!) {
        let addReview = self.storyboard?.instantiateViewControllerWithIdentifier("AddReviewViewController") as! AddReviewViewController
        addReview.product = self.product
        self.navigationController?.pushViewController(addReview, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* --------------UITableView Datasource and Delegate --------------------*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 95.0
    //    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 195.0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewFilterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let review =  self.reviewFilterArray[indexPath.row] as! Review
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailProductTableViewCell") as! DetailProductTableViewCell
        cell.setCellInfo(review, userArray: self.userArray)
        
        return cell
    }

}
