//
//  MenuViewController.swift
//  Swift Slide Menu
//
//  Created by Philippe BOISNEY on 10/01/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}

class TableViewMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableViewMenu : UITableView!
    var btnCloseTableViewMenu : UIButton!
    var arrayMenu = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting TableView
        tableViewMenu = UITableView(frame: view.bounds)
        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.separatorStyle = .None
        tableViewMenu.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViewMenu.tableFooterView = UIView()
        tableViewMenu.clipsToBounds = false
        tableViewMenu.layer.masksToBounds = false
        tableViewMenu.layer.shadowColor = UIColor.blackColor().CGColor
        tableViewMenu.layer.shadowOffset = CGSize(width: 1, height: 0)
        tableViewMenu.layer.shadowOpacity = 0.1
        tableViewMenu.layer.shadowRadius = 3
        
        view.addSubview(tableViewMenu)
        
        //Load Constraints
        applyConstraintsAndViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updatearrayMenu()
    }
    
    override func viewDidLayoutSubviews() {
        //Resize MenuView when orientation change
        createOrResizeMenuView()
    }
    
    func updatearrayMenu(){
        arrayMenu.append(["title":"Home", "icon":"home"])
        arrayMenu.append(["title":"Contacts", "icon":"contact"])
        arrayMenu.append(["title":"Love", "icon":"love"])
        arrayMenu.append(["title":"Settings", "icon":"settings"])
        
        tableViewMenu.reloadData()
    }
    
    func onCloseMenuClick(button:UIButton!){
        btnMenu.tag = 0
        //var  animationSpeed : CGFloat = 0.3
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseTableViewMenu){
                //animationSpeed = 0.3
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(-UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clearColor()
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    //MARK: - Table View Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableViewMenu.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        cell.img.image = UIImage(named: arrayMenu[indexPath.row]["icon"]!)
        cell.label.text = arrayMenu[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height/10
    }
    
    //MARK: - Those two methods are used for image on header tableView
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height/3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let imageToUse: UIImage = UIImage(named: "background.jpg")!
        let imageViewToUse: UIImageView = UIImageView(image: imageToUse)
        
        return imageViewToUse
    }
    
    //MARK: - This method is for resizing menu (Landscape/Portrait)
    
    func createOrResizeMenuView () {
        
        let widthPurcentage:CGFloat
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            widthPurcentage = 0.4 //Purcentage applied when orientation is Landscape
        } else {
            widthPurcentage = 0.8 //Purcentage applied when orientation is Landscape
        }
        
        var newFrame: CGRect = self.view.frame;
        newFrame.size.height = self.view.frame.size.height
        newFrame.size.width = (self.view.frame.size.width) * widthPurcentage
        
        self.tableViewMenu.frame = newFrame
        
        //Set Table View under TopLayoutGuide
        let topLayoutGuide: CGFloat = self.topLayoutGuide.length;
        tableViewMenu.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0);
        
    }
    
    //MARK: This Method is used for autolayout constraint
    
    func applyConstraintsAndViews(){
        
        //*** START Constraints for btnCloseTableViewMenu ***
        
        //Create View
        btnCloseTableViewMenu = UIButton()
        btnCloseTableViewMenu.translatesAutoresizingMaskIntoConstraints = false
        btnCloseTableViewMenu.addTarget(self, action: "onCloseMenuClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnCloseTableViewMenu)
        self.view.sendSubviewToBack(btnCloseTableViewMenu)
        
        
        //Horizontal and Vertical Constraints
        let horizontalConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute:NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        //Height and Width Constraints
        let widthConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        //Applying constraints
        self.view.addConstraint(horizontalConstraint)
        self.view.addConstraint(verticalConstraint)
        self.view.addConstraint(widthConstraint)
        self.view.addConstraint(heightConstraint)
        
        //*** END Constraints for btnCloseTableViewMenu ***
    }
    
}