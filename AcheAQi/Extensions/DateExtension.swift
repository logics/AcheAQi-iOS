//
//  DateExtension.swift
//  QuadrasNet
//
//  Created by Romeu Godoi on 22/01/19.
//  Copyright © 2019 Logics Software. All rights reserved.
//

import Foundation

extension Date {
    
    func minutesSince(_ date: Date) -> Int {
        let interval = self.timeIntervalSince(date)
        let seconds = interval / 60
        
        return Int(seconds)
    }
    
    func hoursSince(_ date: Date) -> Int {
        let interval = self.timeIntervalSince(date)
        let seconds = interval / 3600
        
        return Int(seconds)
    }
}

extension NSDate {
    func minutesSince(_ date: NSDate) -> Int {
        return (self as Date).minutesSince(date as Date)
    }
    
    func hoursSince(_ date: NSDate) -> Int {
        return (self as Date).hoursSince(date as Date)
    }
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }
    
    func isGreaterOrEqualToDate(dateToCompare: NSDate) -> Bool {
        return isGreaterThanDate(dateToCompare: dateToCompare) || equalToDate(dateToCompare: dateToCompare)
    }
    
    func isLessOrEqualToDate(dateToCompare: NSDate) -> Bool {
        return isLessThanDate(dateToCompare: dateToCompare) || equalToDate(dateToCompare: dateToCompare)
    }

    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)

        //Return Result
        return dateWithDaysAdded
    }

    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)

        //Return Result
        return dateWithHoursAdded
    }

}
