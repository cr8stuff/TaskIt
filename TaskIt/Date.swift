//
//  Date.swift
//  TaskIt
//
//  Created by David Montz on 12/16/14.
//  Copyright (c) 2014 davidmontz.net. All rights reserved.
//

import Foundation

class Date {
    
    class func from (#year:Int, month: Int, day: Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)
        var date = gregorianCalendar?.dateFromComponents(components)
        
        return date!
        
    }
    
    class func toString (#date:NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString
    }
    
}