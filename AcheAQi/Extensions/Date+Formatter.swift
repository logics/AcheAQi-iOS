//
//  Date+Formatter.swift
//  Logics
//
//  Created by Romeu Godoi on 10/02/17.
//  Copyright © 2017 Oconcurs. All rights reserved.
//

import Foundation

extension Date {
    
    func wsFormatedString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.WSDateFormat
        
        return formatter.string(from: self)
    }
    
    func formattedDate(style: DateFormatter.Style) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: style, timeStyle: .none)
    }
    
    func littleSmallTime() -> String {
        
        var littleTime = "";
        let now = Date()
        
        let timeInterval = now.timeIntervalSince(self)
        
        
        if timeInterval < 60 { // segundos
            littleTime = String(format: "%.0fs", timeInterval);
        }
        else if (timeInterval < 3600) { // minutos
            littleTime = String(format: "%.0fm", timeInterval/60);
        }
        else if (timeInterval < 86400) { // horas
            littleTime = String(format: "%.0fh", timeInterval/3600);
        }
        else if (timeInterval < 31536000) { // dias
            littleTime = String(format: "%.0fd", timeInterval/86400);
        }
        else { // anos
            littleTime = String(format: "%.0fa", timeInterval/31536000);
        }

        return littleTime
    }
    
    func formattedDate(dateFormat: String = "dd/MM/yyyy") -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
    
    func formattedDateTime(dateFormat: String = "dd/MM/yyyy HH:mm:ss") -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
}

extension NSDate {
    func formattedDate(style: DateFormatter.Style) -> String {
        return DateFormatter.localizedString(from: (self as Date), dateStyle: style, timeStyle: .none)
    }
    
    func wsFormatedString() -> String {
        return (self as Date).wsFormatedString()
    }
    
    func littleSmallTime() -> String {
        return (self as Date).littleSmallTime()
    }
    
    func formattedDate(dateFormat: String) -> String {
        return (self as Date).formattedDate(dateFormat: dateFormat)
    }
}
