//
//  ViewController.swift
//  TaskIt
//
//  Created by David Montz on 12/11/14.
//  Copyright (c) 2014 davidmontz.net. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    var fetchResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchResultsController = getFetchResultsController()
        fetchResultsController.delegate = self
        fetchResultsController.performFetch(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iCloudUpdated"), name: "coreDataUpdated", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  fetchResultsController.sections![section].numberOfObjects
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let task:TaskModel = fetchResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        cell.taskLabel.text = task.task
        cell.descriptionLabel.text = task.subTask
        cell.dateLabel.text = Date.toString(date: task.date)
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTaskDetail" {
            
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = fetchResultsController.objectAtIndexPath(indexPath!) as TaskModel
            
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
            
        } else if segue.identifier == "showTaskAdd" {
            
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
            addTaskVC.delegate = self

        }
    }
    
    //UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showTaskDetail", sender: self)
        
    }

    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if fetchResultsController.sections?.count == 1 {
            let fetchedObjects = fetchResultsController.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as TaskModel

            if testTask.completed == true{
                return "Completed"
            }else{
                return "To do"
            }
        }else {
            if section == 0 {
                return "To Do"
            }
            else {
                return "Completed"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let thisTask = fetchResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        if (thisTask.completed == true){
            thisTask.completed = false
        }else{
            thisTask.completed = true
        }
        //(UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        ModelManager.instance.saveContext()
    }
    
    //NSFetchResultController Delegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    //Helper
    
    func taskFetchRequest () -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        
        fetchRequest.sortDescriptors = [completedDescriptor,sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchResultsController() -> NSFetchedResultsController {
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: ModelManager.instance.managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchResultsController
    }
    
    //TaskDetailViewControllerDelegate
    func taskDetailEdited() {
        showAlert()
    }

    func showAlert (message: String = "Congratulations"){
        var alert = UIAlertController(title: "Change made", message: "Congratulations", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //addtaskviewcontrollerdelegate
    
    func addTask(message: String) {
        showAlert(message: message)
    }
    func addTaskCanceled(message: String) {
        showAlert(message: message)
    }
    
    //iCloud Notification
    
    func iCloudUpdated(){
        tableView.reloadData()
    }
}















