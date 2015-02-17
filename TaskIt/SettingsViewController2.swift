//
//  SettingsViewController2.swift
//  TaskIt
//
//  Created by Jamie Montz on 2/13/15.
//  Copyright (c) 2015 davidmontz.net. All rights reserved.
//

import UIKit

class SettingsViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var capTable: UITableView!
    @IBOutlet weak var doneTable: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.capTable.delegate = self
        self.capTable.dataSource = self
        self.capTable.scrollEnabled = false
        
        self.doneTable.delegate = self
        self.doneTable.dataSource = self
        self.doneTable.scrollEnabled = false
        
        self.title = "Settings"
        self.label.text = "1.0"

        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
        self.navigationItem.leftBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneBarButtonItemPressed (barButtonItem: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.capTable{
            var capitalizeCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("capCell") as UITableViewCell
            
            if indexPath.row == 0{
                capitalizeCell.textLabel?.text = "No do not Capitalize"
                
                if  NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == false {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                capitalizeCell.textLabel?.text = "Yes Capitalize"
                
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey)  == true{
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            
            return capitalizeCell
        } else {
            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("doneCell") as UITableViewCell
            
            if indexPath.row == 0{
                cell.textLabel?.text = "Do not complete task."
                
                if  NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewToDo) == false {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                cell.textLabel?.text = "Complete task."
                
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewToDo)  == true{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            
            return cell
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.capTable {
            return "Capitalize new task?"
        }else{
            return "Complete new task?"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.capTable{
            if indexPath.row == 0{
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCapitalizeTaskKey)
            }else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCapitalizeTaskKey)
            }
        } else {
            if indexPath.row == 0{
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCompleteNewToDo)
            }else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewToDo)
            }
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
