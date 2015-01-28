//
//  TaskModel.swift
//  TaskIt
//
//  Created by David Montz on 12/30/14.
//  Copyright (c) 2014 davidmontz.net. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var task: String
    @NSManaged var subTask: String

}
