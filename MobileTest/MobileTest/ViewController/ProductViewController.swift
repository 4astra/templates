//
//  ProductViewController.swift
//  MobileTest
//
//  Created by Titano on 3/31/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController,
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UISearchBarDelegate
{
    
    @IBOutlet weak var ibNoData: UILabel!
    @IBOutlet weak var ibBrandPicker: UIView!
    @IBOutlet weak var ibProductTable: UITableView!
    @IBOutlet weak var ibBrandButton: UIButton!
    @IBOutlet weak var ibBrandPickerView: UIPickerView!
    @IBOutlet weak var ibSearchBar: UISearchBar!
    
    var brandArray = NSMutableArray()
    var productArray = NSMutableArray()
    var productFilterArray = NSMutableArray()
    var productSearchArray = NSMutableArray()
    var reviewArray = NSMutableArray()
    var brandIDSelected: String?
    var isSearching: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init items on Navigation Bar
        initItemsOnNavigationBar()
        
        self.isSearching = false
        self.ibProductTable.registerNib(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
         self.ibProductTable.hidden = true
        self.ibProductTable.tableFooterView = UIView()
        self.ibProductTable.tableHeaderView = UIView()
        self.ibSearchBar.inputAccessoryView = UIToolbar.keyboardToolbar(self)
        //get all brand
        allBrand()
        //get all product
        allProduct()
        //get all review
        allReview()
    }
    
    func initItemsOnNavigationBar() {
        self.title = "Products"
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 100, 30)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        button.setTitle("Add Review", forState: UIControlState.Normal)
        button.setTitle("Add Review", forState: UIControlState.Selected)
        button.addTarget(self, action: "addReview:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button);
    }
    
    func allBrand() {
        BrandBusinessController.getAllBrand { (brandArray) -> Void in
            self.brandArray = NSMutableArray(array: brandArray)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ibBrandPickerView.reloadAllComponents()
            });
        }
    }
    
    func allProduct() {
        ProductBusinessController.getAllProduct { (productArray) -> Void in
            self.productArray = NSMutableArray(array: productArray)
        }
    }
    
    func allReview() {
        ReviewBusinessController.getAllReview { (reviewArray) -> Void in
            self.reviewArray = NSMutableArray(array: reviewArray)
        }
    }
    
    //get a brand name from brandIDSelected
    func getBrandName()->String! {
        let predicate =  NSPredicate(format: "SELF.ID == %@", self.brandIDSelected!)
        let result = self.brandArray.filteredArrayUsingPredicate(predicate) as NSArray
        let brand = result.firstObject as! Brand
        if brand.name != nil {
            return brand.name!
        }else {
            return ""
        }
    }
    
    func addReview(sender: UIButton!) {
        let addReview = self.storyboard?.instantiateViewControllerWithIdentifier("AddReviewViewController") as! AddReviewViewController
        self.navigationController?.pushViewController(addReview, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Event Touch
    
    @IBAction func hideBrandPicker(sender: AnyObject) {
        ibBrandPicker.hidden = true
    }
    
    @IBAction func showBrandPicker(sender: AnyObject) {
        ibBrandPicker.hidden = false
    }
    
    /* --------------PickerView Datasource and Delegate --------------------*/
   
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = self.brandArray[row]
        return brand.name
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.brandArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let brand = self.brandArray[row] as! Brand
        let brandTitle = "Brand: " + brand.name!
        self.ibBrandButton.setTitle(brandTitle, forState: UIControlState.Normal)
        let predicate = NSPredicate(format: "SELF.brand.ID == %@", brand.ID!)
        self.brandIDSelected = brand.ID
        self.productFilterArray = NSMutableArray(array: self.productArray.filteredArrayUsingPredicate(predicate))
        if (self.productFilterArray.count > 0) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.ibProductTable.hidden = false
                self.ibProductTable.reloadData()
            }
            self.ibNoData.hidden = true
        }else {
            self.ibNoData.hidden = false
            self.ibProductTable.hidden = true
        }

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
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let detailProduct = self.storyboard?.instantiateViewControllerWithIdentifier("DetailProductViewController") as! DetailProductViewController
        var product: Product!;
        if (self.isSearching == true) {
            product = self.productSearchArray[indexPath.row] as! Product
        }else {
            product =  self.productFilterArray[indexPath.row] as! Product
        }
        detailProduct.product = product
        detailProduct.brandName = getBrandName()
        detailProduct.reviewArray = self.reviewArray
        self.ibBrandPicker.hidden = true
        self.navigationController?.pushViewController(detailProduct, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearching == false) {
            return self.productFilterArray.count
        }
        return self.productSearchArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var product: Product!;
        if (self.isSearching == true) {
            product = self.productSearchArray[indexPath.row] as! Product
        }else {
            product =  self.productFilterArray[indexPath.row] as! Product
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductTableViewCell") as! ProductTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.setCellInfo(product, brandName: getBrandName(), reviewArray: self.reviewArray)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //Search Bar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count > 0 && self.productFilterArray.count > 0) {
            self.isSearching = true
            let searchPredicate = NSPredicate(format: "SELF.productName contains %@", searchText)
            let result = self.productFilterArray.filteredArrayUsingPredicate(searchPredicate) as NSArray;
            self.productSearchArray = NSMutableArray(array: result)
        }else {
            self.isSearching = false
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.ibProductTable.reloadData()
        })
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.ibBrandPicker.hidden = true
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func endEditing(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
}
